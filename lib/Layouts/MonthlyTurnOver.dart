import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Modules/MonthlyModule.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyTurnOver extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MonthlyState();
  }
}

class MonthlyState extends State<MonthlyTurnOver>{
  String totalAchived,totalOrder;
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy');
  var formatter2 = new DateFormat('MM');
  String selectedYear;
  String selectedMonth;
  final _loginForm = GlobalKey<FormState>();
  List<String>mapYear = ['2020','2021','2022','2023','2024','2025'];
  List<String>mapMonth = ['01,January', '02,February', '03,March', '04,April','05,May','06,June','07,July','08,August','09,September','10,October','11,November','12,December'];

  @override
  void initState() {
    selectedYear = formatter.format(now);
    selectedMonth = formatter2.format(now);
  }

  @override
  Widget build(BuildContext context) {
    List<MonthlyModule>monthlyList = [];
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 140,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(contentPadding: EdgeInsets.all(6),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        )
                    ),
                    value: selectedYear,
                    validator: (value) {
                      if(value == '-Select Year-'){
                        return 'Select Year';
                      }
                      return null;
                    },
                    iconSize: 30,
                    elevation: 0,
                    style: TextStyle(
                        fontSize: 16.0, color: Colors.black
                    ),
                    onChanged: (newValue) {
                      selectedYear = newValue;
                      setState(() {
                      });
                    },
                    items: mapYear.map((quant) {
                      return DropdownMenuItem(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: new Text(
                            quant, style: TextStyle(fontSize: 15),),
                        ),
                        value: quant,
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: 160,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        )
                    ),
                    value: selectedMonth,
                    validator: (value) {
                      if(value == '-Select Month-'){
                        return 'Select Month';
                      }
                      return null;
                    },
                    iconSize: 30,
                    elevation: 0,
                    style: TextStyle(
                        fontSize: 16.0, color: Colors.black
                    ),
                    onChanged: (newValue) {
                      selectedMonth = newValue;
                      setState(() {

                      });
                    },
                    items: mapMonth.map((quant) {
                      var split2 =  quant.split(',');
                      return DropdownMenuItem(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: new Text(
                            split2[1], style: TextStyle(fontSize: 15),),
                        ),
                        value: split2[0],
                      );
                    }).toList(),
                  ),
                ),
              ],),
          ),
          FutureBuilder(
            future: getorders(selectedYear,selectedMonth),
            builder: (context,snapshot){
              if(snapshot.hasData){
                var response = jsonDecode(snapshot.data);
                if(response['status']==200){
                  monthlyList.clear();
                  var data = response['data'];
                  print('Monthly Turn Over $data');
                  String totalTarget = data['totalTraget'].toString();
                   totalAchived = data['totalAchived'].toString();
                   totalOrder = data['totalOrder'].toString();

                  var entry = data['entry'];
                  if(data['entry']!=null){
                    for(var details in entry){
                      String tid = details['id'];
                      String target = details['target'].toString();
                      String achived = details['achived'].toString();
                      String quantity = details['quantity'].toString();
                      String order = details['order'].toString();
                      String year = details['year'];
                      String month = details['month'];
                      var user = details['user'];
                      String uid = user['id'];
                      String name = user['name'];
                      String achived2;
                      String order2;
                      if(achived == "null"){
                        achived2 = "0";
                      }else{
                        achived2 = achived;
                      }

                      if(order == "null"){
                        order2 = "0";
                      }else{
                        order2 = order;
                      }
                      monthlyList.add(MonthlyModule(name,achived2,order2,quantity));
                    }
                  }
                  return Form(
                    key: _loginForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,10,35,0),
                          child: Text('Total Achieved : $totalAchived',style: mainStyle.text16Bold,),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,5,35,0),
                          child: Text('Total Orders : $totalOrder',style: mainStyle.text16Bold,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.black,
                              width: 1.0,),borderRadius: new BorderRadius.circular(0.0),),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Row(
                                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:120,
                                          child: Text('Name',style: mainStyle.text16Bold),
                                      ),
                                      Container(
                                        width:55,
                                          child: Text('Order',style: mainStyle.text16Bold)),
                                      Container(
                                          width:55,child: Text('Qty',style: mainStyle.text16Bold)),
                                      Container(
                                          width:100,child: Text('Achieved',style: mainStyle.text16Bold)),

                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  ListView.builder(
                                    // primary: false,
                                      shrinkWrap: true,
                                      itemCount: monthlyList.length,
                                      itemBuilder: (context,i){
                                        return Row(
                                          children: [
                                            Container(
                                                width:120,
                                                child: Text('${monthlyList[i].name}',style: mainStyle.text14)),
                                            Container(
                                               width:55,
                                                child: Text(monthlyList[i].orders,style: mainStyle.text14)),
                                            Container(
                                                width:55,
                                                child: Text(monthlyList[i].qty,style: mainStyle.text14)),
                                            Container(
                                                width:100,
                                                child: Text(monthlyList[i].achieved,style: mainStyle.text14)),
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
            },
          ),
        ],
      ),
    );
  }
}

Future<String> getorders(String year,String Month) async {
  print('yearmonthhhhh $year $Month');
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL+'target/all/?year='+year+'&month='+Month));
  request.headers.set('Content-type', 'application/json');
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    print('Target print $reply');
    return reply;
  }
}