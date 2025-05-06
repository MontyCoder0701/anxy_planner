import 'package:flutter/widgets.dart';

import '../view_model/todo.dart';
import 'home_widget_service.dart';

class LifecycleObserver with WidgetsBindingObserver {
  final TodoProvider todoProvider;

  LifecycleObserver({required this.todoProvider});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      HomeWidgetService.updateDailyTodosWidget(todoProvider, DateTime.now());
    }
  }
}
