import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../graphql/queries/post_queries.dart';
import '../../widgets/analytics/stat_card.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/post/post_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getDashboardAnalyticsQuery),
          variables: const {
            'filter': {
              'dateRange': 'LAST_30_DAYS',
            },
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading && result.data == null) {
            return const LoadingIndicator(message: 'Loading dashboard...');
          }

          if (result.hasException) {
            return KamiliErrorWidget(
              message: result.exception.toString(),
              onRetry: () => refetch?.call(),
            );
          }

          final data = result.data?['getDashboardAnalytics'];
          if (data == null || data['__typename'] == 'Error') {
            return KamiliErrorWidget(
              message: (data?['message'] as String?) ??
                  'Failed to load dashboard',
              onRetry: () => refetch?.call(),
            );
          }

          final totalPosts = data['totalPosts'] as int? ?? 0;
          final scheduledPosts = data['scheduledPosts'] as int? ?? 0;
          final publishedPosts = data['publishedPosts'] as int? ?? 0;
          final failedPosts = data['failedPosts'] as int? ?? 0;
          final topPosts =
              (data['topPerformingPosts'] as List<dynamic>?) ?? [];
          final platformBreakdown =
              (data['platformBreakdown'] as List<dynamic>?) ?? [];

          // Calculate engagement rate from platform breakdown
          double totalEngagement = 0;
          for (final p in platformBreakdown) {
            totalEngagement +=
                (p['totalEngagement'] as num?)?.toDouble() ?? 0;
          }
          final engagementRate = publishedPosts > 0
              ? (totalEngagement / publishedPosts)
              : 0.0;

          return RefreshIndicator(
            color: KamiliColors.primary,
            onRefresh: () async => refetch?.call(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Stats grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    StatCard(
                      title: 'Posts Published',
                      value: publishedPosts.toString(),
                      icon: Icons.check_circle_outline,
                    ),
                    StatCard(
                      title: 'Scheduled',
                      value: scheduledPosts.toString(),
                      icon: Icons.schedule,
                    ),
                    StatCard(
                      title: 'Engagement Rate',
                      value: '${engagementRate.toStringAsFixed(1)}%',
                      icon: Icons.trending_up,
                    ),
                    StatCard(
                      title: 'Total Posts',
                      value: totalPosts.toString(),
                      icon: Icons.visibility_outlined,
                      subtitle: '$failedPosts failed',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Upcoming Posts section
                _buildSectionHeader(context, 'Upcoming Posts'),
                const SizedBox(height: 12),
                _buildUpcomingPosts(context),

                const SizedBox(height: 24),

                // Top Performing section
                if (topPosts.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Top Performing'),
                  const SizedBox(height: 12),
                  ...topPosts.take(3).map((post) {
                    final postMap = post as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PostCard(
                        post: {
                          ...postMap,
                          'status': 'PUBLISHED',
                        },
                        onTap: () =>
                            context.push('/posts/${postMap['id']}'),
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: KamiliColors.textPrimary,
      ),
    );
  }

  Widget _buildUpcomingPosts(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getScheduledPostsQuery),
        variables: const {
          'pagination': {'limit': 5},
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading && result.data == null) {
          return const SizedBox(
            height: 140,
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(KamiliColors.primary),
              ),
            ),
          );
        }

        final data = result.data?['getScheduledPosts'];
        final posts = (data?['posts'] as List<dynamic>?) ?? [];

        if (posts.isEmpty) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KamiliColors.borderLight),
            ),
            child: const Text(
              'No upcoming posts scheduled',
              style: TextStyle(
                color: KamiliColors.textSecondary,
                fontSize: 14,
              ),
            ),
          );
        }

        return SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final post = posts[index] as Map<String, dynamic>;
              return SizedBox(
                width: 280,
                child: PostCard(
                  post: post,
                  onTap: () => context.push('/posts/${post['id']}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
