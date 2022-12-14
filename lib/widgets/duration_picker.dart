import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DurationPickerDialog extends StatefulWidget {
  final Duration initialDuration;
  final EdgeInsets? titlePadding;
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  DurationPickerDialog({
    required this.initialDuration,
    required this.title,
    this.titlePadding,
    Widget? confirmWidget,
    Widget? cancelWidget,
  })  : confirmWidget = confirmWidget ?? const Text('OK'),
        cancelWidget = cancelWidget ?? const Text('Cancel');

  @override
  State<StatefulWidget> createState() =>
      _DurationPickerDialogState(initialDuration);
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late int minutes;
  late int seconds;

  _DurationPickerDialogState(Duration initialDuration) {
    minutes = initialDuration.inMinutes;
    seconds = initialDuration.inSeconds % Duration.secondsPerMinute;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      titlePadding: widget.titlePadding,
      content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        NumberPicker(
          itemWidth: 65,
          value: minutes,
          minValue: 0,
          maxValue: 10,
          zeroPad: true,
          onChanged: (value) {
            this.setState(() {
              minutes = value;
            });
          },
          selectedTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 35,
              fontWeight: FontWeight.bold),
        ),
        const Text(
          'm :',
          style: TextStyle(fontSize: 20),
        ),
        NumberPicker(
          itemWidth: 65,
          value: seconds,
          minValue: 0,
          maxValue: 59,
          zeroPad: true,
          onChanged: (value) {
            this.setState(() {
              seconds = value;
            });
          },
          selectedTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 35,
              fontWeight: FontWeight.bold),
        ),
        const Text(
          's',
          style: TextStyle(fontSize: 20),
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget,
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(Duration(minutes: minutes, seconds: seconds)),
          child: widget.confirmWidget,
        ),
      ],
    );
  }
}
