import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future setData (String key,String val) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(key, val);
}

Future<String> getData(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  String val = pref.getString(key);
  return val;
}

Future<bool> checkData(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool status = pref.containsKey(key);
  return status;
}

Future removeData(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(key);
}

Future setCart(key,val) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();

  bool status = pref.containsKey("cart");
  if(status) {
    String cart = pref.getString("cart");
    cartMap = jsonDecode(cart);
  }
  cartMap[key] = val;
  String cartString = jsonEncode(cartMap);

  pref.setString("cart", cartString);

}

Future<int> cartQnt(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();
  int qnt = 0;
  bool status = pref.containsKey("cart");
  if(status) {
    String cart = pref.getString("cart");
    cartMap = jsonDecode(cart);
  }
  if(cartMap.containsKey(key)) {
    qnt = int.parse(cartMap[key]);
  }
  return qnt;
}

Future<bool> checkCart(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();

  bool status = pref.containsKey("cart");
  if(status) {
    String cart = pref.getString("cart");
    cartMap = jsonDecode(cart);
    bool cstatus = cartMap.containsKey(key);

    return cstatus;
  }

  return status;

}

Future<int> cartCount() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();
  int cc = 0;
  bool status = pref.containsKey("cart");
  if(status) {
    String cart = pref.getString("cart");
    cartMap = jsonDecode(cart);

    cc = cartMap.length;
  }

  return cc;

}

Future removeCart(key) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map cartMap = Map<String, dynamic>();

  bool status = pref.containsKey("cart");
  if(status) {
    String cart = pref.getString("cart");
    cartMap = jsonDecode(cart);
  }
  cartMap.remove(key);
  String cartString = jsonEncode(cartMap);
  pref.setString("cart", cartString);

}

Future clearCart() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove("cart");
}

Future<String> getCart() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  String cart = pref.getString("cart");

  return cart;
}
