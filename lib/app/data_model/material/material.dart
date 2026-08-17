/// A material passport, structured after the same 7 sections used in the
/// project's field spec: Identification, Manufacturer/Supply chain,
/// Composition, Physical/Processing data, Sustainability, Data quality,
/// Documents. Every field is optional except [id] — real-world submodels
/// rarely have every field populated, and the UI shows "N/A" for gaps
/// rather than requiring them.
class Material {
  // Section 1: Identification
  final String id; // Material-AAS-ID (Global Asset ID)
  final String? tradeName; // Handelsname / Produktbezeichnung
  final String? articleNumber; // Artikelnummer des Herstellers
  final String? lotNumber; // Chargen-/Lot-Nummer
  final DateTime? manufacturingDate; // Herstellungsdatum / MHD
  final String? carrierReferenceUri; // Datenträger-Referenz (NFC/QR-URI)

  // Section 2: Manufacturer / supply chain
  final String? manufacturerName;
  final String? manufacturerAddress;
  final String? manufacturerCountry;
  final String? manufacturerId; // Hersteller-ID, e.g. GLN / DUNS — highlight
  final String? contact; // Ansprechpartner / Kontakt
  final String? supplier; // Lieferant (falls != Hersteller)
  final String? productionSite; // Produktionsstandort

  // Section 3: Composition
  final String? polymerType; // Polymertyp / Basispolymer — highlight
  final String? fillerContent; // Füllstoff & Anteil
  final String? additives; // Additive / Farbmittel
  final double? recycledContentPercent; // Rezyklatanteil (%) — highlight
  final String? recycledOrigin; // Rezyklat-Herkunft — highlight ("Herkunft")
  final double? biobasedPercent; // Biobasierter Anteil (%)
  final String? hazardousSubstances; // Gefahrstoff-/SVHC-Angaben

  // Section 4: Physical & processing data
  final String? filamentDiameter; // + Toleranz
  final String? density; // g/cm³
  final String? spoolWeight; // netto/brutto
  final String? nozzleTemperature; // °C
  final String? bedTemperature; // °C
  final String? dryingRecommendation; // h @ °C
  final String? mechanicalProperties; // E-Modul, Zugfestigkeit
  final double? moistureContent; // Feuchtegehalt bei Lieferung (%)

  // Section 5: Sustainability / environment
  final double? co2FootprintPerKg; // PCF, kg CO2e/kg — highlight
  final String? calculationMethod; // z.B. cradle-to-gate, ISO 14067
  final String? energyConsumption; // Energieverbrauch Herstellung
  final String? recyclability; // Recyclingfähigkeit / Kunststoffcode
  final String? disposalInfo; // Entsorgungs-/Rückführungshinweise

  // Section 6: Data quality & trust
  final String? dataQualityLevel; // DQL nach DIN SPEC 91481
  final String? dataSource; // gemessen / berechnet / Literatur
  final String? certificateReference; // Chargenzeugnis, EPD, ...
  final String? digitalSignature; // Integritätsnachweis
  final String? validityDate; // Gültigkeitsdatum / Version

  // Section 7: Documents
  final List<String> documents;

  final String? imagePath;

  const Material({
    required this.id,
    this.tradeName,
    this.articleNumber,
    this.lotNumber,
    this.manufacturingDate,
    this.carrierReferenceUri,
    this.manufacturerName,
    this.manufacturerAddress,
    this.manufacturerCountry,
    this.manufacturerId,
    this.contact,
    this.supplier,
    this.productionSite,
    this.polymerType,
    this.fillerContent,
    this.additives,
    this.recycledContentPercent,
    this.recycledOrigin,
    this.biobasedPercent,
    this.hazardousSubstances,
    this.filamentDiameter,
    this.density,
    this.spoolWeight,
    this.nozzleTemperature,
    this.bedTemperature,
    this.dryingRecommendation,
    this.mechanicalProperties,
    this.moistureContent,
    this.co2FootprintPerKg,
    this.calculationMethod,
    this.energyConsumption,
    this.recyclability,
    this.disposalInfo,
    this.dataQualityLevel,
    this.dataSource,
    this.certificateReference,
    this.digitalSignature,
    this.validityDate,
    this.documents = const [],
    this.imagePath,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'] as String,
      tradeName: json['tradeName'] as String?,
      articleNumber: json['articleNumber'] as String?,
      lotNumber: json['lotNumber'] as String?,
      manufacturingDate:
          json['manufacturingDate'] != null
              ? DateTime.tryParse(json['manufacturingDate'] as String)
              : null,
      carrierReferenceUri: json['carrierReferenceUri'] as String?,
      manufacturerName: json['manufacturerName'] as String?,
      manufacturerAddress: json['manufacturerAddress'] as String?,
      manufacturerCountry: json['manufacturerCountry'] as String?,
      manufacturerId: json['manufacturerId'] as String?,
      contact: json['contact'] as String?,
      supplier: json['supplier'] as String?,
      productionSite: json['productionSite'] as String?,
      polymerType: json['polymerType'] as String?,
      fillerContent: json['fillerContent'] as String?,
      additives: json['additives'] as String?,
      recycledContentPercent: (json['recycledContentPercent'] as num?)
          ?.toDouble(),
      recycledOrigin: json['recycledOrigin'] as String?,
      biobasedPercent: (json['biobasedPercent'] as num?)?.toDouble(),
      hazardousSubstances: json['hazardousSubstances'] as String?,
      filamentDiameter: json['filamentDiameter'] as String?,
      density: json['density'] as String?,
      spoolWeight: json['spoolWeight'] as String?,
      nozzleTemperature: json['nozzleTemperature'] as String?,
      bedTemperature: json['bedTemperature'] as String?,
      dryingRecommendation: json['dryingRecommendation'] as String?,
      mechanicalProperties: json['mechanicalProperties'] as String?,
      moistureContent: (json['moistureContent'] as num?)?.toDouble(),
      co2FootprintPerKg: (json['co2FootprintPerKg'] as num?)?.toDouble(),
      calculationMethod: json['calculationMethod'] as String?,
      energyConsumption: json['energyConsumption'] as String?,
      recyclability: json['recyclability'] as String?,
      disposalInfo: json['disposalInfo'] as String?,
      dataQualityLevel: json['dataQualityLevel'] as String?,
      dataSource: json['dataSource'] as String?,
      certificateReference: json['certificateReference'] as String?,
      digitalSignature: json['digitalSignature'] as String?,
      validityDate: json['validityDate'] as String?,
      documents:
          (json['documents'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      imagePath: json['imagePath'] as String?,
    );
  }
}
