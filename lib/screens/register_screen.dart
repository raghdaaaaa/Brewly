import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/validators.dart';
import '../services/auth_service.dart';
import '../widgets/auth/auth_top_bar.dart';
import '../widgets/auth/register_form_card.dart';
import '../widgets/common/auth_switch_link.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _displayNameController = TextEditingController(
    text: 'Omar El-Sayed',
  );
  final _emailController = TextEditingController(
    text: 'omar.sayed@cairobrew.com',
  );
  final _phoneController = TextEditingController(text: '10 2345 6789');
  final _passwordController = TextEditingController(text: 'Cairo@12');

  late bool _displayNameIsValid;
  late bool _emailIsValid;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _emailTaken = false;

  @override
  void initState() {
    super.initState();
    _displayNameIsValid = _displayNameController.text.trim().isNotEmpty;
    _emailIsValid = Validators.email(_emailController.text) == null;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onDisplayNameChanged(String value) {
    final isValid = value.trim().isNotEmpty;
    if (isValid != _displayNameIsValid) {
      setState(() => _displayNameIsValid = isValid);
    }
  }

  void _onEmailChanged(String value) {
    final isValid = Validators.email(value) == null;
    if (isValid != _emailIsValid || _emailTaken) {
      setState(() {
        _emailIsValid = isValid;
        _emailTaken = false;
      });
    }
  }

  String? _validateEmail(String? value) {
    final formatError = Validators.email(value);
    if (formatError != null) {
      return formatError;
    }
    if (_emailTaken) {
      return 'This email is already registered';
    }
    return null;
  }

  void _goToLogin() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.loginRoute);
    }
  }

  Future<void> _register() async {
    if (_isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isLoading = true;
      _emailTaken = false;
    });

    try {
      final email = _emailController.text.trim();
      final exists = await AuthService.instance.emailExists(email);
      if (!mounted) {
        return;
      }

      if (exists) {
        setState(() {
          _emailTaken = true;
          _isLoading = false;
        });
        _formKey.currentState!.validate();
        messenger.showSnackBar(
          const SnackBar(content: Text('This email is already registered.')),
        );
        return;
      }

      await AuthService.instance.register(
        displayName: _displayNameController.text.trim(),
        email: email,
        phoneNumber: '+20${Validators.digitsOnly(_phoneController.text)}',
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
          content: Text('Could not create the account. Please try again.'),
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
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthTopBar(onBack: _goToLogin, showBrandChip: true),
              const SizedBox(height: AppSpacing.lg),
              const Text('Create Account', style: AppTextStyles.displayBig),
              const SizedBox(height: AppSpacing.lg),
              RegisterFormCard(
                formKey: _formKey,
                displayNameController: _displayNameController,
                emailController: _emailController,
                phoneController: _phoneController,
                passwordController: _passwordController,
                displayNameIsValid: _displayNameIsValid,
                emailIsValid: _emailIsValid,
                obscurePassword: _obscurePassword,
                isLoading: _isLoading,
                onDisplayNameChanged: _onDisplayNameChanged,
                onEmailChanged: _onEmailChanged,
                onTogglePassword: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                onSubmit: _register,
                emailValidator: _validateEmail,
              ),
              const SizedBox(height: AppSpacing.lg),
              AuthSwitchLink(
                prompt: 'Already have an account?',
                actionLabel: 'Login',
                onTap: _goToLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
