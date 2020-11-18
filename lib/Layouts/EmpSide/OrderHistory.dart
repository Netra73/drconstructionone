import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Functions/UserData.dart';
import 'package:drconstructions/Layouts/EmpSide/placeOrderForm.dart';
import 'package:drconstructions/Modules/EmpSide/RecentEmpModule.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../DetailsPage.dart';

class OrderHistory extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return OrderHistotyState();
  }

}

class OrderHistotyState extends State<OrderHistory> {

  final DateTime now = DateTime.now();
  String empid,strStatus,strbtn;
  List<Color> _colors = [ //Get list of colors
    Colors.orangeAccent,
    Colors.blue,
    Colors.green,
  ];
  var status;

  @override
  void initState() {

    getData("USERData").then((value) {
      var response = jsonDecode(value);
      var data = response['userData'];
      empid = data['id'];

     });

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    List<RecentOrModule>recentList = [];
    // TODO: implement build
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: mainStyle.bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(15,8,8,8),
                child: Text('Order History',style: mainStyle.text16Rate),
              ),
              FutureBuilder(
                future: getorders(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    var response = jsonDecode(snapshot.data);
                    if(response['status']==200){
                      recentList.clear();
                      var data = response['data'];
                      print('employee details get $response');
                      for(var details in data){
                        if(details['product']!=null){
                          String id = details['id'];
                          var user = details['user'];
                          var status = details['status'];
                          String name = user['name'];
                          String mobile = user['mobile'];
                          var product = details['product'];
                          String pname = product['name'];
                          String pid = product['id'];
                          String quantity = details['quantity'];
                          var location = details['location'];
                          String site = location['site'];
                          String orderDate = details['orderDate'];
                          String dateFormate = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(orderDate));
                          String strbtn;
                          int colorchoose;
                          List<Color> _colors = [ //Get list of colors
                            Colors.orangeAccent,
                            Colors.blue,
                            Colors.green,
                          ];
                          if(status.toString() == "1"){
                            strbtn = "Order";
                            colorchoose = 0;

                          }
                          if(status.toString() == "2"){
                            strbtn = "Scheduled";
                            colorchoose = 1;
                          }
                          if(status.toString() == "3"){
                            strbtn = "Completed";
                            colorchoose = 2;
                          }

                          recentList.add(RecentOrModule(id,pname,quantity,site,dateFormate,strbtn,colorchoose,'1',name,mobile));
                        }

                      }
                      return Container(
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: recentList.length,
                            physics:  NeverScrollableScrollPhysics(),
                            itemBuilder: (context,i){
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsPage(recentList[i].pid)));
                                },
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Order ID : ${recentList[i].pid}',style: mainStyle.text16),
                                                Row(
                                                  children: [
                                                    Text(recentList[i].ordate,style: mainStyle.text14),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Product',style: mainStyle.text14light),
                                                    Text(recentList[i].pname,style: mainStyle.text14),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text('Qty',style: mainStyle.text14light),
                                                    Text(recentList[i].pqty,style: mainStyle.text14),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text('Total',style: mainStyle.text14light),
                                                    Text('₹${recentList[i].orTotal}',style: mainStyle.text14),
                                                  ],
                                                ),

                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text('Site',style: mainStyle.text14light),
                                            Text(recentList[i].site,style: mainStyle.text14),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: _colors[recentList[i].colorChange],
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0.0),
                                                bottomRight: Radius.circular(15.0),
                                                topLeft: Radius.circular(0.0),
                                                bottomLeft: Radius.circular(15.0))
                                        ),
                                        width: double.infinity,
                                        child:Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(recentList[i].status,style: mainStyle.text14,textAlign: TextAlign.center,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
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
                ,),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getorders() async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL+'order'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', empid);
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

}