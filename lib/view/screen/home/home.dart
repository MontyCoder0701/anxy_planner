import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/entity/todo.dart';
import '../../../model/enum/todo_type.dart';
import '../../../view_model/setting.dart';
import '../../../view_model/todo.dart';
import '../../theme.dart';
import 'calendar.dart';
import 'todo_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final todoProvider = context.watch<TodoProvider>();
  late final settingProvider = context.read<SettingProvider>();
  late final _scaffoldMessenger = ScaffoldMessenger.of(context);

  final _formKey = GlobalKey<FormState>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<TodoEntity> get dayTodos =>
      todoProvider.getTodosByDay(_selectedDay ?? _focusedDay);

  List<TodoEntity> get weekTodos =>
      todoProvider.getTodosByWeek(_selectedDay ?? _focusedDay);

  List<TodoEntity> get monthTodos =>
      todoProvider.getTodosByMonth(_selectedDay ?? _focusedDay);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      todoProvider.getMany();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 100.0),
          children: [
            const Divider(),
            ListTile(
              leading: Icon(
                settingProvider.isLight ? Icons.dark_mode : Icons.light_mode,
              ),
              title: const Text('테마 변경'),
              onTap: () => settingProvider.toggleThemeMode(),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('앱 데이터 정리하기'),
              onTap: () async {
                return await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('정리하시겠습니까?'),
                      content: const Text('오래된 데이터를 삭제해 앱이 가벼워집니다.'),
                      actions: <Widget>[
                        IconButton(
                          color: CustomColor.primary,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await todoProvider.deleteExpiredData();

                            if (context.mounted) {
                              Navigator.of(context).pop();
                              _scaffoldMessenger.hideCurrentSnackBar();
                              _scaffoldMessenger.showSnackBar(
                                const SnackBar(content: Text('정리되었습니다.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.check),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(elevation: 0),
      body: Column(
        children: <Widget>[
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TodoListWidget(
                    title: '오늘 할 일',
                    items: dayTodos,
                  ),
                  TodoListWidget(
                    title: '이번주 할 일',
                    items: weekTodos,
                  ),
                  TodoListWidget(
                    title: '이번달 할 일',
                    items: monthTodos,
                  ),
                ],
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
                    title: const Text('할일 추가'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            onChanged: (val) => newTodo.title = val,
                            decoration:
                                const InputDecoration(hintText: '입력해주세요 ...'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '할일을 적어주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          SegmentedButton(
                            segments: const [
                              ButtonSegment(
                                label: Text('오늘'),
                                value: ETodoType.day,
                              ),
                              ButtonSegment(
                                label: Text('이번주'),
                                value: ETodoType.week,
                              ),
                              ButtonSegment(
                                label: Text('이번달'),
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
