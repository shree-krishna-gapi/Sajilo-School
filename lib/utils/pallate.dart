import 'package:flutter/material.dart';



const bgColor = Color(0xFF117aac);
const darkColor = Color(0xFF28588e);
const midColor = Color(0xFF35739f);
const lightColor = Color(0xFF137cad); //117aac
//const darkColor = Colors.deepPurple;
//const lightColor  = Colors.red;
//const  midColor = Colors.blueGrey;


const purpleGradient = LinearGradient(
  colors: <Color>[ lightColor,midColor, darkColor],

  stops: [0.0, 0.5, 1.0],
  begin: Alignment.topLeft,
  end: Alignment.centerRight,
);



const lightGradient = LinearGradient(
//  colors: <Color>[ lightColor1,midColor1, darkColor1],
colors: <Color>[test1,test2,test3],
  stops: [0.0, 0.5, 1.0],
  begin: Alignment.topLeft,
  end: Alignment.centerRight,
);
class Pallate {
  static Color cardtxtcolor= Colors.black;
  static Color cardtxtcolor1= Colors.white;
  static Color cardBtn = Colors.white;
  static Color wcolor = Colors.white;
}

const test1 = Color(0xFFfdfdfd);
const test2 = Color(0xFFffffff);
const test3 = Color(0xFFfdfdfd);

const darkColor1 = Color(0xFF07409a);
const midColor1 = Color(0xFF0375c0);
const lightColor1 = Color(0xFF01a6e0);



ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      button: base.button.copyWith(
        color: Colors.white,
        fontSize: 20,
//        fontFamily: 'Pacifico',
        fontWeight: FontWeight.w500,
      ), // pin pattern,
      title: base.title.copyWith(
          fontFamily: 'Ubuntu',
          fontSize: 16.0,
          color: Colors.black87,
          fontWeight: FontWeight.w600
      ),
    );
  }
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme),
    iconTheme: IconThemeData(
      color: Pallate.wcolor,
      size: 20.0,
    ),
    buttonColor: Colors.white10,
//      tabBarTheme: base.tabBarTheme.copyWith(
//        labelColor: Palatte.color1,
//        unselectedLabelColor: Colors.grey,
//      )
  );
}




class TableHead extends StatelessWidget {
  TableHead({txt});
  String txt;
  @override
  Widget build(BuildContext context) {
    return Text(txt,
      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.4, shadows: [
            Shadow(
              blurRadius: 4.0,
              color: Colors.black12,
              offset: Offset(2.0, 2.0),
            ),
          ]
      ),);
  }
}
