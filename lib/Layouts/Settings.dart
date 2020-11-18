import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Layouts/EditSettings.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return Settingsstate();
  }
}

class Settingsstate extends State<Settings>{
  String Name,email,mobile,freeLimit,extraCharge,gstRate,id,pumpCharge;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: mainStyle.bgColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: FutureBuilder(
                    future: getSettings(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        var response = jsonDecode(snapshot.data);
                        if(response['status']==200){
                          var data = response['data'];
                           id = data['id'];
                           Name = data['name'];
                           email = data['email'];
                           mobile = data['mobile'];
                          String token = data['token'];
                          var setting = data['setting'];
                           freeLimit = setting['freeLimit'];
                           extraCharge = setting['extraCharge'];
                           gstRate = setting['gstRate'];
                          pumpCharge = setting['pumpCharge'];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                   // crossAxisAlignment: CrossAxisAlignment.start,
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
                                              Text(Name,style: mainStyle.text16Bold),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 2),
                                            child: Icon(Icons.phone_android,size: 15,),
                                          ),
                                          Text(mobile,style: mainStyle.text14),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 2),
                                            child: Icon(Icons.mail_outline,size: 15),
                                          ),
                                          Text(email,style: mainStyle.text14),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 2),
                                            child: Text("Free Limit : ",style: mainStyle.text16Bold),
                                          ),
                                          Text('$freeLimit Km',style: mainStyle.text16),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 2),
                                            child: Text("Extra Charge : ",style: mainStyle.text16Bold),
                                          ),
                                          Text('₹$extraCharge',style: mainStyle.text16),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 2),
                                            child: Text("GST Rate : ",style: mainStyle.text16Bold),
                                          ),
                                          Text('$gstRate%',style: mainStyle.text16),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 2),
                                            child: Text("Pump Charge : ",style: mainStyle.text16Bold),
                                          ),
                                          Text('₹$pumpCharge',style: mainStyle.text16),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 100,
                                            child: RaisedButton(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  side: BorderSide(color: Colors.red)
                                              ),
                                              onPressed: (){
                                           Navigator.push(context, MaterialPageRoute(builder: (context)=> EditSettings(id,Name,mobile,email,freeLimit,extraCharge,gstRate,pumpCharge))).then((value) {
                                           setState(() {

                                              });
                                           });
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit,color: Colors.red,),
                                                  Text('Edit',style: TextStyle(color: Colors.red),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('loading',style: TextStyle(fontSize: 20),),
                      );
                    }
                ),
              ),
            ],
          ) ,
        ),
    );
  }
}

Future<String> getSettings() async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL+'Athentication/profile'));
  request.headers.set('Content-type', 'application/json');
  request.headers.set('Authorization', 'e10adc3949ba59abbe56e057f20f883e');
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}

