import 'package:home_widget/home_widget.dart';

import '../view_model/todo.dart';

class HomeWidgetService {
  static Future<void> updateDailyTodosWidget(
    TodoProvider todoProvider,
    DateTime date,
  ) async {
    final todos = todoProvider.getTodosJsonByDay(date);
    await HomeWidget.saveWidgetData('daily_todos', todos);
    await HomeWidget.updateWidget(iOSName: 'TodoWidgets');
  }
}
