import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anxy Planner')),
      body: Center(
        child: Column(
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
              firstDay:
                  DateTime.now().copyWith(month: DateTime.now().month - 1),
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
              child: ListView(
                shrinkWrap: true,
                children: const [
                  ListTile(title: Text('Event')),
                  ListTile(title: Text('Event')),
                  ListTile(title: Text('Event')),
                  ListTile(title: Text('Event')),
                  ListTile(title: Text('Event')),
                  ListTile(title: Text('Event')),
                  ListTile(title: Text('Event')),
                  ListTile(title: Text('Event')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
