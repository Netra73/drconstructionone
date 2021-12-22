// @dart=2.9
import 'dart:convert';

import 'package:drconstructions/Layouts/AdminDashboard.dart';
import 'file:///E:/FlutterProjects/dr_constructions/lib/Layouts/EmpSide/EmployeeDashboard.dart';
import 'package:drconstructions/Layouts/Login.dart';
import 'package:flutter/material.dart';

import 'Functions/UserData.dart';

void main() {
  runApp(MaterialApp(
    home: mainPage(),
  ));
}


class mainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _mainStatePage();
  }
}

class _mainStatePage extends State<mainPage>{
  String password;
  BuildContext mcontext;

  @override
  void initState() {
   // Navigator.push(context,MaterialPageRoute(builder: (context)=> AdminDash()));
    checkData("USERData").then((value) {
      if(value){
        setState(() {
          getData("USERData").then((value) {
           if(value!=null){
             var udata = jsonDecode(value);
          //   print('userdata $udata');
             String loginType = udata['loginType'];
             if(loginType == "Admin"){
               Navigator.of(context).pushAndRemoveUntil(
                   MaterialPageRoute(builder: (context) =>
                       AdminDash()), (Route<dynamic> route) => false);

             }
             if(loginType == "Employee"){
               Navigator.of(context).pushAndRemoveUntil(
                   MaterialPageRoute(builder: (context) =>
                       EmpDash()), (Route<dynamic> route) => false);
             }
           }
          });
        });
      }else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()), (Route<dynamic>route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mcontext = context;
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }

}