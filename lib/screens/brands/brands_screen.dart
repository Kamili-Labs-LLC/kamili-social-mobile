import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../config/theme.dart';
import '../../graphql/queries/brand_queries.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brands'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getBrandsQuery),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading && result.data == null) {
            return const LoadingIndicator(message: 'Loading brands...');
          }

          if (result.hasException) {
            return KamiliErrorWidget(
              message: result.exception.toString(),
              onRetry: () => refetch?.call(),
            );
          }

          final data = result.data?['getBrands'];
          if (data == null || data['__typename'] == 'Error') {
            return KamiliErrorWidget(
              message:
                  (data?['message'] as String?) ?? 'Failed to load brands',
              onRetry: () => refetch?.call(),
            );
          }

          final brands = (data['brands'] as List<dynamic>?) ?? [];

          if (brands.isEmpty) {
            return const EmptyState(
              icon: Icons.business_outlined,
              title: 'No Brands',
              subtitle: 'You have not created any brands yet.',
            );
          }

          return RefreshIndicator(
            color: KamiliColors.primary,
            onRefresh: () async => refetch?.call(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: brands.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final brand = brands[index] as Map<String, dynamic>;
                final name = (brand['name'] as String?) ?? 'Unnamed';
                final description = brand['description'] as String?;
                final role = brand['userRole'] as String?;
                final isActive = brand['isActive'] as bool? ?? true;

                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: KamiliColors.borderLight),
                  ),
                  child: InkWell(
                    onTap: () => context.push('/brands/${brand['id']}'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: KamiliColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.business,
                              color: KamiliColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: KamiliColors.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (role != null) _buildRoleBadge(role),
                                  ],
                                ),
                                if (description != null &&
                                    description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: KamiliColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? KamiliColors.success
                                  : KamiliColors.textSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right,
                            color: KamiliColors.textSecondary,
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
