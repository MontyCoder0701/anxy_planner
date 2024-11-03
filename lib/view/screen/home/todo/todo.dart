import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/entity/todo.dart';
import '../../../../model/enum/todo_type.dart';
import '../../../../view_model/setting.dart';
import '../../../../view_model/todo.dart';
import '../../../theme.dart';
import '../../../widget/moon_phase.dart';
import 'calendar.dart';
import 'todo_list_view.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late final todoProvider = context.watch<TodoProvider>();
  late final settingProvider = context.read<SettingProvider>();

  final _formKey = GlobalKey<FormState>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<TodoEntity> get dayTodos =>
      todoProvider.getTodosByDay(_selectedDay ?? _focusedDay);

  List<TodoEntity> get weekTodos =>
      todoProvider.getTodosByWeek(_selectedDay ?? _focusedDay);

  List<TodoEntity> get monthTodos =>
      todoProvider.getTodosByMonth(_selectedDay ?? _focusedDay);

  bool get isTourComplete => settingProvider.isTourComplete;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      todoProvider.getMany();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MoonPhaseWidget(),
          CalendarWidget(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: (selectedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = selectedDay;
              });
            },
            eventLoader: (day) => todoProvider.events[day] ?? [],
          ),
          const SizedBox(height: 15),
          if (dayTodos.isEmpty && weekTodos.isEmpty && monthTodos.isEmpty) ...{
            Expanded(
              child: Center(
                child: Text('할 일이 없어요.'),
              ),
            ),
          },
          Expanded(
            child: SingleChildScrollView(
              child: TodoListView(
                dayTodos: dayTodos,
                weekTodos: weekTodos,
                monthTodos: monthTodos,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: CustomColor.primary.withOpacity(0.7),
        elevation: 0,
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              final newTodo = TodoEntity();
              return StatefulBuilder(
                builder: (context, StateSetter setStateDialog) {
                  return AlertDialog(
                    title: const Text('할 일 만들기'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            onChanged: (val) => newTodo.title = val,
                            decoration: const InputDecoration(
                              hintText: '할 일을 적어주세요 ...',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '할 일을 적어주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          SegmentedButton(
                            segments: const [
                              ButtonSegment(
                                label: Text('이 날'),
                                value: ETodoType.day,
                              ),
                              ButtonSegment(
                                label: Text('이번 주'),
                                value: ETodoType.week,
                              ),
                              ButtonSegment(
                                label: Text('이번 달'),
                                value: ETodoType.month,
                              ),
                            ],
                            selected: {newTodo.todoType},
                            onSelectionChanged: (newSelection) {
                              setStateDialog(() {
                                newTodo.todoType = newSelection.first;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pop(context);
                            newTodo.setForDate(_selectedDay ?? _focusedDay);
                            todoProvider.createOne(newTodo);
                          }
                        },
                        color: CustomColor.primary,
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
