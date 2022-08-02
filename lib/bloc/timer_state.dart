part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int trainingDuration;

  const TimerState(this.trainingDuration);

  @override
  List<Object> get props => [trainingDuration];
}

class TimerInitial extends TimerState {
  const TimerInitial(int duration) : super(duration);

  @override
  String toString() => 'TimerInitial { duration: $trainingDuration }';
}

class TimerRunPause extends TimerState {
  const TimerRunPause(int duration) : super(duration);

  @override
  String toString() => 'TimerRunPause { duration: $trainingDuration }';
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(int duration) : super(duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $trainingDuration }';
}

class TimerRest extends TimerState {
  const TimerRest(int duration) : super(duration);

  @override
  String toString() => 'TimerBreak { duration: $trainingDuration }';
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}
