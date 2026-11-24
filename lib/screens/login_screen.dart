import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/utils/validators.dart';
import '../services/auth_service.dart';
import '../widgets/auth/login_form.dart';
import '../widgets/auth/login_header.dart';
import '../widgets/common/auth_switch_link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(
    text: 'omar.sayed@cairobrew.com',
  );

  // Sample password that satisfies the API password rule.
  final _passwordController = TextEditingController(text: 'Cairo@12');

  late bool _emailIsValid;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailIsValid = Validators.email(_emailController.text) == null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    final isValid = Validators.email(value) == null;
    if (isValid != _emailIsValid) {
      setState(() => _emailIsValid = isValid);
    }
  }

  void _goBack() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.welcomeRoute);
    }
  }

  Future<void> _login() async {
    if (_isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) {
        return;
      }
      navigator.pushNamedAndRemoveUntil(
        AppRoutes.homeRoute,
        (route) => false,
      );
    } on AppException catch (error) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Could not log in right now. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginHeader(onBack: _goBack),
              const SizedBox(height: AppSpacing.xl),
              LoginForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                emailIsValid: _emailIsValid,
                obscurePassword: _obscurePassword,
                isLoading: _isLoading,
                onEmailChanged: _onEmailChanged,
                onTogglePassword: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                onSubmit: _login,
              ),
              const SizedBox(height: AppSpacing.sm),
              AuthSwitchLink(
                prompt: "Don't have an account?",
                actionLabel: 'Create account',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.registerRoute);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
