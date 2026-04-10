import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../config/theme.dart';
import '../../graphql/queries/collection_queries.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  Color _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return KamiliColors.primary;
    try {
      final hex = colorStr.replaceFirst('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return KamiliColors.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Collections require a brandId - for now use a placeholder or selected brand
    // In a real app, this would come from a brand selection provider
    final brandId = 'default';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create collection coming soon')),
          );
        },
        backgroundColor: KamiliColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getCollectionsQuery),
          variables: {'brandId': brandId},
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading && result.data == null) {
            return const LoadingIndicator(message: 'Loading collections...');
          }

          if (result.hasException) {
            return KamiliErrorWidget(
              message: result.exception.toString(),
              onRetry: () => refetch?.call(),
            );
          }

          final data = result.data?['getCollections'];
          if (data == null) {
            return KamiliErrorWidget(
              message: 'Failed to load collections',
              onRetry: () => refetch?.call(),
            );
          }

          final error = data['error'];
          if (error != null) {
            return KamiliErrorWidget(
              message: (error['message'] as String?) ??
                  'Failed to load collections',
              onRetry: () => refetch?.call(),
            );
          }

          final collections =
              (data['collections'] as List<dynamic>?) ?? [];

          if (collections.isEmpty) {
            return EmptyState(
              icon: Icons.folder_outlined,
              title: 'No Collections',
              subtitle: 'Organize your posts into collections.',
              actionLabel: 'Create Collection',
              onAction: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Create collection coming soon')),
                );
              },
            );
          }

          return RefreshIndicator(
            color: KamiliColors.primary,
            onRefresh: () async => refetch?.call(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: collections.length,
              itemBuilder: (context, index) {
                final collection =
                    collections[index] as Map<String, dynamic>;
                final name =
                    (collection['name'] as String?) ?? 'Unnamed';
                final color = _parseColor(collection['color'] as String?);
                final postCount = collection['postCount'] as int? ?? 0;

                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: KamiliColors.borderLight),
                  ),
                  child: InkWell(
                    onTap: () =>
                        context.push('/collections/${collection['id']}'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          left: BorderSide(
                            color: color,
                            width: 4,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder,
                            color: color,
                            size: 28,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: KamiliColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$postCount ${postCount == 1 ? 'post' : 'posts'}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: KamiliColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
