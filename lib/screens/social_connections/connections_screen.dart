import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../graphql/queries/social_connection_queries.dart';
import '../../graphql/mutations/social_connection_mutations.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/social/connection_card.dart';
import '../../widgets/post/platform_icon.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  void _showPlatformPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: KamiliColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Connect Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: KamiliColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select a platform to connect',
                style: TextStyle(
                  fontSize: 14,
                  color: KamiliColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ...AppConstants.socialPlatforms.map((platform) {
                final displayName =
                    AppConstants.platformDisplayNames[platform] ?? platform;
                return Mutation(
                  options: MutationOptions(
                    document: gql(createSocialConnectionMutation),
                    onCompleted: (data) async {
                      if (data == null) return;
                      final result = data['createSocialConnection'];
                      if (result?['__typename'] == 'Error') {
                        if (sheetContext.mounted) {
                          ScaffoldMessenger.of(sheetContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                result['message'] as String? ??
                                    'Failed to connect',
                              ),
                            ),
                          );
                        }
                        return;
                      }
                      final authUrl = result?['authUrl'] as String?;
                      if (authUrl != null && authUrl.isNotEmpty) {
                        final uri = Uri.parse(authUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      }
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                    onError: (error) {
                      if (sheetContext.mounted) {
                        ScaffoldMessenger.of(sheetContext).showSnackBar(
                          SnackBar(
                            content: Text(
                              error?.graphqlErrors.firstOrNull?.message ??
                                  'Connection failed',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  builder: (runMutation, mutationResult) {
                    final isLoading = mutationResult?.isLoading ?? false;
                    return ListTile(
                      leading: PlatformIcon(platform: platform, size: 32),
                      title: Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: KamiliColors.textPrimary,
                        ),
                      ),
                      trailing: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: KamiliColors.textSecondary,
                            ),
                      onTap: isLoading
                          ? null
                          : () {
                              runMutation({
                                'input': {'platform': platform.toUpperCase()},
                              });
                            },
                    );
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showPlatformPicker(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPlatformPicker(context),
        backgroundColor: KamiliColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Connect Account'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getSocialConnectionsQuery),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading && result.data == null) {
            return const LoadingIndicator(message: 'Loading connections...');
          }

          if (result.hasException) {
            return KamiliErrorWidget(
              message: result.exception.toString(),
              onRetry: () => refetch?.call(),
            );
          }

          final data = result.data?['getSocialConnections'];
          if (data == null || data['__typename'] == 'Error') {
            return KamiliErrorWidget(
              message: (data?['message'] as String?) ??
                  'Failed to load connections',
              onRetry: () => refetch?.call(),
            );
          }

          final connections =
              (data['socialConnections'] as List<dynamic>?) ?? [];

          if (connections.isEmpty) {
            return EmptyState(
              icon: Icons.link_off,
              title: 'No Connected Accounts',
              subtitle:
                  'Connect your social media accounts to start publishing.',
              actionLabel: 'Connect Account',
              onAction: () => _showPlatformPicker(context),
            );
          }

          return RefreshIndicator(
            color: KamiliColors.primary,
            onRefresh: () async => refetch?.call(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: connections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final connection =
                    connections[index] as Map<String, dynamic>;
                return ConnectionCard(connection: connection);
              },
            ),
          );
        },
      ),
    );
  }
}
