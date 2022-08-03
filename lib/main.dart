import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:interval_timer/model/ticker.dart';
import 'package:interval_timer/model/training_model.dart';
import 'package:interval_timer/timer_page.dart';
import 'bloc/timer_bloc.dart';
import 'color_schemes.dart';
import 'package:slide_countdown/slide_countdown.dart';
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Training training = Training(
      interval: 1,
      trainingDuration: Duration(seconds: 0),
      breakDuration: Duration(seconds: 0));

  @override
  Widget build(BuildContext context) {
    int _interval = training.interval;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              height: 400,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Set your Training"),
                    TouchSpin(
                      min: 1,
                      max: 100,
                      step: 1,
                      value: 1,
                      textStyle: const TextStyle(fontSize: 36),
                      iconSize: 44.0,
                      addIcon: const Icon(Icons.add_circle_outline),
                      subtractIcon: const Icon(Icons.remove_circle_outline),
                      iconActiveColor: Theme.of(context).colorScheme.primary,
                      iconDisabledColor: Colors.grey,
                      iconPadding: const EdgeInsets.all(20),
                      onChanged: (val) {
                        setState(() {
                          training.interval = val.toInt();
                        });
                        log("Intervals : " + training.interval.toString());
                      },
                    ),
                    ListTile(
                      title: Text('Exercise Time'),
                      subtitle: Text(
                          training.trainingDuration.toString().substring(0, 7)),
                      leading: Icon(Icons.timer),
                      onTap: () {
                        showDialog<Duration>(
                          context: context,
                          builder: (BuildContext context) {
                            return DurationPickerDialog(
                              initialDuration: Duration(seconds: 0),
                              title: Text('Excercise time per repetition'),
                            );
                          },
                        ).then((exerciseTime) {
                          if (exerciseTime == null) return;
                          setState(() {
                            log(exerciseTime.toString());
                            training.trainingDuration = exerciseTime;
                          });
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Break Time'),
                      subtitle: Text(
                          training.breakDuration.toString().substring(0, 7)),
                      leading: Icon(Icons.pause),
                      onTap: () {
                        showDialog<Duration>(
                          context: context,
                          builder: (BuildContext context) {
                            return DurationPickerDialog(
                              initialDuration: Duration(seconds: 0),
                              title: Text('Break time per repetition'),
                            );
                          },
                        ).then((breakTime) {
                          if (breakTime == null) return;
                          setState(() {
                            training.breakDuration = breakTime;
                          });
                        });
                      },
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<TimerBloc>(
                                      create: (context) {
                                        return TimerBloc(
                                            ticker: Ticker(),
                                            trainingDuration: training
                                                .trainingDuration.inSeconds,
                                            breakDuration: training
                                                .breakDuration.inSeconds,
                                            interval: training.interval);
                                      },
                                      child: TimerPage(
                                        training: training,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text("Start Training")),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  training = Training(
                                      interval: 1,
                                      trainingDuration: Duration(seconds: 0),
                                      breakDuration: Duration(seconds: 0));
                                });
                              },
                              child: Text(
                                "Reset",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
