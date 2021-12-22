// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Functions/UserData.dart';
import 'package:drconstructions/Layouts/EmpSide/ScheduleOrder.dart';
import 'package:drconstructions/Modules/EmpSide/paymentList.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:drconstructions/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget{
  String Eid,status="0";
  DetailsPage(this.Eid);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailsPageState(Eid);
  }

}

class DetailsPageState extends State<DetailsPage>{
  String Eid="",ordate="",scdate="",cmdate="",pendingstatus="0",
      strStatus="",strbtn="",colorCng="",dateFormate="",empid="";
  DateTime selectedDate = DateTime.now();
  var data,product,location,payment,customer,entry,status;
  List<paymentList>payList = [];
  bool pay = false;
  bool btnVisiblity = false;
  bool paymentStatus = false;
  bool dateStatusSc = false;
  bool dateStatuscm = false;
  int colorchoose=0;
  int colorchoosebtn=0;

  //
  String radioPay="",Epayid="",EpaidAmt="",strDate="";
  var payidHolder = TextEditingController();
  var paidAmtHolder = TextEditingController();
  final _loginForm = GlobalKey<FormState>();

  var _date = TextEditingController();

  List<Color> _colors = [ //Get list of colors
    Colors.orangeAccent,
    Colors.blue,
    Colors.green,
  ];

  DetailsPageState(this.Eid);
  @override
  void initState() {
    // TODO: implement initState
    getorders();
    radioPay = "Cash";

    getData("USERData").then((value) {
      var response = jsonDecode(value);
      print('saved emp data $response');
      var data = response['userData'];
      empid = data['id'];
    });

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.white,
         title: Text('Order Details',style: TextStyle(color: Colors.red)),
         iconTheme: IconThemeData(color: Colors.red),
       ),
        body: SingleChildScrollView(
          child: Container(
            color: mainStyle.bgColor,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child:FutureBuilder(
                future: getorders(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    var response = jsonDecode(snapshot.data);
                    if(response['status'] == 200){
                      payList.clear();
                       data = response['data'];
                      String date = data['orderDate'];
                      String date2 = data['scheduleDate'];
                      String date3 = data['completedDate'];
                     if(date2==null || date2=="0000-00-00 00:00:00"){
                       dateStatusSc = false;
                     }else{
                       dateStatusSc = true;
                       scdate = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(date2));
                     }

                      if(date3==null || date2=="0000-00-00 00:00:00"){
                        dateStatuscm = false;
                      }else{
                        dateStatuscm = true;
                        cmdate = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(date3));
                      }
                       ordate = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(date));
                        product = data['product'];
                       location = data['location'];
                       payment = data['payment'];
                       entry = payment['entry'];
                       customer = data['customer'];
                       status = data['status'];

                       if(status.toString() == "1"){
                         strStatus = "Pending";
                         strbtn = "Schedule";
                         colorchoose = 0;
                         colorchoosebtn = 1;
                       }
                       if(status.toString() == "2"){
                         strStatus = "Scheduled";
                         strbtn = "Complete";
                         colorchoose = 1;
                         colorchoosebtn = 2;
                       }
                       if(status.toString() == "3"){
                         strStatus = "Completed";
                         btnVisiblity = true;
                         colorchoose = 2;
                       }

                       String totalPending = payment['totalPending'];
                       if(totalPending == "0" || totalPending == null){
                         pendingstatus = "Paid";
                         paymentStatus = false;
                       }else{
                         pendingstatus = "Pending : ₹$totalPending";
                         paymentStatus = true;
                       }
                       for(var det2 in entry){
                         String eid = det2['id'];
                         String orderId = det2['orderId'];
                         String amount = det2['amount'];
                         String mode = det2['mode'];
                         String paymentId = det2['paymentId'];
                         String date = det2['date'];
                         String paymentIdd;
                         if(amount != null && amount != "0"){
                           pay = true;
                           print('payyy $pay');
                         }else{
                         //  pay= false;
                         }
                         if(paymentId == "" || paymentId == null || paymentId.isEmpty){
                            paymentIdd = "NA";
                         }else{
                           paymentIdd = paymentId;
                         }
                         payList.add(paymentList(eid,amount,mode,paymentIdd,date,orderId));
                       }

                    }
                    return Column(
                     // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15,15,15,15,),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Order ID : ${data['id']}',style: mainStyle.text16),
                                        Text('Status : $strStatus',style: mainStyle.text14Bold,),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            //Icon(Icons.calendar_today,size: 15,),
                                            Text('Ordered     : $ordate',style: mainStyle.text14),
                                           if(dateStatusSc) Text('Scheduled  : $scdate',style: mainStyle.text14),
                                           if(dateStatuscm) Text('Completed : $cmdate',style: mainStyle.text14),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                side: BorderSide(color: Colors.red)
                                            ),
                                            onPressed: (){
                                              _launchURL(data['id']);
                                            },
                                            child: Text('Invoice',style: mainStyle.text16Rate,),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Product',style: mainStyle.text14light),
                                            Text(product['name'],style: mainStyle.text14),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Qty',style: mainStyle.text14light),
                                            Text(data['quantity'],style: mainStyle.text14)
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('Distance',style: mainStyle.text14light),
                                            Text('${location['distance']} Km',style: mainStyle.text14),
                                          ],
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10),
                                    Text('Site',style: mainStyle.text14light),
                                    Text(location['site'],style: mainStyle.text14),
                                  ],
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15,4,15,8),
                                  child: Table(
                                      columnWidths: {
                                        0: FlexColumnWidth(2.5),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(5),
                                      },
                                    children: [
                                      TableRow(
                                        children: [
                                          Text('Sub total',style: mainStyle.text14light),
                                          Text('  :  ',style: mainStyle.text14),
                                          Text('₹ ${data['subTotal']}',style: mainStyle.text14)
                                        ]
                                      ),
                                      TableRow(
                                          children: [
                                            Text('GST',style: mainStyle.text14light),
                                            Text('  :  ',style: mainStyle.text14),
                                            Text('₹ ${data['gst']}',style: mainStyle.text14)
                                          ]
                                      ),
                                      TableRow(
                                          children: [
                                            Text('Extra Mileage',style: mainStyle.text14light),
                                            Text('  :  ',style: mainStyle.text14),
                                            Text('₹ ${data['distanceTotal']}',style: mainStyle.text14)
                                          ]
                                      ),
                                      TableRow(
                                          children: [
                                            Text('Pump Charge',style: mainStyle.text14light),
                                            Text('  :  ',style: mainStyle.text14),
                                            Text('₹ ${data['pumpCharge']}',style: mainStyle.text14)
                                          ]
                                      ),
                                      TableRow(
                                          children: [
                                            Text('Order Total',style: mainStyle.text14light),
                                            Text('  :  ',style: mainStyle.text14),
                                            Text('₹ ${data['orderTotal']}',style: mainStyle.text16)
                                          ]
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8,2,8,8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if(!btnVisiblity) Container(
                                      alignment: Alignment.center,
                                      child: RaisedButton(
                                        color: _colors[colorchoosebtn],
                                        onPressed: (){
                                          filterdialog(data['id'],status.toString(),empid);
                                          setState(() {

                                          });
                                        },
                                        child: Text(strbtn,style: mainStyle.text16White,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8,bottom: 8,top: 8),
                                child: Text('Customer Details : ',style: mainStyle.text14light),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(12,0,12,8),
                                  child: Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(1.25),
                                      1: FlexColumnWidth(0.75),
                                      2: FlexColumnWidth(5.5),
                                    },
                                    children: [
                                      TableRow(
                                          children: [
                                            Text('Name',style: mainStyle.text14light),
                                            Text('  :  ',style: mainStyle.text14),
                                            Text(customer['name'],style: mainStyle.text14)
                                          ]
                                      ),
                                      TableRow(
                                          children: [
                                            Text('Mobile',style: mainStyle.text14light),
                                            Text('  :  ',style: mainStyle.text14),
                                            Text(customer['mobile'],style: mainStyle.text14)
                                          ]
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12,left: 8,right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Payment Details : ',style: mainStyle.text14light),
                                    Text(pendingstatus,style: mainStyle.text14Bold),
                                  ],
                                ),
                              ),
                              pay?Container(
                                child: ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: payList.length,
                                    itemBuilder: (context,i){
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${DateFormat("dd-MM-yyyy").format(DateTime.parse(payList[i].pdate))}',style: mainStyle.text14),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(payList[i].paymentId,style: mainStyle.text14),
                                                  Text(payList[i].mode,style: mainStyle.text14),
                                                  Text('₹${payList[i].amount}',style: mainStyle.text14),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),

                              ):Container(
                                child:  Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text('No Payment',style: TextStyle(color:mainStyle.textColorLight ),),
                                ),
                              ),
                              if(paymentStatus) Container(
                                alignment: Alignment.center,
                                child: RaisedButton(
                                  color: Colors.black,
                                  onPressed: (){
                                    _successDialog(data['id']);
                                    setState(() {

                                    });
                                  },
                                  child: Text("Make Payment",style: mainStyle.text16White,),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('loading..',style: TextStyle(fontSize: 20),),
                  );
                }
              )
            ),
          ),
        ),
     );
  }


  _successDialog(String id) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: Form(
                        key: _loginForm,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child:Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8,5,8,12),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10,0,10,10),
                                              child: Text('Select Payment Type',style: TextStyle(fontSize: 16.0,color: Colors.grey),),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Cash',
                                                      groupValue: radioPay,
                                                      onChanged: (val){
                                                        setState(() {
                                                          radioPay = val;
                                                        });
                                                      },
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    ),
                                                    Image.asset('assets/images/cash.png',width: 30,height: 30,),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Google Pay',
                                                      groupValue: radioPay,
                                                      onChanged: (val){
                                                        setState(() {
                                                          radioPay = val;
                                                        });
                                                      },
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    ),
                                                    Image.asset('assets/images/gpay.png',width: 30,height: 30,),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Phone Pay',
                                                      groupValue: radioPay,
                                                      onChanged: (val){
                                                        setState(() {
                                                          radioPay = val;
                                                        });
                                                      },
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    ),
                                                    Image.asset('assets/images/phonepay.png',width: 30,height: 30,),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            TextFormField(controller: payidHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                              const Radius.circular(0.0),
                                            ),
                                              borderSide: new BorderSide(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),),
                                                hintText: 'Transaction Ref. No.',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                                              onSaved: (value){
                                                Epayid = value;
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            TextFormField(controller: paidAmtHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                              const Radius.circular(0.0),
                                            ),
                                              borderSide: new BorderSide(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),),
                                                hintText: 'Amount',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                                              validator: (value){
                                                if(value == null || value.isEmpty) {
                                                  return 'Amount is required';
                                                }
                                              },
                                              onSaved: (value){
                                                EpaidAmt = value;
                                              }
                                              ,),
                                            SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: (){
                                                _selectDate(context);
                                              },
                                              child: AbsorbPointer(
                                                child: TextFormField(controller: _date,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                                  const Radius.circular(0.0),
                                                ),
                                                  borderSide: new BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),),
                                                    hintText: 'Date',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.datetime,
                                                  validator: (value){
                                                    if(value == null || value.isEmpty) {
                                                      return 'Date is required';
                                                    }
                                                  },
                                                  onSaved: (value){
                                                    strDate = value;
                                                  }
                                                  ,),
                                              ),
                                            ),
                                            SizedBox(height: 10),

                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: RaisedButton(
                                                onPressed: (){
                                                  if(_loginForm.currentState.validate()){
                                                    _loginForm.currentState.save();
                                                    var body = {
                                                      'orderId' : id,
                                                      'paymentPaid' : EpaidAmt,
                                                      'paymentMode' : radioPay,
                                                      'paymentId' : Epayid,
                                                      'paymentDate' : dateFormate,
                                                    };
                                                    paymentMethod(body).then((value) {
                                                          var response = jsonDecode(value);
                                                          print('paymentdddd $response');
                                                          if(response['status'] == 200){
                                                            payidHolder.text = "";
                                                            paidAmtHolder.text = "";
                                                            _date.text = "";
                                                           // var data = response['data'];
                                                            Fluttertoast.showToast(
                                                           msg: "Payment ID Added",gravity: ToastGravity.CENTER,
                                                            toastLength: Toast.LENGTH_LONG);
                                                            Navigator.pop(context);
                                                          }
                                                          setState(() {

                                                          });
                                                          if(response['status'] == 422){
                                                            Fluttertoast.showToast(
                                                                msg: "Error",gravity: ToastGravity.CENTER,
                                                                toastLength: Toast.LENGTH_LONG);
                                                          }
                                                          setState(() {

                                                          });
                                                    });
                                                  }
                                                },
                                                color: Colors.red,
                                                child: Text('SUBMIT',style: TextStyle(fontSize:18,color: Colors.white),),
                                              ),
                                            ),
                                            Container(
                                              child: RaisedButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                color: Colors.grey,
                                                child: Text('CANCEL',style: TextStyle(fontSize: 16.0,color: Colors.white),),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value){
      setState(() {

      });
      if(value==null){
      }
    });
  }




  Future<String> getorders() async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL+'order/'+Eid));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', 'e10adc3949ba59abbe56e057f20f883e');
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      print('changed1111111 $reply');
      return reply;
    }
  }

  filterdialog(String id,String status,String empId) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: ScheduleOrder(id,status,empId),
        );
      },
    ).then((value){
      setState(() {

      });
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateFormate = DateFormat("yyyy-MM-dd").format(picked);
        String  dateFormate2 = DateFormat("dd-MM-yyyy").format(picked);
        _date.value = TextEditingValue(text: dateFormate2.toString());
      });
  }

  Future<String> paymentMethod(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'payment'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', empid);
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }


  void deleteOrder(String id){
    //_showLoading();
    deleteP(id).then((value) {
      Navigator.pop(context);
      var response = jsonDecode(value);
      if(response['status'] == 200){
        // Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Order Cancelled",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);

      }
      if(response['status'] == 422){
        Fluttertoast.showToast(
            msg: "Error",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);
      }
      setState(() {

      });
    });
  }


  Future<String> deleteP(String type) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(API_URL+'order/'+type));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', 'e10adc3949ba59abbe56e057f20f883e');
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

}


_launchURL(id) async {
  var url = 'https://www.eneblur.com.au/drmix/invoice.php?oid='+id;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}




