import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:interval_timer/quotes.dart';
import 'package:interval_timer/widgets/custom_button.dart';
import 'package:wakelock/wakelock.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/training_model.dart';

class TimerPage extends StatefulWidget {
  final TrainingData training;

  TimerPage({Key? key, required this.training}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Training workout;
  final confettiController = ConfettiController();

  //This string will be default string, if no Quote can be fetch
  String quoteStr = "Exercise";

  @override
  void initState() {
    super.initState();
    // Here we take the training value from the MyHomePage object that was created by
    // the Touchspin and DurationPickerDialog widgets, and use it to set our timer.
    workout = Training(widget.training, _onWorkoutChanged);
    //The timer will be start directly by trigger the _start() function
    _start();
    //The quote will be fetch from the API only in the initial state.
    //This will prevent the API been calling multiple time while the timer is running
    fetchQuote();
  }

  //This function will be use to fetch the Quote from the API
  void fetchQuote() {
    getQuote().then((quote) {
      setState(() {
        //The data from the API will be assign to another variable
        //in order to use it as String
        quoteStr = quote; // Future is completed with a value.
      });
    });
  }

  String _stateName() {
    switch (workout.step) {
      case TrainingState.exercising:
        return quoteStr;
      case TrainingState.resting:
        return 'Rest';
      case TrainingState.finished:
        return 'Finished';
      case TrainingState.starting:
        return 'Starting';
      default:
        return '';
    }
  }

  _getBackgroundColor(ThemeData theme) {
    switch (workout.step) {
      case TrainingState.exercising:
        return Theme.of(context).colorScheme.background;
      case TrainingState.starting:
      case TrainingState.resting:
        return Theme.of(context).colorScheme.inversePrimary;
      default:
        return Theme.of(context).colorScheme.background;
    }
  }

  _getTimerColor(ThemeData theme) {
    switch (workout.step) {
      case TrainingState.exercising:
        return Theme.of(context).colorScheme.primary;
      case TrainingState.starting:
      case TrainingState.resting:
        return Theme.of(context).colorScheme.onPrimaryContainer;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  _start() {
    workout.start();
    //Wakelock.enable will prevent the screen from sleep
    Wakelock.enable();
  }

  _pause() {
    workout.pause();
    Wakelock.disable();
  }

  _stop() {
    workout.stop();
    Wakelock.disable();
  }

  _restart() {
    confettiController.stop();
    workout = Training(widget.training, _onWorkoutChanged);
    _start();
  }

  @override
  dispose() {
    workout.dispose();
    Wakelock.disable();
    super.dispose();
  }

  _onWorkoutChanged() {
    if (workout.step == TrainingState.finished) {
      Wakelock.disable();
    }
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    //Stack widget is needed in order for the confetti widget function properly
    return Stack(
        //The confetti position determines by alignment method
        alignment: Alignment.center,
        children: [
          Scaffold(
            backgroundColor: _getBackgroundColor(theme),
            appBar: AppBar(
              title: const Text("Timer"),
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Text(
                      'Round : ${workout.interval}',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 85,
                  ),
                  Expanded(flex: 1, child: Center(child: TimerText())),
                  Text(_stateName(),
                      style: GoogleFonts.caveat(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                  Flexible(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _buildButtonBar())),
                ],
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: confettiController,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ]);
  }

  //TimerText is a Text widget that has been used to act as a timer.
  Widget TimerText() {
    var theme = Theme.of(context);
    final duration = workout.timeLeft;
    String minutesStr = (duration.inMinutes).toString().padLeft(2, '0');
    String secondsStr = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      '$minutesStr:$secondsStr',
      style: TextStyle(
          fontSize: 70,
          fontWeight: FontWeight.bold,
          color: _getTimerColor(theme)),
    );
  }

  //_buildButtonBar() is a list of Button Widget for Pause,Resume,Stop and restart the training
  //the if else is required, to display different button in different workout state.
  Widget _buildButtonBar() {
    if (workout.step == TrainingState.finished) {
      confettiController.play();
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomElevatedButton(
            onPressed: _restart,
            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            forgroundColor: Theme.of(context).colorScheme.onPrimary,
            label: "Restart",
            iconLabel: Icons.replay_rounded,
          ),
        ],
      );
    }
    //This Buttons will only be shown when the Workout is still active.
    //It will dissaper, when the Workout is already finished.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //This button will be act to pause/resume the timer.
        //When the _workout.isActive, it means the timer is active/running
        //the pause button will be shown, when the timer is active.
        //when the timer is deactive or in pause mode, the resume button will be shown.
        CustomElevatedButton(
          onPressed: workout.isActive ? _pause : _start,
          backgroundColor: workout.isActive
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.onPrimaryContainer,
          forgroundColor: workout.isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
          label: workout.isActive ? "Pause" : "Resume",
          iconLabel:
              workout.isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
        ),
        const SizedBox(
          width: 15,
        ),
        //This widget is a stop button, to stop the timer.
        CustomElevatedButton(
          onPressed: _stop,
          backgroundColor: Theme.of(context).colorScheme.onErrorContainer,
          forgroundColor: Theme.of(context).colorScheme.onError,
          label: "Stop",
          iconLabel: Icons.stop_rounded,
        ),
      ],
    );
  }
}
