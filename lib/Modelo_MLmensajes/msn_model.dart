
import 'dart:convert';

import '../Modelo_traspaso/modelo_traspaso.dart';
import 'package:http/http.dart' as http;

class ML_MSG {
  String? iD;
  String? pOSTDELIVEREDMESSAGE;
  String? dATECREATED;
  num? pRICE;
  String? tITLE;
  int? sOLD;
  String? iMAGEN;
  String? sTATUS;

  ML_MSG(
      {this.iD,
        this.pOSTDELIVEREDMESSAGE,
        this.dATECREATED,
        this.pRICE,
        this.tITLE,
        this.sOLD,
        this.iMAGEN,
        this.sTATUS});

  ML_MSG.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    pOSTDELIVEREDMESSAGE = json['POST_DELIVERED_MESSAGE'];
    dATECREATED = json['DATE_CREATED'];
    pRICE = json['PRICE'];
    tITLE = json['TITLE'];
    sOLD = json['SOLD'];
    iMAGEN = json['IMAGEN'];
    sTATUS = json['STATUS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['POST_DELIVERED_MESSAGE'] = this.pOSTDELIVEREDMESSAGE;
    data['DATE_CREATED'] = this.dATECREATED;
    data['PRICE'] = this.pRICE;
    data['TITLE'] = this.tITLE;
    data['SOLD'] = this.sOLD;
    data['IMAGEN'] = this.iMAGEN;
    data['STATUS'] = this.sTATUS;
    return data;
  }
}

class MSG_ML{
  Future MensajesML() async{
    var url = Uri.parse('http://45.56.74.34:6660/ML_MSG');
    var response = await http.get(url);
    List<ML_MSG> lista = <ML_MSG>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Json = json.decode(sJson);
      var Jsonv = Json["data"] as List;
      for (var noteJson in Jsonv) {
        lista.add(ML_MSG.fromJson(noteJson));
      }
      return lista;
    }else
      throw Exception('NO se pudo');
  }
  Add_msg(String id,String msg) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://45.56.74.34:8088/publicaciones_setdelivered_message'));
    request.body = json.encode({
      "id": "${id}",
      "message": "${msg}"
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
  }
}
