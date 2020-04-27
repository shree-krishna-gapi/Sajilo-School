import 'package:flutter/material.dart';
import 'pages/paid.dart';
import 'pages/remaining.dart';
import 'pages/assigned.dart';
import '../../utils/fadeAnimation.dart';
class Modal{
  mainBottomSheet(BuildContext context,action){
    if(action == 'paid') {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context){
            return FadeAnimation(0.4, Paid());
          }
      );
    }
    else if (action == 'unpaid') {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context){
            return FadeAnimation(0.4, Assigned());
          }
      );
    }
    else if (action == 'remaining') {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context){
            return FadeAnimation(0.4, Remaining());
          }
      );
    }
  }
}

