import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../config/theme.dart';
import '../../graphql/queries/post_queries.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/post/post_card.dart';

class PostsListScreen extends StatelessWidget {
  const PostsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: implement search
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: KamiliColors.primary,
            unselectedLabelColor: KamiliColors.textSecondary,
            indicatorColor: KamiliColors.primary,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Drafts'),
              Tab(text: 'Scheduled'),
              Tab(text: 'Published'),
              Tab(text: 'Failed'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PostsTab(status: null, queryType: _QueryType.all),
            _PostsTab(status: 'DRAFT', queryType: _QueryType.drafts),
            _PostsTab(status: 'SCHEDULED', queryType: _QueryType.scheduled),
            _PostsTab(status: 'PUBLISHED', queryType: _QueryType.all),
            _PostsTab(status: 'FAILED', queryType: _QueryType.all),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/posts/create'),
          backgroundColor: KamiliColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

enum _QueryType { all, drafts, scheduled }

class _PostsTab extends StatelessWidget {
  final String? status;
  final _QueryType queryType;

  const _PostsTab({required this.status, required this.queryType});

  String get _query {
    switch (queryType) {
      case _QueryType.drafts:
        return getDraftPostsQuery;
      case _QueryType.scheduled:
        return getScheduledPostsQuery;
      case _QueryType.all:
        return getPostsQuery;
    }
  }

  String get _resultKey {
    switch (queryType) {
      case _QueryType.drafts:
        return 'getDraftPosts';
      case _QueryType.scheduled:
        return 'getScheduledPosts';
      case _QueryType.all:
        return 'getPosts';
    }
  }

  Map<String, dynamic> get _variables {
    final Map<String, dynamic> filter = {};
    if (status != null && queryType == _QueryType.all) {
      filter['status'] = status;
    }
    return {
      if (filter.isNotEmpty) 'filter': filter,
      'pagination': const {'limit': 20},
    };
  }

  String get _emptyLabel {
    switch (status) {
      case 'DRAFT':
        return 'draft';
      case 'SCHEDULED':
        return 'scheduled';
      case 'PUBLISHED':
        return 'published';
      case 'FAILED':
        return 'failed';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(_query),
        variables: _variables,
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading && result.data == null) {
          return const LoadingIndicator(message: 'Loading posts...');
        }

        if (result.hasException) {
          return KamiliErrorWidget(
            message: result.exception.toString(),
            onRetry: () => refetch?.call(),
          );
        }

        final data = result.data?[_resultKey];
        if (data == null || data['__typename'] == 'Error') {
          return KamiliErrorWidget(
            message:
                (data?['message'] as String?) ?? 'Failed to load posts',
            onRetry: () => refetch?.call(),
          );
        }

        final posts = (data['posts'] as List<dynamic>?) ?? [];

        if (posts.isEmpty) {
          return EmptyState(
            icon: Icons.article_outlined,
            title: status == null
                ? 'No posts yet'
                : 'No $_emptyLabel posts',
            subtitle: status == null
                ? 'Create your first post to get started.'
                : 'You don\'t have any $_emptyLabel posts.',
            actionLabel: 'Create Post',
            onAction: () => context.push('/posts/create'),
          );
        }

        return RefreshIndicator(
          color: KamiliColors.primary,
          onRefresh: () async => refetch?.call(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final post = posts[index] as Map<String, dynamic>;
              return PostCard(
                post: post,
                onTap: () => context.push('/posts/${post['id']}'),
              );
            },
          ),
        );
      },
    );
  }
}
