import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../config/theme.dart';
import '../../graphql/queries/post_queries.dart';
import '../../widgets/analytics/stat_card.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedRange = '30d';

  DateTime get _startDate {
    final now = DateTime.now();
    switch (_selectedRange) {
      case '7d':
        return now.subtract(const Duration(days: 7));
      case '30d':
        return now.subtract(const Duration(days: 30));
      case '90d':
        return now.subtract(const Duration(days: 90));
      default:
        return now.subtract(const Duration(days: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Column(
        children: [
          _buildDateRangeSelector(),
          Expanded(
            child: Query(
              options: QueryOptions(
                document: gql(getAnalyticsSummaryQuery),
                variables: {
                  'filter': {
                    'startDate': _startDate.toIso8601String(),
                    'endDate': DateTime.now().toIso8601String(),
                  },
                },
              ),
              builder: (result, {fetchMore, refetch}) {
                if (result.isLoading && result.data == null) {
                  return const LoadingIndicator();
                }
                if (result.hasException) {
                  return KamiliErrorWidget(
                    message: 'Failed to load analytics',
                    onRetry: refetch,
                  );
                }

                final data = result.data?['getAnalyticsSummary'];
                if (data == null || data['__typename'] == 'Error') {
                  return const EmptyState(
                    icon: Icons.bar_chart_outlined,
                    title: 'No Analytics Yet',
                    subtitle: 'Publish some posts to start seeing analytics data.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => refetch?.call(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCards(data),
                        const SizedBox(height: 24),
                        _buildPlatformBreakdown(data),
                        const SizedBox(height: 24),
                        _buildTopPost(data),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: ['7d', '30d', '90d'].map((range) {
          final isSelected = _selectedRange == range;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(range == '7d' ? '7 Days' : range == '30d' ? '30 Days' : '90 Days'),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedRange = range),
              selectedColor: KamiliColors.primary.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                color: isSelected ? KamiliColors.primary : KamiliColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> data) {
    final totalReach = data['totalReach'] ?? 0;
    final totalEngagement = data['totalEngagement'] ?? 0;
    final totalImpressions = data['totalImpressions'] ?? 0;
    final engagementRate = data['engagementRate'] ?? 0.0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          title: 'Total Reach',
          value: _formatNumber(totalReach),
          icon: Icons.visibility_outlined,
        ),
        StatCard(
          title: 'Engagement',
          value: _formatNumber(totalEngagement),
          icon: Icons.favorite_outline,
        ),
        StatCard(
          title: 'Impressions',
          value: _formatNumber(totalImpressions),
          icon: Icons.remove_red_eye_outlined,
        ),
        StatCard(
          title: 'Engagement Rate',
          value: '${(engagementRate as num).toStringAsFixed(1)}%',
          icon: Icons.trending_up,
        ),
      ],
    );
  }

  Widget _buildPlatformBreakdown(Map<String, dynamic> data) {
    final breakdown = data['platformBreakdown'] as List? ?? [];
    if (breakdown.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platform Breakdown',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...breakdown.map((platform) {
          final name = platform['platform'] as String? ?? '';
          final posts = platform['posts'] ?? 0;
          final engagement = platform['engagement'] ?? 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: KamiliColors.platformColor(name).withValues(alpha: 0.1),
                  child: Icon(Icons.public, color: KamiliColors.platformColor(name), size: 20),
                ),
                title: Text(name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : name),
                subtitle: Text('$posts posts'),
                trailing: Text(
                  '${_formatNumber(engagement)} engagements',
                  style: const TextStyle(color: KamiliColors.textSecondary, fontSize: 12),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTopPost(Map<String, dynamic> data) {
    final topPlatform = data['topPlatform'] as String?;
    if (topPlatform == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Best Performing',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.emoji_events, color: KamiliColors.warning, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Top Platform', style: TextStyle(fontSize: 12, color: KamiliColors.textSecondary)),
                      Text(
                        topPlatform[0].toUpperCase() + topPlatform.substring(1),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatNumber(dynamic number) {
    final n = number is int ? number : (number as num?)?.toInt() ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}
