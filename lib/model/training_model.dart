import 'dart:async';

import 'package:equatable/equatable.dart';

class Training extends Equatable {
  int interval;
  Duration trainingDuration;
  Duration breakDuration;

  Training({
    required this.interval,
    required this.trainingDuration,
    required this.breakDuration,
  });

  @override
  List<Object?> get props => [interval, trainingDuration, breakDuration];

  Duration getTotalTime() {
    return (trainingDuration * interval) + (breakDuration * interval);
  }
}

enum WorkoutState { initial, starting, exercising, resting, breaking, finished }

class Workout {
  Training _trainingData;
  Timer? _timer;

  /// Callback for when the workout's state has changed.
  Function _onStateChange;

  WorkoutState _step = WorkoutState.initial;

  /// Time left in the current step
  late Duration _timeLeft;

  Duration _totalTime = Duration(seconds: 0);

  /// Current set
  int _set = 0;

  /// Current rep
  int _rep = 0;

  Workout(this._trainingData, this._onStateChange);

  /// Starts or resumes the workout
  start() {
    if (_step == WorkoutState.initial) {
      _step = WorkoutState.starting;
      _nextStep();
    }
    _timer = Timer.periodic(Duration(seconds: 1), _tick);
    _onStateChange();
  }

  /// Pauses the workout
  pause() {
    _timer?.cancel();
    _onStateChange();
  }

  /// Stop the workout
  stop() {
    _timer?.cancel();
    _step = WorkoutState.finished;
    _timeLeft = Duration(seconds: 0);
    _onStateChange();
  }

  /// Stops the timer without triggering the state change callback.
  dispose() {
    _timer?.cancel();
  }

  _tick(Timer timer) {
    if (_step != WorkoutState.starting) {
      _totalTime += Duration(seconds: 1);
    }

    if (_timeLeft.inSeconds == 1) {
      _nextStep();
    } else {
      _timeLeft -= Duration(seconds: 1);
    }

    _onStateChange();
  }

  /// Moves the workout to the next step and sets up state for it.
  _nextStep() {
    if (_step == WorkoutState.exercising) {
      if (set == _trainingData.interval) {
        _finish();
      } else {
        _startRest();
      }
    } else if (_step == WorkoutState.starting ||
        _step == WorkoutState.resting) {
      _startSet();
    }
  }

  _startRest() {
    _step = WorkoutState.resting;
    if (_trainingData.breakDuration.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _trainingData.breakDuration;
    //TODO play Rest Sound
  }

  _startSet() {
    _set++;
    _rep = 1;
    _step = WorkoutState.exercising;
    _timeLeft = _trainingData.trainingDuration;
    //TODO play Start Sound
  }

  _finish() {
    _timer?.cancel();
    _step = WorkoutState.finished;
    _timeLeft = Duration(seconds: 0);
    //TODO play Finish Sound
  }

  get config => _trainingData;

  get set => _set;

  get rep => _rep;

  get step => _step;

  get timeLeft => _timeLeft;

  get totalTime => _totalTime;

  get isActive => _timer != null && _timer!.isActive;
}
