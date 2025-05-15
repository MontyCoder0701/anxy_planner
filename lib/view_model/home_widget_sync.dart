import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import 'todo.dart';

class HomeWidgetSyncProvider extends ChangeNotifier {
  final TodoProvider todoProvider;

  HomeWidgetSyncProvider(this.todoProvider);

  Future<void> syncHomeWidgetTodos() async {
    final homeWidgetTodos = todoProvider.getTodayTodos();
    await HomeWidget.saveWidgetData('daily_todos', homeWidgetTodos);
    await HomeWidget.updateWidget(iOSName: 'TodoWidgets');
  }
}
