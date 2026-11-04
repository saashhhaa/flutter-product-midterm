import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firstflutterproject/main.dart';
import 'package:firstflutterproject/product.dart';
import 'package:firstflutterproject/product_api.dart';

class FakeProductApi extends ProductApi {
  int? requestedId;

  @override
  Future<List<Product>> getProducts() async {
    return [Product(id: 1, title: 'Example product', price: 10, rating: 4.5)];
  }

  @override
  Future<Product> getProductById(int id) async {
    requestedId = id;
    return Product(
      id: id,
      title: 'Test product $id',
      price: 20,
      rating: 4.5,
      description: 'Description of test product',
      stock: 10,
    );
  }
}

void main() {
  testWidgets('Opens a product by ID on a new page', (tester) async {
    final api = FakeProductApi();
    await tester.pumpWidget(MyApp(productApi: api));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('product_id_field')), '7');
    await tester.tap(find.byKey(const Key('search_button')));
    await tester.pumpAndSettle();

    expect(api.requestedId, 7);
    expect(find.text('Product #7'), findsOneWidget);
    expect(find.text('Test product 7'), findsOneWidget);
    expect(find.text('Description of test product'), findsOneWidget);
  });
}
