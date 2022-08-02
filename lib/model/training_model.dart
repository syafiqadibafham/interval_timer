import 'dart:html';

import 'package:equatable/equatable.dart';

class Training extends Equatable {
  final int interval;
  final Duration trainingDuration;
  final Duration breakDuration;

  const Training({
    required this.interval,
    required this.trainingDuration,
    required this.breakDuration,
  });

  @override
  List<Object?> get props => [interval, trainingDuration, breakDuration];

  static List<Training> training = [
    Training(
        interval: 0,
        trainingDuration: const Duration(seconds: 0),
        breakDuration: const Duration(seconds: 0))
  ];
}
