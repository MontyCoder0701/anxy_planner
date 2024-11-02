import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../theme.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: CustomColor.primary.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: CustomColor.primary,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
      ),
      daysOfWeekHeight: 50,
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: focusedDay,
      availableGestures: AvailableGestures.none,
      firstDay: DateTime.now().copyWith(month: DateTime.now().month - 1),
      lastDay: DateTime.now().copyWith(month: DateTime.now().month + 1),
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay);
      },
    );
  }
}
