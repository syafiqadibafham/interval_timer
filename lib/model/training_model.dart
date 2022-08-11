import 'dart:async';
import 'package:equatable/equatable.dart';

class TrainingData extends Equatable {
  int interval;
  Duration trainingDuration;
  Duration breakDuration;

  TrainingData({
    required this.interval,
    required this.trainingDuration,
    required this.breakDuration,
  });

  @override
  List<Object?> get props => [interval, trainingDuration, breakDuration];

  Duration getTotalTime() {
    return ((trainingDuration * interval) + (breakDuration * (interval - 1)));
  }
}

enum TrainingState {
  initial,
  starting,
  exercising,
  resting,
  breaking,
  finished
}

class Training {
  final TrainingData _trainingData;
  Timer? _timer;

  // Callback when the training's state changes.
  final Function _onStateChange;

  // initial training state
  TrainingState _step = TrainingState.initial;

  // Time left in the current step
  late Duration _timeLeft;

  Duration _totalTime = const Duration(seconds: 0);

  // Current set
  int _interval = 0;

  Training(this._trainingData, this._onStateChange);

  // Starts or resumes the training
  start() {
    if (_step == TrainingState.initial) {
      _step = TrainingState.starting;
      _nextStep();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    _onStateChange();
  }

  // Pauses the training
  pause() {
    _timer?.cancel();
    _onStateChange();
  }

  // Stop the training
  stop() {
    _timer?.cancel();
    _step = TrainingState.finished;
    _timeLeft = const Duration(seconds: 0);
    _onStateChange();
  }

  // Stops the timer without triggering the state change callback.
  dispose() {
    _timer?.cancel();
  }

  _tick(Timer timer) {
    if (_step != TrainingState.starting) {
      _totalTime += const Duration(seconds: 1);
    }

    if (_timeLeft.inSeconds == 1) {
      _nextStep();
    } else {
      _timeLeft -= const Duration(seconds: 1);
    }
    _onStateChange();
  }

  // Moves the training to the next step and sets up state for it.
  _nextStep() {
    if (_step == TrainingState.exercising) {
      if (interval == _trainingData.interval) {
        _finish();
      } else {
        _startRest();
      }
    } else if (_step == TrainingState.starting ||
        _step == TrainingState.resting) {
      _startSet();
    }
  }

  _startRest() {
    _step = TrainingState.resting;
    if (_trainingData.breakDuration.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _trainingData.breakDuration;
    //TODO play Rest Sound
  }

  _startSet() {
    _interval++;
    _step = TrainingState.exercising;
    _timeLeft = _trainingData.trainingDuration;
    //TODO play Start Sound
  }

  _finish() {
    _timer?.cancel();
    _step = TrainingState.finished;
    _timeLeft = const Duration(seconds: 0);
    //TODO play Finish Sound
  }

  get config => _trainingData;

  get interval => _interval;

  get step => _step;

  get timeLeft => _timeLeft;

  get totalTime => _totalTime;

  get isActive => _timer != null && _timer!.isActive;
}
