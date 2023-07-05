import 'dart:convert';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

class main_promo{
  int? status;
  String? message;
  List<promo_list>? data;

  main_promo({required this.status,required this.message,required this.data});
  main_promo.fromJson(Map<String,dynamic> json){
        status=json['status'];
        message= json['message'];
        data= json['data'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toString()).toList();
    }
    return data;
  }
}


class promo_list {
  String iD;
  //String vARIATIONID;
  //String sKU;
  String tITLE;
  num pRICE;
  String lOGISTICTYPE;
  int aVAILABLEQUANTITY;
  int sTOCKCEDIS;
  String dATECREATED;
  String tHUMBNAIL;
  int fACTOR;
  int v30D;
  int age;
  num COSTO_ULTIMO;
  num ML_FEE;
  num shipping_cost;
  String pROMO;

  promo_list(
  {required this.iD,
    //required  this.vARIATIONID,
    //required   this.sKU,
    required   this.tITLE,
    required  this.pRICE,
    required   this.lOGISTICTYPE,
    required   this.aVAILABLEQUANTITY,
    required   this.sTOCKCEDIS,
    required   this.dATECREATED,
    required   this.tHUMBNAIL,
    required   this.fACTOR,
    required   this.v30D,
    required this.age,
    required this.ML_FEE,
    required this.COSTO_ULTIMO,
    required this.shipping_cost,
    required this.pROMO
  });

  factory promo_list.from(Map<String,dynamic>json){
    return promo_list(
    iD : json['ID'],
    tITLE : json['TITLE'],
    pRICE : json['PRICE'],
    lOGISTICTYPE : json['LOGISTIC_TYPE'],
    aVAILABLEQUANTITY : json['AVAILABLE_QUANTITY'],
    sTOCKCEDIS : json['STOCK_CEDIS'],
    dATECREATED : json['DATE_CREATED'],
    tHUMBNAIL : json['THUMBNAIL'],
    fACTOR : json['FACTOR'],
    v30D : json['V30D'],
    age: json['AGE'],
    COSTO_ULTIMO: json['COSTO_ULTIMO'],
    ML_FEE: json['ML_FEE'],
    pROMO: json['PROMO'],
    shipping_cost: json['FREE_SHIPPING_LIST_COST']
    );
  }
}

class promo_class {
  Future Promotion_Data(String searcher,String entry_dt,String final_dt,String sublinea,String ventas_init,String ventas_final,String tipo) async {
    var url = Uri.parse('http://45.56.74.34:6660/promotion/${searcher}?entry_date=${entry_dt}&final_date=${final_dt}&sublinea=${sublinea}&tipo=${tipo}');
    print(url);
    var response = await http.get(url);
    List<promo_list> promotion = <promo_list>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Json = json.decode(sJson);
      print(Json["message"]);
      Promo_toast(Json["message"]);
      var Jsonv = Json["data"] as List;
      for(var noteJson in Jsonv){
          promotion.add(promo_list.from(noteJson));
      }
      return promotion;
    }else
      throw Exception('NO se pudo');
    }
  }

class promoML {
  int? status;
  String? message;

  promoML({required this.status,required this.message});
  promoML.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['data'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.message;
    return data;
  }

}

class controlo_promo {
  Future ADD_PROMO(String id,num descuento,String entry_dt,String final_dt) async {
    var url = Uri.parse('http://45.56.74.34:6660/addpromo/${id}?descuento_min=${descuento}&init_dt=${entry_dt}&final_dt=${final_dt}');
    print(url);
    var response = await http.get(url);
    List<promoML> responsepromo = <promoML>[];
    if(response.statusCode ==200){
      String sJson ='['+response.body.toString()+']';
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        responsepromo.add(promoML.fromJson(noteJson));
      }
      return responsepromo;
    }else
      throw Exception('NO se pudo');
  }

  Future DELETE_PROMO(String id) async {
    var url = Uri.parse('http://45.56.74.34:6660/deletepromo/${id}');
    print(url);
    var response = await http.get(url);
    List<promoML> responsepromo = <promoML>[];
    if(response.statusCode ==200){
      String sJson ='['+response.body.toString()+']';
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        responsepromo.add(promoML.fromJson(noteJson));
      }
      return responsepromo;
    }else
      throw Exception('NO se pudo');
  }
}

Promo_toast(String text){
  BotToast.showCustomText(
    duration: Duration(seconds: 2),
    onlyOne: true,
    clickClose: true,
    crossPage: true,
    ignoreContentClick: false,
    backgroundColor: Color(0x00000000),
    backButtonBehavior: BackButtonBehavior.none,
    animationDuration: Duration(milliseconds: 350),
    animationReverseDuration: Duration(milliseconds: 350),
    toastBuilder: (_) => Align(
      alignment: Alignment(0,0),
      child: Card(
        //color: Colors.deepPurple,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check_circle,color: Colors.green),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(text),),
          ],
        ),
      ),
    ),
  );
}


