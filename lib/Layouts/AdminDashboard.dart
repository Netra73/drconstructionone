
import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Fragments/EmpListFragment.dart';
import 'package:drconstructions/Fragments/ProductFragmentList.dart';
import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Functions/UserData.dart';
import 'package:drconstructions/Layouts/DetailsPage.dart';
import 'package:drconstructions/Layouts/DetailsPageAdmin.dart';
import 'package:drconstructions/Layouts/MonthlyTurnOver.dart';
import 'package:drconstructions/Modules/EmpSide/RecentEmpModule.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'EmpSide/placeOrderForm.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'Login.dart';
import 'Settings.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class AdminDash extends StatefulWidget{
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Employee List", Icons.people),
    new DrawerItem("Product List", Icons.list),
    new DrawerItem("Monthly Turnover ", Icons.payment),
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("Logout", Icons.exit_to_app)
  ];
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return AdminDashState();
  }
}

class AdminDashState extends State<AdminDash>{
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FirstFragment();
      case 1:
        return new SecondFragment();
      case 2:
        return new ThirdFragment();
      case 3:
        return new MonthlyTurnOver();
      case 4:
        return new Settings();
      case 5:
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
                 child: Center(child: Text('DR CONSTRUCTIONS',style: TextStyle(fontSize: 20,color: Colors.red),)),
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
class FirstFragment extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FirstFragmentState();
  }

}

class FirstFragmentState extends State<FirstFragment> {
  List<Color> _colors = [ //Get list of colors
    Colors.orangeAccent,
    Colors.blue,
    Colors.green,
  ];
  String typeId = "1";
  String recentOrder = "Pending Orders";
  var Norder="0",Nscheduled="0",Ncompleted="0";
  List<RecentOrModule>recentList = [];


//  @override
//  void initState() {
//    getSettings().then((value) {
//      var response = jsonDecode(value);
//      print('settings response $response');
//      var data = response['data'];
//      var summary = data['summary'];
//       Norder = summary['order'];
//       Nscheduled = summary['scheduled'];
//       Ncompleted = summary['completed'];
//       setState(() {
//
//       });
//    });
//  }

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
                future: getSettings(),
                builder: (context,snap){
                  if(snap.hasData){
                    var response = jsonDecode(snap.data);
                    if(response['status']==200){
                      var data = response['data'];
                      var summary = data['summary'];
                      Norder = summary['order'];
                      Nscheduled = summary['scheduled'];
                      Ncompleted = summary['completed'];

                    }
                  }
                  return  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap :(){
                                typeId = "1";
                                recentOrder = "Pending Orders";
                                setState(() {

                                });
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2,color: Colors.orangeAccent),
                                  shape: BoxShape.circle,
                                  // You can use like this way or like the below line
                                  //borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(Norder.toString(),style: TextStyle(color: Colors.orangeAccent)),
                                  ],
                                ),

                              ),
                            ),
                            SizedBox(height: 15),
                            Text('Pending',style: mainStyle.text14)
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap :(){
                                typeId = "2";
                                recentOrder = "Scheduled Orders";
                                setState(() {

                                });
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2,color: Colors.blue),
                                  shape: BoxShape.circle,
                                  // You can use like this way or like the below line
                                  //borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(Nscheduled.toString(),style: TextStyle(color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text('Scheduled',style: mainStyle.text14)
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap :(){
                                typeId = "3";
                                recentOrder = "Completed Orders";
                                setState(() {

                                });
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2,color: Colors.green),
                                  shape: BoxShape.circle,
                                  // You can use like this way or like the below line
                                  //borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(Ncompleted.toString(),style: TextStyle(color: Colors.green)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text('Completed',style: mainStyle.text14)
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 5),
              FutureBuilder(
                future: getorders(typeId),
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
                          List<Color> _colors = [ //Get list of colors
                            Colors.orangeAccent,
                            Colors.blue,
                            Colors.green,
                          ];
                          if(status.toString() == "1"){
                            strbtn = "Pending";
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
                          recentList.add(RecentOrModule(id,pname,quantity,site,dateFormate,strbtn,colorchoose,orderTotal,name,mobile));
                        }
                      }
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,8,8,8),
                              child: Text(recentOrder,style: mainStyle.text16Rate),
                            ),
                            ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: recentList.length,
                                physics:  NeverScrollableScrollPhysics(),
                                itemBuilder: (context,i){
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsPageAdmin(recentList[i].pid))).then((value){
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
                                                SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 2),
                                                          child: Icon(Icons.person,size: 15),
                                                        ),
                                                        Text(recentList[i].empName,style: mainStyle.text14),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 2),
                                                          child: Icon(Icons.phone_android,size: 15,),
                                                        ),
                                                        Text(recentList[i].empMobile,style: mainStyle.text14),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(height: 5),
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
                                                        Text('Total Amount',style: mainStyle.text14light),
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

  Future<String> getorders(String type) async {
   // print('empididdddddddddddd $emp');
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL+'order/?type='+type));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', 'e10adc3949ba59abbe56e057f20f883e');
    // request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      print('placed print $reply');
      return reply;
    }
  }

  Future<String> getSettings() async {
    final response = await http.get(API_URL+'Athentication/settings');
    if(response.statusCode == 200){
      String reply = response.body;
      print(reply);
      return reply;
    }
  }

}
