import 'dart:convert';
import 'package:http/http.dart' as http;

class DEV {
  String? iD;
  String? sTATUS;
  String? dATECREATED;
  String? tITLE;
  String? sHIPPING;
  String? pACKID;
  String? dATECLOSED;
  String? sKU;

  DEV(
      {this.iD,
        this.sTATUS,
        this.dATECREATED,
        this.tITLE,
        this.sHIPPING,
        this.pACKID,
        this.dATECLOSED,
        this.sKU});

 factory DEV.fromJson(Map<String, dynamic> json) {
    return DEV(
    iD: json['ID'],
    sTATUS: json['STATUS'],
    dATECREATED : json['DATE_CREATED'],
    tITLE : json['TITLE'],
    sHIPPING : json['SHIPPING'],
    pACKID : json['PACK_ID'],
    dATECLOSED : json['DATE_CLOSED'],
    sKU : json['SKU']
    );
  }
}

class dev_searcher {
  Future dv_searcher(String ID) async{
    var url = Uri.parse('http://45.56.74.34:6660/condensado/'+ID);
    var response = await http.get(url);
    List<DEV> devs = <DEV>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      //int count = sJson.toString().length;
      //String _sub = sJson.toString().substring(36, count-1);
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        devs.add(DEV.fromJson(noteJson));
      }
      return devs;
    }else
      throw Exception('NO se pudo');
  }
}