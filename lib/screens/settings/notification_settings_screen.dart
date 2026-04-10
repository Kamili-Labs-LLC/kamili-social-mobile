import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../config/theme.dart';
import '../../graphql/mutations/account_mutations.dart';
import '../../providers/auth_provider.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  late bool _postSuccess;
  late bool _postFailure;
  late bool _accountIssues;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    if (authState is Authenticated) {
      final prefs = authState.account.notificationPreferences;
      _postSuccess = prefs?.postSuccess ?? false;
      _postFailure = prefs?.postFailure ?? false;
      _accountIssues = prefs?.accountIssues ?? false;
    } else {
      _postSuccess = false;
      _postFailure = false;
      _accountIssues = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Mutation(
        options: MutationOptions(
          document: gql(updateAccountMutation),
          onCompleted: (data) {
            if (data == null) return;
            final result = data['updateAccount'];
            if (result?['__typename'] == 'Error') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result['message'] as String? ??
                        'Failed to update preferences',
                  ),
                ),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Preferences updated')),
            );
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  error?.graphqlErrors.firstOrNull?.message ??
                      'Failed to update preferences',
                ),
              ),
            );
          },
        ),
        builder: (runMutation, mutationResult) {
          void savePreferences() {
            runMutation({
              'data': {
                'notificationPreferences': {
                  'postSuccessEmail': _postSuccess,
                  'postFailureEmail': _postFailure,
                  'accountIssuesEmail': _accountIssues,
                },
              },
            });
          }

          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Email Notifications',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: KamiliColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text(
                  'Post Published Successfully',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: KamiliColors.textPrimary,
                  ),
                ),
                subtitle: const Text(
                  'Get notified when your posts are published',
                  style: TextStyle(
                    fontSize: 13,
                    color: KamiliColors.textSecondary,
                  ),
                ),
                value: _postSuccess,
                activeColor: KamiliColors.primary,
                onChanged: (value) {
                  setState(() => _postSuccess = value);
                  savePreferences();
                },
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              SwitchListTile(
                title: const Text(
                  'Post Failed to Publish',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: KamiliColors.textPrimary,
                  ),
                ),
                subtitle: const Text(
                  'Get notified when a post fails to publish',
                  style: TextStyle(
                    fontSize: 13,
                    color: KamiliColors.textSecondary,
                  ),
                ),
                value: _postFailure,
                activeColor: KamiliColors.primary,
                onChanged: (value) {
                  setState(() => _postFailure = value);
                  savePreferences();
                },
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              SwitchListTile(
                title: const Text(
                  'Account Issues',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: KamiliColors.textPrimary,
                  ),
                ),
                subtitle: const Text(
                  'Get notified about connection or account issues',
                  style: TextStyle(
                    fontSize: 13,
                    color: KamiliColors.textSecondary,
                  ),
                ),
                value: _accountIssues,
                activeColor: KamiliColors.primary,
                onChanged: (value) {
                  setState(() => _accountIssues = value);
                  savePreferences();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
