import 'package:flutter/foundation.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/{{feature_name}}.dart';
import '../../domain/use_cases/get_{{feature_name}}_usecase.dart';
import '../../domain/use_cases/create_{{feature_name}}_usecase.dart';
import '../../domain/use_cases/update_{{feature_name}}_usecase.dart';
import '../../domain/use_cases/delete_{{feature_name}}_usecase.dart';

class {{feature_name.pascalCase()}}Provider extends ChangeNotifier {
  late final Get{{feature_name.pascalCase()}}UseCase _get{{feature_name.pascalCase()}}UseCase;
  late final Create{{feature_name.pascalCase()}}UseCase _create{{feature_name.pascalCase()}}UseCase;
  late final Update{{feature_name.pascalCase()}}UseCase _update{{feature_name.pascalCase()}}UseCase;
  late final Delete{{feature_name.pascalCase()}}UseCase _delete{{feature_name.pascalCase()}}UseCase;

  {{feature_name.pascalCase()}}Provider() {
    _get{{feature_name.pascalCase()}}UseCase = ServiceLocator.get<Get{{feature_name.pascalCase()}}UseCase>();
    _create{{feature_name.pascalCase()}}UseCase = ServiceLocator.get<Create{{feature_name.pascalCase()}}UseCase>();
    _update{{feature_name.pascalCase()}}UseCase = ServiceLocator.get<Update{{feature_name.pascalCase()}}UseCase>();
    _delete{{feature_name.pascalCase()}}UseCase = ServiceLocator.get<Delete{{feature_name.pascalCase()}}UseCase>();
  }

  List<{{feature_name.pascalCase()}}> _items = [];
  bool _isLoading = false;
  String? _error;

  List<{{feature_name.pascalCase()}}> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _get{{feature_name.pascalCase()}}UseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create{{feature_name.pascalCase()}}({{feature_name.pascalCase()}} item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final created = await _create{{feature_name.pascalCase()}}UseCase(item);
      _items.add(created);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update{{feature_name.pascalCase()}}({{feature_name.pascalCase()}} item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _update{{feature_name.pascalCase()}}UseCase(item);
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

  Future<void> delete{{feature_name.pascalCase()}}(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final deleted = await _delete{{feature_name.pascalCase()}}UseCase(id);
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