import 'package:dpp/app/services/api/nameplate_service.dart';
import 'package:dpp/app/services/hive/hive_service.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';

class NameplateRepository {
  final NameplateService _nameplateService;

  NameplateRepository(this._nameplateService);

  /// Get nameplate with cache-first strategy
  Future<Submodel?> getNameplate({bool forceRefresh = false}) async {
    // Try cache first unless force refresh
    if (!forceRefresh && HiveService.hasNameplateData()) {
      final cached = HiveService.getStoredSubmodel();
      if (cached != null) return cached;
    }

    // Fetch from API
    try {
      final submodel = await _nameplateService.getNameplateSubmodel();
      await HiveService.storeSubmodel(submodel);
      return submodel;
    } catch (e) {
      // Fallback to cache if API fails
      return HiveService.getStoredSubmodel();
    }
  }

  /// Get manufacturer name with caching
  Future<String?> getManufacturerName({bool forceRefresh = false}) async {
    const cacheKey = 'manufacturerName';

    if (!forceRefresh) {
      final cached = HiveService.getNameplateProperty<String>(cacheKey);
      if (cached != null) return cached;
    }

    try {
      final value = await _nameplateService.getManufacturerName();
      if (value != null) {
        await HiveService.storeNameplateProperty(cacheKey, value);
      }
      return value;
    } catch (e) {
      return HiveService.getNameplateProperty<String>(cacheKey);
    }
  }

  /// Set manufacturer name with sync
  Future<void> setManufacturerName(String name) async {
    await _nameplateService.setManufacturerName(name);
    await HiveService.storeNameplateProperty('manufacturerName', name);
  }

  /// Clear local cache
  Future<void> clearCache() async {
    await HiveService.clearNameplateData();
  }
}
