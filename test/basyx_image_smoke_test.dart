// Regression test for the "thumbnail fetched fine but never shown" bug:
// BasyxLocalCache can't persist to disk on platforms with no filesystem
// (Flutter Web — and, conveniently, under flutter_test too, since
// path_provider has no real platform channel here), so BasyxSyncService
// must fall back to keeping the thumbnail bytes on the Product itself
// instead of silently dropping the image.
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/services/basyx/basyx_models.dart';
import 'package:dpp/app/services/basyx/basyx_repository.dart';
import 'package:dpp/app/services/basyx/basyx_sync_service.dart';
import 'package:dpp/app/services/test/product_service.dart';

class _FakeRepository implements BasyxRepository {
  final Uint8List thumbnail = Uint8List.fromList(List.filled(16, 7));

  @override
  Future<List<ShellDescriptor>> fetchShellList() async => [
    const ShellDescriptor(id: 'shell-1', idShort: 'Shell1'),
  ];

  @override
  Future<AasResponse> fetchShellPackage(ShellDescriptor shell) async =>
      AasResponse(
        assetAdministrationShells: [
          AssetAdministrationShell(id: shell.id, idShort: shell.idShort),
        ],
        submodels: const [],
      );

  @override
  Future<Uint8List?> fetchThumbnail(ShellDescriptor shell) async => thumbnail;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('synced product keeps thumbnail bytes when there is no filesystem cache', () async {
    ProductService.responses = [];
    ProductService.manifestMap = {};
    ProductService.products = [];
    ProductService.productMap = {};

    await BasyxSyncService(repository: _FakeRepository()).syncOnAppStart();

    final product = ProductService.getProductById('Shell1');
    expect(product, isNotNull);
    // No filesystem here (same situation as Flutter Web), so the disk path
    // must NOT have been used...
    expect(product!.imagePath, anyOf(isNull, equals('No Image')));
    // ...and the bytes must have been kept instead, so the image can still
    // render via Image.memory.
    expect(product.imageBytes, isNotNull);
    expect(product.imageBytes!.length, 16);
  });
}
