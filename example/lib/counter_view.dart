
import 'package:glue/glue.dart';
import 'package:flutter/material.dart';

abstract class InEvent {}
class PlusEvent extends InEvent {}
class MinusEvent extends InEvent {}

abstract class OutEvent {}
class HelloEvent extends OutEvent {}


class CounterView extends GlueWidget<InEvent, OutEvent> {
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends GlueState<InEvent, OutEvent, CounterView> {

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