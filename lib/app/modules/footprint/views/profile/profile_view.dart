import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/modules/auth/controllers/auth_controller.dart';
import 'package:dpp/app/routes/app_pages.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 20, top: 16),
              child: Text('Profile', style: theme.textTheme.headlineSmall),
            ),
            Expanded(
              child: Obx(() {
                final auth = Get.find<AuthController>();
                return auth.isGuest.value
                    ? const _GuestPrompt()
                    : const _ProfileForm();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 56,
              color: colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Sign in to set up your profile',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Guests can browse and keep history for this session, but a profile needs an account.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await Get.find<AuthController>().signOut();
                Get.offAllNamed(Routes.SIGN_IN);
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileForm extends StatefulWidget {
  const _ProfileForm();

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  late final TextEditingController _nameController;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: Get.find<AuthController>().displayName.value,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await Get.find<AuthController>().updateDisplayName(_nameController.text);
    if (!mounted) return;
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final auth = Get.find<AuthController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                auth.displayName.value.isNotEmpty
                    ? auth.displayName.value[0].toUpperCase()
                    : '?',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text('Display name', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Your name'),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _save,
            child: Text(_saved ? 'Saved ✓' : 'Save'),
          ),
          const SizedBox(height: 28),
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.badge_outlined, color: colors.onSurfaceVariant, size: 20),
              const SizedBox(width: 12),
              Text(
                'Signed in as ${auth.username.value}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () async {
              await auth.signOut();
              Get.offAllNamed(Routes.SIGN_IN);
            },
            icon: Icon(Icons.logout, color: colors.error),
            label: Text('Sign Out', style: TextStyle(color: colors.error)),
          ),
        ],
      ),
    );
  }
}
