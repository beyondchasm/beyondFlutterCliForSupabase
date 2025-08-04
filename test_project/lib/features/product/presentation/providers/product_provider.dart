import 'package:flutter/foundation.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/product.dart';
import '../../domain/use_cases/get_product_usecase.dart';
import '../../domain/use_cases/create_product_usecase.dart';
import '../../domain/use_cases/update_product_usecase.dart';
import '../../domain/use_cases/delete_product_usecase.dart';

class ProductProvider extends ChangeNotifier {
  late final GetProductUseCase _getProductUseCase;
  late final CreateProductUseCase _createProductUseCase;
  late final UpdateProductUseCase _updateProductUseCase;
  late final DeleteProductUseCase _deleteProductUseCase;

  ProductProvider() {
    _getProductUseCase = ServiceLocator.get<GetProductUseCase>();
    _createProductUseCase = ServiceLocator.get<CreateProductUseCase>();
    _updateProductUseCase = ServiceLocator.get<UpdateProductUseCase>();
    _deleteProductUseCase = ServiceLocator.get<DeleteProductUseCase>();
  }

  List<Product> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _getProductUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProduct(Product item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final created = await _createProductUseCase(item);
      _items.add(created);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _updateProductUseCase(item);
      final index = _items.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        _items[index] = updated;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final deleted = await _deleteProductUseCase(id);
      if (deleted) {
        _items.removeWhere((element) => element.id == id);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}