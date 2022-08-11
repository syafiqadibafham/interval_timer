import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interval_timer/screens/timer_page.dart';
import '../model/training_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/duration_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //This is the initial training data, when user open the App
  TrainingData training = TrainingData(
      interval: 1,
      trainingDuration: const Duration(seconds: 0),
      breakDuration: const Duration(seconds: 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              child: Center(
                child: Text(
                  "Define your Training",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const Text("No. of Training intervals:"),
            //Touchspin widget will create the interger for the Interval object
            TouchSpin(
              min: 1,
              max: 100,
              step: 1,
              value: training.interval,
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
                log("Intervals : ${training.interval}");
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
                            initialDuration: Duration(
                                seconds: training.trainingDuration.inSeconds),
                            title: const Text('Training time per intervals'),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Training Duration"),
                          //Duration.toString() method will show the entire string start from the miliseconds
                          //Therefore, the substring has been use, in order to remove the miliseconds part.
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
                            initialDuration: Duration(
                                seconds: training.breakDuration.inSeconds),
                            title: const Text('Break time per intervals'),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Break Duration"),
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
                      CustomElevatedButton(
                        onPressed: () {
                          if (training.trainingDuration.inSeconds != 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TimerPage(
                                  training: training,
                                ),
                              ),
                            );
                          } else {
                            // A snackbar will be shown at the bottom of the screen
                            // to tell the user to input more than 0s.
                            var snackBar = const SnackBar(
                                content: Text(
                                    'Please insert Training Duration more than 0s'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        forgroundColor: Theme.of(context).colorScheme.primary,
                        label: "Start Training",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomElevatedButton(
                          onPressed: () {
                            setState(() {
                              training = TrainingData(
                                  interval: 1,
                                  trainingDuration: const Duration(seconds: 0),
                                  breakDuration: const Duration(seconds: 0));
                            });
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.onErrorContainer,
                          forgroundColor: Theme.of(context).colorScheme.onError,
                          label: "Reset")
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
