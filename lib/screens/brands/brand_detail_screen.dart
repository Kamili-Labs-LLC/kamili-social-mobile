import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../config/theme.dart';
import '../../graphql/queries/brand_queries.dart';
import '../../graphql/queries/brand_user_queries.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/kamili_card.dart';

class BrandDetailScreen extends StatelessWidget {
  final String brandId;

  const BrandDetailScreen({super.key, required this.brandId});

  Widget _buildRoleBadge(String? role) {
    final label = switch (role?.toUpperCase()) {
      'ACCOUNT_OWNER' => 'Owner',
      'BRAND_MANAGER' => 'Manager',
      'VIEW_APPROVE' => 'Viewer',
      _ => role ?? 'Member',
    };

    final color = switch (role?.toUpperCase()) {
      'ACCOUNT_OWNER' => KamiliColors.primary,
      'BRAND_MANAGER' => KamiliColors.warning,
      'VIEW_APPROVE' => KamiliColors.textSecondary,
      _ => KamiliColors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    final isActive = status?.toUpperCase() == 'ACTIVE' ||
        status?.toUpperCase() == 'ACCEPTED';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (isActive ? KamiliColors.success : KamiliColors.warning)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status ?? 'Unknown',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isActive ? KamiliColors.success : KamiliColors.warning,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand Detail'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getBrandsQuery),
        ),
        builder: (brandsResult, {fetchMore, refetch}) {
          // Find the brand from the list
          Map<String, dynamic>? brand;
          String brandName = 'Brand';

          if (brandsResult.data != null) {
            final data = brandsResult.data?['getBrands'];
            if (data != null && data['__typename'] != 'Error') {
              final brands = (data['brands'] as List<dynamic>?) ?? [];
              for (final b in brands) {
                if ((b as Map<String, dynamic>)['id'] == brandId) {
                  brand = b;
                  brandName = (b['name'] as String?) ?? 'Brand';
                  break;
                }
              }
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Brand info card
              if (brand != null) ...[
                KamiliCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color:
                                  KamiliColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.business,
                              color: KamiliColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  brandName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: KamiliColors.textPrimary,
                                  ),
                                ),
                                if (brand['description'] != null &&
                                    (brand['description'] as String)
                                        .isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    brand['description'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: KamiliColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else if (brandsResult.isLoading) ...[
                const SizedBox(
                  height: 100,
                  child: LoadingIndicator(),
                ),
              ],

              const SizedBox(height: 24),

              // Team Members header
              const Text(
                'Team Members',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: KamiliColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Team Members query
              Query(
                options: QueryOptions(
                  document: gql(getBrandUsersQuery),
                  variables: {'brandId': brandId},
                ),
                builder: (result, {fetchMore, refetch}) {
                  if (result.isLoading && result.data == null) {
                    return const SizedBox(
                      height: 200,
                      child:
                          LoadingIndicator(message: 'Loading team members...'),
                    );
                  }

                  if (result.hasException) {
                    return KamiliErrorWidget(
                      message: result.exception.toString(),
                      onRetry: () => refetch?.call(),
                    );
                  }

                  final data = result.data?['getBrandUsers'];
                  if (data == null || data['__typename'] == 'Error') {
                    return KamiliErrorWidget(
                      message: (data?['message'] as String?) ??
                          'Failed to load team members',
                      onRetry: () => refetch?.call(),
                    );
                  }

                  final users = (data['users'] as List<dynamic>?) ?? [];

                  if (users.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'No team members found',
                          style: TextStyle(
                            fontSize: 14,
                            color: KamiliColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: users.map((user) {
                      final u = user as Map<String, dynamic>;
                      final name =
                          (u['userName'] as String?) ?? 'Unknown User';
                      final email = (u['userEmail'] as String?) ?? '';
                      final role = u['role'] as String?;
                      final status = u['status'] as String?;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                                color: KamiliColors.borderLight),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: KamiliColors.primary
                                      .withValues(alpha: 0.1),
                                  child: Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: KamiliColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: KamiliColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: KamiliColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _buildRoleBadge(role),
                                    if (status != null) ...[
                                      const SizedBox(height: 4),
                                      _buildStatusBadge(status),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
