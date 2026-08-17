// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DPP Passport';

  @override
  String get appSubtitle => 'Digital Product Passport';

  @override
  String get tabHome => 'Home';

  @override
  String get tabHistory => 'History';

  @override
  String get tabProfile => 'Profile';

  @override
  String get tabMore => 'More';

  @override
  String get drawerHelp => 'Help';

  @override
  String get drawerFeedback => 'FeedBack';

  @override
  String get drawerInviteFriend => 'Invite Friend';

  @override
  String get drawerRateApp => 'Rate the app';

  @override
  String get drawerAboutUs => 'About Us';

  @override
  String get drawerDarkMode => 'Dark mode';

  @override
  String get drawerSignOut => 'Sign Out';

  @override
  String get signInUsername => 'Username';

  @override
  String get signInPassword => 'Password';

  @override
  String get signInButton => 'Sign In';

  @override
  String get signInGuestButton => 'Continue as Guest';

  @override
  String get signInError => 'Incorrect username or password.';

  @override
  String get signInUsernameRequired => 'Enter your username';

  @override
  String get signInPasswordRequired => 'Enter your password';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingSlide1Title => 'Scan any code';

  @override
  String get onboardingSlide1Body =>
      'Point your camera at a product or material label to instantly pull up its digital passport.';

  @override
  String get onboardingSlide2Title => 'See its footprint';

  @override
  String get onboardingSlide2Body =>
      'View energy use, CO2 emissions, and recycled content at a glance, right where you need them.';

  @override
  String get onboardingSlide3Title => 'Trace the material';

  @override
  String get onboardingSlide3Body =>
      'Every product links to the material it\'s made from — full composition, origin, and sustainability data.';

  @override
  String get onboardingSlide4Title => 'Sign in, or just browse';

  @override
  String get onboardingSlide4Body =>
      'Create an account to keep your history across visits, or jump straight in as a guest.';

  @override
  String get homeModeProduct => 'Product';

  @override
  String get homeModeMaterial => 'Material';

  @override
  String get homeSearchHintProduct => 'Product ID';

  @override
  String get homeSearchHintMaterial => 'Material ID';

  @override
  String homeErrorProductNotFound(Object id) {
    return 'No product found for \"$id\"';
  }

  @override
  String homeErrorMaterialNotFound(Object id) {
    return 'No material found for \"$id\"';
  }

  @override
  String get homeLastSearched => 'Last Searched';

  @override
  String get homeEmptyProductsTitle => 'No products searched yet';

  @override
  String get homeEmptyMaterialsTitle => 'No materials searched yet';

  @override
  String get homeEmptyHint =>
      'Enter an ID above or use the scanner to add one to your list.';

  @override
  String get homeScanButton => 'Scan a code';

  @override
  String get homeGuestCardTitle => 'Sign in for more';

  @override
  String get homeGuestCardBody =>
      'Keep your history across sessions and set up a profile.';

  @override
  String get historyTitle => 'History & Favorites';

  @override
  String get historyFavoritesSection => 'Favorites';

  @override
  String get historyRecentSection => 'Recent';

  @override
  String get historyFavoritesEmpty =>
      'Nothing favorited yet. Tap the star on any item to save it here.';

  @override
  String get historyRecentEmpty =>
      'No history yet. Search or scan a product/material to see it here.';

  @override
  String historySeeAll(Object count) {
    return 'See all ($count)';
  }

  @override
  String get historyShowLess => 'Show less';

  @override
  String get historyItemProduct => 'Product';

  @override
  String get historyItemMaterial => 'Material';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileGuestTitle => 'Sign in to set up your profile';

  @override
  String get profileGuestBody =>
      'Guests can browse and keep history for this session, but a profile needs an account.';

  @override
  String get profileSignIn => 'Sign In';

  @override
  String get profileDisplayName => 'Display name';

  @override
  String get profileNameHint => 'Your name';

  @override
  String get profileSave => 'Save';

  @override
  String get profileSaved => 'Saved ✓';

  @override
  String profileSignedInAs(Object username) {
    return 'Signed in as $username';
  }

  @override
  String get profileSignOut => 'Sign Out';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageGerman => 'German';

  @override
  String get profileLanguageSystem => 'Match system';

  @override
  String get scannerTitle => 'Scan QR Code';

  @override
  String scannerNoMatch(Object code) {
    return 'No match for \"$code\"';
  }

  @override
  String get scannerScanAgain => 'Scan Again';

  @override
  String get scannerPermissionTitle => 'Camera access needed';

  @override
  String get scannerPermissionBody =>
      'Enable camera access in Settings to scan a QR code.';

  @override
  String get scannerOpenSettings => 'Open Settings';

  @override
  String get productDetailsTitle => 'Product Details';

  @override
  String get productManufacturer => 'Manufacturer';

  @override
  String get productMaterialLabel => 'Material';

  @override
  String get productLastUpdated => 'Last Updated';

  @override
  String get productLoading => 'Loading product details...';

  @override
  String get productNotFoundTitle => 'Oops! Something went wrong';

  @override
  String get productTryAgain => 'Try Again';

  @override
  String get productQuickActions => 'Quick Actions';

  @override
  String get productActionQr => 'QR Code';

  @override
  String get productActionShare => 'Share';

  @override
  String get productActionExport => 'Export';

  @override
  String get productActionAnalytics => 'Analytics';

  @override
  String get productNoImage => 'No image available';

  @override
  String get productCarbonFootprint => 'Carbon Footprint';

  @override
  String get productCo2Process => 'CO2 from Process';

  @override
  String get productCo2Material => 'CO2 from Material';

  @override
  String get productCo2Total => 'Total (indicative)';

  @override
  String get productCo2TotalNote =>
      'Process (kg) + material PCF (kg CO2e/kg) — a simplified estimate, not a unit-normalized LCA figure.';

  @override
  String get productEnvironmentalImpact => 'Environmental Impact';

  @override
  String get productEnergyUsed => 'Energy Used (Process)';

  @override
  String get productMaterialComposition => 'Material Composition';

  @override
  String get productRecycledMaterial => 'Recycled Material';

  @override
  String get productVirginMaterial => 'Virgin Material';

  @override
  String get productEcoFriendly => 'Eco-friendly: High recycled content';

  @override
  String get productConsiderRecycled =>
      'Consider using more recycled materials';

  @override
  String get productTechnicalDetails => 'Technical Details';

  @override
  String get productIdLabel => 'Product ID';

  @override
  String get productTypeLabel => 'Type';

  @override
  String get productSustainabilityScore => 'Sustainability Score';

  @override
  String get productCarbonFootprintRow => 'Carbon Footprint';

  @override
  String get productQrDialogTitle => 'Product QR Code';

  @override
  String get commonClose => 'Close';

  @override
  String get productShareSoon => 'Share feature coming soon!';

  @override
  String get productExportSoon => 'Export feature coming soon!';

  @override
  String get productAnalyticsSoon => 'Analytics feature coming soon!';

  @override
  String productRecycledBadge(Object percent) {
    return '$percent% recycled';
  }

  @override
  String get commonNotFound => 'Product not found';

  @override
  String get commonNoInfoProvided => 'No information provided';

  @override
  String get commonComingSoon => 'Coming soon!';

  @override
  String get relativeJustNow => 'Just now';

  @override
  String relativeMinutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String relativeHoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String relativeDaysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String productErrorNotFoundBody(Object id) {
    return 'Product not found (ID: $id)';
  }

  @override
  String productErrorLoadFailed(Object error) {
    return 'Failed to load product: $error';
  }

  @override
  String get productErrorUnknown => 'Unknown error occurred';

  @override
  String get productUnknownType => 'Unknown Type';

  @override
  String get energyRatingExcellent => 'A+ (Excellent)';

  @override
  String get energyRatingVeryGood => 'A (Very Good)';

  @override
  String get energyRatingGood => 'B (Good)';

  @override
  String get energyRatingAverage => 'C (Average)';

  @override
  String get energyRatingBelowAverage => 'D (Below Average)';

  @override
  String get energyRatingPoor => 'E (Poor)';

  @override
  String get co2RatingLow => 'Low Impact';

  @override
  String get co2RatingModerate => 'Moderate Impact';

  @override
  String get co2RatingHigh => 'High Impact';

  @override
  String get co2RatingVeryHigh => 'Very High Impact';

  @override
  String productSustainablePercent(Object percent) {
    return '$percent% Sustainable';
  }

  @override
  String productCarbonFootprintValue(Object value) {
    return '$value kg CO2/kWh';
  }

  @override
  String get materialDetailsTitle => 'Material Details';

  @override
  String get materialNotFoundTitle => 'Material not found';

  @override
  String get materialSectionIdentification => 'Identification';

  @override
  String get materialSectionManufacturer => 'Manufacturer & Supply Chain';

  @override
  String get materialSectionComposition => 'Composition';

  @override
  String get materialSectionPhysical => 'Physical & Processing Data';

  @override
  String get materialSectionSustainability => 'Sustainability & Environment';

  @override
  String get materialSectionDataQuality => 'Data Quality & Trust';

  @override
  String get materialSectionDocuments => 'Documents';

  @override
  String get materialHighlightPolymerType => 'Polymer Type';

  @override
  String get materialHighlightOrigin => 'Origin';

  @override
  String get materialHighlightCo2 => 'CO2 Footprint';

  @override
  String get materialHighlightManufacturerId => 'Manufacturer ID';

  @override
  String get materialHighlightRecycledContent => 'Recycled Content';

  @override
  String get materialQrDialogTitle => 'Material QR Code';

  @override
  String get commonNA => 'N/A';

  @override
  String get fieldMaterialId => 'Material ID';

  @override
  String get fieldTradeName => 'Trade Name';

  @override
  String get fieldArticleNumber => 'Article Number';

  @override
  String get fieldLotNumber => 'Lot / Batch Number';

  @override
  String get fieldManufacturingDate => 'Manufacturing Date';

  @override
  String get fieldCarrierReference => 'Data Carrier Reference';

  @override
  String get fieldManufacturer => 'Manufacturer';

  @override
  String get fieldAddress => 'Address';

  @override
  String get fieldCountry => 'Country';

  @override
  String get fieldManufacturerId => 'Manufacturer ID';

  @override
  String get fieldContact => 'Contact';

  @override
  String get fieldSupplier => 'Supplier';

  @override
  String get fieldProductionSite => 'Production Site';

  @override
  String get fieldPolymerType => 'Polymer Type';

  @override
  String get fieldFillerContent => 'Filler & Share';

  @override
  String get fieldAdditives => 'Additives / Colorants';

  @override
  String get fieldRecycledContent => 'Recycled Content';

  @override
  String get fieldRecycledOrigin => 'Recycled Origin';

  @override
  String get fieldBiobasedContent => 'Biobased Content';

  @override
  String get fieldHazardousSubstances => 'Hazardous Substances';

  @override
  String get fieldFilamentDiameter => 'Filament Diameter';

  @override
  String get fieldDensity => 'Density';

  @override
  String get fieldSpoolWeight => 'Spool Weight';

  @override
  String get fieldNozzleTemperature => 'Nozzle Temperature';

  @override
  String get fieldBedTemperature => 'Bed / Chamber Temperature';

  @override
  String get fieldDryingRecommendation => 'Drying Recommendation';

  @override
  String get fieldMechanicalProperties => 'Mechanical Properties';

  @override
  String get fieldMoistureContent => 'Moisture Content';

  @override
  String get fieldCo2Footprint => 'CO2 Footprint (PCF)';

  @override
  String get fieldCalculationMethod => 'Calculation Method';

  @override
  String get fieldEnergyConsumption => 'Energy Consumption';

  @override
  String get fieldRecyclability => 'Recyclability';

  @override
  String get fieldDisposalInfo => 'Disposal Information';

  @override
  String get fieldDataQualityLevel => 'Data Quality Level';

  @override
  String get fieldDataSource => 'Data Source';

  @override
  String get fieldCertificateReference => 'Certificate Reference';

  @override
  String get fieldDigitalSignature => 'Digital Signature';

  @override
  String get fieldValidityDate => 'Validity Date';
}
