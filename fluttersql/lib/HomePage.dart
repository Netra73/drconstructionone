import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttersql/UserData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Layouts/EditCard.dart';
import 'package:sawarnabindudc/Layouts/Viewallstock.dart';
import 'package:sawarnabindudc/Modules/stockModule.dart';
import 'package:sawarnabindudc/Modules/stockModule.dart';
import 'package:sawarnabindudc/Modules/todaysModule.dart';
import 'package:sawarnabindudc/Styles/textstyle.dart';


import 'Camp.dart';
import 'DReports.dart';
import 'DatabaseHelper.dart';
import 'IssueHistory.dart';
import 'MonthlyKit.dart';
import 'SurveyDialog.dart';
import 'campDialog.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{
 String id,c100,c80,med,email,dateformat2,dateformat3;
 List<stockModule>stockList = [];
 List<TodayasModule>todaysList = [];
 bool tlist = false;
 bool hdata = false;
 DateTime selectedDate = DateTime.now();

  @override
  void initState() {
     dateformat2 = DateFormat("yyyy-MM-dd").format(selectedDate);
     dateformat3 = DateFormat("dd-MM-yyyy").format(selectedDate);
    // TODO: implement initState
    getData("USERData").then((value) {
       var data = jsonDecode(value);
       id = data['id'].toString();
       email = data['email'].toString();
    });
    DatabaseHelper.instance.getPendingCount().then((value) {
      setState(() {
        if(value.isNotEmpty){
          hdata = true;
        }
        else{
          hdata = false;
        }
      });
    });
    setState(() {

    });
  }

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
    return Scaffold(
       body: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
            if(hdata) Padding(
               padding: const EdgeInsets.only(left: 6,right: 6,top: 6),
               child: Card(
                 elevation: 2,
                 shape: RoundedRectangleBorder(
                     side: BorderSide(width: 0.2),
                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
                 child: Padding(
                   padding: const EdgeInsets.only(left: 12),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       SizedBox(height: 10),
                       Text('Offline Entries',style: mainStyle.text18BoldM,),
                       SizedBox(height: 8),
                       FutureBuilder(
                         future:  fetchOfflineDatabase(),
                         builder: (context,snapshot){
                           if(snapshot.hasData){
                             return ListView.separated(
                               shrinkWrap: true,
                               itemCount: snapshot.data.length,
                               itemBuilder: (context, index) {
                                 return  Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: <Widget>[
                                       Container(
                                         width:130,
                                         child: Text(snapshot.data[index]['campName'].toString(),
                                             style: new TextStyle(fontSize: 18.0)),
                                       ),
                                       Row(
                                         children: [
                                           Icon(Icons.people,size: 20,),
                                           SizedBox(width: 4),
                                           Text(snapshot.data[index]['total'].toString(),
                                               style: new TextStyle(fontSize: 18.0)),
                                         ],
                                       ),
                                       GestureDetector(
                                         onTap: (){
                                           DatabaseHelper.instance.getCampCustomer(snapshot.data[index]['camp']).then((value){
                                             String camp = snapshot.data[index]['camp'].toString();
                                             var data = jsonEncode(value);
                                             SyncMethod(context,data,email,camp);
                                           });
                                         },
                                         child: Card(
                                             margin: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                                             shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.only(topRight:Radius.circular(20),bottomRight: Radius.circular(20)),
                                             ),
                                             color: Colors.black,
                                             child: Padding(
                                               padding: const EdgeInsets.all(2.0),
                                               child: Row(
                                                 children: [
                                                   const Text("Sync",style: TextStyle(fontSize: 16,color: Colors.white),textAlign: TextAlign.center,),
                                                   Icon(Icons.sync,color: Colors.white,),
                                                 ],
                                               ),
                                             )),
                                       ),
                                     ]);
                               },
                               separatorBuilder: (context, index) {
                                 return Divider();
                               },
                             );
                           }
                           return Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('Loading',style: mainStyle.text18),
                           );
                         }
                         ,)
                     ],
                   ),
                 ),
               ),
             ),
             SizedBox(height: 5),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                 elevation: 2,
                 shape: RoundedRectangleBorder(
                     side: BorderSide(width: 0.2),
                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
                 child: Padding(
                   padding: const EdgeInsets.only(left: 12),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       SizedBox(height: 10),
                       Padding(
                         padding: const EdgeInsets.only(left: 8,right: 8,bottom: 6),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Stock',style: mainStyle.text18BoldM,),
                             GestureDetector(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=> viewAllStock()));
                               },
                                 child: Icon(Icons.arrow_forward_ios,size: 23,)),
                           ],
                         ),
                       ),
                       SizedBox(height: 8),
                      FutureBuilder(
                        future: getData("USERData"),
                        builder: (context,snap2){
                          if(snap2.hasData){
                            var data = jsonDecode(snap2.data);
                            id = data['id'].toString();
                            email = data['email'].toString();
                            return FutureBuilder(
                                future: getStock(id),
                                builder: (context,snapshot2){
                                  if(snapshot2.hasData){
                                    var response = jsonDecode(snapshot2.data);
                                    if(response['status']==200){
                                      stockList.clear();
                                      var data = response['data'];
                                      var accounts = data['account'];
                                      var summary = accounts['summary'];
                                      for(var details in summary){
                                        String name = details['name'].toString();
                                        String total = details['total'].toString();

                                        if(name=='Cards-100' || name=='Cards-80' || name=='Big dose'){
                                          total = details['total'].toString();
                                          String cc = total;
                                          stockList.add(stockModule(name,cc));
                                        }
                                      }
                                      return  Padding(
                                        padding: const EdgeInsets.only(left: 4,right: 8),
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Column(
                                              children: <Widget>[
                                                ListView.separated( shrinkWrap: true,
                                                  itemCount: stockList.length,
                                                  itemBuilder: (context,i){
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.credit_card,color: Colors.blue,),
                                                            SizedBox(width: 6),
                                                            Text(stockList[i].cname.toString(), style: new TextStyle(fontSize: 18.0)),
                                                          ],
                                                        ),
                                                        Text(stockList[i].ctotal.toString(),
                                                            style: new TextStyle(fontSize: 18.0)),
                                                      ],
                                                    );
                                                  },
                                                  separatorBuilder: (context, index) {
                                                    return Divider();
                                                  },),
                                              ]),
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
                                    child: Text('Loading..',style: mainStyle.text18),
                                  );
                                }
                                ,);
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('loading',style: TextStyle(fontSize: 20),),
                          );
                        },
                      )
                     ],
                   ),
                 ),
               ),
             ),
             SizedBox(height: 8),
             Padding(
               padding: const EdgeInsets.only(left: 6,right: 6),
               child: Card(
                 elevation: 2,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Container(
                       width: double.infinity,
                       color: Colors.grey[300],
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Todays Camp',style: mainStyle.text18BoldM,),
                         )),
                     SizedBox(height: 8),
                     Padding(
                       padding: const EdgeInsets.only(left: 5,right: 5),
                       child: Row(
                         children: [
                           Expanded(
                             child: Container(
                               height: 80,
                               child: FutureBuilder(
                                 future: getData("USERData"),
                                 builder: (context,snap3){
                                   if(snap3.hasData){
                                     var data = jsonDecode(snap3.data);
                                     id = data['id'].toString();
                                     email = data['email'].toString();
                                     return FutureBuilder(
                                       future: getStock(id),
                                       builder: (context,snapshot){
                                         if(snapshot.hasData){
                                           var response = jsonDecode(snapshot.data);
                                           if(response['status']==200){
                                             todaysList.clear();
                                             var data = response['data'];
                                             var todayCamp = data['todayCamp'];
                                             for(var details in todayCamp){
                                               String id = details['id'];
                                               String name = details['name'];
                                               String taluk = details['taluk'];
                                               String customer = details['customer'];
                                               String type = details['type'];
                                               int c = int.parse(customer);
                                               if(c>0){
                                                 todaysList.add(TodayasModule(id,name,taluk,customer,type));
                                               }
                                              // todaysList.add(TodayasModule(id,name,taluk,customer,type));

                                             }
                                             if(todaysList.isNotEmpty){
                                               tlist = true;
                                             }
                                             if(tlist) return ListView.builder(
                                                 scrollDirection: Axis.horizontal,
                                                 itemCount: todaysList.length,
                                                 shrinkWrap: true,
                                                 itemBuilder: (context,i){
                                                   return  Container(
                                                    // width: MediaQuery.of(context).size.width,
                                                     width: 350,
                                                     padding: EdgeInsets.only(right: 5,left: 5,top: 5),
                                                     margin: EdgeInsets.only(right: 8,bottom: 8),
                                                     decoration: BoxDecoration(
                                                         border: mainStyle.grayBorder,
                                                         borderRadius: BorderRadius.circular(10.0)
                                                     ),
                                                     child: Padding(
                                                       padding: const EdgeInsets.only(left: 12,right: 18),
                                                       child: Column(
                                                           mainAxisSize: MainAxisSize.min,
                                                           crossAxisAlignment: CrossAxisAlignment.start,
                                                           children: <Widget>[
                                                             Row(
                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                               children: [
                                                                 Row(
                                                                   children: [
                                                                     Icon(Icons.home,size: 20,),
                                                                     SizedBox(width: 4),
                                                                     Text(todaysList[i].pname.toString(),
                                                                         style: new TextStyle(fontSize: 18.0)),
                                                                   ],
                                                                 ),
                                                                 Row(
                                                                   children: [
                                                                     Icon(Icons.people,size: 20,),
                                                                     SizedBox(width: 4),
                                                                     Text(todaysList[i].num.toString(),
                                                                         style: new TextStyle(fontSize: 18.0)),
                                                                   ],
                                                                 ),

                                                               ],
                                                             ),
                                                             SizedBox(height: 5),
                                                             Row(
                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                               children: [
                                                                 Row(
                                                                   children: [
                                                                     Icon(Icons.location_on,size: 20,),
                                                                     SizedBox(width: 4),
                                                                     Text(todaysList[i].taluk.toString(),
                                                                         style: new TextStyle(fontSize: 18.0)),
                                                                   ],
                                                                 ),
                                                                 Container(
                                                                   height: 25,
                                                                   child: RaisedButton(
                                                                     onPressed: (){
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Camp(todaysList[i].taluk,todaysList[i].pname,dateformat3,todaysList[i].type.toString(),dateformat2,todaysList[i].id.toString()))).then((value) {
                                                                        setState(() {

                                                                        });
                                                                      });
                                                                     },
                                                                     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                     color: Colors.blue,
                                                                     child: Text('START',style: TextStyle(fontSize: 12.0,color: Colors.white),),
                                                                   ),
                                                                 ),
                                                               ],
                                                             ),
                                                           ]),
                                                     ),
                                                   );
                                                 });
                                             if(!tlist)return  Padding(
                                               padding: const EdgeInsets.all(8.0),
                                               child: Text('No Camps Created Today..',style: mainStyle.text18),
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
                                           child: Text('Loading..',style: mainStyle.text18),
                                         );
                                       }
                                       ,);
                                   }
                                   return Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text('loading',style: TextStyle(fontSize: 20),),
                                   );
                                 },
                               )
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             GridView.count(
               primary: false,
               shrinkWrap: true,
               padding: const EdgeInsets.all(10),
               crossAxisSpacing: 10,
               mainAxisSpacing: 12,
               crossAxisCount: 3,
               children: <Widget>[
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> CampDialog()));
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
                         Image(image: AssetImage('images/camp.png'),height: 40,width: 20,),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: const Text("Camp",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
                         // color: Colors.teal[100],
                       ],
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>SurveyDialog()));
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
                         Image(image: AssetImage('images/survey1.png'),height: 40,width: 20,),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: const Text("Survey",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
                         // color: Colors.teal[100],
                       ],
                     ),
                   ),
                 ),
                 GestureDetector(
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
                         Icon(Icons.assignment_late ,size: 36,color: Colors.blueGrey,),
                         Padding(
                           padding: const EdgeInsets.only(right: 8,left: 8,bottom: 8),
                           child: const Text("Material",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
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
                         Image(image: AssetImage('images/month.png'),height: 40,width: 20,),
                         Padding(
                           padding: const EdgeInsets.only(right: 8,left: 8,bottom: 8),
                           child: const Text("Kit",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
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
                         Image(image: AssetImage('images/report.png'),height: 40,width: 20,),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: const Text("Reports",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
                         // color: Colors.teal[100],
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
    );
  }

 void SyncMethod(context,var body,String emailId,String camp){
    _showLoading();
     submitSync(body, emailId).then((value) {
     Navigator.pop(context);
     var responce = jsonDecode(value);
     if(responce['status'] == 200) {
       _showLoading();
       DatabaseHelper.instance.deleteCustomer(" ",camp).then((value){
         Navigator.pop(context);
         setState(() {
         });
         DatabaseHelper.instance.getPendingCount().then((value) {
           setState(() {

           });
           if(value.isNotEmpty){
             hdata = true;
           }else{
             hdata = false;
           }
           setState(() {

           });
         });
         setState(() {

         });
       });
     }
     if(responce['status'] == 422 ){
       _showLoading();
       var data = responce['data'];
       List dnum = [];
       String card;
       String id;
       String s;
       String st;
       for(var details in data){
         id = details['id'].toString();
         card = details['card'].toString();
         String status = details['status'].toString();
         dnum.add(id);
         s = dnum.join("','");
         st = '\'$s\'';
       }

      DatabaseHelper.instance.deleteCustomer(st,camp).then((value){
        Navigator.pop(context);
        setState(() {

        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCard(camp))).then((value) {
          DatabaseHelper.instance.getPendingCount().then((value) {
            if(value.isNotEmpty){
              hdata = true;
            }else{
              hdata = false;
            }
            setState(() {

            });
          });
        });
      });
     }
   });
 }

 Future<List<Map>> fetchOfflineDatabase() async {
   DatabaseHelper.instance.getPendingCount().then((value) {
   });
   return DatabaseHelper.instance.getPendingCount();
 }

}




Future<String> getStock(String ide) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(
      Uri.parse(API_URL + 'Athentication/user/'+ide));
  request.headers.set('Content-type', 'application/json');
  HttpClientResponse response = await request.close();
  httpClient.close();
  if (response.statusCode == 200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}


Future<String> submitSync(body,String emaill) async {
  var sdata = {
    "emp":emaill,
    "data":body
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'syncCustomer'));
  request.headers.set('Content-type', 'application/JSON');
  request.add(utf8.encode(jsonEncode(sdata)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}
