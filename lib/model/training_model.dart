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

  static List<Training> training = [
    Training(
        interval: 0,
        trainingDuration: const Duration(seconds: 0),
        breakDuration: const Duration(seconds: 0))
  ];
}
