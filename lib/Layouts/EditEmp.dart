import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditEmp extends StatefulWidget{
  String cid,cname,cmobile,cmail,caddress;

  EditEmp(this.cid, this.cname, this.cmobile, this.cmail, this.caddress,);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return EditEmpState(cid,cname,cmobile,cmail,caddress);
  }
}

class EditEmpState extends State<EditEmp>{
  //constructor
  String cid,cname,cmobile,cmail,caddress,pass1,pass2;
  EditEmpState(this.cid, this.cname, this.cmobile, this.cmail, this.caddress);


  final _loginForm = GlobalKey<FormState>();
  final _passForm = GlobalKey<FormState>();
  var nameHolder = TextEditingController();
  var pass1Holder = TextEditingController();
  var pass2Holder = TextEditingController();
  var mobHolder = TextEditingController();
  var emailHolder = TextEditingController();
  var addressHolder = TextEditingController();
  String EName,EMob,EMail,EAddress,EPass;

  @override
  void initState() {
       nameHolder.text = cname;
       mobHolder.text = cmobile;
       emailHolder.text = cmail;
       addressHolder.text = caddress;
       setState(() {

       });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Employee',style: TextStyle(color:Colors.red)),
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: SingleChildScrollView(
        child: Container(
           color: mainStyle.bgColor,
         // height: MediaQuery.of(context).size.height,
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
                               if(value == null || value.isEmpty) {
                                 return 'Mail Id is required';
                               }
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
                 Container(
                   color: Colors.white,
                   margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                   child: Padding(
                     padding: const EdgeInsets.all(12.0),
                     child: Form(
                       key: _passForm,
                       child: Column(
                         children: [
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                 child: Text('Change Password',style: mainStyle.text14light),
                               ),
                               SizedBox(height: 8),
                               TextFormField(controller: pass1Holder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                 const Radius.circular(0.0),
                               ),
                                 borderSide: new BorderSide(
                                   color: Colors.black,
                                   width: 1.0,
                                 ),),
                                   hintText: 'Enter New Password',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                                 validator: (value){
                                   if(value == null || value.isEmpty) {
                                     return 'New Password is required';
                                   }
                                 },
                                 onSaved: (value){
                                   pass1 = value;
                                 }
                                 ,),
                               SizedBox(height: 10),
                               TextFormField(controller: pass2Holder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                 const Radius.circular(0.0),
                               ),
                                 borderSide: new BorderSide(
                                   color: Colors.black,
                                   width: 1.0,
                                 ),),
                                   hintText: 'Re-enter Password',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                                 validator: (value){
                                   if(value == null || value.isEmpty) {
                                     return 'Confirmation Password is required';
                                   }
                                 },
                                 onSaved: (value){
                                   pass2 = value;
                                 }
                                 ,),
                               SizedBox(height: 10),
                             ],
                           ),
                           SizedBox(height: 10),
                           Container(
                             height: 40,
                             width: 150,
                             child: RaisedButton(
                               onPressed: (){
                                 if(_passForm.currentState.validate()){
                                   _passForm.currentState.save();
                                  if(pass1 == pass2){
                                    Reset();
                                  }
                                  else{
                                   return Fluttertoast.showToast(
                                        msg: "Both password din't match",gravity: ToastGravity.CENTER,
                                        toastLength: Toast.LENGTH_SHORT);
                                  }
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
                 )
               ],
             )],
           ),
         ),
      ),
    );
  }

  void submitAdd(){
    var body = {
      'id' : cid,
      'prvMobile' : cmobile,
      'name' : EName,
      'mobile': EMob,
      'email': EMail,
      'address': EAddress,
    };
    print('Emp update $body');
    EmpUpdate(body).then((value) {
      var response = jsonDecode(value);
      print('emp edited value $response');
      if(response['status'] == 200){
        Navigator.pop(context);
        nameHolder.text = '';
        mobHolder.text = '';
        emailHolder.text = '';
        addressHolder.text = '';
        Fluttertoast.showToast(
            msg: "Employee Data Updated",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      //  Navigator.pop(context);

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

  void Reset(){
    var body = {
      'employeeId' : cid,
      'password' : pass2,
    };
    print('Emp reset pass $body');
    passwordReset(body).then((value) {
      var response = jsonDecode(value);
      print('emp change pass value $response');
      if(response['status'] == 200){
        Navigator.pop(context);
        pass1Holder.text = '';
        pass2Holder.text = '';

        Fluttertoast.showToast(
            msg: "Employee Data Updated",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
        //  Navigator.pop(context);

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

  Future<String> EmpUpdate(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(API_URL+'user'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
       print("Replay :"+reply);
       return reply;
    }
  }

  Future<String> passwordReset(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(API_URL+'userPassword'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', 'e10adc3949ba59abbe56e057f20f883e');
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