import 'package:dpp/l10n/generated/app_localizations.dart';

/// Pure formatting/rating helpers shared by the product-detail section
/// widgets. Kept separate from the widgets themselves since none of them
/// need a [BuildContext] — just a value and the localizations to translate
/// the rating band into.

String formatDateTime(DateTime dateTime) {
  return '${dateTime.day.toString().padLeft(2, '0')}/'
      '${dateTime.month.toString().padLeft(2, '0')}/'
      '${dateTime.year} '
      '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}';
}

String energyEfficiencyRating(AppLocalizations l10n, double energyUsed) {
  if (energyUsed < 50) return l10n.energyRatingExcellent;
  if (energyUsed < 100) return l10n.energyRatingVeryGood;
  if (energyUsed < 150) return l10n.energyRatingGood;
  if (energyUsed < 200) return l10n.energyRatingAverage;
  if (energyUsed < 300) return l10n.energyRatingBelowAverage;
  return l10n.energyRatingPoor;
}

String co2Rating(AppLocalizations l10n, double co2Emissions) {
  if (co2Emissions < 10) return l10n.co2RatingLow;
  if (co2Emissions < 25) return l10n.co2RatingModerate;
  if (co2Emissions < 50) return l10n.co2RatingHigh;
  return l10n.co2RatingVeryHigh;
}

/// % of the product's material that's recycled, out of virgin+recycled.
String sustainabilityScore(
  AppLocalizations l10n, {
  required double? virginMaterial,
  required double? recycledMaterial,
}) {
  final virgin = virginMaterial ?? 0;
  final recycled = recycledMaterial ?? 0;
  final total = virgin + recycled;
  if (total <= 0) return l10n.commonNA;

  final score = (recycled / total) * 100;
  return l10n.productSustainablePercent(score.toStringAsFixed(1));
}

/// A legacy per-energy carbon-footprint figure (kg CO2 / kWh), shown in the
/// Technical Details table alongside the newer process/material breakdown.
String legacyCarbonFootprint(
  AppLocalizations l10n, {
  required double? energyUsed,
  required double? co2Emissions,
}) {
  final energy = energyUsed ?? 0;
  final co2 = co2Emissions ?? 0;
  if (energy <= 0) return l10n.commonNA;

  final footprint = co2 / energy;
  return l10n.productCarbonFootprintValue(footprint.toStringAsFixed(3));
}
