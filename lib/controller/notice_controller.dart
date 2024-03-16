import 'dart:convert';


import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:talabiapp/data/model/response/NoticeModel%20.dart';




class NoteModelControllerS extends GetxController{


  // int index = 0;

//   int get index => _index;
//   List<Concat> concatFromJson(String str) => List<Concat>.from(json.decode(str).map((x) => Concat.fromJson(x)));

// String concatToJson(List<Concat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String? imagename;

  List<NoteModel> listnote=[];
  bool loding = false;
  bool loadingImage =false;

  getMarqueeDtat() async{
    loding=true;
    update();
  var response  ;
    
     response = await http.get(Uri.parse("https://talabi-ye.com/api/v1/textmove"));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode==200){
     List responselist = data?? "";
      listnote.addAll(responselist.map((e) => NoteModel.fromJson(e)));
        print("========Respo==========");
        print(data) ;
        print("==================");

      }
      loding=false;
      update();

   
    }




    getImgeData() async{
    loadingImage = true;
    update();
  var response ;
    
     response = await http.get(Uri.parse("https://talabi-ye.com/api/v1/imagepopub"));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode==200){
     List responselist = data;

     imagename=data[0]["value"];
      // listnote.addAll(responselist.map((e) => NoteModel.fromJson(e)));
        print("=======images ===========");
        print(data) ;
        print("==================");

      }
      loadingImage = false;
      update();

   
    }
@override
  void onInit() {
    getMarqueeDtat();
    getImgeData();
    super.onInit();
  }
   
  }
