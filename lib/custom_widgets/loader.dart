
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader{

  static Widget loaderWhite(){
    return LoadingAnimationWidget.threeRotatingDots(
        color: Colors.white,
        size: 30
    );
  }
  static Widget loaderPurple(){
    return LoadingAnimationWidget.threeRotatingDots(
        color:Color(0xFFe68f50),
        size: 30
    );
  }

}