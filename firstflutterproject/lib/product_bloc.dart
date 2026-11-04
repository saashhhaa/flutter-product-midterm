import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product.dart';
import 'product_api.dart';

// Events
abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class LoadProductById extends ProductEvent {
  final int id;
  LoadProductById(this.id);
}

// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  ProductsLoaded(this.products);
}

class ProductLoaded extends ProductState {
  final Product product;
  ProductLoaded(this.product);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

// BLoC handles requests and updates the screen state.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductApi api;

  ProductBloc(this.api) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await api.getProducts();
        emit(ProductsLoaded(products));
      } catch (e) {
        emit(ProductError('Could not load products. Check your internet.'));
      }
    });

    on<LoadProductById>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = await api.getProductById(event.id);
        emit(ProductLoaded(product));
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          emit(ProductError('Product with ID ${event.id} was not found.'));
        } else {
          emit(ProductError('Could not load product. Check your internet.'));
        }
      } catch (e) {
        emit(ProductError('Could not load product.'));
      }
    });
  }
}
