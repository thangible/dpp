// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'DPP Passport';

  @override
  String get appSubtitle => 'Digitaler Produktpass';

  @override
  String get tabHome => 'Start';

  @override
  String get tabHistory => 'Verlauf';

  @override
  String get tabProfile => 'Profil';

  @override
  String get tabMore => 'Mehr';

  @override
  String get drawerHelp => 'Hilfe';

  @override
  String get drawerFeedback => 'Feedback';

  @override
  String get drawerInviteFriend => 'Freund einladen';

  @override
  String get drawerRateApp => 'App bewerten';

  @override
  String get drawerAboutUs => 'Über uns';

  @override
  String get drawerDarkMode => 'Dunkelmodus';

  @override
  String get drawerSignOut => 'Abmelden';

  @override
  String get signInUsername => 'Benutzername';

  @override
  String get signInPassword => 'Passwort';

  @override
  String get signInButton => 'Anmelden';

  @override
  String get signInGuestButton => 'Als Gast fortfahren';

  @override
  String get signInError => 'Benutzername oder Passwort ist falsch.';

  @override
  String get signInUsernameRequired => 'Benutzernamen eingeben';

  @override
  String get signInPasswordRequired => 'Passwort eingeben';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingGetStarted => 'Los geht\'s';

  @override
  String get onboardingSlide1Title => 'Jeden Code scannen';

  @override
  String get onboardingSlide1Body =>
      'Richten Sie Ihre Kamera auf ein Produkt- oder Materialetikett, um sofort den digitalen Pass aufzurufen.';

  @override
  String get onboardingSlide2Title => 'Den Fußabdruck sehen';

  @override
  String get onboardingSlide2Body =>
      'Energieverbrauch, CO2-Emissionen und Rezyklatanteil auf einen Blick, genau dort, wo Sie sie brauchen.';

  @override
  String get onboardingSlide3Title => 'Das Material verfolgen';

  @override
  String get onboardingSlide3Body =>
      'Jedes Produkt verweist auf sein Material — vollständige Zusammensetzung, Herkunft und Nachhaltigkeitsdaten.';

  @override
  String get onboardingSlide4Title => 'Anmelden oder einfach stöbern';

  @override
  String get onboardingSlide4Body =>
      'Erstellen Sie ein Konto, um Ihren Verlauf zu speichern, oder steigen Sie direkt als Gast ein.';

  @override
  String get homeModeProduct => 'Produkt';

  @override
  String get homeModeMaterial => 'Material';

  @override
  String get homeSearchHintProduct => 'Produkt-ID';

  @override
  String get homeSearchHintMaterial => 'Material-ID';

  @override
  String homeErrorProductNotFound(Object id) {
    return 'Kein Produkt für \"$id\" gefunden';
  }

  @override
  String homeErrorMaterialNotFound(Object id) {
    return 'Kein Material für \"$id\" gefunden';
  }

  @override
  String get homeLastSearched => 'Zuletzt gesucht';

  @override
  String get homeEmptyProductsTitle => 'Noch keine Produkte gesucht';

  @override
  String get homeEmptyMaterialsTitle => 'Noch keine Materialien gesucht';

  @override
  String get homeEmptyHint =>
      'Geben Sie oben eine ID ein oder nutzen Sie den Scanner, um einen Eintrag hinzuzufügen.';

  @override
  String get homeScanButton => 'Code scannen';

  @override
  String get homeGuestCardTitle => 'Für mehr Funktionen anmelden';

  @override
  String get homeGuestCardBody =>
      'Bewahren Sie Ihren Verlauf sitzungsübergreifend auf und richten Sie ein Profil ein.';

  @override
  String get historyTitle => 'Verlauf & Favoriten';

  @override
  String get historyFavoritesSection => 'Favoriten';

  @override
  String get historyRecentSection => 'Zuletzt angesehen';

  @override
  String get historyFavoritesEmpty =>
      'Noch nichts favorisiert. Tippen Sie auf den Stern eines Eintrags, um ihn hier zu speichern.';

  @override
  String get historyRecentEmpty =>
      'Noch kein Verlauf. Suchen oder scannen Sie ein Produkt/Material, um es hier zu sehen.';

  @override
  String historySeeAll(Object count) {
    return 'Alle anzeigen ($count)';
  }

  @override
  String get historyShowLess => 'Weniger anzeigen';

  @override
  String get historyItemProduct => 'Produkt';

  @override
  String get historyItemMaterial => 'Material';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileGuestTitle => 'Zum Einrichten eines Profils anmelden';

  @override
  String get profileGuestBody =>
      'Gäste können stöbern und den Verlauf für diese Sitzung behalten, aber ein Profil erfordert ein Konto.';

  @override
  String get profileSignIn => 'Anmelden';

  @override
  String get profileDisplayName => 'Anzeigename';

  @override
  String get profileNameHint => 'Ihr Name';

  @override
  String get profileSave => 'Speichern';

  @override
  String get profileSaved => 'Gespeichert ✓';

  @override
  String profileSignedInAs(Object username) {
    return 'Angemeldet als $username';
  }

  @override
  String get profileSignOut => 'Abmelden';

  @override
  String get profileLanguage => 'Sprache';

  @override
  String get profileLanguageEnglish => 'Englisch';

  @override
  String get profileLanguageGerman => 'Deutsch';

  @override
  String get profileLanguageSystem => 'Systemsprache';

  @override
  String get scannerTitle => 'QR-Code scannen';

  @override
  String scannerNoMatch(Object code) {
    return 'Keine Übereinstimmung für \"$code\"';
  }

  @override
  String get scannerScanAgain => 'Erneut scannen';

  @override
  String get scannerPermissionTitle => 'Kamerazugriff erforderlich';

  @override
  String get scannerPermissionBody =>
      'Aktivieren Sie den Kamerazugriff in den Einstellungen, um einen QR-Code zu scannen.';

  @override
  String get scannerOpenSettings => 'Einstellungen öffnen';

  @override
  String get productDetailsTitle => 'Produktdetails';

  @override
  String get productManufacturer => 'Hersteller';

  @override
  String get productMaterialLabel => 'Material';

  @override
  String get productLastUpdated => 'Zuletzt aktualisiert';

  @override
  String get productLoading => 'Produktdetails werden geladen...';

  @override
  String get productNotFoundTitle => 'Hoppla! Etwas ist schiefgelaufen';

  @override
  String get productTryAgain => 'Erneut versuchen';

  @override
  String get productQuickActions => 'Schnellzugriff';

  @override
  String get productActionQr => 'QR-Code';

  @override
  String get productActionShare => 'Teilen';

  @override
  String get productActionExport => 'Exportieren';

  @override
  String get productActionAnalytics => 'Analyse';

  @override
  String get productNoImage => 'Kein Bild verfügbar';

  @override
  String get productCarbonFootprint => 'CO2-Fußabdruck';

  @override
  String get productCo2Process => 'CO2 aus Prozess';

  @override
  String get productCo2Material => 'CO2 aus Material';

  @override
  String get productCo2Total => 'Gesamt (indikativ)';

  @override
  String get productCo2TotalNote =>
      'Prozess (kg) + Material-PCF (kg CO2e/kg) — eine vereinfachte Schätzung, keine einheitennormierte Ökobilanz.';

  @override
  String get productEnvironmentalImpact => 'Umweltauswirkungen';

  @override
  String get productEnergyUsed => 'Energieverbrauch (Prozess)';

  @override
  String get productMaterialComposition => 'Materialzusammensetzung';

  @override
  String get productRecycledMaterial => 'Rezyklatmaterial';

  @override
  String get productVirginMaterial => 'Neumaterial';

  @override
  String get productEcoFriendly => 'Umweltfreundlich: hoher Rezyklatanteil';

  @override
  String get productConsiderRecycled =>
      'Erwägen Sie einen höheren Rezyklatanteil';

  @override
  String get productTechnicalDetails => 'Technische Details';

  @override
  String get productIdLabel => 'Produkt-ID';

  @override
  String get productTypeLabel => 'Typ';

  @override
  String get productSustainabilityScore => 'Nachhaltigkeitswert';

  @override
  String get productCarbonFootprintRow => 'CO2-Fußabdruck';

  @override
  String get productQrDialogTitle => 'Produkt-QR-Code';

  @override
  String get commonClose => 'Schließen';

  @override
  String get productShareSoon => 'Teilen-Funktion folgt in Kürze!';

  @override
  String get productExportSoon => 'Export-Funktion folgt in Kürze!';

  @override
  String get productAnalyticsSoon => 'Analyse-Funktion folgt in Kürze!';

  @override
  String productRecycledBadge(Object percent) {
    return '$percent% rezykliert';
  }

  @override
  String get commonNotFound => 'Produkt nicht gefunden';

  @override
  String get commonNoInfoProvided => 'Keine Informationen angegeben';

  @override
  String get commonComingSoon => 'Demnächst verfügbar!';

  @override
  String get relativeJustNow => 'Gerade eben';

  @override
  String relativeMinutesAgo(Object count) {
    return 'vor $count Min.';
  }

  @override
  String relativeHoursAgo(Object count) {
    return 'vor $count Std.';
  }

  @override
  String relativeDaysAgo(Object count) {
    return 'vor $count Tg.';
  }

  @override
  String productErrorNotFoundBody(Object id) {
    return 'Produkt nicht gefunden (ID: $id)';
  }

  @override
  String productErrorLoadFailed(Object error) {
    return 'Produkt konnte nicht geladen werden: $error';
  }

  @override
  String get productErrorUnknown => 'Unbekannter Fehler aufgetreten';

  @override
  String get productUnknownType => 'Unbekannter Typ';

  @override
  String get energyRatingExcellent => 'A+ (Ausgezeichnet)';

  @override
  String get energyRatingVeryGood => 'A (Sehr gut)';

  @override
  String get energyRatingGood => 'B (Gut)';

  @override
  String get energyRatingAverage => 'C (Durchschnittlich)';

  @override
  String get energyRatingBelowAverage => 'D (Unterdurchschnittlich)';

  @override
  String get energyRatingPoor => 'E (Schlecht)';

  @override
  String get co2RatingLow => 'Geringe Auswirkung';

  @override
  String get co2RatingModerate => 'Mäßige Auswirkung';

  @override
  String get co2RatingHigh => 'Hohe Auswirkung';

  @override
  String get co2RatingVeryHigh => 'Sehr hohe Auswirkung';

  @override
  String productSustainablePercent(Object percent) {
    return '$percent% nachhaltig';
  }

  @override
  String productCarbonFootprintValue(Object value) {
    return '$value kg CO2/kWh';
  }

  @override
  String get materialDetailsTitle => 'Materialdetails';

  @override
  String get materialNotFoundTitle => 'Material nicht gefunden';

  @override
  String get materialSectionIdentification => 'Identifikation';

  @override
  String get materialSectionManufacturer => 'Hersteller / Lieferkette';

  @override
  String get materialSectionComposition => 'Materialzusammensetzung';

  @override
  String get materialSectionPhysical => 'Physikalische & Verarbeitungsdaten';

  @override
  String get materialSectionSustainability => 'Nachhaltigkeit / Umwelt';

  @override
  String get materialSectionDataQuality => 'Datenqualität & Vertrauen';

  @override
  String get materialSectionDocuments => 'Dokumente';

  @override
  String get materialHighlightPolymerType => 'Polymertyp';

  @override
  String get materialHighlightOrigin => 'Herkunft';

  @override
  String get materialHighlightCo2 => 'CO2-Fußabdruck';

  @override
  String get materialHighlightManufacturerId => 'Hersteller-ID';

  @override
  String get materialHighlightRecycledContent => 'Rezyklatanteil';

  @override
  String get materialQrDialogTitle => 'Material-QR-Code';

  @override
  String get commonNA => 'N/A';

  @override
  String get fieldMaterialId => 'Material-AAS-ID';

  @override
  String get fieldTradeName => 'Handelsname';

  @override
  String get fieldArticleNumber => 'Artikelnummer';

  @override
  String get fieldLotNumber => 'Chargen-/Lot-Nummer';

  @override
  String get fieldManufacturingDate => 'Herstellungsdatum';

  @override
  String get fieldCarrierReference => 'Datenträger-Referenz';

  @override
  String get fieldManufacturer => 'Hersteller';

  @override
  String get fieldAddress => 'Adresse';

  @override
  String get fieldCountry => 'Land';

  @override
  String get fieldManufacturerId => 'Hersteller-ID';

  @override
  String get fieldContact => 'Ansprechpartner';

  @override
  String get fieldSupplier => 'Lieferant';

  @override
  String get fieldProductionSite => 'Produktionsstandort';

  @override
  String get fieldPolymerType => 'Polymertyp';

  @override
  String get fieldFillerContent => 'Füllstoff & Anteil';

  @override
  String get fieldAdditives => 'Additive / Farbmittel';

  @override
  String get fieldRecycledContent => 'Rezyklatanteil';

  @override
  String get fieldRecycledOrigin => 'Rezyklat-Herkunft';

  @override
  String get fieldBiobasedContent => 'Biobasierter Anteil';

  @override
  String get fieldHazardousSubstances => 'Gefahrstoff-/SVHC-Angaben';

  @override
  String get fieldFilamentDiameter => 'Filamentdurchmesser';

  @override
  String get fieldDensity => 'Dichte';

  @override
  String get fieldSpoolWeight => 'Spulengewicht';

  @override
  String get fieldNozzleTemperature => 'Düsentemperatur';

  @override
  String get fieldBedTemperature => 'Bett-/Kammertemperatur';

  @override
  String get fieldDryingRecommendation => 'Trocknungsempfehlung';

  @override
  String get fieldMechanicalProperties => 'Mechanische Kennwerte';

  @override
  String get fieldMoistureContent => 'Feuchtegehalt';

  @override
  String get fieldCo2Footprint => 'CO2-Fußabdruck (PCF)';

  @override
  String get fieldCalculationMethod => 'Berechnungsmethode';

  @override
  String get fieldEnergyConsumption => 'Energieverbrauch';

  @override
  String get fieldRecyclability => 'Recyclingfähigkeit';

  @override
  String get fieldDisposalInfo => 'Entsorgungshinweise';

  @override
  String get fieldDataQualityLevel => 'Datenqualitätsstufe (DQL)';

  @override
  String get fieldDataSource => 'Datenquelle';

  @override
  String get fieldCertificateReference => 'Zertifikatsreferenz';

  @override
  String get fieldDigitalSignature => 'Digitale Signatur';

  @override
  String get fieldValidityDate => 'Gültigkeitsdatum';
}
