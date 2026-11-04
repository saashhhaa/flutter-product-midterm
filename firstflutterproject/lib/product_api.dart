import 'package:dio/dio.dart';
import 'product.dart';
import 'rest_api.dart';

abstract class ProductApi extends RestApi {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(int id);
}

class ProductApiImpl extends ProductApi {
  final Dio dio = Dio();

  @override
  Future<List<Product>> getProducts() async {
    final response = await dio.get('$baseUrl/products');
    final data = response.data as Map<String, dynamic>;
    final items = data['products'] as List;

    return items
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    final response = await dio.get('$baseUrl/products/$id');
    return Product.fromJson(response.data as Map<String, dynamic>);
  }
}
