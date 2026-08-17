import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/modules/auth/controllers/auth_controller.dart';
import 'package:dpp/app/routes/app_pages.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    final auth = Get.find<AuthController>();
    final success = await auth.signIn(
      _usernameController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _error = success ? null : AppLocalizations.of(context)!.signInError;
    });
    if (success) {
      Get.offAllNamed(Routes.NAVIGATION_HOME);
    }
  }

  void _continueAsGuest() {
    Get.find<AuthController>().continueAsGuest();
    Get.offAllNamed(Routes.NAVIGATION_HOME);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Wordmark(),
                    const SizedBox(height: 8),
                    Text(
                      l10n.appSubtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(l10n.signInUsername, style: theme.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(hintText: 'admin'),
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? l10n.signInUsernameRequired
                                  : null,
                    ),
                    const SizedBox(height: 20),
                    Text(l10n.signInPassword, style: theme.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: 'admin',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                        ),
                      ),
                      validator:
                          (v) =>
                              (v == null || v.isEmpty)
                                  ? l10n.signInPasswordRequired
                                  : null,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child:
                          _isSubmitting
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(l10n.signInButton),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isSubmitting ? null : _continueAsGuest,
                      child: Text(l10n.signInGuestButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small red/yellow wordmark stand-in for a real logo — no brand assets
/// exist in this project, so it's built from the theme tokens. "DPP" stays
/// unlocalized (it's the product name, like a brand mark would be).
class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.qr_code_2, color: colors.onPrimary, size: 34),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineSmall,
            children: [
              TextSpan(text: 'DPP', style: TextStyle(color: colors.primary)),
              TextSpan(
                text: ' Passport',
                style: TextStyle(color: colors.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
