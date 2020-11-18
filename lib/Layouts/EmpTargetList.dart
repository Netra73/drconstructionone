import 'dart:convert';
import 'dart:io';

import 'package:drconstructions/Functions/Config.dart';
import 'package:drconstructions/Layouts/setTarget.dart';
import 'package:drconstructions/Modules/TargetList.dart';
import 'package:drconstructions/Styles/textstyle.dart';
import 'package:flutter/material.dart';

class EmpTargerListClass extends StatefulWidget{
  String eid;

  EmpTargerListClass(this.eid);

  @override
  State<StatefulWidget> createState() {
    return EmpTargerListClassState(eid);
  }
}

class EmpTargerListClassState extends State<EmpTargerListClass>
{
  String eid;
  EmpTargerListClassState(this.eid);


  @override
  void initState() {
    // TODO: implement initState
    // getorders("1");
  }

  @override
  Widget build(BuildContext context) {
    List<TargetList>targetList = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Target List',style: TextStyle(color: Colors.red)),
        iconTheme: IconThemeData(color: Colors.red),
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder(
              future: getorders(eid),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  var response = jsonDecode(snapshot.data);
                  if(response['status']==200){
                    targetList.clear();
                    var data = response['data'];
                    print('targetlist $data');
                    String totalTarget = data['totalTraget'].toString();
                    String totalAchived = data['totalAchived'].toString();

                    var entry = data['entry'];
                    if(data['entry']!=null){
                      for(var details in entry){
                        String tid = details['id'];
                        String target = details['target'].toString();
                        String achived = details['achived'].toString();
                        String year = details['year'];
                        String month = details['month'];
                        String achived2;
                        String target2;
                        if(achived == "null"){
                          achived2 = "0";
                        }else{
                          achived2 = achived;
                        }

                        if(target == "null"){
                          target2 = "0";
                        }else{
                          target2 = target;
                        }
                        targetList.add(TargetList(tid,target2,achived2,year,month));

                      }
                      print('length  ${targetList.length}');
                    }
                    return Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25,0,25,25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Month',style: mainStyle.text16Bold),
                                    Text('Target',style: mainStyle.text16Bold),
                                    Text('Achieved',style: mainStyle.text16Bold),
                                  ],
                                ),
                                SizedBox(height: 8),
                                ListView.builder(
                                  // primary: false,
                                    shrinkWrap: true,
                                    itemCount: targetList.length,
                                    itemBuilder: (context,i){
                                      return Row(
                                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width:120,
                                              child: Text('${targetList[i].year}-${targetList[i].month}',style: mainStyle.text14)),
                                          Container(
                                              width:120,
                                              child: Text(targetList[i].target,style: mainStyle.text14)),
                                          Text(targetList[i].achieved,style: mainStyle.text14),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
//          Container(
//          child:  Padding(
//          padding: const EdgeInsets.all(15.0),
//          child: Text('No Payment',style: TextStyle(color:mainStyle.textColorLight ),),
//          ),
//          );
                  }
                  if(response['status']==422){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('No Data',style: mainStyle.text18),
                    );
                  }
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Loading',style: mainStyle.text18),
                );
              },
            ),
          ],
        ),
      ),


    );
  }

}

Future<String> getorders(empid) async {
  print('empididdddddddddddd $empid');
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(API_URL+'target/'+empid+'/'));
  request.headers.set('Content-type', 'application/json');
  // request.headers.set('Authorization', empid);
  // request.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    print('Target print $reply');
    return reply;
  }
}
