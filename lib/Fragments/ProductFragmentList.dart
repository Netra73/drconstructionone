
import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Modules/productModule.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ThirdFragment extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ThirdFragmentState();
  }

}

class ThirdFragmentState extends State<ThirdFragment> {
  List<productModule>productList = [];

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
    return Container(
      color: mainStyle.bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15,4,15,4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Product List',style: mainStyle.text16Rate),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.red)
                  ),
                  onPressed: (){
                    _addProductDialog(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add,color: Colors.red,),
                      Text('ADD',style: TextStyle(color: Colors.red),),
                    ],
                  ),
                )
              ],
            ),
          ),
          FutureBuilder(
          future: getProducts(),
      builder: (context,snapShot){
      if(snapShot.hasData){
      var response = jsonDecode(snapShot.data);
      productList.clear();
      if(response['status'] == 200){
      var data = response['data'];
      String crate;
      for(var details in data){
      String id = details['id'];
      String name = details['name'];
      String rate = details['rate'];
      String status = details['status'];
      if(rate==null){
        rate = "100";
      }
      productList.add(productModule(id,name,rate,status));
      }
      return Container(
        child: Expanded(
          child: Container(
            color: mainStyle.bgColor,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: productList.length,
                 primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context,i){
               return GestureDetector(
                 onTap: (){

                 },
                 child: Card(
                   elevation: 2,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0)),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     mainAxisSize: MainAxisSize.max,
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisSize: MainAxisSize.max,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(productList[i].name,style: mainStyle.text16),
                                 (productList[i].status.toString() == "1") ? Row(
                                   children: [
                                     GestureDetector(
                                       onTap: (){
                                         _EditDialog(productList[i].id,productList[i].name,productList[i].rate,context);
                                       },
                                       child: Padding(
                                         padding: const EdgeInsets.only(right: 12),
                                         child: Icon(Icons.edit,color: mainStyle.rateColor,),
                                       ),
                                     ),
                                     GestureDetector(
                                       onTap: (){
                                         _DeleteDialog(productList[i].id, context);
                                       },
                                       child: Padding(
                                         padding: const EdgeInsets.only(right: 12),
                                         child: Icon(Icons.delete,color: mainStyle.textColorLight),
                                       ),
                                     ),
                                   ],
                                 ):Text('Deleted'),
                               ],
                             ),
                             SizedBox(height: 5),
                             Text('Price : ₹${productList[i].rate}',style: mainStyle.text14),
                             SizedBox(height: 5),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
               );
            }),
          ),
        ),
      );
      }
      if(response['status']== 422){
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
      },
      ),
        ],
      ),
    );

  }

  _addProductDialog(context) {
    final _loginForm = GlobalKey<FormState>();
    var pNameHolder = TextEditingController();
    var pPriceHolder = TextEditingController();
    String name,rate;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Form(
          key: _loginForm,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                  //  height: 270.0,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            Text('Add Product',style: mainStyle.text16Bold,),
                            SizedBox(height: 15),
                            TextFormField(controller: pNameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                              const Radius.circular(0.0),
                            ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),),
                                hintText: 'Product Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                              validator: (value){
                                if(value == null || value.isEmpty) {
                                  return 'Product Name is required';
                                }
                              },
                              onSaved: (value){
                                 name = value;
                              }
                              ,),
                            SizedBox(height: 15.0,),
                            TextFormField(controller: pPriceHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                              const Radius.circular(0.0),
                            ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),),
                                hintText: 'Price',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                              validator: (value){
                                if(value == null || value.isEmpty) {
                                  return 'Price is required';
                                }
                              },
                              onSaved: (value){
                                 rate = value;
                              }
                              ,),
                            SizedBox(height: 15.0,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8,8,8,0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RaisedButton(
                                    onPressed: (){
                                      if(_loginForm.currentState.validate()){
                                        _loginForm.currentState.save();
                                        submitAdd(name, rate,context);
                                      }
                                    },
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    color: Colors.black,
                                    child: Text('OK',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                  ),
                                  RaisedButton(
                                    onPressed: (){
                                     Navigator.pop(context);
                                    },
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    color: Colors.red,
                                    child: Text('CANCEL',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),
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

    });
  }

  Future<String> getProducts() async {
    final response = await http.get(API_URL+'product');
    if(response.statusCode == 200){
      String reply = response.body;
      print(reply);
      return reply;
    }
  }

  void submitAdd(String name,String rate,context){
    var body = {
      'name' : name,
      'price': rate,
    };
    AddProduct(body).then((value) {
      var response = jsonDecode(value);
      if(response['status'] == 200){
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Product Added",gravity: ToastGravity.CENTER,
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

  //to add Product
  Future<String> AddProduct(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'product'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }


  _EditDialog(String id,String pname,String price,context) {
    final _loginForm = GlobalKey<FormState>();
    var pNameHolder = TextEditingController();
    var pPriceHolder = TextEditingController();
    pNameHolder.text = pname;
    pPriceHolder.text = price;
    String name,rate;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Form(
          key: _loginForm,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    //  height: 270.0,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            Text('Edit Product',style: mainStyle.text16Bold,),
                            SizedBox(height: 15),
                            TextFormField(controller: pNameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                              const Radius.circular(0.0),
                            ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),),
                                hintText: 'Product Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                              validator: (value){
                                if(value == null || value.isEmpty) {
                                  return 'Product Name is required';
                                }
                              },
                              onSaved: (value){
                                name = value;
                              }
                              ,),
                            SizedBox(height: 15.0,),
                            TextFormField(controller: pPriceHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                              const Radius.circular(0.0),
                            ),
                              borderSide: new BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),),
                                hintText: 'Price',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                              validator: (value){
                                if(value == null || value.isEmpty) {
                                  return 'Price is required';
                                }
                              },
                              onSaved: (value){
                                rate = value;
                              }
                              ,),
                            SizedBox(height: 15.0,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8,8,8,0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RaisedButton(
                                    onPressed: (){
                                      if(_loginForm.currentState.validate()){
                                        _loginForm.currentState.save();
                                        updateProduct(id,pname,name, rate, context);
                                      }
                                    },
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    color: Colors.red,
                                    child: Text('SAVE',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                  ),
                                  RaisedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    color: Colors.grey,
                                    child: Text('CANCEL',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),
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

    });
  }

  void updateProduct(String id,String prvname,String name,String rate,context){
    var body = {
      'id' : id,
      'prvName': prvname,
      'name': name,
      'price': rate,
    };
    productUpdate(body).then((value) {
      var response = jsonDecode(value);
      print('edited response $response');
      if(response['status'] == 200){
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Product Updated",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);

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

  Future<String> productUpdate(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(API_URL+'product'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }

  }

  _DeleteDialog(String id,context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  //  height: 270.0,
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Are you sure, you want to delete??',style: mainStyle.text18,textAlign: TextAlign.center,),
                          ),
                         // SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8,8,8,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  onPressed: (){
                                     deleteProduct(id);
                                  },
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  color: Colors.red,
                                  child: Text('YES',style: TextStyle(fontSize: 16.0,color: Colors.white),),
                                ),
                                RaisedButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  color: Colors.grey,
                                  child: Text('No',style: TextStyle(fontSize: 16.0,color: Colors.white),),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    ).then((value){

    });
  }

  void deleteProduct(String id){
      _showLoading();
      deleteP(id).then((value) {
        Navigator.pop(context);
        var response = jsonDecode(value);
        print('delete product response $response');
        if(response['status'] == 200){
         // Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Product Deleted",gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
          Navigator.pop(context);

        }
        if(response['status'] == 422){
          Fluttertoast.showToast(
              msg: "Error while deleting",gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
          Navigator.pop(context);
        }
        if(response['status'] == 423){
          Fluttertoast.showToast(
              msg: "Product is loacked",gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
          Navigator.pop(context);
        }
        setState(() {

        });
      });
  }

  Future<String> deleteP(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(API_URL+'product/'+body));
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