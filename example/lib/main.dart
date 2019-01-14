import 'package:flutter/material.dart';
import 'counter_view.dart';



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
    _counterView.on<HelloEvent>((HelloEvent event) => print('bye'));
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
        child: Icon(Icons.remove)) 
      ],
      )

   // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


