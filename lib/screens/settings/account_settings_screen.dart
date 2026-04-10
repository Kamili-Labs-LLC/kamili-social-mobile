import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../config/theme.dart';
import '../../graphql/mutations/account_mutations.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/kamili_text_field.dart';
import '../../widgets/common/kamili_button.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _timezone = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    String name = '';
    String email = '';

    if (authState is Authenticated) {
      name = authState.account.name;
      email = authState.account.email;
      _timezone = authState.account.selectedTimezone ?? 'UTC';
    }

    _nameController = TextEditingController(text: name);
    _emailController = TextEditingController(text: email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Mutation(
        options: MutationOptions(
          document: gql(updateAccountMutation),
          onCompleted: (data) {
            setState(() => _isSaving = false);
            if (data == null) return;
            final result = data['updateAccount'];
            if (result?['__typename'] == 'Error') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result['message'] as String? ?? 'Failed to update account',
                  ),
                ),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account updated successfully')),
            );
          },
          onError: (error) {
            setState(() => _isSaving = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  error?.graphqlErrors.firstOrNull?.message ??
                      'Failed to update account',
                ),
              ),
            );
          },
        ),
        builder: (runMutation, mutationResult) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KamiliTextField(
                    label: 'Name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  KamiliTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),

                  // Timezone display
                  const Text(
                    'Timezone',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: KamiliColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: KamiliColors.border),
                    ),
                    child: Text(
                      _timezone.isNotEmpty ? _timezone : 'Not set',
                      style: const TextStyle(
                        fontSize: 16,
                        color: KamiliColors.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  KamiliButton(
                    label: 'Save Changes',
                    isLoading: _isSaving,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() => _isSaving = true);
                        runMutation({
                          'data': {
                            'name': _nameController.text.trim(),
                          },
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
