import 'package:flutter/material.dart';

MyGlobals myGlobals;

class MyGlobals {
  GlobalKey _gestureKey;
  MyGlobals() {
    _gestureKey = new GlobalKey();
  }
  GlobalKey get gestureKey => _gestureKey;
}
