import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Functions/UserData.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CompleteOrder extends StatefulWidget{
  String orId;
  CompleteOrder(this.orId);
  @override
  State<StatefulWidget> createState() {
     return completeOrState(orId);
  }
}

class completeOrState extends State<CompleteOrder>{
  String oId,empid;
  completeOrState(this.oId);

  DateTime selectedDate = DateTime.now();
  String dateFormate,strDate;
  var _date = TextEditingController();
  final _loginForm = GlobalKey<FormState>();


  @override
  void initState() {

    getData("USERData").then((value) {
      var response = jsonDecode(value);
      print('saved data empppppppp $response');
      var data = response['userData'];
      empid = data['id'];
    });

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return  Form(
      key: _loginForm,
      child: Row(
        children: [
          Expanded(
            child: Container(
              // height: 220.0,
              padding: EdgeInsets.all(10.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,8,8,0),
                        child: Text("Order Id : $oId",style: TextStyle(fontSize: 16.0),),
                      ),
                      SizedBox(height: 15),
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
                              hintText: 'Select Date',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.datetime,
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
                      SizedBox(height: 15.0,),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton(
                              onPressed: (){
                                if(_loginForm.currentState.validate()){
                                  _loginForm.currentState.save();
                                  scheduleOrder();
                                }
                              },
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: Colors.green,
                              child: Text('Schedule',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                            ),
                            RaisedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: Colors.red,
                              child: Text('Cancel',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );;
  }

  void scheduleOrder(){
    var body = {
      'orderId' : oId,
      'status'  : "3",
      'date'    : dateFormate,
    };
    print(' String orId $body');
    scheduleMethod(body).then((value) {
      var response = jsonDecode(value);
      if(response['status']==200){
        var data = response['data'];
        Fluttertoast.showToast(
            msg: "Order Scheduled",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);
      }
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

  Future<String> scheduleMethod(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(API_URL+'order'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', empid);
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      print("Replay :"+reply);
      return reply;
    }
  }


}