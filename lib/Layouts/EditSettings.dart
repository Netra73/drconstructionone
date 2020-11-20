import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditSettings extends StatefulWidget{
  String aid,aname,amobile,amail,afreelimit,aextracharge,agstRate,apump;

  EditSettings(this.aid, this.aname, this.amobile, this.amail, this.afreelimit,
      this.aextracharge, this.agstRate, this.apump);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditSettingsState(aid,aname,amobile,amail,afreelimit,aextracharge,agstRate,apump);
  }
}

class EditSettingsState extends State<EditSettings>{
  //constructor
  String aid,aname,amobile,amail,afreelimit,aextracharge,agstRate,apump;
  EditSettingsState(this.aid, this.aname, this.amobile, this.amail, this.afreelimit,
      this.aextracharge, this.agstRate, this.apump);

  final _loginForm = GlobalKey<FormState>();
  final _passForm = GlobalKey<FormState>();
  var nameHolder = TextEditingController();
  var pass1Holder = TextEditingController();
  var pass2Holder = TextEditingController();
  var mobHolder = TextEditingController();
  var emailHolder = TextEditingController();
  var freelimitHolder = TextEditingController();
  var extraChrgHolder = TextEditingController();
  var GstRateHolder = TextEditingController();
  var PumpHolder = TextEditingController();
  String EName,EMob,EMail,Efreelimit,EextraChrg,EgstRate,Epump;

  @override
  void initState() {
    nameHolder.text = aname;
    mobHolder.text = amobile;
    emailHolder.text = amail;
    freelimitHolder.text = afreelimit;
    extraChrgHolder.text = aextracharge;
    GstRateHolder.text = agstRate;
    PumpHolder.text = apump;
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Settings',style: TextStyle(color:Colors.red)),
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: mainStyle.bgColor,
           height: MediaQuery.of(context).size.height,
          // margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
          child: Wrap(
            children: [Column(
              children: [
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8,12,8,15),
                    child: Form(
                      key: _loginForm,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextFormField(controller: nameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                            validator: (value){
                              if(value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                            },
                            onSaved: (value){
                              EName = value;
                            }
                            ,),
                          SizedBox(height: 10),
                          TextFormField(controller: mobHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Mobile Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                            validator: (value){
                              if(value == null || value.isEmpty) {
                                return 'Mobile Number is required';
                              }
                            },
                            onSaved: (value){
                              EMob = value;
                            }
                            ,),
                          SizedBox(height: 10),
                          TextFormField(controller: emailHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Mail Id',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                            validator: (value){
                                return emailRequired(value, "Valid Mail Id is required");
                            },
                            onSaved: (value){
                              EMail = value;
                            }
                            ,),
                          SizedBox(height: 10),
                          TextFormField(controller: freelimitHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Free Limit',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                            validator: (value){
                              if(value == null || value.isEmpty) {
                                return 'Free Limit distance is required';
                              }
                            },
                            onSaved: (value){
                              Efreelimit = value;
                            }
                            ,),
                          SizedBox(height: 10),
                          TextFormField(controller: extraChrgHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Extra Charge',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                            validator: (value){
                              if(value == null || value.isEmpty) {
                                return 'Extra Charge required';
                              }
                            },
                            onSaved: (value){
                              EextraChrg = value;
                            }
                            ,),
                          SizedBox(height: 10),
                          TextFormField(controller: GstRateHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'GST Rate',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                            validator: (value){
                              if(value == null || value.isEmpty) {
                                return 'GST Rate is required';
                              }
                            },
                            onSaved: (value){
                              EgstRate = value;
                            }
                            ,),
                          SizedBox(height: 10),
                          TextFormField(controller: PumpHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Pump Charge',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                            validator: (value){
                              if(value == null || value.isEmpty) {
                                return 'Pump Charge is required';
                              }
                            },
                            onSaved: (value){
                              Epump = value;
                            }
                            ,),
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
                              child: Text('SAVE',style: TextStyle(fontSize:18,color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )],
          ),
        ),
      ),
    );
  }

  String validateEmail(String value,String error) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return error;
    else
      return null;
  }

  String emailRequired(String value,String error) {
    if (value == null || value.isEmpty) {
      return error;
    } else {
      return validateEmail(value,error);
    }
  }
  void submitAdd(){
    var body = {
      'name' : EName,
      'email' : EMail,
      'mobile' : EMob,
      'freeLimit': Efreelimit,
      'extraCharge': EextraChrg,
      'gstRate': EgstRate,
      'pumpCharge': Epump,
    };
    SettingsUpdate(body).then((value) {
      var response = jsonDecode(value);
      if(response['status'] == 200){
        Navigator.pop(context);
        nameHolder.text = '';
        mobHolder.text = '';
        emailHolder.text = '';
        freelimitHolder.text = '';
        extraChrgHolder.text = '';
        GstRateHolder.text = '';
        PumpHolder.text = '';
        Fluttertoast.showToast(
            msg: "Profile Updated",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      }
      if(response['status'] == 422){
        Fluttertoast.showToast(
            msg: "Error",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      }
      setState(() {

      });
    });
  }

  Future<String> SettingsUpdate(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(API_URL+'Athentication/profile'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', 'e10adc3949ba59abbe56e057f20f883e');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

}