import 'package:flutter/material.dart';
import 'package:glue/src/glue_rx.dart';

abstract class GlueWidget extends StatefulWidget {
  final GlueRX _inGlue = GlueRX();
  final GlueRX _outGlue = GlueRX();
  final String groupName;

  GlueWidget({this.groupName}) {
    if (groupName != null) {
      glueDispatcher.addGroup(groupName);
    }
     glueDispatcher.addType(this.runtimeType);
  }
   
  pushEvent(event) => _inGlue.pushEvent(event);
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
  on<T>(void onData(T event)) {
    widget._inGlue.on(onData);
    glueDispatcher.onType<S, T>(onData);
    if (widget.groupName != null)
      glueDispatcher.onGroup<T>(widget.groupName, onData);
  } 
  pushEvent(event) => widget._outGlue.pushEvent(event);

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
}


class GlueHub {
  final Map<String, GlueRX> _groups = Map<String, GlueRX>();
  final Map<Type, GlueRX> _types = Map<Type, GlueRX>();

  addGroup(String groupName) {
    if (!_groups.containsKey(groupName))
      _groups[groupName] = GlueRX();
  }

  addType(Type type) {
    if (!_types.containsKey(type))
      _types[type] = GlueRX();
  }

  internalPushGroup(String groupName, event) {
    if (_groups.containsKey(groupName)) {
      _groups[groupName].pushEvent(event);
    }
  }

  static pushGroup(String groupName, event) {
    glueDispatcher.internalPushGroup(groupName, event);
  }

   internalPush<T>(event) {
    if (_types.containsKey(T)) {
      _types[T].pushEvent(event);
    }
  }

  static push<T>(event) {
    glueDispatcher.internalPush<T>(event);
  }

  onGroup<E>(String groupName, onData) {
    _groups[groupName].on<E>(onData);
  }

  onType<T, E>(onData) {
    _types[T].on<E>(onData);
  }



  
}

var glueDispatcher = GlueHub();



