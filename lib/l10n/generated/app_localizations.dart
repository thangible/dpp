import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DPP Passport'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Product Passport'**
  String get appSubtitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @tabMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get tabMore;

  /// No description provided for @drawerHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get drawerHelp;

  /// No description provided for @drawerFeedback.
  ///
  /// In en, this message translates to:
  /// **'FeedBack'**
  String get drawerFeedback;

  /// No description provided for @drawerInviteFriend.
  ///
  /// In en, this message translates to:
  /// **'Invite Friend'**
  String get drawerInviteFriend;

  /// No description provided for @drawerRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get drawerRateApp;

  /// No description provided for @drawerAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get drawerAboutUs;

  /// No description provided for @drawerDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get drawerDarkMode;

  /// No description provided for @drawerSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get drawerSignOut;

  /// No description provided for @signInUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get signInUsername;

  /// No description provided for @signInPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signInPassword;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @signInGuestButton.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get signInGuestButton;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password.'**
  String get signInError;

  /// No description provided for @signInUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get signInUsernameRequired;

  /// No description provided for @signInPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get signInPasswordRequired;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Scan any code'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at a product or material label to instantly pull up its digital passport.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'See its footprint'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'View energy use, CO2 emissions, and recycled content at a glance, right where you need them.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Trace the material'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Every product links to the material it\'s made from — full composition, origin, and sustainability data.'**
  String get onboardingSlide3Body;

  /// No description provided for @onboardingSlide4Title.
  ///
  /// In en, this message translates to:
  /// **'Sign in, or just browse'**
  String get onboardingSlide4Title;

  /// No description provided for @onboardingSlide4Body.
  ///
  /// In en, this message translates to:
  /// **'Create an account to keep your history across visits, or jump straight in as a guest.'**
  String get onboardingSlide4Body;

  /// No description provided for @homeModeProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get homeModeProduct;

  /// No description provided for @homeModeMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get homeModeMaterial;

  /// No description provided for @homeSearchHintProduct.
  ///
  /// In en, this message translates to:
  /// **'Product ID'**
  String get homeSearchHintProduct;

  /// No description provided for @homeSearchHintMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material ID'**
  String get homeSearchHintMaterial;

  /// No description provided for @homeErrorProductNotFound.
  ///
  /// In en, this message translates to:
  /// **'No product found for \"{id}\"'**
  String homeErrorProductNotFound(Object id);

  /// No description provided for @homeErrorMaterialNotFound.
  ///
  /// In en, this message translates to:
  /// **'No material found for \"{id}\"'**
  String homeErrorMaterialNotFound(Object id);

  /// No description provided for @homeLastSearched.
  ///
  /// In en, this message translates to:
  /// **'Last Searched'**
  String get homeLastSearched;

  /// No description provided for @homeEmptyProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'No products searched yet'**
  String get homeEmptyProductsTitle;

  /// No description provided for @homeEmptyMaterialsTitle.
  ///
  /// In en, this message translates to:
  /// **'No materials searched yet'**
  String get homeEmptyMaterialsTitle;

  /// No description provided for @homeEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter an ID above or use the scanner to add one to your list.'**
  String get homeEmptyHint;

  /// No description provided for @homeScanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan a code'**
  String get homeScanButton;

  /// No description provided for @homeGuestCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in for more'**
  String get homeGuestCardTitle;

  /// No description provided for @homeGuestCardBody.
  ///
  /// In en, this message translates to:
  /// **'Keep your history across sessions and set up a profile.'**
  String get homeGuestCardBody;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History & Favorites'**
  String get historyTitle;

  /// No description provided for @historyFavoritesSection.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get historyFavoritesSection;

  /// No description provided for @historyRecentSection.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get historyRecentSection;

  /// No description provided for @historyFavoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing favorited yet. Tap the star on any item to save it here.'**
  String get historyFavoritesEmpty;

  /// No description provided for @historyRecentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history yet. Search or scan a product/material to see it here.'**
  String get historyRecentEmpty;

  /// No description provided for @historySeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all ({count})'**
  String historySeeAll(Object count);

  /// No description provided for @historyShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get historyShowLess;

  /// No description provided for @historyItemProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get historyItemProduct;

  /// No description provided for @historyItemMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get historyItemMaterial;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to set up your profile'**
  String get profileGuestTitle;

  /// No description provided for @profileGuestBody.
  ///
  /// In en, this message translates to:
  /// **'Guests can browse and keep history for this session, but a profile needs an account.'**
  String get profileGuestBody;

  /// No description provided for @profileSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get profileSignIn;

  /// No description provided for @profileDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayName;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get profileNameHint;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved ✓'**
  String get profileSaved;

  /// No description provided for @profileSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {username}'**
  String profileSignedInAs(Object username);

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileSignOut;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profileLanguageEnglish;

  /// No description provided for @profileLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get profileLanguageGerman;

  /// No description provided for @profileLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'Match system'**
  String get profileLanguageSystem;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scannerTitle;

  /// No description provided for @scannerNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No match for \"{code}\"'**
  String scannerNoMatch(Object code);

  /// No description provided for @scannerScanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scannerScanAgain;

  /// No description provided for @scannerPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access needed'**
  String get scannerPermissionTitle;

  /// No description provided for @scannerPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Enable camera access in Settings to scan a QR code.'**
  String get scannerPermissionBody;

  /// No description provided for @scannerOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get scannerOpenSettings;

  /// No description provided for @productDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetailsTitle;

  /// No description provided for @productManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get productManufacturer;

  /// No description provided for @productMaterialLabel.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get productMaterialLabel;

  /// No description provided for @productLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get productLastUpdated;

  /// No description provided for @productLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading product details...'**
  String get productLoading;

  /// No description provided for @productNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get productNotFoundTitle;

  /// No description provided for @productTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get productTryAgain;

  /// No description provided for @productQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get productQuickActions;

  /// No description provided for @productActionQr.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get productActionQr;

  /// No description provided for @productActionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get productActionShare;

  /// No description provided for @productActionExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get productActionExport;

  /// No description provided for @productActionAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get productActionAnalytics;

  /// No description provided for @productNoImage.
  ///
  /// In en, this message translates to:
  /// **'No image available'**
  String get productNoImage;

  /// No description provided for @productCarbonFootprint.
  ///
  /// In en, this message translates to:
  /// **'Carbon Footprint'**
  String get productCarbonFootprint;

  /// No description provided for @productCo2Process.
  ///
  /// In en, this message translates to:
  /// **'CO2 from Process'**
  String get productCo2Process;

  /// No description provided for @productCo2Material.
  ///
  /// In en, this message translates to:
  /// **'CO2 from Material'**
  String get productCo2Material;

  /// No description provided for @productCo2Total.
  ///
  /// In en, this message translates to:
  /// **'Total (indicative)'**
  String get productCo2Total;

  /// No description provided for @productCo2TotalNote.
  ///
  /// In en, this message translates to:
  /// **'Process (kg) + material PCF (kg CO2e/kg) — a simplified estimate, not a unit-normalized LCA figure.'**
  String get productCo2TotalNote;

  /// No description provided for @productEnvironmentalImpact.
  ///
  /// In en, this message translates to:
  /// **'Environmental Impact'**
  String get productEnvironmentalImpact;

  /// No description provided for @productEnergyUsed.
  ///
  /// In en, this message translates to:
  /// **'Energy Used (Process)'**
  String get productEnergyUsed;

  /// No description provided for @productMaterialComposition.
  ///
  /// In en, this message translates to:
  /// **'Material Composition'**
  String get productMaterialComposition;

  /// No description provided for @productRecycledMaterial.
  ///
  /// In en, this message translates to:
  /// **'Recycled Material'**
  String get productRecycledMaterial;

  /// No description provided for @productVirginMaterial.
  ///
  /// In en, this message translates to:
  /// **'Virgin Material'**
  String get productVirginMaterial;

  /// No description provided for @productEcoFriendly.
  ///
  /// In en, this message translates to:
  /// **'Eco-friendly: High recycled content'**
  String get productEcoFriendly;

  /// No description provided for @productConsiderRecycled.
  ///
  /// In en, this message translates to:
  /// **'Consider using more recycled materials'**
  String get productConsiderRecycled;

  /// No description provided for @productTechnicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical Details'**
  String get productTechnicalDetails;

  /// No description provided for @productIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Product ID'**
  String get productIdLabel;

  /// No description provided for @productTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get productTypeLabel;

  /// No description provided for @productSustainabilityScore.
  ///
  /// In en, this message translates to:
  /// **'Sustainability Score'**
  String get productSustainabilityScore;

  /// No description provided for @productCarbonFootprintRow.
  ///
  /// In en, this message translates to:
  /// **'Carbon Footprint'**
  String get productCarbonFootprintRow;

  /// No description provided for @productQrDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Product QR Code'**
  String get productQrDialogTitle;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @productShareSoon.
  ///
  /// In en, this message translates to:
  /// **'Share feature coming soon!'**
  String get productShareSoon;

  /// No description provided for @productExportSoon.
  ///
  /// In en, this message translates to:
  /// **'Export feature coming soon!'**
  String get productExportSoon;

  /// No description provided for @productAnalyticsSoon.
  ///
  /// In en, this message translates to:
  /// **'Analytics feature coming soon!'**
  String get productAnalyticsSoon;

  /// No description provided for @productRecycledBadge.
  ///
  /// In en, this message translates to:
  /// **'{percent}% recycled'**
  String productRecycledBadge(Object percent);

  /// No description provided for @commonNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get commonNotFound;

  /// No description provided for @commonNoInfoProvided.
  ///
  /// In en, this message translates to:
  /// **'No information provided'**
  String get commonNoInfoProvided;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get commonComingSoon;

  /// No description provided for @relativeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get relativeJustNow;

  /// No description provided for @relativeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String relativeMinutesAgo(Object count);

  /// No description provided for @relativeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String relativeHoursAgo(Object count);

  /// No description provided for @relativeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String relativeDaysAgo(Object count);

  /// No description provided for @productErrorNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Product not found (ID: {id})'**
  String productErrorNotFoundBody(Object id);

  /// No description provided for @productErrorLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product: {error}'**
  String productErrorLoadFailed(Object error);

  /// No description provided for @productErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get productErrorUnknown;

  /// No description provided for @productUnknownType.
  ///
  /// In en, this message translates to:
  /// **'Unknown Type'**
  String get productUnknownType;

  /// No description provided for @energyRatingExcellent.
  ///
  /// In en, this message translates to:
  /// **'A+ (Excellent)'**
  String get energyRatingExcellent;

  /// No description provided for @energyRatingVeryGood.
  ///
  /// In en, this message translates to:
  /// **'A (Very Good)'**
  String get energyRatingVeryGood;

  /// No description provided for @energyRatingGood.
  ///
  /// In en, this message translates to:
  /// **'B (Good)'**
  String get energyRatingGood;

  /// No description provided for @energyRatingAverage.
  ///
  /// In en, this message translates to:
  /// **'C (Average)'**
  String get energyRatingAverage;

  /// No description provided for @energyRatingBelowAverage.
  ///
  /// In en, this message translates to:
  /// **'D (Below Average)'**
  String get energyRatingBelowAverage;

  /// No description provided for @energyRatingPoor.
  ///
  /// In en, this message translates to:
  /// **'E (Poor)'**
  String get energyRatingPoor;

  /// No description provided for @co2RatingLow.
  ///
  /// In en, this message translates to:
  /// **'Low Impact'**
  String get co2RatingLow;

  /// No description provided for @co2RatingModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate Impact'**
  String get co2RatingModerate;

  /// No description provided for @co2RatingHigh.
  ///
  /// In en, this message translates to:
  /// **'High Impact'**
  String get co2RatingHigh;

  /// No description provided for @co2RatingVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High Impact'**
  String get co2RatingVeryHigh;

  /// No description provided for @productSustainablePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Sustainable'**
  String productSustainablePercent(Object percent);

  /// No description provided for @productCarbonFootprintValue.
  ///
  /// In en, this message translates to:
  /// **'{value} kg CO2/kWh'**
  String productCarbonFootprintValue(Object value);

  /// No description provided for @materialDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Material Details'**
  String get materialDetailsTitle;

  /// No description provided for @materialNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Material not found'**
  String get materialNotFoundTitle;

  /// No description provided for @materialSectionIdentification.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get materialSectionIdentification;

  /// No description provided for @materialSectionManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer & Supply Chain'**
  String get materialSectionManufacturer;

  /// No description provided for @materialSectionComposition.
  ///
  /// In en, this message translates to:
  /// **'Composition'**
  String get materialSectionComposition;

  /// No description provided for @materialSectionPhysical.
  ///
  /// In en, this message translates to:
  /// **'Physical & Processing Data'**
  String get materialSectionPhysical;

  /// No description provided for @materialSectionSustainability.
  ///
  /// In en, this message translates to:
  /// **'Sustainability & Environment'**
  String get materialSectionSustainability;

  /// No description provided for @materialSectionDataQuality.
  ///
  /// In en, this message translates to:
  /// **'Data Quality & Trust'**
  String get materialSectionDataQuality;

  /// No description provided for @materialSectionDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get materialSectionDocuments;

  /// No description provided for @materialHighlightPolymerType.
  ///
  /// In en, this message translates to:
  /// **'Polymer Type'**
  String get materialHighlightPolymerType;

  /// No description provided for @materialHighlightOrigin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get materialHighlightOrigin;

  /// No description provided for @materialHighlightCo2.
  ///
  /// In en, this message translates to:
  /// **'CO2 Footprint'**
  String get materialHighlightCo2;

  /// No description provided for @materialHighlightManufacturerId.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer ID'**
  String get materialHighlightManufacturerId;

  /// No description provided for @materialHighlightRecycledContent.
  ///
  /// In en, this message translates to:
  /// **'Recycled Content'**
  String get materialHighlightRecycledContent;

  /// No description provided for @materialQrDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Material QR Code'**
  String get materialQrDialogTitle;

  /// No description provided for @commonNA.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get commonNA;

  /// No description provided for @fieldMaterialId.
  ///
  /// In en, this message translates to:
  /// **'Material ID'**
  String get fieldMaterialId;

  /// No description provided for @fieldTradeName.
  ///
  /// In en, this message translates to:
  /// **'Trade Name'**
  String get fieldTradeName;

  /// No description provided for @fieldArticleNumber.
  ///
  /// In en, this message translates to:
  /// **'Article Number'**
  String get fieldArticleNumber;

  /// No description provided for @fieldLotNumber.
  ///
  /// In en, this message translates to:
  /// **'Lot / Batch Number'**
  String get fieldLotNumber;

  /// No description provided for @fieldManufacturingDate.
  ///
  /// In en, this message translates to:
  /// **'Manufacturing Date'**
  String get fieldManufacturingDate;

  /// No description provided for @fieldCarrierReference.
  ///
  /// In en, this message translates to:
  /// **'Data Carrier Reference'**
  String get fieldCarrierReference;

  /// No description provided for @fieldManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get fieldManufacturer;

  /// No description provided for @fieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get fieldAddress;

  /// No description provided for @fieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get fieldCountry;

  /// No description provided for @fieldManufacturerId.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer ID'**
  String get fieldManufacturerId;

  /// No description provided for @fieldContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get fieldContact;

  /// No description provided for @fieldSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get fieldSupplier;

  /// No description provided for @fieldProductionSite.
  ///
  /// In en, this message translates to:
  /// **'Production Site'**
  String get fieldProductionSite;

  /// No description provided for @fieldPolymerType.
  ///
  /// In en, this message translates to:
  /// **'Polymer Type'**
  String get fieldPolymerType;

  /// No description provided for @fieldFillerContent.
  ///
  /// In en, this message translates to:
  /// **'Filler & Share'**
  String get fieldFillerContent;

  /// No description provided for @fieldAdditives.
  ///
  /// In en, this message translates to:
  /// **'Additives / Colorants'**
  String get fieldAdditives;

  /// No description provided for @fieldRecycledContent.
  ///
  /// In en, this message translates to:
  /// **'Recycled Content'**
  String get fieldRecycledContent;

  /// No description provided for @fieldRecycledOrigin.
  ///
  /// In en, this message translates to:
  /// **'Recycled Origin'**
  String get fieldRecycledOrigin;

  /// No description provided for @fieldBiobasedContent.
  ///
  /// In en, this message translates to:
  /// **'Biobased Content'**
  String get fieldBiobasedContent;

  /// No description provided for @fieldHazardousSubstances.
  ///
  /// In en, this message translates to:
  /// **'Hazardous Substances'**
  String get fieldHazardousSubstances;

  /// No description provided for @fieldFilamentDiameter.
  ///
  /// In en, this message translates to:
  /// **'Filament Diameter'**
  String get fieldFilamentDiameter;

  /// No description provided for @fieldDensity.
  ///
  /// In en, this message translates to:
  /// **'Density'**
  String get fieldDensity;

  /// No description provided for @fieldSpoolWeight.
  ///
  /// In en, this message translates to:
  /// **'Spool Weight'**
  String get fieldSpoolWeight;

  /// No description provided for @fieldNozzleTemperature.
  ///
  /// In en, this message translates to:
  /// **'Nozzle Temperature'**
  String get fieldNozzleTemperature;

  /// No description provided for @fieldBedTemperature.
  ///
  /// In en, this message translates to:
  /// **'Bed / Chamber Temperature'**
  String get fieldBedTemperature;

  /// No description provided for @fieldDryingRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Drying Recommendation'**
  String get fieldDryingRecommendation;

  /// No description provided for @fieldMechanicalProperties.
  ///
  /// In en, this message translates to:
  /// **'Mechanical Properties'**
  String get fieldMechanicalProperties;

  /// No description provided for @fieldMoistureContent.
  ///
  /// In en, this message translates to:
  /// **'Moisture Content'**
  String get fieldMoistureContent;

  /// No description provided for @fieldCo2Footprint.
  ///
  /// In en, this message translates to:
  /// **'CO2 Footprint (PCF)'**
  String get fieldCo2Footprint;

  /// No description provided for @fieldCalculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get fieldCalculationMethod;

  /// No description provided for @fieldEnergyConsumption.
  ///
  /// In en, this message translates to:
  /// **'Energy Consumption'**
  String get fieldEnergyConsumption;

  /// No description provided for @fieldRecyclability.
  ///
  /// In en, this message translates to:
  /// **'Recyclability'**
  String get fieldRecyclability;

  /// No description provided for @fieldDisposalInfo.
  ///
  /// In en, this message translates to:
  /// **'Disposal Information'**
  String get fieldDisposalInfo;

  /// No description provided for @fieldDataQualityLevel.
  ///
  /// In en, this message translates to:
  /// **'Data Quality Level'**
  String get fieldDataQualityLevel;

  /// No description provided for @fieldDataSource.
  ///
  /// In en, this message translates to:
  /// **'Data Source'**
  String get fieldDataSource;

  /// No description provided for @fieldCertificateReference.
  ///
  /// In en, this message translates to:
  /// **'Certificate Reference'**
  String get fieldCertificateReference;

  /// No description provided for @fieldDigitalSignature.
  ///
  /// In en, this message translates to:
  /// **'Digital Signature'**
  String get fieldDigitalSignature;

  /// No description provided for @fieldValidityDate.
  ///
  /// In en, this message translates to:
  /// **'Validity Date'**
  String get fieldValidityDate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
