import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
class infraction_map {
  String? id;
  String? dt;
  String? itemId;
  String? topic;
  String? reason;
  String? checked;

  infraction_map(
      {this.id, this.dt, this.itemId, this.topic, this.reason, this.checked});

  infraction_map.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dt = json['dt'];
    itemId = json['item_id'];
    topic = json['topic'];
    reason = json['reason'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dt'] = this.dt;
    data['item_id'] = this.itemId;
    data['topic'] = this.topic;
    data['reason'] = this.reason;
    data['checked'] = this.checked;
    return data;
  }
}

class get_infra {
  Future indice_req(String topic,String date) async{
    var url = Uri.parse('http://45.56.74.34:6660/infractions?topic=${topic}&date=${date}');
    var response = await http.get(url);
    List<infraction_map> infrac = <infraction_map>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        infrac.add(infraction_map.fromJson(noteJson));
      }
      return infrac;
    }else
      throw Exception('Error al generar la peticion');
  }
  checked_infractions(String id,String mlm,String dt,String topic,String user,String check_dt)async{
    var url =  Uri.parse('http://45.56.74.34:6660/infractions?topic=${topic}&mlm=${mlm}&dt=${dt}&user=${user}&id=${id}&checked_dt=${check_dt}');
   var response = await http.post(url);
    if (response.statusCode == 200) {
      String sJson =response.body.toString();
      var Json = json.decode(sJson);
      print(Json["message"]);
      toast_impro(Json["message"], true);
    }
    else {
      //throw Exception('Valio verga');
      String sJson =response.body.toString();
      var Json = json.decode(sJson);
      print(Json["message"]);
      toast_impro(Json["message"], false);
    }
  }
}

toast_impro(String text,bool goodrq){
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
            Icon(goodrq?Icons.check_circle:Icons.cancel_outlined,color: goodrq?Colors.green:Colors.red),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(text,style: TextStyle(color: Colors.black),),),
          ],
        ),
      ),
    ),
  );
}


class main_item {
  String? iD;
  String? tITLE;
  num? pRICE;
  int? dISP;
  String? sTATUS;
  String? dATECREATED;
  String? lASTUPDATED;
  num? hEALTH;
  String? lOGISTICTYPE;
  String? iMAGES;

  main_item(
      {this.iD,
        this.tITLE,
        this.pRICE,
        this.dISP,
        this.sTATUS,
        this.dATECREATED,
        this.lASTUPDATED,
        this.hEALTH,
        this.lOGISTICTYPE,
        this.iMAGES});

  main_item.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    tITLE = json['TITLE'];
    pRICE = json['PRICE'];
    dISP = json['DISP'];
    sTATUS = json['STATUS'];
    dATECREATED = json['DATE_CREATED'];
    lASTUPDATED = json['LAST_UPDATED'];
    hEALTH = json['HEALTH'];
    lOGISTICTYPE = json['LOGISTIC_TYPE'];
    iMAGES = json['IMAGES'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['TITLE'] = this.tITLE;
    data['PRICE'] = this.pRICE;
    data['DISP'] = this.dISP;
    data['STATUS'] = this.sTATUS;
    data['DATE_CREATED'] = this.dATECREATED;
    data['LAST_UPDATED'] = this.lASTUPDATED;
    data['HEALTH'] = this.hEALTH;
    data['LOGISTIC_TYPE'] = this.lOGISTICTYPE;
    data['IMAGES'] = this.iMAGES;
    return data;
  }
}

class variation_item {
  String? sKU;
  int? aVAILABLEQUANTITY;
  String? sTATUS;
  String? tHUMBNAIL;
  String? cODIGO;
  String? sTOCKCEDIS;

  variation_item(
      {this.sKU,
        this.aVAILABLEQUANTITY,
        this.sTATUS,
        this.tHUMBNAIL,
        this.cODIGO,
        this.sTOCKCEDIS});

  variation_item.fromJson(Map<String, dynamic> json) {
    sKU = json['SKU'];
    aVAILABLEQUANTITY = json['AVAILABLE_QUANTITY'];
    sTATUS = json['STATUS'];
    tHUMBNAIL = json['THUMBNAIL'];
    cODIGO = json['CODIGO'];
    sTOCKCEDIS = json['STOCK_CEDIS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SKU'] = this.sKU;
    data['AVAILABLE_QUANTITY'] = this.aVAILABLEQUANTITY;
    data['STATUS'] = this.sTATUS;
    data['THUMBNAIL'] = this.tHUMBNAIL;
    data['CODIGO'] = this.cODIGO;
    data['STOCK_CEDIS'] = this.sTOCKCEDIS;
    return data;
  }
}

class get_impro_data {
  Future infra_main(String id) async {
    var url = Uri.parse(
        'http://45.56.74.34:6660/infrac-atrb/${id}');
    var response = await http.get(url);
    List<main_item> item_p = <main_item>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json);
      var Jsonv = Json["main"] as List;
      for (var noteJson in Jsonv) {
       item_p.add(main_item.fromJson(noteJson));
      }
      return item_p;
    } else
      throw Exception('Error al generar la peticion');
  }
  Future infra_var(String id) async {
    var url = Uri.parse(
        'http://45.56.74.34:6660/infrac-atrb/${id}');
    var response = await http.get(url);
    List<variation_item> item_v = <variation_item>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json);
      var Jsonv = Json["variants"] as List;
      for (var noteJson in Jsonv) {
        item_v.add(variation_item.fromJson(noteJson));
      }
      return item_v;
    } else
      throw Exception('Error al generar la peticion');
  }
}

launchuURL(String id) async {
  String url = 'https://www.mercadolibre.com.mx/publicaciones/${id}/modificar';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

class MLMvtas {
  String? cODIGO;
  String? iD;
  String? tITULO;
  String? lOGISTICA;
  String? iMAGE;
  String? sTATUS;
  int? sTOCKCEDIS;
  num? uNITPRICE;
  num? sALEFEE;
  int? vENTAS;
  int? sUBLINEA2;
  num? cOSTOULTIMO;
  num? ventas_total;
  num? comision_total;
  num? costo_total;
  num? utilidad;

  MLMvtas(
      {this.cODIGO,
        this.iD,
        this.tITULO,
        this.lOGISTICA,
        this.iMAGE,
        this.sTATUS,
        this.sTOCKCEDIS,
        this.uNITPRICE,
        this.sALEFEE,
        this.vENTAS,
        this.sUBLINEA2,
        this.cOSTOULTIMO,
        this.ventas_total,
        this.comision_total,
        this.costo_total,
        this.utilidad});

  MLMvtas.fromJson(Map<String, dynamic> json) {
    cODIGO = json['CODIGO'];
    iD = json['ID'];
    tITULO = json['TITULO'];
    lOGISTICA = json['LOGISTICA'];
    iMAGE = json['IMAGE'];
    sTATUS = json['STATUS'];
    sTOCKCEDIS = json['STOCK_CEDIS'];
    uNITPRICE = json['UNIT_PRICE'];
    sALEFEE = json['SALE_FEE'];
    vENTAS = json['VENTAS'];
    sUBLINEA2 = json['SUBLINEA2'];
    cOSTOULTIMO = json['COSTO_ULTIMO'];
    ventas_total = json['VENTAS']*json['UNIT_PRICE'];
    comision_total = json['SALE_FEE']*json['VENTAS'];
    costo_total = json['VENTAS']*json['COSTO_ULTIMO'];
    utilidad = (json['VENTAS']*json['UNIT_PRICE'])-((json['SALE_FEE']*json['VENTAS'])+(json['VENTAS']*json['COSTO_ULTIMO']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO'] = this.cODIGO;
    data['ID'] = this.iD;
    data['TITULO'] = this.tITULO;
    data['LOGISTICA'] = this.lOGISTICA;
    data['IMAGE'] = this.iMAGE;
    data['STATUS'] = this.sTATUS;
    data['STOCK_CEDIS'] = this.sTOCKCEDIS;
    data['UNIT_PRICE'] = this.uNITPRICE;
    data['SALE_FEE'] = this.sALEFEE;
    data['VENTAS'] = this.vENTAS;
    data['SUBLINEA2'] = this.sUBLINEA2;
    data['COSTO_ULTIMO'] = this.cOSTOULTIMO;
    data['ventas_total']= this.ventas_total;
    data['comision_total']=this.comision_total;
    data['costo_total']=this.costo_total;
    data['utilidad']=this.utilidad;
    return data;
  }
}



class MLMvtasatrb {
  String? iD;
  int? vARIATIONID;
  String? tITLE;
  String? sKU;
  num? pRICE;
  int? aVAILABLEQUANTITY;
  String? dATECREATED;
  String? lASTUPDATED;
  num? hEALTH;
  String? lOGISTICTYPE;
  String? pICTUREURL;
  String? cODIGO;
  int? sTOCKCEDIS;
  int? vENTAS;

  MLMvtasatrb(
      {this.iD,
        this.vARIATIONID,
        this.tITLE,
        this.sKU,
        this.pRICE,
        this.aVAILABLEQUANTITY,
        this.dATECREATED,
        this.lASTUPDATED,
        this.hEALTH,
        this.lOGISTICTYPE,
        this.pICTUREURL,
        this.cODIGO,
        this.sTOCKCEDIS,
        this.vENTAS});

  MLMvtasatrb.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    vARIATIONID = json['VARIATION_ID'];
    tITLE = json['TITLE'];
    sKU = json['SKU'];
    pRICE = json['PRICE'];
    aVAILABLEQUANTITY = json['AVAILABLE_QUANTITY'];
    dATECREATED = json['DATE_CREATED'];
    lASTUPDATED = json['LAST_UPDATED'];
    hEALTH = json['HEALTH'];
    lOGISTICTYPE = json['LOGISTIC_TYPE'];
    pICTUREURL = json['PICTURE_URL'];
    cODIGO = json['CODIGO'];
    sTOCKCEDIS = json['STOCK_CEDIS'];
    vENTAS = json['VENTAS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['VARIATION_ID'] = this.vARIATIONID;
    data['TITLE'] = this.tITLE;
    data['SKU'] = this.sKU;
    data['PRICE'] = this.pRICE;
    data['AVAILABLE_QUANTITY'] = this.aVAILABLEQUANTITY;
    data['DATE_CREATED'] = this.dATECREATED;
    data['LAST_UPDATED'] = this.lASTUPDATED;
    data['HEALTH'] = this.hEALTH;
    data['LOGISTIC_TYPE'] = this.lOGISTICTYPE;
    data['PICTURE_URL'] = this.pICTUREURL;
    data['CODIGO'] = this.cODIGO;
    data['STOCK_CEDIS'] = this.sTOCKCEDIS;
    data['VENTAS'] = this.vENTAS;
    return data;
  }
}

class MLMvtasclass{
  Future getMLMlist(String initdt,String finadt) async {
    var url = Uri.parse(
        'http://45.56.74.34:6660/vtasbyMLM?initdt=${initdt}&finaldt=${finadt}');
    var response = await http.get(url);
    List<MLMvtas> item_vta = <MLMvtas>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json);
      var Jsonv = Json["data"] as List;
      toast_impro(Json["message"], true);
      for (var noteJson in Jsonv) {
        item_vta.add(MLMvtas.fromJson(noteJson));
      }
      return item_vta;
    } else {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      toast_impro(Json["message"], false);
    }

  }

  Future getMLMatrb(String id,String initdt,String finaldt) async {
    var url = Uri.parse(
        'http://45.56.74.34:6660/vtasbyMLMatrb/${id}?initdt=${initdt}&finaldt=${finaldt}');
    var response = await http.get(url);
    List<MLMvtasatrb> item_atrb = <MLMvtasatrb>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json);
      var Jsonv = Json["data"] as List;
      toast_impro(Json["message"], true);
      for (var noteJson in Jsonv) {
        item_atrb.add(MLMvtasatrb.fromJson(noteJson));
      }
      return item_atrb;
    } else {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      toast_impro(Json["message"], false);
    }
  }

}

class imp_items {
  String? iD;
  String? tITLE;
  num? pRICE;

  imp_items({this.iD, this.tITLE, this.pRICE});

  imp_items.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    tITLE = json['TITLE'];
    pRICE = json['PRICE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['TITLE'] = this.tITLE;
    data['PRICE'] = this.pRICE;
    return data;
  }
}

class items_improve_services{
  Future getMLMlist(String topic) async {
    var url = Uri.parse(
        'http://45.56.74.34:6660/${topic}');
    var response = await http.get(url);
    List<imp_items> list= <imp_items>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json);
      var Jsonv = Json["data"] as List;
      toast_impro(Json["message"], true);
      for (var noteJson in Jsonv) {
        list.add(imp_items.fromJson(noteJson));
      }
      return list;
    } else {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      toast_impro(Json["message"], false);
    }

  }
}


class ASIN_SALES {
  String? asin;
  String? item;
  String? sku;
  String? image;
  num? price;
  String? sTATUS;
  String? cHANNEL;
  num? cOSTOPUBLICACION;
  int? vTAS;
  num? cOMISION;
  num? sHIPPING;
  num? sHIPPINGFEE;
  int? stock;
  String? sublinea;

  ASIN_SALES(
      {this.asin,
        this.sublinea,
        this.item,
        this.sku,
        this.image,
        this.price,
        this.sTATUS,
        this.cHANNEL,
        this.cOSTOPUBLICACION,
        this.vTAS,
        this.cOMISION,
        this.sHIPPING,
        this.sHIPPINGFEE,
        this.stock});

  ASIN_SALES.fromJson(Map<String, dynamic> json) {
    asin = json['asin'];
    sublinea = json['SUBLINEA2_ID']==0?'Accesorio':'Refaccion';
    item = json['item'];
    sku = json['sku'];
    image = json['image'];
    price = json['price'];
    sTATUS = json['STATUS'];
    cHANNEL = json['CHANNEL'];
    cOSTOPUBLICACION = json['COSTO_PUBLICACION'];
    vTAS = json['VTAS'];
    cOMISION = json['COMISION'];
    sHIPPING = json['SHIPPING'];
    sHIPPINGFEE = json['SHIPPING_FEE'];
    stock = json['STOCK_CEDIS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['asin'] = this.asin;
    data['SUBLINEA2_ID']= this.sublinea;
    data['item'] = this.item;
    data['sku'] = this.sku;
    data['image'] = this.image;
    data['price'] = this.price;
    data['STATUS'] = this.sTATUS;
    data['CHANNEL'] = this.cHANNEL;
    data['COSTO_PUBLICACION'] = this.cOSTOPUBLICACION;
    data['VTAS'] = this.vTAS;
    data['COMISION'] = this.cOMISION;
    data['SHIPPING'] = this.sHIPPING;
    data['SHIPPING_FEE'] = this.sHIPPINGFEE;
    data['STOCK_CEDIS']=this.stock;
    return data;
  }
}


class vtas_byasin{
  Future getASINlist(String initdt,String finadt) async {
    var url = Uri.parse(
        'http://45.56.74.34:6660/vtasbyASIN?initdt=${initdt}&finaldt=${finadt}');
    var response = await http.get(url);
    List<ASIN_SALES> item_vta = <ASIN_SALES>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json);
      var Jsonv = Json["data"] as List;
      toast_impro(Json["message"], true);
      for (var noteJson in Jsonv) {
        item_vta.add(ASIN_SALES.fromJson(noteJson));
      }
      return item_vta;
    } else {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      toast_impro(Json["message"], false);
    }
  }
}

class skc_sales {
  String? cODIGO;
  String? sPU;
  String? sKC;
  String? sKU;
  String? nAME;
  int? qUANTITY;
  int? sTOCKCEDIS;
  int? vTAS;
  num? pRICE;
  num? iNCOME;
  num? cOMISION;
  num? cOSTOULTIMO;
  num? vtas_totales;
  num? comision_total;
  num? costo_total;
  String? sublinea;
  skc_sales(
      {this.cODIGO,
        this.sublinea,
        this.sPU,
        this.sKC,
        this.sKU,
        this.nAME,
        this.qUANTITY,
        this.sTOCKCEDIS,
        this.vTAS,
        this.pRICE,
        this.iNCOME,
        this.cOMISION,
        this.cOSTOULTIMO,
        //-----
        this.vtas_totales,
        this.comision_total,
        this.costo_total});

  skc_sales.fromJson(Map<String, dynamic> json) {
    cODIGO = json['CODIGO'];
    sublinea = json['SUBLINEA2_ID']==0?'Accesorio':'Refaccion';
    sPU = json['SPU'];
    sKC = json['SKC'];
    sKU = json['SKU'];
    nAME = json['NAME'];
    qUANTITY = json['QUANTITY'];
    sTOCKCEDIS = json['STOCK_CEDIS'];
    vTAS = json['VTAS'];
    pRICE = json['PRICE'];
    iNCOME = json['INCOME'];
    cOMISION = json['COMISION'];
    cOSTOULTIMO = json['COSTO_ULTIMO'];
    vtas_totales = json['PRICE']*json['VTAS'];
    comision_total = json['COMISION']*json['VTAS'];
    costo_total = json['COSTO_ULTIMO']*json['VTAS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO'] = this.cODIGO;
    data['SUBLINEA2_ID']= this.sublinea;
    data['SPU'] = this.sPU;
    data['SKC'] = this.sKC;
    data['SKU'] = this.sKU;
    data['NAME'] = this.nAME;
    data['QUANTITY'] = this.qUANTITY;
    data['STOCK_CEDIS'] = this.sTOCKCEDIS;
    data['VTAS'] = this.vTAS;
    data['PRICE'] = this.pRICE;
    data['INCOME'] = this.iNCOME;
    data['COMISION'] = this.cOMISION;
    data['COSTO_ULTIMO'] = this.cOSTOULTIMO;
    data['VTAS_TOTALES'] = this.vtas_totales;
    data['COMISION_TOTAL'] = this.comision_total;
    data['COSTO_TOTAL'] = this.costo_total;
    return data;
  }
}

class get_skcdata{
  Future getSKClist(String initdt,String finadt) async {
    var url = Uri.parse(
        'http://45.56.74.34:6660/vtasbySKC?initdt=${initdt}&finaldt=${finadt}');
    var response = await http.get(url);
    List<skc_sales> item_vta = <skc_sales>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json);
      var Jsonv = Json["data"] as List;
      toast_impro(Json["message"], true);
      for (var noteJson in Jsonv) {
        item_vta.add(skc_sales.fromJson(noteJson));
      }
      return item_vta;
    } else {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      toast_impro(Json["message"], false);
    }
  }
}