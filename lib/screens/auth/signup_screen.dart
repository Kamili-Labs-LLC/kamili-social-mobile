import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../models/error_response.dart';
import '../../providers/auth_provider.dart';
import '../../router/route_names.dart';
import '../../utils/validators.dart';
import '../../widgets/common/kamili_button.dart';
import '../../widgets/common/kamili_text_field.dart';
import '../../widgets/common/password_strength_indicator.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedPlan = 'FREE';
  String _password = '';
  bool _isLoading = false;

  static const _plans = [
    {'key': 'FREE', 'label': 'Free', 'price': 'Free'},
    {'key': 'SOLO', 'label': 'Solo', 'price': '\$12/mo'},
    {'key': 'PREMIUM', 'label': 'Premium', 'price': '\$29/mo'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
            _selectedPlan,
          );
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/kamili-social-logo.png',
                    width: 160,
                  ),
                ),
                const SizedBox(height: 32),
                // Heading
                const Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: KamiliColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                // Name field
                KamiliTextField(
                  label: 'Name',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) => Validators.required(value, 'Name'),
                ),
                const SizedBox(height: 16),
                // Email field
                KamiliTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                // Password field
                KamiliTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.strongPassword,
                  onChanged: (value) {
                    setState(() => _password = value);
                  },
                ),
                const SizedBox(height: 8),
                PasswordStrengthIndicator(password: _password),
                const SizedBox(height: 16),
                // Confirm Password field
                KamiliTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (value) =>
                      Validators.confirmPassword(value, _passwordController.text),
                ),
                const SizedBox(height: 24),
                // Plan selection
                const Text(
                  'Select a plan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: KamiliColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ..._plans.map((plan) => _buildPlanCard(plan)),
                const SizedBox(height: 24),
                // Create Account button
                KamiliButton(
                  label: 'Create Account',
                  isLoading: _isLoading,
                  onPressed: _handleSignup,
                ),
                const SizedBox(height: 16),
                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 14,
                        color: KamiliColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(RoutePaths.login),
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(Map<String, String> plan) {
    final isSelected = _selectedPlan == plan['key'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedPlan = plan['key']!),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? KamiliColors.primary : KamiliColors.border,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? KamiliColors.primary.withValues(alpha: 0.05)
                : Colors.white,
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? KamiliColors.primary
                    : KamiliColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  plan['label']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? KamiliColors.primary
                        : KamiliColors.textPrimary,
                  ),
                ),
              ),
              Text(
                plan['price']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? KamiliColors.primary
                      : KamiliColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
