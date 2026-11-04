import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product.dart';
import 'product_api.dart';
import 'product_bloc.dart';
import 'product_page.dart';
import 'widgets/product_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final ProductApi? productApi;

  const MyApp({super.key, this.productApi});

  @override
  Widget build(BuildContext context) {
    final api = productApi ?? ProductApiImpl();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Products',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF5F5F8),
      ),
      home: BlocProvider(
        create: (_) => ProductBloc(api)..add(LoadProducts()),
        child: MyHomePage(title: 'Products', productApi: api),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final ProductApi productApi;

  const MyHomePage({
    super.key,
    required this.title,
    required this.productApi,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController idController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  void openProduct(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ProductBloc(widget.productApi)
            ..add(LoadProductById(id)),
          child: ProductPage(productId: id),
        ),
      ),
    );
  }

  void searchProduct() {
    final id = int.tryParse(idController.text.trim());

    if (id == null || id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid product ID')),
      );
      return;
    }

    openProduct(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('product_id_field'),
                    controller: idController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Product ID',
                      hintText: 'For example: 1',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => searchProduct(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  key: const Key('search_button'),
                  onPressed: searchProduct,
                  child: const Text('Find'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading || state is ProductInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.read<ProductBloc>().add(LoadProducts()),
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final Product product = state.products[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ProductCard(
                              product: product,
                              onTap: () {
                                if (product.id != null) {
                                  openProduct(product.id!);
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
