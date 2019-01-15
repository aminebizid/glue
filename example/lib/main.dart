import 'package:flutter/material.dart';
import 'package:glue/glue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _counterView
          ],
        ),
      ),
      floatingActionButton: 
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[   
          FloatingActionButton(
        onPressed: () => _counterView.pushEvent(PlusEvent()),
        tooltip: 'Plus',
        child: Icon(Icons.add),
      ),
       FloatingActionButton(
        onPressed: () => _counterView.pushEvent(MinusEvent()),
        tooltip: 'Minus',
        child: Icon(Icons.remove)),
        FloatingActionButton(
        onPressed: () => GlueHub.push<CounterView>(MinusEvent()),
        tooltip: 'Minus',
        child: Icon(Icons.ac_unit)),
         FloatingActionButton(
        onPressed: () => GlueHub.pushGroup("Group1", PlusEvent()),
        tooltip: 'Minus',
        child: Icon(Icons.access_alarm))
      ],
      )

   // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



abstract class InEvent {}
class PlusEvent extends InEvent {}
class MinusEvent extends InEvent {}

abstract class OutEvent {}
class HelloEvent extends OutEvent {}


class CounterView extends GlueWidget {
  final String groupName;
  CounterView({this.groupName}) : super (groupName: groupName);

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


