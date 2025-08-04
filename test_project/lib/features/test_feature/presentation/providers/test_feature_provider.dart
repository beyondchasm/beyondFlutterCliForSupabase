import 'package:flutter/foundation.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/test_feature.dart';
import '../../domain/use_cases/get_test_feature_usecase.dart';
import '../../domain/use_cases/create_test_feature_usecase.dart';
import '../../domain/use_cases/update_test_feature_usecase.dart';
import '../../domain/use_cases/delete_test_feature_usecase.dart';

class TestFeatureProvider extends ChangeNotifier {
  late final GetTestFeatureUseCase _getTestFeatureUseCase;
  late final CreateTestFeatureUseCase _createTestFeatureUseCase;
  late final UpdateTestFeatureUseCase _updateTestFeatureUseCase;
  late final DeleteTestFeatureUseCase _deleteTestFeatureUseCase;

  TestFeatureProvider() {
    _getTestFeatureUseCase = ServiceLocator.get<GetTestFeatureUseCase>();
    _createTestFeatureUseCase = ServiceLocator.get<CreateTestFeatureUseCase>();
    _updateTestFeatureUseCase = ServiceLocator.get<UpdateTestFeatureUseCase>();
    _deleteTestFeatureUseCase = ServiceLocator.get<DeleteTestFeatureUseCase>();
  }

  List<TestFeature> _items = [];
  bool _isLoading = false;
  String? _error;

  List<TestFeature> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _getTestFeatureUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTestFeature(TestFeature item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final created = await _createTestFeatureUseCase(item);
      _items.add(created);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTestFeature(TestFeature item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _updateTestFeatureUseCase(item);
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

  Future<void> deleteTestFeature(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final deleted = await _deleteTestFeatureUseCase(id);
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