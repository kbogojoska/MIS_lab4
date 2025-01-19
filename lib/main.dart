import 'package:flutter/material.dart';
import 'package:mis_lab_4/providers/exam_provider.dart';
import 'package:mis_lab_4/screens/exam_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => ExamProvider(),
        child: MyApp(),
      )
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Calendar',
      initialRoute: '/',
      routes: {
        '/': (context) => ExamScheduleScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}