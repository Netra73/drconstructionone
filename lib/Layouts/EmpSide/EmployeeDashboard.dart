
import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Fragments/EmpListFragment.dart';
import 'package:drconstructions/Fragments/ProductFragmentList.dart';
import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Functions/UserData.dart';
import 'package:drconstructions/Layouts/DetailsPage.dart';
import 'package:drconstructions/Layouts/EmpSide/placeOrderForm.dart';
import 'package:drconstructions/Modules/EmpSide/RecentEmpModule.dart';
import 'package:drconstructions/Modules/TargetList.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import '../EmpTargetList.dart';
import '../Login.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../TargetList.dart';
import 'OrderHistory.dart';
import 'ViewAll.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class EmpDash extends StatefulWidget{
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Order History", Icons.history),
    new DrawerItem("Logout", Icons.exit_to_app)
  ];
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EmpDashState();
  }
}


class EmpDashState extends State<EmpDash>{
  int _selectedDrawerIndex = 0;
  String empName="";
  String empMob="";


  @override
  void initState() {
    getData("USERData").then((value) {
      var response = jsonDecode(value);
      print('saved data empppppppp $response');
      var data = response['userData'];
      empName = data['name'];
      empMob = data['mobile'];
    });
    setState(() {

    });
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new EmpFrag1();
      case 1:
        return new OrderHistory();
      case 2:
        return _logout() ;

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  _logout(){
    removeData("USERData").then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>
              Login()), (Route<dynamic> route) => false);
    });
  }


  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title,style: mainStyle.text16,),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        //centerTitle: false,
        titleSpacing: 0.0,
        title:
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png',height: 30,width: 30,),
            Row(
              children: [
                Text('  D',style: TextStyle(color: Colors.red),),
                Text('R',style: TextStyle(color: Colors.black),),
                Text(' R',style: TextStyle(color: Colors.red),),
                Text('EADY',style: TextStyle(color: Colors.black),),
                Text(' M',style: TextStyle(color: Colors.red),),
                Text('IX',style: TextStyle(color: Colors.black),),
                Text(' C',style: TextStyle(color: Colors.red),),
                Text('ONCRETE',style: TextStyle(color: Colors.black),),
              ],
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            DrawerHeader(
              child: Row(
                children: [
                  Center(child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text('DR CONSTRUCTIONS',style: TextStyle(fontSize: 20,color: Colors.red),),
                      SizedBox(height: 5),
                      Text(empName,style:mainStyle.text16,),
                      SizedBox(height: 5),
                      Text(empMob,style:mainStyle.text16)
                    ],
                  )),
                ],
              ),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

}

//fragments
class EmpFrag1 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EmpFrag1State();
  }
}


class EmpFrag1State extends State<EmpFrag1> {

 // final DateTime now = DateTime.now();
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy');
  var formatter2 = new DateFormat('MM');
  String selectedYear ;
  String selectedMonth;
  String empid,strStatus,strbtn;
  List<Color> _colors = [ //Get list of colors
    Colors.orangeAccent,
    Colors.blue,
    Colors.green,
  ];
  String typeId = "1";
  String recentOrder = "Recent Orders";
  var Ntarget="0",NAchieved="0",NPending="0";
  var status;
  List<RecentOrModule>recentList = [];

  @override
  void initState() {
    selectedYear = formatter.format(now);
    selectedMonth = formatter2.format(now);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: mainStyle.bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             FutureBuilder(
               future: getData("USERData"),
               builder: (context,snap){
                 if(snap.hasData){
                   var response = jsonDecode(snap.data);
                   print('saved data empppppppp $response');
                    var data = response['userData'];
                    empid = data['id'];
                    return  FutureBuilder(
                      future: getTarget(selectedYear,selectedMonth),
                      builder: (context,snap){
                        if(snap.hasData){
                          var response = jsonDecode(snap.data);
                          if(response['status']==200){
                            var data = response['data'];
                            String totalTarget = data['totalTraget'].toString();
                            String totalAchived = data['totalAchived'].toString() ;
                            if(totalTarget==null){
                              Ntarget = "0";
                            }else{
                              Ntarget = totalTarget.toString();
                            }
                            if(totalAchived==null){
                              NAchieved = "0";
                            }else{
                              NAchieved = totalAchived.toString();
                            }

                            int a = int.parse(totalTarget);
                            print('aaaaaaaa $a');
                            int b = int.parse(totalAchived);
                            print('bbbbbbb $b');
                            int c = a-b;
                            if(c<0){
                              NPending = "0";
                            }else{
                              NPending = c.toString();
                            }
                            print('ccccccc $c');
                          }
//                          if(response['status']==422){
//                            return Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text('No Data',style: mainStyle.text18),
//                            );
//                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap :(){
                                          typeId = "1";
                                          //recentOrder = "Pending Orders";
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>EmpTargerListClass(empid)));
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2,color: Colors.orangeAccent),
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(Ntarget.toString(),style: TextStyle(color: Colors.orangeAccent)),
                                            ],
                                          ),

                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text('Target',style: mainStyle.text14)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap :(){
                                          typeId = "2";
                                          //  recentOrder = "Scheduled Orders";
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>EmpTargerListClass(empid)));
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2,color: Colors.blue),
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(NAchieved.toString(),style: TextStyle(color: Colors.blue)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text('Achieved',style: mainStyle.text14)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap :(){
                                          typeId = "3";
                                          // recentOrder = "Completed Orders";
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>EmpTargerListClass(empid)));
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2,color: Colors.green),
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(NPending.toString(),style: TextStyle(color: Colors.green)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text('Remaining',style: mainStyle.text14)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                 }
                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text('loading',style: TextStyle(fontSize: 20),),
                 );
               },
             ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.orangeAccent,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaceOrder()));
                    },
                    child: Text('Place Order',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
              SizedBox(height: 0),
              FutureBuilder(
                future: getorders(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    var response = jsonDecode(snapshot.data);
                    if(response['status']==200){
                      recentList.clear();
                      var data = response['data'];
                      print('employee details get $response');
                      int totalValues = 0;
                      for(var details in data){
                        totalValues++;
                        if(totalValues<=5){
                          if(details['product']!=null){
                            String id = details['id'];
                            var status = details['status'];
                            var user = details['user'];
                            var orderTotal = details['orderTotal'];
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
                            String times;
                            List<Color> _colors = [ //Get list of colors
                              Colors.orangeAccent,
                              Colors.blue,
                              Colors.green,
                            ];
                            if(status.toString() == "1"){
                              strbtn = "Pending";
                              times =  details['orderDate'];
                              dateFormate = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(times));
                              colorchoose = 0;
                            }
                            if(status.toString() == "2"){
                              strbtn = "Scheduled";
                              times =  details['scheduleDate'];
                              dateFormate = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(times));
                              colorchoose = 1;
                            }
                            if(status.toString() == "3"){
                              strbtn = "Completed";
                              times =  details['completeDate'];
                              dateFormate = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(times));
                              colorchoose = 2;
                            }
                            recentList.add(RecentOrModule(id,pname,quantity,site,dateFormate,strbtn,colorchoose,orderTotal,name,mobile));
                          }
                        }
                      }
                      return Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,0,8,8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(recentOrder,style: mainStyle.text16Rate),
                                  Container(
                                    //width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(2,0,2,0),
                                      child: RaisedButton(
                                        color: Colors.black,
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAll()));
                                        },
                                        child: Text('View All',style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ),
                                  //Text("View All",style: mainStyle.text16Rate),
                                ],
                              ),
                            ),
                            ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: recentList.length,
                                physics:  NeverScrollableScrollPhysics(),
                                itemBuilder: (context,i){
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsPage(recentList[i].pid))).then((value) {
                                        setState(() {

                                        });
                                      });
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
                    child: Text('Loading',style: mainStyle.text18),
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

  Future<String> getTarget(String year,String Month) async {
    final response = await http.get(API_URL+'target/'+empid+'?year='+year+'&month='+Month);
    if(response.statusCode == 200){
      String reply = response.body;
      return reply;
    }
  }

}
