import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmpForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EmpFormState();
  }
}

class EmpFormState extends State<EmpForm>{
  final _loginForm = GlobalKey<FormState>();
  var nameHolder = TextEditingController();
  var mobHolder = TextEditingController();
  var emailHolder = TextEditingController();
  var passHolder = TextEditingController();
  var addressHolder = TextEditingController();
  String EName,EMob,EMail,EAddress,EPass;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add Employee',style: TextStyle(color:Colors.red)),
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: mainStyle.bgColor,
          height: MediaQuery.of(context).size.height,
          child: Wrap(
            children:[Container(
              color: Colors.white,
             // height: ,
              margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8,12,8,12),
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
                          hintText: 'Employee Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                         validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Employee Name is required';
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
                          if(value == null || value.isEmpty || value.length != 10) {
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
                      TextFormField(controller: addressHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Address',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.multiline,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Address is required';
                          }
                        },
                        onSaved: (value){
                           EAddress = value;
                        }
                        ,),
                      SizedBox(height: 10),
                      TextFormField(controller: passHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Password',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                        },
                        onSaved: (value){
                           EPass = value;
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
                          child: Text('SUBMIT',style: TextStyle(fontSize:18,color: Colors.white),),
                        ),
                      ),
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
      'mobile': EMob,
      'email': EMail,
      'address': EAddress,
      'password': EPass,
    };
    AddEmp(body).then((value) {
      var response = jsonDecode(value);
      if(response['status'] == 200){
        nameHolder.text = '';
        mobHolder.text = '';
        emailHolder.text = '';
        addressHolder.text = '';
        passHolder.text = '';
        Fluttertoast.showToast(
            msg: "Employee Saved",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);

      }
      if(response['status'] == 422){
        Fluttertoast.showToast(
            msg: "Error",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      }
      if(response['status'] == 208){
        Fluttertoast.showToast(
            msg: "Mobile number already exist",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      }
      setState(() {

      });
    });
  }

  Future<String> AddEmp(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'user'));
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