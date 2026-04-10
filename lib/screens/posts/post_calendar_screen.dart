import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../config/theme.dart';
import '../../graphql/queries/post_queries.dart';
import '../../models/post.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/post/post_card.dart';

class PostCalendarScreen extends StatefulWidget {
  const PostCalendarScreen({super.key});

  @override
  State<PostCalendarScreen> createState() => _PostCalendarScreenState();
}

class _PostCalendarScreenState extends State<PostCalendarScreen> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final startOfMonth = _currentMonth;
    final endOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0, 23, 59, 59);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          _buildMonthHeader(),
          _buildWeekdayHeaders(),
          Expanded(
            child: Query(
              options: QueryOptions(
                document: gql(getPostsCalendarQuery),
                variables: {
                  'filter': {
                    'startDate': startOfMonth.toIso8601String(),
                    'endDate': endOfMonth.toIso8601String(),
                  },
                },
              ),
              builder: (result, {fetchMore, refetch}) {
                if (result.isLoading && result.data == null) {
                  return const LoadingIndicator();
                }
                if (result.hasException) {
                  return KamiliErrorWidget(
                    message: 'Failed to load calendar',
                    onRetry: refetch,
                  );
                }

                final data = result.data?['getPostsCalendar'];
                final List<Post> posts = [];
                if (data != null && data['__typename'] != 'Error') {
                  final postsList = data['posts'] as List? ?? [];
                  posts.addAll(postsList.map((p) => Post.fromJson(p)));
                }

                final postsByDay = <int, List<Post>>{};
                for (final post in posts) {
                  final date = post.scheduledAt ?? post.publishedAt ?? post.createdAt;
                  if (date != null) {
                    final parsed = DateTime.tryParse(date);
                    if (parsed != null) {
                      postsByDay.putIfAbsent(parsed.day, () => []).add(post);
                    }
                  }
                }

                return _buildCalendarGrid(postsByDay);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
          ),
          Text(
            '${months[_currentMonth.month - 1]} ${_currentMonth.year}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: days.map((d) => Expanded(
          child: Center(
            child: Text(d, style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: KamiliColors.textSecondary,
            )),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(Map<int, List<Post>> postsByDay) {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;
    final today = DateTime.now();
    final isCurrentMonth = today.year == _currentMonth.year && today.month == _currentMonth.month;

    final cells = <Widget>[];
    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final postsForDay = postsByDay[day] ?? [];
      final isToday = isCurrentMonth && today.day == day;

      cells.add(
        GestureDetector(
          onTap: postsForDay.isNotEmpty
              ? () => _showDayPosts(context, day, postsForDay)
              : null,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isToday ? KamiliColors.primary.withValues(alpha: 0.1) : null,
              borderRadius: BorderRadius.circular(8),
              border: isToday ? Border.all(color: KamiliColors.primary) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    color: isToday ? KamiliColors.primary : KamiliColors.textPrimary,
                  ),
                ),
                if (postsForDay.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      postsForDay.length.clamp(0, 3),
                      (_) => Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.only(top: 2, right: 1),
                        decoration: const BoxDecoration(
                          color: KamiliColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 1,
      children: cells,
    );
  }

  void _showDayPosts(BuildContext context, int day, List<Post> posts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${_currentMonth.month}/$day — ${posts.length} post${posts.length == 1 ? '' : 's'}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: posts.length,
                itemBuilder: (context, index) => PostCard(
                  post: posts[index].toJson(),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/posts/${posts[index].id}');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
