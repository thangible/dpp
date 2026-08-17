import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/modules/auth/controllers/auth_controller.dart';
import 'package:dpp/app/modules/settings/controllers/locale_controller.dart';
import 'package:dpp/app/routes/app_pages.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(l10n.profileTitle, style: theme.textTheme.headlineSmall),
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
    final l10n = AppLocalizations.of(context)!;
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
              l10n.profileGuestTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.profileGuestBody,
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
              child: Text(l10n.profileSignIn),
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
    final l10n = AppLocalizations.of(context)!;

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
          Text(l10n.profileDisplayName, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: l10n.profileNameHint),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _save,
            child: Text(_saved ? l10n.profileSaved : l10n.profileSave),
          ),
          const SizedBox(height: 28),
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 20),
          Text(l10n.profileLanguage, style: theme.textTheme.labelLarge),
          const SizedBox(height: 10),
          const _LanguagePicker(),
          const SizedBox(height: 24),
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.badge_outlined, color: colors.onSurfaceVariant, size: 20),
              const SizedBox(width: 12),
              Text(
                l10n.profileSignedInAs(auth.username.value),
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
            label: Text(l10n.profileSignOut, style: TextStyle(color: colors.error)),
          ),
        ],
      ),
    );
  }
}

/// English / German / match-system picker, wired to [LocaleController].
class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = Get.find<LocaleController>();

    return Obx(() {
      final current = controller.locale.value?.languageCode;
      return Wrap(
        spacing: 8,
        children: [
          ChoiceChip(
            label: Text(l10n.profileLanguageSystem),
            selected: current == null,
            onSelected: (_) => controller.setLocale(null),
          ),
          ChoiceChip(
            label: Text(l10n.profileLanguageEnglish),
            selected: current == 'en',
            onSelected: (_) => controller.setLocale(const Locale('en')),
          ),
          ChoiceChip(
            label: Text(l10n.profileLanguageGerman),
            selected: current == 'de',
            onSelected: (_) => controller.setLocale(const Locale('de')),
          ),
        ],
      );
    });
  }
}
