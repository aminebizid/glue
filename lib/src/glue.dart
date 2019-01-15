import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class GlueWidget<IN, OUT> extends StatefulWidget {
  final Glue<IN> _inGlue = Glue<IN>();
  final Glue<OUT> _outGlue = Glue<OUT>();
   
  pushEvent(IN event) => _inGlue.pushEvent(event);
  on<T>(void onData(T event)) => _outGlue.on(onData);

  dispose() {
    _inGlue.dispose();
    _outGlue.dispose();
  }

  @override
  State createState();
} 


abstract class GlueState<S extends GlueWidget> extends State<S>
{
  on<T>(void onData(T event)) => widget._inGlue.on(onData);
  pushEvent(event) => widget._outGlue.pushEvent(event);

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

}


class Glue<T> {
  Map<Type, Function> _callbacks = new Map<Type, Function>();
  final PublishSubject<T> subject = PublishSubject<T>();

  Glue() {
     subject.listen(
       (T event) {
          if (_callbacks.containsKey(event.runtimeType)) {
            Function.apply(_callbacks[event.runtimeType], [event]);
          }
       }
     );
  }

  listen(void onData(T event)) => subject.listen(onData);
  pushEvent(T event) => subject.add(event);
  on<E>(void onData(E event)) => _callbacks[E] = onData;
  dispose() => subject.close();
}



