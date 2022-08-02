import 'dart:async';

import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'model/training_model.dart';

class timerPage extends StatefulWidget {
  final Training training;

  timerPage({Key? key, required this.training}) : super(key: key);

  @override
  State<timerPage> createState() => _timerPageState();
}

class _timerPageState extends State<timerPage> {
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      final training = widget.training;
      int seconds = training.trainingDuration.inSeconds;
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Training training = widget.training;
    int interval = training.interval;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Timer"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Round : $interval',
            ),
            Text(
              training.trainingDuration.toString(),
            ),
            SlideCountdown(
              duration: training.trainingDuration,
              showZeroValue: true,
              withDays: false,
              textStyle: TextStyle(
                  fontSize: 30, color: Theme.of(context).colorScheme.primary),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
