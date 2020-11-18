import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Functions/UserData.dart';
import 'package:drconstructions/Layouts/EmpSide/EmployeeDashboard.dart';
import 'package:drconstructions/Layouts/EmpSide/ScheduleOrder.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class PlaceOrder extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlaceOrderState();
  }
}

class PlaceOrderState extends State<PlaceOrder>{
  final _loginForm = GlobalKey<FormState>();
  final _loginForm2= GlobalKey<FormState>();
  String selectedProduct='-Select Product-';
  int totalAmtCard = 0;
  var nameHolder = TextEditingController();
  var priceHolder = TextEditingController();
  var mobHolder = TextEditingController();
  var quantityHolder = TextEditingController();
  var totalAmtHolder = TextEditingController();
  var addressHolder = TextEditingController();
  var distanceHolder = TextEditingController();
  var payidHolder = TextEditingController();
  var paidAmtHolder = TextEditingController();
  var GstNumHolder = TextEditingController();
  var _date = TextEditingController();
  var freeLimit,extraCharge,ETotal,gstRate,pumpCharge;
  int amt = 0;
  int extraDistCharge = 0;
  int GstforCard = 0;
  int pumpforCard = 0;
  int totalAfDiCh = 0;
  int totalAmtCardd = 0;
  String paymentMode,radioPay,dateFormate,EName,EMob,EAddress,EAmt,Eqty,selectedrate="0",totalamt,selectedId="0",empid,Epayid,EpaidAmt,Edist,GstNo,strDate;

  bool checkedValue = false;
  bool checkSms = false;
  bool checkgst = false;
  bool checkPump = false;
  bool pressedT = false;
  bool _validate = false;

  var mapProduct = ['-Select Product-'];
  var campData = Map<String,Map<String,String>>();

  DateTime selectedDate = DateTime.now();

  bool loadList = false;

  _loadTaluk(dname){
    print('nameee $dname');
    print( campData.length);
    setState(() {
      var tdata = campData[dname];
      print('changed map $tdata');
       selectedrate = tdata['rate'];
       selectedId = tdata['id'];
      priceHolder.text = selectedrate;
    });

  }

  @override
  void initState() {
    setState(() {
      radioPay = "Cash";
      priceHolder.text = selectedrate;
      totalAmtHolder.text = "0";
      getProducts().then((value) {
        setState(() {
          var response = jsonDecode(value);
          var data = response['data'];
          print('place order product $response data $data');
          for(var detail in data){
            mapProduct.add(detail['name']);
            Map<String, String> idMap = {'rate': detail['rate'], 'id': detail['id'],};
            campData[detail['name']] = idMap;
            print('added data ${campData[detail['name']] = idMap}');
          }
          loadList = true;
        });

      });

      getSettings().then((value) {
          var response = jsonDecode(value);
          print('settings response $response');
          var data = response['data'];
          var settings = data['setting'];
          freeLimit = settings['freeLimit'];
          extraCharge = settings['extraCharge'];
          gstRate = settings['gstRate'];
          pumpCharge = settings['pumpCharge'];
          print('printGst $pumpCharge');
          setData("Settings", jsonEncode(data)).then((value) {

         });
      });

      getData("USERData").then((value) {
         var response = jsonDecode(value);
         print('saved emp data $response');
         var data = response['userData'];
          empid = data['id'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Place Order',style: TextStyle(color:Colors.red)),
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: SingleChildScrollView(
        child: loadList ? Container(
          color: mainStyle.bgColor,
        //  height: MediaQuery.of(context).size.height,
          child: Wrap(
              children:[
                Form(
                  key: _loginForm,
                  child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      // height: ,
                      margin: const EdgeInsets.fromLTRB(6, 15, 10, 6),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2,6,2,6),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.black,
                            width: 1.0,),borderRadius: new BorderRadius.circular(15.0),),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8,12,8,12),
                            child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150.0,
                                      child: DropdownButtonFormField<String>(
                                       // isExpanded: false,
                                      //  alignedDropdown: true,
                                        decoration: InputDecoration(contentPadding: EdgeInsets.all(0),
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
                                        value: selectedProduct,
                                        validator: (value) {
                                          if(value == '-Select Product-'){
                                            return 'Select Product';
                                          }
                                          return null;
                                        },
                                        iconSize: 30,
                                        elevation: 0,
                                        style: TextStyle(
                                            fontSize: 16.0, color: Colors.black
                                        ),
                                        onChanged: (newValue) {
                                            selectedProduct = newValue;
                                            _loadTaluk(newValue);
                                             quantityHolder.text = "";
                                             totalAmtHolder.text = "0";
                                             totalAmtCard = 0;
                                            print('new value $newValue');
                                            setState(() {
                                          });
                                        },
                                        items: mapProduct.map((quant) {
                                          return DropdownMenuItem(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0,right: 0),
                                              child: new Text(
                                                quant, style: TextStyle(fontSize: 15),),
                                            ),
                                            value: quant,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      child: TextFormField(controller: quantityHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                        const Radius.circular(0.0),
                                      ),
                                        borderSide: new BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),),
                                          hintText: 'Quantity',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                                        validator: (value){
                                          if(value == null || value.isEmpty) {
                                            return 'Quantity is required';
                                          }
                                        },
                                        onChanged: (value){
                                            if(value==null || value=="0" || value==0 || value==""){
                                              totalAmtCard = 0;
                                            }
                                            //original
                                            double b = double.parse(value);
                                            print('quantDistance holder $b');
                                            int c = int.parse(selectedrate);
                                            print('quantDistance holder rate $c');
                                            double a = b*c;
                                            print('quantDistance holder totalval $a');
                                            int cg = a.round();
                                            totalamt = cg.toString();
                                            print('quantDistance holder totalvalextra $totalamt');
                                            int etr = 0;


                                            String ad = distanceHolder.text;
                                            print('quantDistance holder $ad');
                                            if(ad != ""){
                                              int d1 = int.parse(ad);
                                              int z1 = int.parse(freeLimit);
                                              int a2 = (d1 - z1)as int;

                                              if(a2>0){
                                                etr = int.parse(extraCharge) * a2;
                                                print('receivedValue Dist3 $etr');
                                              }else{
                                                etr = 0;
                                              }
                                            }

                                            amt = int.parse(totalamt) + etr;
                                            totalAfDiCh = amt;

                                            //if gst box is checked
                                            if(checkgst){
                                              int gstAmt1 = amt * int.parse(gstRate);
                                              double gstAmt2 = gstAmt1 / 100;
                                              int Gst = gstAmt2.round();
                                              GstforCard = Gst;
                                              amt = amt+Gst;
                                              print('receivedValue Dist and gst $gstAmt2');
                                            }else{
                                              amt = amt+0;
                                              GstforCard = 0;
                                            }

                                            if(checkPump){
                                              int p1 = int.parse(pumpCharge);
                                              pumpforCard = p1;
                                              amt = amt+p1;
                                               print('receivedValue Dist and gst $p1');
                                            }else{
                                              amt = amt+0;
                                              pumpforCard = 0;
                                            }

                                            totalAmtCardd = amt;
                                            totalAmtHolder.text = amt.toString();
                                            totalAmtCard = amt;
                                            setState(() {

                                            });

                                        },
                                        onSaved: (value){
                                          Eqty = value;
                                        }
                                        ,),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:280,
                                      //width:double.infinity,
                                      child: TextFormField(controller: addressHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),errorText: _validate ? 'Address is required' : null,border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                        const Radius.circular(0.0),
                                      ),
                                        borderSide: new BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),),
                                          hintText: 'Full Address',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.multiline,
                                        validator: (value){
                                          if(value == null || value.isEmpty) {
                                            return 'Full Address is required';
                                          }
                                        },
                                        onSaved: (value){
                                          EAddress = value;
                                        }
                                        ,),
                                    ),
                                     GestureDetector(
                                       onTap: (){
                                        // addressHolder.text.isEmpty ? _validate = true  : _validate = false;
                                         if(addressHolder.text.isEmpty){
                                           setState(() {
                                              _validate = true;
                                           });
                                         }else{
                                           getDistance();
                                         }


//                                     if(addressHolder.text == "" || addressHolder.text == null){
//                                      // return "address is reqired";
//                                     }else{
//                                       return getDistance();
//                                     }
                                       },
                                       child: Container(
                                           child: Image.asset('assets/images/calculater.png',width: 40,height: 40,)),
                                     ),
                                  ],
                                ),
                                SizedBox(height: 10),
                               // SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 100,
                                      child:   TextFormField(controller: distanceHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(8),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                        const Radius.circular(0.0),
                                      ),
                                        borderSide: new BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),),
                                          hintText: 'Distance',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                                        validator: (value){
                                          if(value == null || value.isEmpty) {
                                            return 'Distance is required';
                                          }
                                        },onChanged: (value){
                                          print('receivedValue Dist $value');
                                          int d1 = int.parse(value);
                                          print('receivedValue Dist2 $d1');

                                          int z1 = int.parse(freeLimit);
                                          int a2 = (d1 - z1)as int;
                                          print('receivedValue Dist3 $a2');

                                          int etr = 0;
                                          if(a2>0){
                                            etr = int.parse(extraCharge) * a2;
                                            print('receivedValue Dist3 $etr');
                                          }else{
                                            etr = 0;
                                          }
                                          amt = int.parse(totalamt) + etr;
                                          totalAfDiCh = amt;
                                          extraDistCharge = etr;

                                          //if gst box is checked
                                          if(checkgst){
                                            int gstAmt1 = amt * int.parse(gstRate);
                                            double gstAmt2 = gstAmt1 / 100;
                                            int Gst = gstAmt2.round();
                                            GstforCard = Gst;
                                            amt = amt+Gst;
                                            print('receivedValue Dist and gst $gstAmt2');
                                          }else{
                                            amt = amt+0;
                                            GstforCard = 0;
                                          }

                                          if(checkPump){
                                            int p1 = int.parse(pumpCharge);
                                            pumpforCard = p1;
                                            amt = amt+p1;
                                            // print('receivedValue Dist and gst $gstAmt2');
                                          }else{
                                            amt = amt+0;
                                            pumpforCard = 0;
                                          }

                                          String dtotalamt = amt.toString();
                                          totalAmtCardd = amt;
                                          totalAmtHolder.text = dtotalamt;
                                          totalAmtCard = int.parse(dtotalamt);
                                          print('total amt card $totalAmtCard');

                                          setState(() {
                                          });

                                        },
                                        onSaved: (value){
                                          Edist = value;
                                        }
                                        ,),
                                    ),
                                    Container(
                                      width:100,
                                      child: ListTileTheme(
                                        contentPadding: EdgeInsets.zero,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text("GST"),
                                          activeColor: Colors.red,
                                          value: checkgst,
                                          onChanged: (newValue) {
                                            checkgst = newValue;
                                            int etr = 0;

                                            String ad = distanceHolder.text;
                                            print('quantDistance holder $ad');
                                            if(ad != ""){
                                              int d1 = int.parse(ad);
                                              int z1 = int.parse(freeLimit);
                                              int a2 = (d1 - z1)as int;

                                              if(a2>0){
                                                etr = int.parse(extraCharge) * a2;
                                                print('receivedValue Dist3 $etr');
                                              }else{
                                                etr = 0;
                                              }
                                            }

                                            amt = int.parse(totalamt) + etr;
                                            totalAfDiCh = amt;

                                            //if gst box is checked
                                            if(checkgst){
                                              int gstAmt1 = amt * int.parse(gstRate);
                                              double gstAmt2 = gstAmt1 / 100;
                                              int Gst = gstAmt2.round();
                                              GstforCard = Gst;
                                              amt = amt+Gst;
                                              print('receivedValue Dist and gst $gstAmt2');
                                            }else{
                                              amt = amt+0;
                                              GstforCard = 0;
                                            }

                                            if(checkPump){
                                              int p1 = int.parse(pumpCharge);
                                              pumpforCard = p1;
                                              amt = amt+p1;
                                              // print('receivedValue Dist and gst $gstAmt2');
                                            }else{
                                              amt = amt+0;
                                              pumpforCard = 0;
                                            }

                                            totalAmtCardd = amt;
                                            totalAmtHolder.text = amt.toString();
                                            totalAmtCard = amt;
                                            setState(() {

                                            });

                                          },
                                          controlAffinity: ListTileControlAffinity.leading,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: ListTileTheme(
                                        contentPadding: EdgeInsets.zero,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text("Pump"),
                                          activeColor: Colors.red,
                                          value: checkPump,
                                          onChanged: (newValue) {
                                            checkPump = newValue;
                                            int etr = 0;

                                            String ad = distanceHolder.text;
                                            print('quantDistance holder $ad');
                                            if(ad != ""){
                                              int d1 = int.parse(ad);
                                              int z1 = int.parse(freeLimit);
                                              int a2 = (d1 - z1)as int;

                                              if(a2>0){
                                                etr = int.parse(extraCharge) * a2;
                                                print('receivedValue Dist3 $etr');
                                              }else{
                                                etr = 0;
                                              }
                                            }

                                            amt = int.parse(totalamt) + etr;
                                            totalAfDiCh = amt;

                                            //if gst box is checked
                                            if(checkgst){
                                              int gstAmt1 = amt * int.parse(gstRate);
                                              double gstAmt2 = gstAmt1 / 100;
                                              int Gst = gstAmt2.round();
                                              GstforCard = Gst;
                                              amt = amt+Gst;
                                              print('receivedValue Dist and gst $gstAmt2');
                                            }else{
                                              amt = amt+0;
                                              GstforCard = 0;
                                            }

                                            if(checkPump){
                                              int p1 = int.parse(pumpCharge);
                                              pumpforCard = p1;
                                              amt = amt+p1;
                                             // print('receivedValue Dist and gst $gstAmt2');
                                            }else{
                                              amt = amt+0;
                                              pumpforCard = 0;
                                            }

                                            totalAmtCardd = amt;
                                            totalAmtHolder.text = amt.toString();
                                            totalAmtCard = amt;
                                            setState(() {

                                            });

                                          },
                                          controlAffinity: ListTileControlAffinity.leading,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),


                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if(totalAmtCard>0)Container(
                      color: Colors.white,
                      margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black,
                                width: 1.0,),borderRadius: new BorderRadius.circular(15.0),),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text('Unit Price',style: mainStyle.text14light),
                                              Text(priceHolder.text,style: mainStyle.text14),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text('Qty',style: mainStyle.text14light),
                                              Text(quantityHolder.text,style: mainStyle.text14),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text('Total',style: mainStyle.text14light),
                                              Text(totalamt,style: mainStyle.text14),
                                            ],
                                          )

                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:  MainAxisAlignment.end,
                                        children: [
                                          Text('',style: mainStyle.text14light),
                                          Text('Extra Mileage :     ',style: mainStyle.text14light),
                                          Text(extraDistCharge.toString(),style: mainStyle.text14),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:  MainAxisAlignment.end,
                                        children: [
                                          Text('',style: mainStyle.text14light),
                                          Text('After Adding :   ',style: mainStyle.text14light),
                                          Text(totalAfDiCh.toString(),style: mainStyle.text14),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:  MainAxisAlignment.end,
                                        children: [
                                          Text('',style: mainStyle.text14light),
                                          Text('Add GST :     ',style: mainStyle.text14light),
                                          Text(GstforCard.toString(),style: mainStyle.text14),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:  MainAxisAlignment.end,
                                        children: [
                                          Text('',style: mainStyle.text14light),
                                          Text('Pump Charge :     ',style: mainStyle.text14light),
                                          Text(pumpforCard.toString(),style: mainStyle.text14),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:  MainAxisAlignment.end,
                                        children: [
                                          Text('',style: mainStyle.text14light),
                                          Text('Total Amount :   ',style: mainStyle.text14light),
                                          Text(totalAmtCardd.toString(),style: mainStyle.text16),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],

                      ),

                    ),
                    if(totalAmtCard>0)Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10,top: 8,bottom: 0),
                          child: Text('Customer Details'),
                        ),
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.fromLTRB(8, 15, 8, 20),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4,12,4,12),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black,
                                width: 1.0,),borderRadius: new BorderRadius.circular(15.0),),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextFormField(controller: nameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(8),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
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
                                    TextFormField(controller: mobHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(8),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                      const Radius.circular(0.0),
                                    ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),),
                                        hintText: 'Mobile Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                                      validator: (value){
                                        if(value == null || value.isEmpty || value.length != 10) {
                                          return 'Valid Mobile Number is required';
                                        }
                                      },
                                      onSaved: (value){
                                        EMob = value;
                                      }
                                      ,),
                                    SizedBox(height: 10),
                                    if(checkgst)TextFormField(controller: GstNumHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                      const Radius.circular(0.0),
                                    ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),),
                                        hintText: 'GST Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.characters,
                                      validator: (value){
                                       return gstValidation(value, " Enter Valid GST Number");
                                      },
                                      onSaved: (value){
                                        GstNo = value;
                                      }
                                      ,),
//                                Container(
//                                  height: 30,
//                                  width: 150,
//                                  child: RaisedButton(
//                                    onPressed: (){
//                                      if(_loginForm2.currentState.validate()){
//                                        _loginForm2.currentState.save();
//                                         getDistance();
//                                      }
//                                    },
//                                    color: Colors.grey,
//                                    child: Text('Get Distance',style: TextStyle(fontSize:18,color: Colors.white),),
//                                  ),
//                                ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      contentPadding:EdgeInsets.only(left: 8,top: 0,bottom: 0),
                      title: Text("Payment"),
                      activeColor: Colors.red,
                      value: checkedValue,
                      onChanged: (newValue) {
                        setState(() {
                          checkedValue = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if(checkedValue)Container(
                      color: Colors.white,
                      margin: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: Padding(
                         padding: const EdgeInsets.fromLTRB(10,12,10,12),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.black,
                            width: 1.0,),borderRadius: new BorderRadius.circular(15.0),),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Select Payment Type',style: TextStyle(fontSize: 16.0,color: Colors.grey),),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 //mainAxisSize: MainAxisSize.min,
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
//                              RadioListTile(
//                                dense: true,
//                                groupValue: radioPay,
//                                title: Row(children: [Image.asset('assets/images/cash.png',width: 30,height: 30,)],),
//                                value: 'Cash',
//                                onChanged: (val){
//                                  setState(() {
//                                    radioPay = val;
//                                  });
//                                },
//                              ),
//                              Flexible(
//                                fit: FlexFit.loose,
//                                child: RadioListTile(
//                                  dense: true,
//                                  groupValue: radioPay,
//                                  title: Row(children: [Image.asset('assets/images/gpay.png',width: 30,height: 30,)],),
//                                  value: 'Google Pay',
//                                  onChanged: (val){
//                                    setState(() {
//                                      radioPay = val;
//                                    });
//                                  },
//                                ),
//                              ),
//                              Flexible(
//                                fit: FlexFit.loose,
//                                child: RadioListTile(
//                                  dense: true,
//                                  groupValue: radioPay,
//                                  title: Row(children: [Image.asset('assets/images/phonepay.png',width: 30,height: 30,)],),
//                                  value: 'Phone Pay',
//                                  onChanged: (val){
//                                    setState(() {
//                                      radioPay = val;
//                                    });
//                                  },
//                                ),
//                              ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                TextFormField(controller: payidHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                  const Radius.circular(0.0),
                                ),
                                  borderSide: new BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),),
                                    hintText: 'Transaction Ref. No.',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
//                              validator: (value){
//                                if(value == null || value.isEmpty) {
//                                  return 'Payment Id is required';
//                                }
//                              },
                                  onSaved: (value){
                                    Epayid = value;
                                  }
                                  ,),
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
                          ),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding:EdgeInsets.only(left: 8,top: 0,bottom: 0),
                      title: Text("Notify Customer With SMS ?"),
                      activeColor: Colors.red,
                      value: checkSms,
                      onChanged: (newValue) {
                        setState(() {
                          checkSms = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    Container(
                      height: 40,
                      width: 150,
                      child: RaisedButton(
                        onPressed: (){
                          if(_loginForm.currentState.validate()){
                            _loginForm.currentState.save();
                            submitOrder();
                          }
                        },
                        color: Colors.red,
                        child: Text('SUBMIT',style: TextStyle(fontSize:18,color: Colors.white),),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
              ),
                ),
              ]),
        ):SpinKitThreeBounce(
          color: Colors.amber,
          size: 20,
        )
      ),
    );
  }


  String gstValidation(String value,String error) {
    Pattern pattern = "[0-9]{2}[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9A-Za-z]{1}[Z]{1}[0-9a-zA-Z]{1}";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return error;
    else
      return null;
  }

  void submitOrder(){
    int gst = int.parse(gstRate);
    int subTotal = totalAfDiCh;
    int mul = (subTotal*gst);
    double tt =(mul/100);
    int totalgst = tt.round();
    print('totalGst $totalgst');

    int Odist = int.parse(Edist);
    int Ldist = int.parse(freeLimit);
    int dstexrat= (Odist - Ldist) as int;
    String DExtra;
    if(dstexrat>0){
      DExtra = dstexrat.toString();
    }else{
      DExtra = "0";
    }

    print('totalDistEtra $DExtra');

    if(!checkedValue){
      Epayid = "0";
      EpaidAmt = "0";
      strDate = "0";
    }
    String strSms;
    if(checkSms){
      strSms = "1";
    }else{
      strSms = "0";
    }
    String strPump;
    if(pumpforCard>0){
      strPump = "1";
    }else{
      strPump = "0";
    }

    int d1 = int.parse(DExtra);
    int d2 = int.parse(extraCharge);
    int d3 = (d1 * d2) as int ;
    String dtstRate = d3.toString();

    print('totaldtstRate $dtstRate');

    //dtTotal(d3)+
    int OT = (d3+totalgst+ subTotal) as int;

    print('gst OT $OT $subTotal');

    EAmt = priceHolder.text;
    ETotal = totalamt;
   // String dateFormate = DateFormat("dd-MM-yyyy").format(_date);

    var body = {
      'employeeId' : empid,
      'productId': selectedId,
      'productName': selectedProduct,
      'price': EAmt,
      'quantity': Eqty,
      'subTotal': ETotal,
      'totalGst': GstforCard,
      'distExtra': DExtra,
      'distRate': extraCharge,
      'distTotal': dtstRate,
      'orderTotal': totalAmtCardd,
      'paymentPaid': EpaidAmt,
      'name': EName,
      'mobile': EMob,
      'location': EAddress,
      'lat': "",
      'log': "",
      'distance': Edist,
      'gstNumber': GstNo,
      'status': "1",
      'schDate': "",
      'paymentMode': radioPay,
      'paymentId': Epayid,
      'paymentDate': dateFormate,
      'pump': strPump,
      'pumpCharge':pumpforCard,
      'sms':strSms,
    };

    print('place order body $body');
    placeOrder(body).then((value) {
      var response = jsonDecode(value);
      print('emp value $response');
      if(response['status'] == 200){
        selectedProduct='-Select Product-';
        priceHolder.text  = "0";
        quantityHolder.text = '';
        totalAmtHolder.text = '';
        nameHolder.text = '';
        mobHolder.text = '';
        addressHolder.text = '';
        distanceHolder.text = '';
        GstNumHolder.text = '';
        payidHolder.text = '';
        paidAmtHolder.text = '';
        _date.text = '';
        var data = response['data'];
        String id = data['id'];
        String status = data['status'];
        _successDialog(id,status);
//        Fluttertoast.showToast(
//            msg: "Order Placed",gravity: ToastGravity.CENTER,
//            toastLength: Toast.LENGTH_SHORT);
//        Navigator.pop(context);

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

  Future<String> placeOrder(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'order'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', empid);
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      print('placed print $reply');
      return reply;
    }
  }

  void getDistance(){
    var body = {
      'address':addressHolder.text,
    };
    getDistanceMethod(body).then((value) {
      var response = jsonDecode(value);
      if(response['status']==200){
        String str = response['distance'].toString();
        distanceHolder.text = str;
        Fluttertoast.showToast(
            msg: "Distance fetched",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);

        int d1 = int.parse(str);
        print('receivedValue Dist after calculation $d1');

        int z1 = int.parse(freeLimit);
        int a2 = (d1 - z1)as int;
        print('receivedValue Dist3 $a2');

        int etr = 0;
        if(a2>0){
          etr = int.parse(extraCharge) * a2;
          print('receivedValue Dist3 $etr');
        }else{
          etr = 0;
        }
        amt = int.parse(totalamt) + etr;
        totalAfDiCh = amt;
        extraDistCharge = etr;

        //if gst box is checked
        if(checkgst){
          int gstAmt1 = amt * int.parse(gstRate);
          double gstAmt2 = gstAmt1 / 100;
          int Gst = gstAmt2.round();
          GstforCard = Gst;
          amt = amt+Gst;
          print('receivedValue Dist and gst $gstAmt2');
        }else{
          amt = amt+0;
          GstforCard = 0;
        }

        if(checkPump){
          int p1 = int.parse(pumpCharge);
          pumpforCard = p1;
          amt = amt+p1;
          // print('receivedValue Dist and gst $gstAmt2');
        }else{
          amt = amt+0;
          pumpforCard = 0;
        }

        String dtotalamt = amt.toString();
        totalAmtCardd = amt;
        totalAmtHolder.text = dtotalamt;
        totalAmtCard = int.parse(dtotalamt);
        print('total amt card $totalAmtCard');

        setState(() {
        });

      }
      if(response['status'] == 422){
        Fluttertoast.showToast(
            msg: "Invalid Address",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      }
      setState(() {

      });
    });

  }

  Future<String> getDistanceMethod(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'distance'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      print('placed print $reply');
      return reply;
    }
  }


  Future<String> getProducts() async {
    final response = await http.get(API_URL+'product');
    if(response.statusCode == 200){
      String reply = response.body;
      print(reply);
      return reply;
    }
  }

  //to get distances and some details
  Future<String> getSettings() async {
    final response = await http.get(API_URL+'Athentication/settings');
    if(response.statusCode == 200){
      String reply = response.body;
      print(reply);
      return reply;
    }
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

  _successDialog(String id,String Status) {
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
                    height: 220.0,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Center(
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 50.0,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text("Order Placed",style: TextStyle(fontSize: 18.0),),
                            Text("Order Id : $id",style: TextStyle(fontSize: 16.0),),
                            SizedBox(height: 15.0,),
                            Padding(
                              padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RaisedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                      filterdialog(id, Status);
//                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//                                    ScheduleOrder(id,Status)), (Route<dynamic> route) => false);
                                    },
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    color: Colors.black,
                                    child: Text('Schedule',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                  ),
                                  RaisedButton(
                                    onPressed: (){
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    EmpDash()), (Route<dynamic> route) => false);
                                    },
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    color: Colors.red,
                                    child: Text('Close',style: TextStyle(fontSize: 18.0,color: Colors.white),),
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
          ),
        );
      },
    ).then((value){
      if(value==null){
//        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//            ProductList()), (Route<dynamic> route) => false);
      }
    });
  }


  filterdialog(String id,String status) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: ScheduleOrder2(id,status),
        );
      },
    ).then((value){
        var jdata = jsonDecode(value);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            EmpDash()), (Route<dynamic> route) => false);
          setState(() {

          });
    });
  }

}

class ScheduleOrder2 extends StatefulWidget{
  String orId,status;
  ScheduleOrder2(this.orId,this.status);

  @override
  State<StatefulWidget> createState() {

    return ScheduleState2(orId,status);
  }

}

class ScheduleState2 extends State<ScheduleOrder2>{
  String oId,empid,status;
  ScheduleState2(this.oId,this.status);

  DateTime selectedDate = DateTime.now();
  final format = DateFormat("dd-MM-yyyy HH:mm");
  String dateFormate,strDate,strDrive,strVehicle;
  var _date = TextEditingController();
  final _loginForm = GlobalKey<FormState>();
  var driveHolder = TextEditingController();
  var vehicleHolder = TextEditingController();


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
//                      GestureDetector(
//                        onTap: (){
//                          _selectDate(context);
//                        },
//                        child: AbsorbPointer(
//                          child: TextFormField(controller: _date,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
//                            const Radius.circular(0.0),
//                          ),
//                            borderSide: new BorderSide(
//                              color: Colors.black,
//                              width: 1.0,
//                            ),),
//                              hintText: 'Select Date',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.datetime,
//                            validator: (value){
//                              if(value == null || value.isEmpty) {
//                                return 'Date is required';
//                              }
//                            },
//                            onSaved: (value){
//                              strDate = value;
//                            }
//                            ,),
//                        ),
//                      ),
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
//                        TextFormField(controller: driveHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
//                          const Radius.circular(0.0),
//                        ),
//                          borderSide: new BorderSide(
//                            color: Colors.black,
//                            width: 1.0,
//                          ),),
//                            hintText: 'Driver Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
//                          validator: (value){
//                            if(value == null || value.isEmpty) {
//                              return 'Driver Name is required';
//                            }
//                          },
//                          onSaved: (value){
//                            strDrive = value;
//                          }
//                          ,),
//                        SizedBox(height: 10),
//                        TextFormField(controller: vehicleHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
//                          const Radius.circular(0.0),
//                        ),
//                          borderSide: new BorderSide(
//                            color: Colors.black,
//                            width: 1.0,
//                          ),),
//                            hintText: 'Vehicle Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.characters,
//                          validator: (value){
//                            if(value == null || value.isEmpty) {
//                              return 'Vehicle Number is required';
//                            }
//                          },
//                          onSaved: (value){
//                            strVehicle = value;
//                          }
//                          ,),
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
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    EmpDash()), (Route<dynamic> route) => false);
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
    String st;

    if(status == "1"){
      st = "2";
    }
    if(status == "2"){
      st = "3";
    }
    var body = {
      'orderId' : oId,
      'status'  : st,
      'date'    : dateFormate,
      'driverName' : "",
      'vehicle'    : "",
    };
    print(' String orId $body');
    scheduleMethod(body).then((value) {
      var response = jsonDecode(value);
      if(response['status']==200){
        var data = response['data'];
        var data1 = jsonEncode(data);
        Fluttertoast.showToast(
            msg: "Order Scheduled",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            EmpDash()), (Route<dynamic> route) => false);
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