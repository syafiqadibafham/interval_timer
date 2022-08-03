import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:interval_timer/model/ticker.dart';
import 'package:interval_timer/model/training_model.dart';
import 'package:interval_timer/screens/timer_page.dart';
import 'bloc/timer_bloc.dart';
import 'color_schemes.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'screens/home_page.dart';
import 'widgets/durationPicker.dart';
import 'model/training_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interval Timer',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.dark,
      home: MyHomePage(title: 'Interval Timer'),
      debugShowCheckedModeBanner: false,
    );
  }
}
