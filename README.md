# glue

A library that allows you to easily pass a data Model from a one Widget to others using messaging system.
This will help avoid passing delegates.

A widget can subscribe to external events using on<EventType>() method.

```dart


abstract class InEvent {}
class PlusEvent extends InEvent {}
class MinusEvent extends InEvent {}

 @override
  void initState() {
    // subscribe to events
    on<PlusEvent>(_onPlusRecieved);
    on<MinusEvent>(_onMinusRecieved);
    super.initState();
  }


// Another widget
myWidget.pushEvent(myEvent);


```

## Usage

Let's demo the basic usage with the all-time favorite: A counter example!

Homepage

```dart
import 'package:flutter/material.dart';
import 'package:comm/counter_view.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _counterView = CounterView();

  @override
  Widget build(BuildContext context) {
    _counterView.on<HelloEvent>((HelloEvent event) => print('CounterView sent Hello'));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _counterView
          ]
        )
      ),
      floatingActionButton:
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
            FloatingActionButton(
                onPressed: () => _counterView.pushEvent(PlusEvent()),
                child: Icon(Icons.add)
            ),
            FloatingActionButton(
                onPressed: () => _counterView.pushEvent(MinusEvent()),
                child: Icon(Icons.remove)
            )
        ]
      )
    );
  }
}
```

```dart
import 'package:flutter/material.dart';
import 'package:glue/glue.dart';

abstract class InEvent {}
class PlusEvent extends InEvent {}
class MinusEvent extends InEvent {}

abstract class OutEvent {}
class HelloEvent extends OutEvent {}


class CounterView extends GlueWidget<InEvent, OutEvent> {
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends GlueState<CounterView> {

  String _text = '';

  @override
  void initState() {
    // subscribe to events
    on<PlusEvent>(_onPlusRecieved);
    on<MinusEvent>(_onMinusRecieved);
    super.initState();
  }

   void _onPlusRecieved(PlusEvent event) {
        setState(() {
            _text = 'Plus Pushed';
        });
   }

    void _onMinusRecieved(MinusEvent event) {
        setState(() {
            _text = 'Minus Pushed';
        });
   }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(_text),
        RaisedButton(
          child: Text('Push'),
          onPressed: () => pushEvent(HelloEvent()), // Send event to parent
        )
      ]
    );
  }
}
```
