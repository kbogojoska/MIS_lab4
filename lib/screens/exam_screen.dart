import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event_screen.dart';
import 'map_screen.dart';
import '../models/exam.dart';
import '../providers/exam_provider.dart';

class ExamScheduleScreen extends StatefulWidget {
  @override
  _ExamScheduleScreenState createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Scheduler'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.event),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              List<Exam> exams = Provider.of<ExamProvider>(context, listen: false).getExamsForDay(_selectedDay);
              if (exams.isNotEmpty) {
                Exam selectedExam = exams[0];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(event: selectedExam),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No exams available for the selected day')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
          ),
          Expanded(
            child: Consumer<ExamProvider>(
              builder: (context, examProvider, child) {
                List<Exam> exams = examProvider.getExamsForDay(_selectedDay);
                if (exams.isEmpty) {
                  return Center(child: Text('No exams for this day.'));
                } else {
                  return ListView.builder(
                    itemCount: exams.length,
                    itemBuilder: (context, index) {
                      Exam exam = exams[index];
                      return ListTile(
                        title: Text(exam.subject),
                        subtitle: Text(
                          '${DateFormat('dd-MM-yyyy').format(exam.dateTime)} at ${DateFormat('HH:mm').format(exam.dateTime)} - ${exam.locationName}',
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
