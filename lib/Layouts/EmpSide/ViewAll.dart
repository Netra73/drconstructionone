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

class ViewAll extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViewAllState();
  }

}

class ViewAllState extends State<ViewAll> {

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
      print('saved data empppppppp $response');
      var data = response['userData'];
      empid = data['id'];

      print('idiniit $empid');

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('All Orders',style: TextStyle(color:Colors.red)),
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            color: mainStyle.bgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
//              Padding(
//                padding: const EdgeInsets.fromLTRB(12,15,12,0),
//                child: Text(formatted,style: mainStyle.text18,),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(10.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    Column(
//                      children: [
//                        Container(
//                          width: 90,
//                          height: 90,
//                          decoration: BoxDecoration(
//                            border: Border.all(width: 2,color: Colors.orangeAccent),
//                            shape: BoxShape.circle,
//                            // You can use like this way or like the below line
//                            //borderRadius: new BorderRadius.circular(30.0),
//                            color: Colors.white,
//                          ),
//                          child:Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Text('ABC',style: TextStyle(color: Colors.orangeAccent)),
//                            ],
//                          ),
//
//                        ),
//                        SizedBox(height: 15),
//                        Text('Target',style: mainStyle.text14)
//                      ],
//                    ),
//                    Column(
//                      children: [
//                        Container(
//                          width: 90,
//                          height: 90,
//                          decoration: BoxDecoration(
//                            border: Border.all(width: 2,color: Colors.blue),
//                            shape: BoxShape.circle,
//                            // You can use like this way or like the below line
//                            //borderRadius: new BorderRadius.circular(30.0),
//                            color: Colors.white,
//                          ),
//                          child:Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Text('90',style: TextStyle(color: Colors.blue)),
//                            ],
//                          ),
//                        ),
//                        SizedBox(height: 15),
//                        Text('Achieved',style: mainStyle.text14)
//                      ],
//                    ),
//                    Column(
//                      children: [
//                        Container(
//                          width: 90,
//                          height: 90,
//                          decoration: BoxDecoration(
//                            border: Border.all(width: 2,color: Colors.green),
//                            shape: BoxShape.circle,
//                            // You can use like this way or like the below line
//                            //borderRadius: new BorderRadius.circular(30.0),
//                            color: Colors.white,
//                          ),
//                          child:Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Text('ABC',style: TextStyle(color: Colors.green)),
//                            ],
//                          ),
//                        ),
//                        SizedBox(height: 15),
//                        Text('Pending',style: mainStyle.text14)
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//              Container(
//                width: double.infinity,
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: RaisedButton(
//                    color: Colors.orangeAccent,
//                    onPressed: (){
//                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaceOrder()));
//                    },
//                    child: Text('Place Order',style: TextStyle(color: Colors.white),),
//                  ),
//                ),
//              ),
                SizedBox(height: 5),
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(15,8,8,8),
//                  child: Text('Order History',style: mainStyle.text16Rate),
//                ),
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
                              strbtn = "Schduled";
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
                      child: Text('Loading',style: mainStyle.text18),
                    );
                  }
                  ,),
              ],
            ),
          ),
        ),
      ),
    );

  }

  Future<String> getorders() async {
    print('empididdddddddddddd $empid');
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL+'order'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', empid);
    // request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      print('placed print $reply');
      return reply;
    }
  }

}