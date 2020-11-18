import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Functions/UserData.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class ScheduleOrder extends StatefulWidget{
  String orId,status,empId;
  ScheduleOrder(this.orId,this.status,this.empId);

  @override
  State<StatefulWidget> createState() {

   return ScheduleState(orId,status,empId);
  }

}

class ScheduleState extends State<ScheduleOrder>{
  String oId,empId,status,strbtn;
  ScheduleState(this.oId,this.status,this.empId);
  final format = DateFormat("dd-MM-yyyy HH:mm");

  DateTime selectedDate = DateTime.now();
  String dateFormate,strDate,strDrive,strVehicle;
  var _date = TextEditingController();
  var driveHolder = TextEditingController();
  var vehicleHolder = TextEditingController();
  final _loginForm = GlobalKey<FormState>();


  @override
  void initState() {
    if(status=="1"){
      strbtn = "Schedule";
    }
    if(status == "2"){
      strbtn = "Complete";
    }
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
                     SizedBox(height: 10),
                     DateTimeField(
                       decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                         const Radius.circular(0.0),
                       ),
                         borderSide: new BorderSide(
                           color: Colors.black,
                           width: 1.0,
                         ),),
                           hintText: 'Select Date',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                       format: format,
                       onShowPicker: (context, currentValue) async {
                         final date = await showDatePicker(
                             context: context,
                             firstDate: DateTime(1900),
                             initialDate: currentValue ?? DateTime.now(),
                             lastDate: DateTime(2100));
                         if (date != null) {
                           final time = await showTimePicker(
                             context: context,
                             initialTime:
                             TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                           );
                           dateFormate = DateFormat("yyyy-MM-dd HH:mm").format(DateTimeField.combine(date, time));
                           return DateTimeField.combine(date, time);

                         } else {
                           return currentValue;
                         }
                       },
                         validator: (value){
                           if(value == null ) {
                             return 'Date is required';
                           }
                         },

                     ),
                    SizedBox(height: 10),
                     SizedBox(height: 10),
                     SizedBox(height: 10.0,),
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
                             child: Text(strbtn,style: TextStyle(fontSize: 18.0,color: Colors.white),),
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

  void scheduleOrder(){
    _showLoading();
     String st;
     String drive;
     String vehicle;
    // dateFormate = DateFormat("yyyy-MM-dd").format(format);
     if(status == "1"){
       st = "2";
       drive = strDrive;
       vehicle = strVehicle;
     }
     if(status == "2"){
       st = "3";
       drive = "";
       vehicle = "";
     }
    var body = {
      'orderId' : oId,
      'status'  : st,
      'date'    : dateFormate,
      'driverName' : drive,
      'vehicle' : vehicle,
    };
    scheduleMethod(body).then((value) {
      Navigator.pop(context);
        var response = jsonDecode(value);
        if(response['status']==200){
          var data = response['data'];
          var data1 = jsonEncode(data);
          Fluttertoast.showToast(
              msg: "Order Scheduled",gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
          Navigator.pop(context);
        }
    });
  }

  Future<String> scheduleMethod(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(API_URL+'order'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', empId);
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }


}

