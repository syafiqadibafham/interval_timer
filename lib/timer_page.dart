import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interval_timer/bloc/timer_bloc.dart';
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

  int seconds = 60;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    final training = widget.training;
    //seconds = training.trainingDuration.inSeconds;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
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
    Duration? currentTimer;
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
              training.breakDuration.toString(),
            ),
            // Text(
            //   " h : m : $seconds s",
            //   style: TextStyle(
            //       fontSize: 70,
            //       fontWeight: FontWeight.bold,
            //       color: Theme.of(context).colorScheme.primary),
            // ),
            TimerText(),
            SlideCountdown(
              duration: training.trainingDuration,
              showZeroValue: true,
              withDays: false,
              textStyle: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
              ),
              onChanged: (tick) {
                currentTimer = tick;
              },
              onDone: () {
                interval = interval - 1;
                new SlideCountdown(duration: training.breakDuration);
              },
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary:
                              Theme.of(context).colorScheme.primaryContainer),
                      onPressed: () {
                        print(currentTimer.toString());
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.pause_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            "Pause",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => timerPage(
                              training: training,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.stop_rounded,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          Text(
                            "Stop",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Actions(trainingDuration: widget.training.trainingDuration),
          ],
        ),
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: TextStyle(
          fontSize: 70,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary),
    );
  }
}

class Actions extends StatelessWidget {
  final trainingDuration;

  const Actions({super.key, required this.trainingDuration});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state is TimerInitial) ...[
              FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () {
                    context
                        .read<TimerBloc>()
                        .add(TimerStarted(duration: state.duration));
                  }),
            ],
            if (state is TimerRunInProgress) ...[
              FloatingActionButton(
                child: const Icon(Icons.pause),
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerPaused()),
              ),
              FloatingActionButton(
                child: const Icon(Icons.replay),
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerReset()),
              ),
            ],
            if (state is TimerRunPause) ...[
              FloatingActionButton(
                child: const Icon(Icons.play_arrow),
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerResumed()),
              ),
              FloatingActionButton(
                child: const Icon(Icons.replay),
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerReset()),
              ),
            ],
            if (state is TimerRunComplete) ...[
              FloatingActionButton(
                child: const Icon(Icons.replay),
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerReset()),
              ),
            ]
          ],
        );
      },
    );
  }
}
