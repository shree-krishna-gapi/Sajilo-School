import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fadeAnimation.dart';
import 'package:shimmer/shimmer.dart';
class Urls {
//  static const BASE_API_URL = "http://mobileapp.karmathalo.com/Api";  // live server
  static const BASE_API_URL = "http://192.168.1.89:88/api"; // Ramesh Laptop192.168.100.12:88
  static const Image_API_URL = "http://192.168.1.89:88";
//  static const BASE_API_URL = "http://192.168.100.12/School/Api"; // Bikesh Laptop
//  static const BASE_API_URL = "http://192.168.0.140:88/api";  // mining wifi
//  static const BASE_API_URL = Future((oo));
//  static const BASE_API_URL = "http://192.168.1.100:88/api"; // Ramesh Laptop
}
class Single {
  static const height = 40.0;
}
class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.6, Center(
        child: CircularProgressIndicator(backgroundColor: Colors.yellow[700],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      ),
    );
  }
}
class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
      letterSpacing: 0.4,),)
    );
  }
}
class WaitLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: Colors.yellow[700],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          SizedBox(height: 30,),
          Shimmer.fromColors(
              baseColor: Colors.white, highlightColor: Colors.white54,
              child: Text('Please Wait...', style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white,
                  letterSpacing: 0.6),)),
          SizedBox(height: 30,),
        ],
      )
    );
  }
}

class Wait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xfffbfbef),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Container(height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.yellow[700],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            SizedBox(height: 30,),
            Shimmer.fromColors(
                baseColor: Colors.black, highlightColor: Colors.black12,
                child: Text('Please Wait...', style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w500,
                    letterSpacing: 0.6),))
          ],
        ),
      ),
    );
  }
}
class YearLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
    baseColor: Colors.black, highlightColor: Colors.black12,
child: Text('Year', style: TextStyle(
fontSize: 17, fontWeight: FontWeight.w500,
letterSpacing: 0.6),));
  }
}


class Success extends StatelessWidget {
  Success({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.3, AlertDialog(
          backgroundColor: Color(0xfffbfbef),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(15.0))),

          title: Container(height: 110,
            child: Column(
              children: <Widget>[
                Icon(Icons.done_all, size: 54,
                  color: Colors.green[400],),
                SizedBox(height: 10,),
                Text(txt, style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6),)

              ],
            ),
          )),
    );
  }
}
class Error extends StatelessWidget {
  Error({this.txt,this.subTxt});
  final String txt;
  final String subTxt;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xfffbfbef),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Row(
        children: <Widget>[
          txt == 'Data Not Found' ?
          Container(
            height: 24, width: 5, color: Colors.orange[700].withOpacity(0.8),
          ):Container(
            height: 24, width: 5, color: Colors.red[700].withOpacity(0.8),
          ),
          SizedBox(width: 15,),
          Text(txt),
        ],
      ),
      content: Text(subTxt),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Duration(milliseconds: 300);
            Navigator.of(context).pop();
          },
        ),
      ],);
  }
}

class EmptyData extends StatelessWidget {
  EmptyData({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Text(txt,style: TextStyle(fontSize: 20,
          letterSpacing: 0.4,),)
    );
  }
}