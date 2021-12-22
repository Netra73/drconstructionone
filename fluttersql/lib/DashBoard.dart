import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersql/UserData.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Layouts/DReports.dart';
import 'package:sawarnabindudc/Layouts/IssueHistory.dart';
import 'package:sawarnabindudc/Layouts/Issuematerial.dart';
import 'package:sawarnabindudc/Layouts/Login.dart';
import 'package:sawarnabindudc/Layouts/MonthlyKit.dart';
import 'package:sawarnabindudc/Layouts/Report.dart';
import 'package:sawarnabindudc/Layouts/Survey.dart';

import 'Camp.dart';
import 'Survey.dart';

class DashBoard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return DashBoardState();
  }

}

class DashBoardState extends State<DashBoard>{
  String name,post;
  bool lPost = false;
  List<String>_images = ['images/mainimg.png','images/mainimg.png','images/mainimg.png'];

  @override
  void initState() {
    // TODO: implement initState
    getData("USERData").then((value) {
      setState(() {
        if(value!=null){
          var udata = jsonDecode(value);
          print('userdata $udata');
          name = udata['name'];
          post = udata['post'];
         // post = 'co';
          if(post == "Dist.Coordinator"){
            lPost = true;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.white,
         actions: <Widget> [
         Padding(
         padding: const EdgeInsets.only(right: 5),
          child: IconButton(icon: Icon(Icons.exit_to_app,size:35,color: Colors.blueGrey,), onPressed: () {
            removeData("USERData").then((value) {
              removeData("USERMail").then((value) {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      Login()), (Route<dynamic> route) => false);
              });
            });
         }),
       ),
         ],
         leading: Padding(
           padding: const EdgeInsets.all(6.0),
           child: Image(image: AssetImage('images/mainimg.png'),),
         ),
         title: Padding(
           padding: const EdgeInsets.only(top: 6,bottom: 6,left: 3,right: 0),
           child: Text('$name \n$post',style: TextStyle(fontSize:18,color: Colors.blueGrey),),
         ),

       ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        crossAxisCount: 2,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Survey()));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: AssetImage('images/survey1.png'),height: 90,width: 60,),
                  Card(
                      margin: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    color: Colors.orangeAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("Survey",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                      )),
                  // color: Colors.teal[100],
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DReports()));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(image: AssetImage('images/report.png'),height: 90,width: 60,),
                  Card(
                    margin: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.orangeAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Reports",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                    ),
                  ),
                  // color: Colors.teal[100],
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MonthlyKit()));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(image: AssetImage('images/month.png'),height: 90,width: 60,),
                  Card(
                    margin: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.orangeAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Monthly Kit",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                    ),
                  ),
                  // color: Colors.teal[100],
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Camp()));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(image: AssetImage('images/camp.png'),height: 80,width: 80,),
                  Card(
                    margin: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.orangeAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Camp",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                    ),
                  ),
                  // color: Colors.teal[100],
                ],
              ),
            ),
          ),
          if(lPost) GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Issuematerial()));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_late ,size: 90,color: Colors.blueGrey,),
                  Card(
                      margin: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.orangeAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("Issue Material",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                      )),
                  // color: Colors.teal[100],
                ],
              ),
            ),
          ),
          if(lPost)GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>IssueHistory()));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history ,size: 90,color: Colors.blueGrey,),
                  Card(
                      margin: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.orangeAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("History",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                      )),
                  // color: Colors.teal[100],
                ],
              ),
            ),
          ),
          if(lPost)GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Report()));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.insert_chart ,size: 90,color: Colors.blueGrey,),
                  Card(
                      margin: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.orangeAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("Monthly Report",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                      )),
                  // color: Colors.teal[100],
                ],
              ),
            ),
          ),
        ],
      ),
      );
  }

}