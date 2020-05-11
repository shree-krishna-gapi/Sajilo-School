import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class TitleText extends StatelessWidget {
  final txt;
  TitleText({this.txt});
  @override
  Widget build(BuildContext context) {
    return Align( alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text('$txt',style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 0.4,
            fontWeight: FontWeight.w500,
            shadows:[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Colors.black26,
              ),
            ]
        ),),
      ),
    );
  }
}
