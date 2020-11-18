import 'package:flutter/material.dart';

class mainStyle {
  static const Color mainColor = Color(0xff232f3e);
  static const  Color secColor = Color(0xffF6B600);
  static const  Color secColorDark = Color(0xfff67200);
  static const  Color textColor = Color(0xff0D1321);
  static const  Color textColorLight = Color(0xff525252);
  static const  Color rateColor = Color(0xffe53935);
  static const  Color chipColor = Color(0xfff8f9fa);
  static const  Color bgColor = Color(0xffe7e8ec);

  static const TextStyle text16Rate = TextStyle(
    //  fontWeight:FontWeight.bold,
      color: rateColor,
      fontSize: 16.0,
      fontFamily: 'OpenSans');

  static const TextStyle text18Bold = TextStyle(
      fontWeight:FontWeight.bold,
      color: textColor,
      fontSize: 18.0);

  static const TextStyle text18 = TextStyle(
      color: textColor,
      fontSize: 18.0,
      fontFamily: 'OpenSans');

  static const TextStyle text14 = TextStyle(
      color: textColor,
      fontSize: 14.0,
      fontFamily: 'OpenSans');

  static const TextStyle text14Gray = TextStyle(
      color: Colors.grey,
      fontSize: 14.0,
      fontFamily: 'OpenSans');

  static const TextStyle text14Bold = TextStyle(
      fontWeight:FontWeight.bold,
      color: textColor,
      fontSize: 14.0);

  static const TextStyle text16Bold = TextStyle(
      fontWeight:FontWeight.bold,
      color: textColor,
      fontSize: 16.0);

  static const TextStyle text12Bold = TextStyle(
      fontWeight:FontWeight.bold,
      color: textColor,
      fontSize: 12.0,);

  static const TextStyle text12 = TextStyle(
      color: textColor,
      fontSize: 12.0,
      fontFamily: 'OpenSans');
  static const TextStyle text14light = TextStyle(
      color: Colors.grey,
      fontSize: 14.0,
      fontFamily: 'OpenSans');

  static const TextStyle text16 = TextStyle(
      color: textColor,
      fontSize: 16.0,
      fontFamily: 'OpenSans');

  static const TextStyle text16White = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontFamily: 'OpenSans');

  static const TextStyle text20 = TextStyle(
      color: textColor,
      fontSize: 20.0,
      fontFamily: 'OpenSans');

  static const TextStyle text20White = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontFamily: 'OpenSans');

  static const TextStyle text20Bold = TextStyle(
      fontWeight:FontWeight.bold,
      color: textColor,
      fontSize: 20.0,
      fontFamily: 'OpenSans');

  static const TextStyle text20Rate = TextStyle(
      fontWeight:FontWeight.bold,
      color: rateColor,
      fontSize: 20.0,
      fontFamily: 'OpenSans');

  static const TextStyle text20gray = TextStyle(
      color: Colors.grey,
      fontSize: 20.0,
      fontFamily: 'OpenSans');

  static const Border grayBorder = Border(
    top: BorderSide(width: 1.0, color: Colors.black26),
    left: BorderSide(width: 1.0, color: Colors.black26),
    right: BorderSide(width: 1.0, color: Colors.black26),
    bottom: BorderSide(width: 1.0, color: Colors.black26),
  );
}