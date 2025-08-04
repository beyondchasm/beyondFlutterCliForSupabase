import 'package:flutter/foundation.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/order.dart';
import '../../domain/use_cases/get_order_usecase.dart';
import '../../domain/use_cases/create_order_usecase.dart';
import '../../domain/use_cases/update_order_usecase.dart';
import '../../domain/use_cases/delete_order_usecase.dart';

class OrderProvider extends ChangeNotifier {
  late final GetOrderUseCase _getOrderUseCase;
  late final CreateOrderUseCase _createOrderUseCase;
  late final UpdateOrderUseCase _updateOrderUseCase;
  late final DeleteOrderUseCase _deleteOrderUseCase;

  OrderProvider() {
    _getOrderUseCase = ServiceLocator.get<GetOrderUseCase>();
    _createOrderUseCase = ServiceLocator.get<CreateOrderUseCase>();
    _updateOrderUseCase = ServiceLocator.get<UpdateOrderUseCase>();
    _deleteOrderUseCase = ServiceLocator.get<DeleteOrderUseCase>();
  }

  List<Order> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _getOrderUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createOrder(Order item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final created = await _createOrderUseCase(item);
      _items.add(created);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrder(Order item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _updateOrderUseCase(item);
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

  Future<void> deleteOrder(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final deleted = await _deleteOrderUseCase(id);
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