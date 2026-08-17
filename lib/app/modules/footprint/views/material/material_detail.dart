import 'package:flutter/material.dart' hide Material;
import 'package:get/get.dart';
import 'package:dpp/app/data_model/material/material.dart' as model;
import 'package:dpp/app/data_model/history/history_entry.dart';
import 'package:dpp/app/modules/history/controllers/history_controller.dart';
import 'package:dpp/app/services/test/material_service.dart';
import 'package:dpp/l10n/generated/app_localizations.dart';
import 'widgets/material_overview_card.dart';
import 'widgets/material_highlights.dart';
import 'widgets/material_section_card.dart';
import 'widgets/material_documents_card.dart';
import 'widgets/material_qr_dialog.dart';

/// Material passport screen: five "highlight" fields shown as icon tiles
/// up top, everything else in the same 7 sections as the field spec this
/// was built from (Identification, Manufacturer/Supply chain, Composition,
/// Physical/Processing data, Sustainability, Data quality, Documents). Each
/// section is a [MaterialSectionCard] built from this screen's own data —
/// the section widgets themselves are pure display, no logic.
class MaterialDetailScreen extends StatefulWidget {
  final model.Material? material;
  final String? materialId;

  const MaterialDetailScreen({super.key, this.material, this.materialId});

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  model.Material? material;
  bool _noInfoProvided = false;
  String? _notFoundId;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    if (widget.material != null) {
      material = widget.material;
    } else if (widget.materialId != null) {
      material = MaterialService.getMaterialById(widget.materialId!);
      if (material == null) _notFoundId = widget.materialId;
    } else {
      _noInfoProvided = true;
    }
    _logHistory();
  }

  // Log to history regardless of how we got here (Home search, scanner, or
  // tapping through from a Product) so "last viewed" on Home reflects every
  // real way a material gets looked at, not just direct search. Deferred a
  // frame: firing this synchronously from initState mutates the shared
  // HistoryController while this screen's own route is still being built,
  // which trips "setState() or markNeedsBuild() called during build" for
  // the Home screen's Obx sitting underneath.
  void _logHistory() {
    final id = material?.id;
    if (id == null || !Get.isRegistered<HistoryController>()) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HistoryController>().addEntry(id, HistoryItemType.material);
    });
  }

  bool get _hasError => _noInfoProvided || _notFoundId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_l10n.materialDetailsTitle),
        actions: [
          if (material != null)
            IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () => showMaterialQrDialog(context, material!.id),
            ),
        ],
      ),
      body:
          _hasError
              ? _buildError()
              : material == null
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(material!),
    );
  }

  Widget _buildError() {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 24),
            Text(_l10n.materialNotFoundTitle, style: text.headlineSmall),
            const SizedBox(height: 12),
            Text(
              _notFoundId != null
                  ? _l10n.homeErrorMaterialNotFound(_notFoundId!)
                  : _l10n.commonNoInfoProvided,
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(model.Material m) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MaterialOverviewCard(material: m),
          const SizedBox(height: 20),
          MaterialHighlights(material: m),
          const SizedBox(height: 24),
          MaterialSectionCard(
            title: _l10n.materialSectionIdentification,
            icon: Icons.fingerprint,
            rows: [
              (_l10n.fieldMaterialId, m.id),
              (_l10n.fieldTradeName, m.tradeName),
              (_l10n.fieldArticleNumber, m.articleNumber),
              (_l10n.fieldLotNumber, m.lotNumber),
              (
                _l10n.fieldManufacturingDate,
                m.manufacturingDate != null
                    ? _formatDate(m.manufacturingDate!)
                    : null,
              ),
              (_l10n.fieldCarrierReference, m.carrierReferenceUri),
            ],
          ),
          MaterialSectionCard(
            title: _l10n.materialSectionManufacturer,
            icon: Icons.factory_outlined,
            rows: [
              (_l10n.fieldManufacturer, m.manufacturerName),
              (_l10n.fieldAddress, m.manufacturerAddress),
              (_l10n.fieldCountry, m.manufacturerCountry),
              (_l10n.fieldManufacturerId, m.manufacturerId),
              (_l10n.fieldContact, m.contact),
              (_l10n.fieldSupplier, m.supplier),
              (_l10n.fieldProductionSite, m.productionSite),
            ],
          ),
          MaterialSectionCard(
            title: _l10n.materialSectionComposition,
            icon: Icons.science_outlined,
            rows: [
              (_l10n.fieldPolymerType, m.polymerType),
              (_l10n.fieldFillerContent, m.fillerContent),
              (_l10n.fieldAdditives, m.additives),
              (
                _l10n.fieldRecycledContent,
                m.recycledContentPercent != null
                    ? '${m.recycledContentPercent!.toStringAsFixed(0)}%'
                    : null,
              ),
              (_l10n.fieldRecycledOrigin, m.recycledOrigin),
              (
                _l10n.fieldBiobasedContent,
                m.biobasedPercent != null
                    ? '${m.biobasedPercent!.toStringAsFixed(0)}%'
                    : null,
              ),
              (_l10n.fieldHazardousSubstances, m.hazardousSubstances),
            ],
          ),
          MaterialSectionCard(
            title: _l10n.materialSectionPhysical,
            icon: Icons.settings_outlined,
            rows: [
              (_l10n.fieldFilamentDiameter, m.filamentDiameter),
              (_l10n.fieldDensity, m.density),
              (_l10n.fieldSpoolWeight, m.spoolWeight),
              (_l10n.fieldNozzleTemperature, m.nozzleTemperature),
              (_l10n.fieldBedTemperature, m.bedTemperature),
              (_l10n.fieldDryingRecommendation, m.dryingRecommendation),
              (_l10n.fieldMechanicalProperties, m.mechanicalProperties),
              (
                _l10n.fieldMoistureContent,
                m.moistureContent != null ? '${m.moistureContent}%' : null,
              ),
            ],
          ),
          MaterialSectionCard(
            title: _l10n.materialSectionSustainability,
            icon: Icons.eco_outlined,
            rows: [
              (
                _l10n.fieldCo2Footprint,
                m.co2FootprintPerKg != null
                    ? '${m.co2FootprintPerKg} kg CO2e/kg'
                    : null,
              ),
              (_l10n.fieldCalculationMethod, m.calculationMethod),
              (_l10n.fieldEnergyConsumption, m.energyConsumption),
              (_l10n.fieldRecyclability, m.recyclability),
              (_l10n.fieldDisposalInfo, m.disposalInfo),
            ],
          ),
          MaterialSectionCard(
            title: _l10n.materialSectionDataQuality,
            icon: Icons.verified_outlined,
            rows: [
              (_l10n.fieldDataQualityLevel, m.dataQualityLevel),
              (_l10n.fieldDataSource, m.dataSource),
              (_l10n.fieldCertificateReference, m.certificateReference),
              (_l10n.fieldDigitalSignature, m.digitalSignature),
              (_l10n.fieldValidityDate, m.validityDate),
            ],
          ),
          MaterialDocumentsCard(documents: m.documents),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
