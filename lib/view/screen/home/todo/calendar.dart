import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../theme.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final List<dynamic> Function(DateTime)? eventLoader;
  final bool isExpanded;
  final bool isFirstDaySunday;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    required this.onDaySelected,
    this.eventLoader,
    this.isExpanded = true,
    this.isFirstDaySunday = false,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      startingDayOfWeek:
          isFirstDaySunday
              ? StartingDayOfWeek.sunday
              : StartingDayOfWeek.monday,
      calendarFormat: isExpanded ? CalendarFormat.month : CalendarFormat.week,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: CustomColor.primary.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: CustomColor.primary,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
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
      focusedDay: focusedDay,
      availableGestures: AvailableGestures.none,
      firstDay: DateTime(DateTime.now().year, DateTime.now().month, 1),
      lastDay: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay);
      },
      eventLoader: eventLoader,
    );
  }
}
