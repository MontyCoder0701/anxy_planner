import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/entity/todo.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final items =
      List<TodoEntity>.generate(5, (i) => TodoEntity(title: 'Item ${i + 1}'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anxy Planner')),
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
            focusedDay: _focusedDay,
            availableGestures: AvailableGestures.none,
            firstDay: DateTime.now().copyWith(month: DateTime.now().month - 1),
            lastDay: DateTime.now().copyWith(month: DateTime.now().month + 1),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
          ),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildListView(title: '오늘 할 일'),
                  _buildListView(title: '이번주 할 일'),
                  _buildListView(title: '이번달 할 일'),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView _buildListView({required String title}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(title: Text(title));
        }

        final item = items[index];
        return Dismissible(
          key: Key(item.title),
          onDismissed: (direction) {
            setState(() {
              items.removeAt(index);
            });
          },
          background: Container(color: Colors.red),
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(item.title),
            value: true,
            onChanged: (bool? value) {},
          ),
        );
      },
    );
  }
}
