import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

class timerPage extends StatefulWidget {
  timerPage({Key? key}) : super(key: key);

  @override
  State<timerPage> createState() => _timerPageState();
}

class _timerPageState extends State<timerPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'Round : $_counter',
            ),
            SlideCountdown(
              duration: Duration(seconds: 100),
              showZeroValue: true,
              withDays: false,
              textStyle: TextStyle(
                  fontSize: 30, color: Theme.of(context).colorScheme.primary),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Start Timer',
        child: const Icon(Icons.play_arrow_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
