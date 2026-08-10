import 'package:flutter_test/flutter_test.dart';
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/services/test/product_service.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await ProductService.init();
  print(ProductService.productIds);
  print(ProductService.getAllProducts());
  String firstID = ProductService.productIds.first;
  Product firstProduct = ProductService.getProductById(firstID)!;
  print(firstProduct.energyUsed);
  print(firstProduct.manufacturer);
  print(firstProduct.type);
  print(firstProduct.material);
  print(firstProduct.virginMaterial);
  print(firstProduct.recycledMaterial);
  print(firstProduct.imagePath);
}
