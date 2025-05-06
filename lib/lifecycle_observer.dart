import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import 'view_model/todo.dart';

class LifecycleObserver with WidgetsBindingObserver {
  final TodoProvider todoProvider;

  LifecycleObserver({required this.todoProvider});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      final todos = todoProvider.getTodayTodos();
      await HomeWidget.saveWidgetData('daily_todos', todos);
      await HomeWidget.updateWidget(iOSName: 'TodoWidgets');
    }
  }
}
