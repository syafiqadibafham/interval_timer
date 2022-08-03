import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interval_timer/screens/timer_page.dart';

import '../bloc/timer_bloc.dart';
import '../model/ticker.dart';
import '../model/training_model.dart';
import '../widgets/durationPicker.dart';

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
            Expanded(
              child: Center(
                child: const Text(
                  "Set your Training",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            Text("No. of Training intervals:"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
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
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Exercise Duration"),
                          Text(
                            training.trainingDuration
                                .toString()
                                .substring(0, 7),
                            style: GoogleFonts.nunitoSans(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      showDialog<Duration>(
                        context: context,
                        builder: (BuildContext context) {
                          return DurationPickerDialog(
                            initialDuration: Duration(seconds: 0),
                            title: Text('Excercise time per repetition'),
                          );
                        },
                      ).then((breakTime) {
                        if (breakTime == null) return;
                        setState(() {
                          log(breakTime.toString());
                          training.breakDuration = breakTime;
                        });
                      });
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Break Duration"),
                          Text(
                            training.breakDuration.toString().substring(0, 7),
                            style: GoogleFonts.nunitoSans(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider<TimerBloc>(
                                    create: (context) {
                                      return TimerBloc(
                                          ticker: const Ticker(),
                                          trainingDuration: training
                                              .trainingDuration.inSeconds,
                                          breakDuration:
                                              training.breakDuration.inSeconds,
                                          interval: training.interval);
                                    },
                                    child: TimerPage(
                                      training: training,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Start Training",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 70,
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
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
                                  color: Theme.of(context).colorScheme.onError),
                            )),
                      ),
                    ],
                  ),
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
