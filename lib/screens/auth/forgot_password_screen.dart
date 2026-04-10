import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../models/error_response.dart';
import '../../router/route_names.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../widgets/common/kamili_button.dart';
import '../../widgets/common/kamili_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.forgotPassword(_emailController.text.trim());
      if (mounted) {
        setState(() => _isSuccess = true);
      }
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _isSuccess ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 64),
        const Icon(
          Icons.check_circle_outline,
          size: 80,
          color: KamiliColors.success,
        ),
        const SizedBox(height: 24),
        const Text(
          'Check your email',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: KamiliColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'We have sent a password reset link to your email address.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: KamiliColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        KamiliButton(
          label: 'Back to Sign In',
          onPressed: () => context.go(RoutePaths.login),
        ),
      ],
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Reset Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: KamiliColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Enter your email and we'll send you a reset link",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: KamiliColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          KamiliTextField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: 24),
          KamiliButton(
            label: 'Send Reset Link',
            isLoading: _isLoading,
            onPressed: _handleSendResetLink,
          ),
        ],
      ),
    );
  }
}
