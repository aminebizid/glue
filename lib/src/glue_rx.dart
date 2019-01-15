import 'package:rxdart/rxdart.dart';

class GlueRX {
  Map<Type, Function> _callbacks = new Map<Type, Function>();
  final PublishSubject<dynamic> subject = PublishSubject<dynamic>();

  GlueRX() {
     subject.listen(
       (event) {
          if (_callbacks.containsKey(event.runtimeType)) {
            Function.apply(_callbacks[event.runtimeType], [event]);
          }
       }
     );
  }

  listen(void onData(event)) => subject.listen(onData);
  pushEvent(event) => subject.add(event);
  on<T>(void onData(T event)) => _callbacks[T] = onData;
  dispose() => subject.close();
}