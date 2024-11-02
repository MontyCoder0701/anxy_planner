import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/entity/todo.dart';
import '../model/enum/todo_type.dart';
import '../view_model/todo.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final todoProvider = context.watch<TodoProvider>();
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
      appBar: AppBar(title: const Text('One Moon')),
      body: Column(
        children: <Widget>[
          TableCalendar(
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
            daysOfWeekHeight: 50,
            startingDayOfWeek: StartingDayOfWeek.monday,
            focusedDay: _focusedDay,
            availableGestures: AvailableGestures.none,
            firstDay: DateTime.now().copyWith(month: DateTime.now().month - 1),
            lastDay: DateTime.now().copyWith(month: DateTime.now().month + 1),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildListView(
                    title: '오늘 할 일',
                    items: dayTodos,
                  ),
                  _buildListView(
                    title: '이번주 할 일',
                    items: weekTodos,
                  ),
                  _buildListView(
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
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView({
    required List<TodoEntity> items,
    required String title,
  }) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              key: Key(item.id.toString()),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('삭제하시겠습니까?'),
                      actions: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            todoProvider.deleteOne(item);
                          },
                          icon: const Icon(Icons.check),
                        ),
                      ],
                    );
                  },
                );
              },
              background: Container(color: const Color(0xffe06960)),
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(item.title),
                value: item.isComplete,
                onChanged: (bool? value) {
                  if (value != null) {
                    todoProvider.updateOne(item..isComplete = value);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
