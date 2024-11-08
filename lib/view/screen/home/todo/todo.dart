import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  late final tr = AppLocalizations.of(context);
  late final colorScheme = Theme.of(context).colorScheme;
  late final todoProvider = context.watch<TodoProvider>();
  late final settingProvider = context.read<SettingProvider>();
  late final animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final scaleAnimation = Tween(begin: 1.0, end: 1.3).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ),
  );

  final scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  bool _isCalendarExpanded = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<TodoEntity> get dayTodos =>
      todoProvider.getTodosByDay(_selectedDay ?? _focusedDay);

  List<TodoEntity> get weekTodos =>
      todoProvider.getTodosByWeek(_selectedDay ?? _focusedDay);

  List<TodoEntity> get monthTodos => todoProvider.calendarTodosByMonth;

  bool get isTourComplete => settingProvider.isTourComplete;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      todoProvider.getMany();
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => animationController.forward(from: 0),
            child: AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: scaleAnimation.value,
                  child: child,
                );
              },
              child: MoonPhaseWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CalendarWidget(
              isExpanded: _isCalendarExpanded,
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
          ),
          SizedBox(height: 15),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border(
                  top: BorderSide(
                    color: colorScheme.primary.withOpacity(0.4),
                  ),
                ),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta == null) {
                    return;
                  }

                  setState(() {
                    if (details.primaryDelta! < 0 && _isCalendarExpanded) {
                      _isCalendarExpanded = false;
                      scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 50),
                        curve: Curves.easeOut,
                      );
                    }

                    if (details.primaryDelta! > 0 && !_isCalendarExpanded) {
                      _isCalendarExpanded = true;
                    }
                  });
                },
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (dayTodos.isEmpty &&
                        weekTodos.isEmpty &&
                        monthTodos.isEmpty) ...{
                      Expanded(
                        child: Center(
                          child: Text(
                            tr.noTodos,
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    },
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: TodoListView(
                          dayTodos: dayTodos,
                          weekTodos: weekTodos,
                          monthTodos: monthTodos,
                          onDelete: (item) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(tr.confirmDelete),
                                  actions: <Widget>[
                                    IconButton(
                                      color: CustomColor.primary,
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
                          onEdit: (item) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder:
                                      (context, StateSetter setStateDialog) {
                                    return AlertDialog(
                                      title: Text(tr.editTodo),
                                      content: Form(
                                        key: _editFormKey,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                initialValue: item.title,
                                                onChanged: (val) =>
                                                    item.title = val,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      '${tr.todoRequired}..',
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return tr.todoRequired;
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 15),
                                              SegmentedButton(
                                                showSelectedIcon: false,
                                                segments: [
                                                  ButtonSegment(
                                                    label: Text(tr.thisDay),
                                                    value: ETodoType.day,
                                                  ),
                                                  ButtonSegment(
                                                    label: Text(tr.thisWeek),
                                                    value: ETodoType.week,
                                                  ),
                                                  ButtonSegment(
                                                    label: Text(tr.thisMonth),
                                                    value: ETodoType.month,
                                                  ),
                                                ],
                                                selected: {item.todoType},
                                                onSelectionChanged:
                                                    (newSelection) {
                                                  setStateDialog(() {
                                                    item.todoType =
                                                        newSelection.first;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          onPressed: () async {
                                            if (_editFormKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              Navigator.pop(context);
                                              item.setForDate(
                                                _selectedDay ?? _focusedDay,
                                              );
                                              todoProvider.updateOne(item);
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
                          onTap: (item) => todoProvider.updateOne(item),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'todo',
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
                    title: Text(tr.createTodo),
                    content: Form(
                      key: _formKey,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              onChanged: (val) => newTodo.title = val,
                              decoration: InputDecoration(
                                hintText: '${tr.todoRequired}..',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr.todoRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            SegmentedButton(
                              showSelectedIcon: false,
                              segments: [
                                ButtonSegment(
                                  label: Text(tr.thisDay),
                                  value: ETodoType.day,
                                ),
                                ButtonSegment(
                                  label: Text(tr.thisWeek),
                                  value: ETodoType.week,
                                ),
                                ButtonSegment(
                                  label: Text(tr.thisMonth),
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
