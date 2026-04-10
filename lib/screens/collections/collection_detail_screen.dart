import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../config/theme.dart';
import '../../graphql/queries/collection_queries.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/kamili_card.dart';
import '../../widgets/post/post_card.dart';

class CollectionDetailScreen extends StatelessWidget {
  final String collectionId;

  const CollectionDetailScreen({super.key, required this.collectionId});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getCollectionQuery),
          variables: {'id': collectionId},
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading && result.data == null) {
            return const LoadingIndicator(message: 'Loading collection...');
          }

          if (result.hasException) {
            return KamiliErrorWidget(
              message: result.exception.toString(),
              onRetry: () => refetch?.call(),
            );
          }

          final data = result.data?['getCollection'];
          if (data == null) {
            return KamiliErrorWidget(
              message: 'Failed to load collection',
              onRetry: () => refetch?.call(),
            );
          }

          final error = data['error'];
          if (error != null) {
            return KamiliErrorWidget(
              message: (error['message'] as String?) ??
                  'Failed to load collection',
              onRetry: () => refetch?.call(),
            );
          }

          final collection =
              data['collection'] as Map<String, dynamic>?;
          if (collection == null) {
            return KamiliErrorWidget(
              message: 'Collection not found',
              onRetry: () => refetch?.call(),
            );
          }

          final name = (collection['name'] as String?) ?? 'Unnamed';
          final description = collection['description'] as String?;
          final postCount = collection['postCount'] as int? ?? 0;
          final color = _parseColor(collection['color'] as String?);
          final posts = (collection['posts'] as List<dynamic>?) ?? [];

          return RefreshIndicator(
            color: KamiliColors.primary,
            onRefresh: () async => refetch?.call(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Collection info card
                KamiliCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.folder,
                          color: color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: KamiliColors.textPrimary,
                              ),
                            ),
                            if (description != null &&
                                description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: KamiliColors.textSecondary,
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              '$postCount ${postCount == 1 ? 'post' : 'posts'}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: KamiliColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Posts header
                const Text(
                  'Posts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: KamiliColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Posts list
                if (posts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No posts in this collection',
                        style: TextStyle(
                          fontSize: 14,
                          color: KamiliColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ...posts.map((post) {
                    final postMap = post as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PostCard(
                        post: postMap,
                        onTap: () =>
                            context.push('/posts/${postMap['id']}'),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}
