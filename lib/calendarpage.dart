import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'widgets/bottom_navigation.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Calendar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary.withOpacity(0.75),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFCE93D8),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFFCE93D8),
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: Colors.deepPurple),
                  weekendTextStyle: TextStyle(color: Colors.deepPurple),
                  todayTextStyle: TextStyle(color: Colors.white),
                  selectedTextStyle: TextStyle(color: Colors.white)),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: Colors.deepPurple),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.deepPurple),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    color: Colors.deepPurple),
                weekendStyle: TextStyle(
                    color: Colors.deepPurple),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                _selectedDay == null
                    ? 'Select a date'
                    : 'Selected date: ${_selectedDay!.toLocal()}'.split(' ')[0],
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add event functionality
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // Handle tab changes here
      ),
    );
  }
}
