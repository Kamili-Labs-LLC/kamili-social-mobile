import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/kamili_button.dart';
import '../../widgets/common/kamili_card.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    String plan = 'FREE';
    String? subscriptionStatus;

    if (authState is Authenticated) {
      plan = authState.account.plan;
      subscriptionStatus = authState.account.subscriptionStatus;
    }

    final planLabel = AppConstants.planLabels[plan] ?? plan;
    final isActive = subscriptionStatus?.toUpperCase() == 'ACTIVE' ||
        subscriptionStatus?.toUpperCase() == 'TRIALING' ||
        subscriptionStatus == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current plan card
          KamiliCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.diamond_outlined,
                      color: KamiliColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Current Plan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: KamiliColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isActive
                                ? KamiliColors.success
                                : KamiliColors.warning)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isActive ? 'Active' : (subscriptionStatus ?? 'Unknown'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? KamiliColors.success
                              : KamiliColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  planLabel,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: KamiliColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Plan Comparison',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: KamiliColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Free plan
          _buildPlanCard(
            name: 'Free',
            price: '\$0/mo',
            isCurrent: plan == 'FREE',
            features: [
              '5 social accounts',
              '30 posts per month',
              '1 brand',
              'Basic analytics',
            ],
          ),
          const SizedBox(height: 12),

          // Solo plan
          _buildPlanCard(
            name: 'Solo',
            price: '\$15/mo',
            isCurrent: plan == 'SOLO',
            features: [
              '15 social accounts',
              'Unlimited posts',
              '3 brands',
              'Advanced analytics',
              'AI content suggestions',
            ],
          ),
          const SizedBox(height: 12),

          // Premium plan
          _buildPlanCard(
            name: 'Premium',
            price: '\$39/mo',
            isCurrent: plan == 'PREMIUM',
            features: [
              'Unlimited social accounts',
              'Unlimited posts',
              'Unlimited brands',
              'Full analytics suite',
              'AI content generation',
              'Team collaboration',
              'Priority support',
            ],
          ),

          const SizedBox(height: 24),

          KamiliButton(
            label: 'Manage Billing on Web',
            variant: KamiliButtonVariant.secondary,
            icon: Icons.open_in_new,
            onPressed: () async {
              final uri = Uri.parse('https://app.kamili.social/billing');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              'Plan changes can only be made on the web app',
              style: TextStyle(
                fontSize: 13,
                color: KamiliColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String name,
    required String price,
    required bool isCurrent,
    required List<String> features,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCurrent ? KamiliColors.primary : KamiliColors.borderLight,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: KamiliColors.textPrimary,
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: KamiliColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Current',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: KamiliColors.primary,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: KamiliColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: KamiliColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 14,
                          color: KamiliColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
