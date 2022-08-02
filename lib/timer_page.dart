import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interval_timer/bloc/timer_bloc.dart';
import 'package:interval_timer/model/ticker.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'model/training_model.dart';

class timerPage extends StatefulWidget {
  final Training training;

  timerPage({Key? key, required this.training}) : super(key: key);

  @override
  State<timerPage> createState() => _timerPageState();
}

class _timerPageState extends State<timerPage> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    final training = widget.training;
  }

  void startTimer() {
    setState(() {});
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
            TimerText(),
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
    final duration =
        context.select((TimerBloc bloc) => bloc.state.trainingDuration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        Text(
          '$minutesStr:$secondsStr',
          style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primaryContainer),
                  onPressed: () => context
                      .read<TimerBloc>()
                      .add(TimerStarted(duration: state.trainingDuration)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        "Start",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  )),
            ],
            if (state is TimerRunInProgress) ...[
              ElevatedButton(
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerPaused()),
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.onErrorContainer),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                  child: Row(
                    children: [
                      Icon(
                        Icons.stop_rounded,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                      Text(
                        "Stop",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onError),
                      ),
                    ],
                  )),
            ],
            if (state is TimerRunPause) ...[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primaryContainer),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerResumed()),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        "Start",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  )),
              ElevatedButton(
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                  child: Row(
                    children: [
                      Icon(
                        Icons.replay_rounded,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      Text(
                        "Restart",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ],
                  )),
            ],
            if (state is TimerRunComplete) ...[
              ElevatedButton(
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                  child: Row(
                    children: [
                      Icon(
                        Icons.replay_rounded,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      Text(
                        "Restart",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ],
                  )),
            ]
          ],
        );
      },
    );
  }
}
