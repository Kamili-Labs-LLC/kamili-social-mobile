import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../graphql/queries/post_queries.dart';
import '../../graphql/mutations/post_mutations.dart';
import '../../widgets/analytics/stat_card.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/post/platform_icon.dart';
import '../../widgets/post/post_status_badge.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getPostsQuery),
        variables: {
          'filter': {'postId': postId},
          'pagination': const {'limit': 1},
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading && result.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Post')),
            body: const LoadingIndicator(message: 'Loading post...'),
          );
        }

        if (result.hasException) {
          return Scaffold(
            appBar: AppBar(title: const Text('Post')),
            body: KamiliErrorWidget(
              message: result.exception.toString(),
              onRetry: () => refetch?.call(),
            ),
          );
        }

        final data = result.data?['getPosts'];
        if (data == null || data['__typename'] == 'Error') {
          return Scaffold(
            appBar: AppBar(title: const Text('Post')),
            body: KamiliErrorWidget(
              message:
                  (data?['message'] as String?) ?? 'Failed to load post',
              onRetry: () => refetch?.call(),
            ),
          );
        }

        final posts = (data['posts'] as List<dynamic>?) ?? [];
        if (posts.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Post')),
            body: const KamiliErrorWidget(message: 'Post not found'),
          );
        }

        final post = posts.first as Map<String, dynamic>;
        return _PostDetailContent(
          post: post,
          onRefetch: () => refetch?.call(),
        );
      },
    );
  }
}

class _PostDetailContent extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onRefetch;

  const _PostDetailContent({
    required this.post,
    required this.onRefetch,
  });

  String get _status => (post['status'] as String?) ?? 'DRAFT';

  String get _text {
    final content = post['content'] as Map<String, dynamic>?;
    final defaultContent = content?['default'] as Map<String, dynamic>?;
    return (defaultContent?['text'] as String?) ?? '';
  }

  List<dynamic> get _media {
    final content = post['content'] as Map<String, dynamic>?;
    final defaultContent = content?['default'] as Map<String, dynamic>?;
    return (defaultContent?['media'] as List<dynamic>?) ?? [];
  }

  List<Map<String, dynamic>> get _targetConnections {
    final connections =
        post['targetConnections'] as List<dynamic>?;
    if (connections == null) return [];
    return connections.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          _buildPopupMenu(context),
        ],
      ),
      body: RefreshIndicator(
        color: KamiliColors.primary,
        onRefresh: () async => onRefetch(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Status badge
            PostStatusBadge(status: _status),
            const SizedBox(height: 16),

            // Text content
            if (_text.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: KamiliColors.borderLight),
                ),
                child: Text(
                  _text,
                  style: const TextStyle(
                    fontSize: 15,
                    color: KamiliColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Media gallery
            if (_media.isNotEmpty) ...[
              _buildMediaGallery(),
              const SizedBox(height: 16),
            ],

            // Time info
            _buildTimeInfo(),
            const SizedBox(height: 16),

            // Target connections / platforms
            if (_targetConnections.isNotEmpty) ...[
              _buildPlatformsSection(),
              const SizedBox(height: 16),
            ],

            // Fail reason
            if (_status == 'FAILED' && post['failReason'] != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: KamiliColors.error.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: KamiliColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.error_outline,
                            size: 18, color: KamiliColors.error),
                        SizedBox(width: 8),
                        Text(
                          'Failure Reason',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: KamiliColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post['failReason'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: KamiliColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Notes section
            if ((post['notesCount'] as int? ?? 0) > 0) ...[
              _buildNotesSection(),
              const SizedBox(height: 16),
            ],

            // Analytics for published posts
            if (_status == 'PUBLISHED') ...[
              _buildAnalyticsSection(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return Mutation(
      options: MutationOptions(document: gql(deletePostMutation)),
      builder: (runDeleteMutation, deleteResult) {
        return Mutation(
          options: MutationOptions(document: gql(publishPostNowMutation)),
          builder: (runPublishMutation, publishResult) {
            return Mutation(
              options:
                  MutationOptions(document: gql(duplicatePostMutation)),
              builder: (runDuplicateMutation, duplicateResult) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        // TODO: navigate to edit screen
                        break;
                      case 'duplicate':
                        runDuplicateMutation({'postId': post['id']});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Post duplicated')),
                        );
                        onRefetch();
                        break;
                      case 'delete':
                        _showDeleteConfirmation(
                            context, runDeleteMutation);
                        break;
                      case 'publish':
                        runPublishMutation({'postId': post['id']});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Publishing post...')),
                        );
                        onRefetch();
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: ListTile(
                        leading: Icon(Icons.copy_outlined),
                        title: Text('Duplicate'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'publish',
                      child: ListTile(
                        leading: Icon(Icons.send_outlined),
                        title: Text('Publish Now'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading:
                            Icon(Icons.delete_outline, color: KamiliColors.error),
                        title: Text('Delete',
                            style: TextStyle(color: KamiliColors.error)),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, RunMutation runDeleteMutation) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post'),
        content:
            const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              runDeleteMutation({'id': post['id']});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post deleted')),
              );
              context.pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: KamiliColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGallery() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _media.length,
      itemBuilder: (context, index) {
        final mediaItem = _media[index] as Map<String, dynamic>;
        final url = mediaItem['url'] as String?;
        final thumbnailUrl = mediaItem['thumbnailUrl'] as String?;
        final displayUrl = thumbnailUrl ?? url;

        if (displayUrl == null || displayUrl.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: KamiliColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.image_outlined,
                color: KamiliColors.textSecondary),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: displayUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: KamiliColors.surface,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: KamiliColors.surface,
              child: const Icon(Icons.broken_image_outlined,
                  color: KamiliColors.textSecondary),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeInfo() {
    final scheduledAt = post['scheduledAt'] as String?;
    final publishedAt = post['publishedAt'] as String?;
    final createdAt = post['createdAt'] as String?;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KamiliColors.borderLight),
      ),
      child: Column(
        children: [
          if (publishedAt != null)
            _buildTimeRow(
                Icons.check_circle_outline, 'Published', publishedAt),
          if (scheduledAt != null) ...[
            if (publishedAt != null) const SizedBox(height: 12),
            _buildTimeRow(Icons.schedule, 'Scheduled', scheduledAt),
          ],
          if (createdAt != null) ...[
            if (publishedAt != null || scheduledAt != null)
              const SizedBox(height: 12),
            _buildTimeRow(Icons.access_time, 'Created', createdAt),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeRow(IconData icon, String label, String dateStr) {
    String formatted;
    try {
      final date = DateTime.parse(dateStr);
      formatted = DateFormat.yMMMd().add_jm().format(date);
    } catch (_) {
      formatted = dateStr;
    }

    return Row(
      children: [
        Icon(icon, size: 18, color: KamiliColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: KamiliColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            formatted,
            style: const TextStyle(
              fontSize: 13,
              color: KamiliColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KamiliColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Target Platforms',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: KamiliColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _targetConnections.map((conn) {
              final platform =
                  (conn['platform'] as String?) ?? 'unknown';
              final username =
                  (conn['platformUsername'] as String?) ?? '';
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlatformIcon(platform: platform, size: 20),
                  const SizedBox(width: 6),
                  if (username.isNotEmpty)
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 13,
                        color: KamiliColors.textPrimary,
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    final count = post['notesCount'] as int? ?? 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KamiliColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.note_outlined,
              size: 20, color: KamiliColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            'Post Notes ($count)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: KamiliColors.textPrimary,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right,
              color: KamiliColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getPostAnalyticsQuery),
        variables: {
          'postId': post['id'],
          'filter': const {'dateRange': 'LAST_30_DAYS'},
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading && result.data == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(KamiliColors.primary),
              ),
            ),
          );
        }

        final data = result.data?['getPostAnalytics'];
        if (data == null || data['__typename'] == 'Error') {
          return const SizedBox.shrink();
        }

        final totalEngagement =
            (data['totalEngagement'] as num?)?.toInt() ?? 0;
        final platforms =
            (data['platforms'] as List<dynamic>?) ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: KamiliColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                StatCard(
                  title: 'Total Engagement',
                  value: totalEngagement.toString(),
                  icon: Icons.favorite_outline,
                ),
                StatCard(
                  title: 'Platforms',
                  value: platforms.length.toString(),
                  icon: Icons.public,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
