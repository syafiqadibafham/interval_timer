import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../model/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final int _trainingDuration;
  final int _breakDuration;
  final int _interval;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc(
      {required Ticker ticker,
      required int interval,
      required int trainingDuration,
      required int breakDuration})
      : _ticker = ticker,
        _interval = interval,
        _trainingDuration = trainingDuration,
        _breakDuration = breakDuration,
        super(TimerInitial(trainingDuration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerBreak>(_onBreak);
    on<TimerReset>(_onReset);
  }
  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    _interval > 0
        ? emit(
            event.duration > 0
                ? TimerRunInProgress(event.duration)
                : TimerRest(state.trainingDuration),
          )
        : emit(
            event.duration > 0
                ? TimerRunInProgress(event.duration)
                : const TimerRunComplete(),
          );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.trainingDuration));
    }
  }

  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.trainingDuration));
    }
  }

  void _onBreak(TimerBreak event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    //_tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: _breakDuration)
        .listen((duration) => add(TimerTicked(duration: _breakDuration)));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(_trainingDuration));
  }
}
