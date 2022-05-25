import 'dart:ffi';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier{
  var status = [
    'initilized',
    'captured',
    'eaten'
  ];
  int step = -1;
  bool isCameraInitialized = false;
  late File picture;

  cameraInitialized(){
    isCameraInitialized = true;
    notifyListeners();
  }

  stepError(){
    step = -1;
    notifyListeners();
  }

  stepDone(int index){
  step = index;
  notifyListeners();
  }

  picData(File path){
    picture = path;
    notifyListeners();
  }
  refreshData(){
    step = 0;
    notifyListeners();


  }
}