import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class setTarget extends StatefulWidget{
  String eid;
  setTarget(this.eid);

  @override
  State<StatefulWidget> createState() {
    return setTargetState(eid);
  }
}

class setTargetState extends State<setTarget>{
  String eid;
  setTargetState(this.eid);
  final _loginForm = GlobalKey<FormState>();
  var targetHolder = TextEditingController();
  String strTarget;
  String selectedYear = '-Select Year-';
  String selectedMonth = '-Select Month-';
  List<String>mapYear = ['-Select Year-','2020','2021','2022','2023','2024','2025'];
  List<String>mapMonth = ['-Select Month-,-Select Month-','01,January', '02,February', '03,March', '04,April','05,May','06,June','07,July','08,August','09,September','10,October','11,November','12,December'];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Set Target',style: TextStyle(color:Colors.red)),
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: mainStyle.bgColor,
          height: MediaQuery.of(context).size.height,
          child: Wrap(
              children:[Container(
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,12,8,12),
                  child: Form(
                    key: _loginForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(contentPadding: EdgeInsets.all(10),
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
                            setState(() {
                              selectedYear = newValue;
                            });
                          },
                          items: mapYear.map((quant) {
                            return DropdownMenuItem(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: new Text(
                                  quant, style: TextStyle(fontSize: 15),),
                              ),
                              value: quant,
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
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
                            setState(() {
                              selectedMonth = newValue;
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
                        SizedBox(height: 10),
                        TextFormField(controller: targetHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                          const Radius.circular(0.0),
                        ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),),
                            hintText: 'Target Amount',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                          validator: (value){
                            if(value == null || value.isEmpty) {
                              return 'Target Amount is required';
                            }
                          },
                          onSaved: (value){
                            strTarget = value;
                          }
                          ,),
                        SizedBox(height: 10),
                        SizedBox(height: 25),
                        Container(
                          height: 40,
                          width: 150,
                          child: RaisedButton(
                            onPressed: (){
                              if(_loginForm.currentState.validate()){
                                _loginForm.currentState.save();
                                submitAdd();
                              }
                            },
                            color: Colors.red,
                            child: Text('SUBMIT',style: TextStyle(fontSize:18,color: Colors.white),),
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              ),
              ]),
        ),
      ),
    );
  }

  void submitAdd(){
    var body = {
      'employeeId' : eid,
      'year': selectedYear,
      'month': selectedMonth,
      'target': strTarget,
    };
    addTarget(body).then((value) {
      var response = jsonDecode(value);
      print('emp value $response');
      if(response['status'] == 200){
        targetHolder.text = '';
        selectedYear = '-Select Year-';
        selectedMonth = '-Select Month-';

        Fluttertoast.showToast(
            msg: "Target saved successfully",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);

      }
      if(response['status'] == 422){
        Fluttertoast.showToast(
            msg: "Error",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      }
      setState(() {

      });
    });
  }

  Future<String> addTarget(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'target'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

}

