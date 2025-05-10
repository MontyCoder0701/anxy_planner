import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import 'todo.dart';

class HomeWidgetSyncProvider extends ChangeNotifier {
  final TodoProvider todoProvider;

  HomeWidgetSyncProvider(this.todoProvider);

  Future<void> syncTodayTodos() async {
    final todayTodos = todoProvider.getTodayTodos();
    await HomeWidget.saveWidgetData('daily_todos', todayTodos);
    await HomeWidget.updateWidget(iOSName: 'TodoWidgets');
  }
}
