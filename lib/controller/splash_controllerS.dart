import 'dart:convert';


import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../data/model/response/social_media.dart';

class SplashControllerS extends GetxController implements GetxService {

  int _Index = 0;

  int get Index => _Index;
  List<Concat> concatFromJson(String str) => List<Concat>.from(json.decode(str).map((x) => Concat.fromJson(x)));

String concatToJson(List<Concat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  List<Concat> concat=[
    
  ];
  
  SplashControllerS();
  
  Future<List<Concat>>getDtat() async{
     _Index = 0;
    final response=await http.get(Uri.parse("https://talabi-ye.com/api/v1/contact-us"));
    var data=jsonDecode(response.body.toString());
    if(response.statusCode==200){
      for(Map<String,dynamic>index in data){
        concat.add(Concat.fromJson(index));

        


      }
      return concat;

     
    }

    else{
      return concat;
    }
  }





}

 


