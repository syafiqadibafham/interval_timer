import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'bloc/timer_bloc.dart';
import 'color_schemes.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'widgets/durationPicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(),
      child: MaterialApp(
        title: 'Interval Timer',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        themeMode: ThemeMode.dark,
        home: const MyHomePage(title: 'Interval Timer'),
        debugShowCheckedModeBanner: false,
      ),
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
  int _counter = 0;
  int _interval = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            Text(
              'Round : $_interval',
            ),
            SlideCountdown(
              duration: Duration(seconds: 100),
              showZeroValue: true,
              withDays: false,
              textStyle: TextStyle(
                  fontSize: 50, color: Theme.of(context).colorScheme.primary),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
              ),
            ),
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
                    Text("Training Intervals"),
                    TouchSpin(
                      min: 1,
                      max: 100,
                      step: 1,
                      value: 1,
                      textStyle: const TextStyle(fontSize: 36),
                      iconSize: 48.0,
                      addIcon: const Icon(Icons.add_circle_outline),
                      subtractIcon: const Icon(Icons.remove_circle_outline),
                      iconActiveColor: Theme.of(context).colorScheme.primary,
                      iconDisabledColor: Colors.grey,
                      iconPadding: const EdgeInsets.all(20),
                      onChanged: (val) {
                        setState(() {
                          _interval = val.toInt();
                        });
                        log("Interval : $val");
                      },
                    ),
                    Text("Training Duration"),
                    ListTile(
                      title: Text('Exercise Time'),
                      subtitle: Text(Duration(minutes: 1).toString()),
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
                          //_tabata.exerciseTime = exerciseTime;
                        });
                      },
                    ),
                    Text("Break Duration"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Start Timer',
        child: const Icon(Icons.play_arrow_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
