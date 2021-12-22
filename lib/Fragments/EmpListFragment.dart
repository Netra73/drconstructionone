import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Layouts/DetailsPage.dart';
import 'package:drconstructions/Layouts/EditEmp.dart';
import 'package:drconstructions/Layouts/EmpForm.dart';
import 'package:drconstructions/Layouts/OrderOfEmp.dart';
import 'package:drconstructions/Layouts/TargetList.dart';
import 'package:drconstructions/Modules/empModule.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SecondFragment extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SecondFragmentState();
  }

}

class SecondFragmentState extends State<SecondFragment> {
  List<empModule>empList = [];

  _showLoading() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  height: 40.0,
                  width: 40.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return  Container(
       color: mainStyle.bgColor,
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15,4,15,4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Employee List',style: mainStyle.text16Rate),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.red)
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> EmpForm())).then((value) {
                      setState(() {

                      });
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add,color: Colors.red,),
                      Text('ADD',style: TextStyle(color: Colors.red),),
                    ],
                  ),
                )
              ],
            ),
          ),
          FutureBuilder(
          future: getOrders(),
          builder: (context,snapshot){
          if(snapshot.hasData){
          var response = jsonDecode(snapshot.data);
          if(response['status']==200){
          empList.clear();
          var data = response['data'];
          for(var details in data){
            String id = details['id'];
            String name = details['name'];
            String mobile = details['mobile'];
            String email = details['email'];
            String address = details['address'];
            String regDate = details['regDate'];
            String status = details['status'];
       if(status == "1"){
         empList.add(empModule(id,name,mobile,email,address,regDate,status));
        }
      }
           return Container(
             child: Expanded(
               child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: empList.length,
                    itemBuilder: (context,i){
                    return GestureDetector(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsPage()));
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 2),
                                            child: Icon(Icons.person,size: 15),
                                          ),
                                          Text(empList[i].name,style: mainStyle.text16),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> TargerListClass(empList[i].id,empList[i].name)));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Icon(Icons.insert_chart,color: mainStyle.textColorLight),
                                            ),
                                          ),
                                          GestureDetector(
                                          onTap: (){
//
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>EditEmp(empList[i].id,empList[i].name,empList[i].mobile,empList[i].email,empList[i].address))).then((value) {
                                              setState(() {

                                              });
                                            });
                                              },
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Icon(Icons.edit,color: mainStyle.rateColor),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              _DeleteDialog(empList[i].id,context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 4),
                                              child: Icon(Icons.delete,color: mainStyle.textColorLight),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 2),
                                        child: Icon(Icons.phone_android,size: 15,),
                                      ),
                                      Text(empList[i].mobile,style: mainStyle.text14),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 2),
                                        child: Icon(Icons.mail_outline,size: 15),
                                      ),
                                      Text(empList[i].email,style: mainStyle.text14),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(0.0),
                                      bottomRight: Radius.circular(15.0),
                                      topLeft: Radius.circular(0.0),
                                      bottomLeft: Radius.circular(15.0))
                              ),
                              width: double.infinity,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderOfEmp(empList[i].id,"2")));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius: BorderRadius.only(bottomLeft:Radius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text('Scheduled',textAlign: TextAlign.center,),
                                        ),
                                      ),
                                    ),
                                  ),
//                                  Expanded(
//                                    flex: 3,
//                                    child: GestureDetector(
//                                      onTap: (){
//                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderOfEmp(empList[i].id,"2")));
//                                      },
//                                      child: Container(
//                                        decoration: BoxDecoration(
//                                          color: Colors.blue,
//                                          borderRadius: BorderRadius.all(Radius.circular(0)),
//                                        ),
//                                        child: Padding(
//                                          padding: const EdgeInsets.all(12.0),
//                                          child: Text('Scheduled',textAlign: TextAlign.center,),
//                                        ),
//                                      ),
//                                    ),
//                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderOfEmp(empList[i].id,"3")));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(bottomRight:Radius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text('Completed',textAlign: TextAlign.center,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                 }),
             ),
           );
    }
         if(response['status']==422){
               return Padding(
       padding: const EdgeInsets.all(8.0),
               child: Text('No Data',style: mainStyle.text18),
              );
           }
        }
            return Padding(
         padding: const EdgeInsets.all(8.0),
               child: Text('Loading',style: mainStyle.text18),
    );
    }

    ,),
        ],
    ),
     );

  }

  Future<String> getOrders() async {
    final response = await http.get(API_URL+'user');
    if(response.statusCode == 200){
      String reply = response.body;
      print(reply);
      return reply;
    }
  }

  void deleteEmp(String id){
    _showLoading();
    deleteP(id).then((value) {
      Navigator.pop(context);
      var response = jsonDecode(value);
      if(response['status'] == 200){
        Fluttertoast.showToast(
            msg: "Employee Deleted",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);

      }
      if(response['status'] == 422){
        Fluttertoast.showToast(
            msg: "Error",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);
      }
      if(response['status'] == 423){
        Fluttertoast.showToast(
            msg: "Employee locked",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);
      }
      setState(() {

      });
    });
  }

  _DeleteDialog(String id,context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  //  height: 270.0,
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Are you sure, you want to delete??',style: mainStyle.text18,textAlign: TextAlign.center,),
                          ),
                          // SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8,8,8,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  onPressed: (){
                                    deleteEmp(id);
                                  },
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  color: Colors.red,
                                  child: Text('YES',style: TextStyle(fontSize: 16.0,color: Colors.white),),
                                ),
                                RaisedButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  color: Colors.grey,
                                  child: Text('No',style: TextStyle(fontSize: 16.0,color: Colors.white),),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    ).then((value){

    });
  }

  Future<String> deleteP(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(API_URL+'user/'+body));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

}