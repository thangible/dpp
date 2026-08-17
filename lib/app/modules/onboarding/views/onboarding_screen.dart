import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dpp/app/modules/auth/controllers/auth_controller.dart';
import 'package:dpp/app/routes/app_pages.dart';
import 'package:dpp/app/services/hive/hive_service.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });
}

List<_OnboardingSlide> _slidesFor(AppLocalizations l10n) => [
  _OnboardingSlide(
    icon: Icons.qr_code_scanner,
    title: l10n.onboardingSlide1Title,
    description: l10n.onboardingSlide1Body,
  ),
  _OnboardingSlide(
    icon: Icons.eco_outlined,
    title: l10n.onboardingSlide2Title,
    description: l10n.onboardingSlide2Body,
  ),
  _OnboardingSlide(
    icon: Icons.science_outlined,
    title: l10n.onboardingSlide3Title,
    description: l10n.onboardingSlide3Body,
  ),
  _OnboardingSlide(
    icon: Icons.person_outline,
    title: l10n.onboardingSlide4Title,
    description: l10n.onboardingSlide4Body,
  ),
];

/// First-run carousel, shown once ever (see HiveService.hasSeenOnboarding).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await HiveService.markOnboardingSeen();
    if (!mounted) return;
    final isAuthenticated = Get.find<AuthController>().isAuthenticated.value;
    Get.offAllNamed(
      isAuthenticated ? Routes.NAVIGATION_HOME : Routes.SIGN_IN,
    );
  }

  static const _slideCount = 4;

  void _next() {
    if (_page == _slideCount - 1) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final slides = _slidesFor(l10n);
    final isLast = _page == _slideCount - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, right: 8),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(l10n.onboardingSkip),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: 0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            slide.icon,
                            color: colors.onPrimary,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _page ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              i == _page ? colors.primary : colors.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(
                        isLast ? l10n.onboardingGetStarted : l10n.onboardingNext,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
