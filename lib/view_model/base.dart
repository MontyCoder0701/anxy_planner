import 'package:flutter/foundation.dart';

import '../model/entity/base.dart';
import '../model/repository/local.dart';

mixin CrudMixin<T extends BaseEntity> on ChangeNotifier {
  late final LocalRepository<T> _repository;
  List<T> _resources = [];

  List<T> get resources {
    _resources.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _resources;
  }

  Future<void> getMany() async {
    _resources = await _repository.getMany();
    notifyListeners();
  }

  Future<void> createOne(T item) async {
    final result = await _repository.createOne(item);
    _resources.add(result);
    notifyListeners();
  }

  Future<void> updateOne(T item) async {
    await _repository.updateOne(item);
    final index = _resources.indexWhere((e) => e.id == item.id);
    if (index >= 0) {
      _resources[index] = item;
    }
    notifyListeners();
  }

  Future<void> deleteOne(T item) async {
    await _repository.deleteOne(item.id!);
    _resources.remove(item);
    notifyListeners();
  }
}
