import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interval_timer/bloc/timer_bloc.dart';
import 'package:interval_timer/model/ticker.dart';
import 'package:interval_timer/quotes.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:wakelock/wakelock.dart';

import 'model/training_model.dart';

String stepName(WorkoutState step) {
  switch (step) {
    case WorkoutState.exercising:
      return 'Exercise';
    case WorkoutState.resting:
      return 'Rest';
    case WorkoutState.breaking:
      return 'Break';
    case WorkoutState.finished:
      return 'Finished';
    case WorkoutState.starting:
      return 'Starting';
    default:
      return '';
  }
}

class TimerPage extends StatefulWidget {
  final Training training;

  TimerPage({Key? key, required this.training}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Workout _workout;
  late Future futureQuote;

  @override
  void initState() {
    super.initState();
    _workout = Workout(widget.training, _onWorkoutChanged);
    _start();
    futureQuote = getQuote();
  }

  _restart() {
    _workout = Workout(widget.training, _onWorkoutChanged);
    _start();
  }

  @override
  dispose() {
    _workout.dispose();
    Wakelock.disable();
    super.dispose();
  }

  _onWorkoutChanged() {
    if (_workout.step == WorkoutState.finished) {
      Wakelock.disable();
    }
    this.setState(() {});
  }

  _getBackgroundColor(ThemeData theme) {
    switch (_workout.step) {
      case WorkoutState.exercising:
        return Theme.of(context).colorScheme.background;
      case WorkoutState.starting:
      case WorkoutState.resting:
        return Theme.of(context).colorScheme.onPrimary;
      case WorkoutState.breaking:
        return Theme.of(context).colorScheme.onPrimaryContainer;
      default:
        return Theme.of(context).colorScheme.background;
    }
  }

  _getTimerColor(ThemeData theme) {
    switch (_workout.step) {
      case WorkoutState.exercising:
        return Theme.of(context).colorScheme.primary;
      case WorkoutState.starting:
      case WorkoutState.resting:
        return Theme.of(context).colorScheme.onPrimaryContainer;
      case WorkoutState.breaking:
        return Theme.of(context).colorScheme.onPrimary;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  _pause() {
    _workout.pause();
    Wakelock.disable();
  }

  _stop() {
    _workout.stop();
    Wakelock.disable();
  }

  _start() {
    _workout.start();
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    Training training = widget.training;
    int interval = training.interval;
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _getBackgroundColor(theme),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Timer"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Round : ${_workout.set}',
                style: TextStyle(fontSize: 30),
              ),
              TimerText(),
              //Actions(trainingDuration: widget.training.trainingDuration),
              //if()
              FutureBuilder(
                  future: futureQuote,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data.toString(),
                      );
                    } else {
                      return Text(
                        "No Quotes",
                      );
                    }
                  }),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildButtonBar())),
              SizedBox(
                height: 35,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget TimerText() {
    var theme = Theme.of(context);
    final duration = _workout.timeLeft;
    String minutesStr = (duration.inMinutes).toString().padLeft(2, '0');
    String secondsStr = (duration.inSeconds % 60).toString().padLeft(2, '0');
    // final minutesStr =
    //     ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    // final secondsStr = (duration % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        Text(
          '$minutesStr:$secondsStr',
          style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: _getTimerColor(theme)),
        ),
      ],
    );
  }

  Widget _buildButtonBar() {
    if (_workout.step == WorkoutState.finished) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            width: 130,
            child: ElevatedButton(
              style: ButtonStyle(),
              onPressed: _restart,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.replay_rounded),
                  Text(
                    "Restart",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 70,
          width: 130,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: _workout.isActive
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: _workout.isActive ? _pause : _start,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _workout.isActive
                    ? Icon(
                        Icons.pause_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : Icon(Icons.play_arrow_rounded,
                        color: Theme.of(context).colorScheme.onPrimary),
                Text(
                  _workout.isActive ? "Pause" : "Resume",
                  style: TextStyle(
                    color: _workout.isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        SizedBox(
          height: 70,
          width: 130,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.onErrorContainer),
            onPressed: _stop,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.stop_rounded,
                  color: Theme.of(context).colorScheme.onError,
                ),
                Text(
                  "Stop",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onError),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// class TimerText extends StatelessWidget {
//   const TimerText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final duration =
//     //     context.select((TimerBloc bloc) => bloc.state.trainingDuration);
//     final duration = _workout.
//     final minutesStr =
//         ((duration / 60) % 60).floor().toString().padLeft(2, '0');
//     final secondsStr = (duration % 60).toString().padLeft(2, '0');

//     return Column(
//       children: [
//         Text(
//           '$minutesStr:$secondsStr',
//           style: TextStyle(
//               fontSize: 70,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.primary),
//         ),
//       ],
//     );
//   }
// }

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
