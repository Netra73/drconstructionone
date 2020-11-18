import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Functions/UserData.dart';
import 'file:///E:/FlutterProjects/dr_constructions/lib/Layouts/EmpSide/EmployeeDashboard.dart';
import 'package:flutter/material.dart';

import 'AdminDashboard.dart';
class Login extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login>{
  final _loginForm  = GlobalKey<FormState>();
  String username;
  String password;
  bool inValid = false;

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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        child: Stack(
          children: <Widget> [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/background.png'),fit: BoxFit.cover),
              ),
            ),

            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.png',width: 80,height: 80,),
                    ],
                  ),
                  SizedBox(height: 10),
                  if(inValid) Text("Login details are incorrect",style: TextStyle(fontSize: 14,color: Colors.red),),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _loginForm,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 15),
                            TextFormField(style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding:EdgeInsets.all(14),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),),labelText: 'Mobile Number',labelStyle: (TextStyle(color: Colors.grey)),
                                hintText: 'Mobile Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),cursorColor: Colors.black,keyboardType: TextInputType.number,
                              validator: (value){
                                if (value == null || value.isEmpty || value.length != 10) {
                                  return 'Valid Mobile Number is required';
                                }
                                return null;
                              },
                              onSaved: (value){
                                username = value;
                              },
                            ),
                            SizedBox(height: 25,),
                            TextFormField(style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding:EdgeInsets.all(14),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),),labelText: 'Password',labelStyle: (TextStyle(color: Colors.grey)),
                                hintText: 'Password',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),cursorColor: Colors.black,
                              obscureText: true,
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                              onSaved: (value){
                                password = value;
                              },
                            ),
                            SizedBox(height: 10,),
                            SizedBox(height: 30),
                            Container(
                              //alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 20,right: 20),
                              width: 150,
                              height: 50,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: (){
                                  if(_loginForm.currentState.validate()){
                                    _loginForm.currentState.save();
                                    _login(username,password);
                                  }
                                },
                                color: Colors.red,
                                child: (Text('Login',style: TextStyle(fontSize: 20.0,color: Colors.white,))),
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _forgotPass() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 250.0,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,10,10,0),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Text("Forgot Password",style: TextStyle(fontSize: 20.0),),
                            SizedBox(height: 35.0,),
                            TextFormField(style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding:EdgeInsets.all(14),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),),labelText: 'Email',labelStyle: (TextStyle(color: Colors.grey)),
                                hintText: 'Enter Email Id',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),cursorColor: Colors.black,
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                return null;
                              },
                              onSaved: (value){
                                username = value;
                              },
                            ),
                            SizedBox(height: 30.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  child: RaisedButton(
                                    onPressed: (){
                                    },
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    color: Colors.black,
                                    child: Text('OK',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: RaisedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    color: Colors.red,
                                    child: Text('Cancel',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value){
      if(value==null){
      }
    });
  }


  _login(name,pass){
    _showLoading();
    String a  =name;
    String b  =pass;
    var body =
    {
      'username': a,
      'password': b
    };
    UserLogin(body).then((value){
      Navigator.pop(context);
      var response = jsonDecode(value);
      if(response['status'] == 422){
        setState(() {
          inValid = true;
        });
      }
      if(response['status']==200) {
        setState(() {
          inValid = false;
          var data = response['data'];
          String loginType = data['loginType'];
          setData("USERData", jsonEncode(data)).then((value) {
            if(loginType == "Admin"){
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) =>
                      AdminDash()), (Route<dynamic> route) => false);

            }
            if(loginType == "Employee"){
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) =>
                      EmpDash()), (Route<dynamic> route) => false);
            }
          });
        });
      }});
  }


  Future<String> UserLogin(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'Athentication'));
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