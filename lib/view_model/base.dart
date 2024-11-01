import 'package:flutter/foundation.dart';

import '../model/entity/base.dart';
import '../model/repository/local.dart';

abstract class CrudProvider<T extends BaseEntity> with ChangeNotifier {
  LocalRepository<T> get repository => throw UnimplementedError();

  List<T> _resources = [];

  List<T> get resources => _resources;

  Future<void> getMany() async {
    _resources = await repository.getMany();
    notifyListeners();
  }

  Future<void> createOne(T item) async {
    final result = await repository.createOne(item);
    _resources.add(result);
    notifyListeners();
  }

  Future<void> updateOne(T item) async {
    await repository.updateOne(item);
    final index = _resources.indexWhere((e) => e.id == item.id);
    if (index >= 0) {
      _resources[index] = item;
    }
    notifyListeners();
  }

  Future<void> deleteOne(T item) async {
    await repository.deleteOne(item.id!);
    _resources.remove(item);
    notifyListeners();
  }
}
