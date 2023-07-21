import 'dart:convert';
import 'package:http/http.dart' as http;

class dev_model {
  String? cODIGOSLIM;
  String? dESCRIPCIONCORTA;
  String? pERMALINK;
  int? vARIATIONID;
  int? sHIPPINGQUANTITY;
  String? aREA;
  String? uNIDAD;
  String? fOLIO;
  String? iD;
  int? dIA;
  int? mES;
  int? aNI;
  String? fECHAHORA;
  String? fECHA;
  String? hORA;
  String? tRACKINGNUMBER;
  String? pUBLICACION;
  String? pAQUETERIA;
  String? pRODUCTO;
  String? dESCRIPCIONDELPRODUCTO;
  String? oBSERVACIONES;
  String? nICKNAME;
  String? nOMBRE;
  int? vENTA;
  String? rEVISO;
  String? sTATUS;
  String? oRDERDATECREATED;
  String? lLEGADADEVOLUCION;
  bool? pORREVISAR;
  int? uSERID;
  String? link_checked;
  String? exclusion_rembolso;
  String? notas;
  String? resolucion;
  String? reputation;
  String? money_rturn;
  dev_model(
      {this.cODIGOSLIM,
        this.dESCRIPCIONCORTA,
        this.pERMALINK,
        this.vARIATIONID,
        this.sHIPPINGQUANTITY,
        this.aREA,
        this.uNIDAD,
        this.fOLIO,
        this.iD,
        this.dIA,
        this.mES,
        this.aNI,
        this.fECHAHORA,
        this.fECHA,
        this.hORA,
        this.tRACKINGNUMBER,
        this.pUBLICACION,
        this.pAQUETERIA,
        this.pRODUCTO,
        this.dESCRIPCIONDELPRODUCTO,
        this.oBSERVACIONES,
        this.nICKNAME,
        this.nOMBRE,
        this.vENTA,
        this.rEVISO,
        this.sTATUS,
        this.oRDERDATECREATED,
        this.lLEGADADEVOLUCION,
        this.pORREVISAR,
        this.uSERID,
        this.link_checked,
        this.exclusion_rembolso,
        this.notas,
        this.resolucion,
        this.reputation,
        this.money_rturn});

  dev_model.fromJson(Map<String, dynamic> json) {
    cODIGOSLIM = json['CODIGO_SLIM'];
    dESCRIPCIONCORTA = json['DESCRIPCION_CORTA'];
    pERMALINK = json['PERMALINK'];
    vARIATIONID = json['VARIATION_ID'];
    sHIPPINGQUANTITY = json['SHIPPING_QUANTITY'];
    aREA = json['AREA'];
    uNIDAD = json['UNIDAD'];
    fOLIO = json['FOLIO'];
    iD = json['ID'];
    dIA = json['DIA'];
    mES = json['MES'];
    aNI = json['ANI'];
    fECHAHORA = json['FECHA_HORA'];
    fECHA = json['FECHA'];
    hORA = json['HORA'];
    tRACKINGNUMBER = json['TRACKING_NUMBER'];
    pUBLICACION = json['PUBLICACION'];
    pAQUETERIA = json['PAQUETERIA'];
    pRODUCTO = json['PRODUCTO'];
    dESCRIPCIONDELPRODUCTO = json['DESCRIPCION_DEL_PRODUCTO'];
    oBSERVACIONES = json['OBSERVACIONES'];
    nICKNAME = json['NICKNAME'];
    nOMBRE = json['NOMBRE'];
    vENTA = json['VENTA'];
    rEVISO = json['REVISO'];
    sTATUS = json['STATUS'];
    oRDERDATECREATED = json['ORDER_DATE_CREATED'];
    lLEGADADEVOLUCION = json['LLEGADA_DEVOLUCION'];
    pORREVISAR = json['POR_REVISAR'];
    uSERID = json['USER_ID'];
    link_checked = json['LINK_RECLAMO'];
    exclusion_rembolso = json['EXCLUSION_REEMBOLSO'];
    notas = json['NOTAS'];
    resolucion = json['RESOLUCION'];
    reputation = json['REPUTATION'];
    money_rturn = json['MONEY_RETURN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO_SLIM'] = this.cODIGOSLIM;
    data['DESCRIPCION_CORTA'] = this.dESCRIPCIONCORTA;
    data['PERMALINK'] = this.pERMALINK;
    data['VARIATION_ID'] = this.vARIATIONID;
    data['SHIPPING_QUANTITY'] = this.sHIPPINGQUANTITY;
    data['AREA'] = this.aREA;
    data['UNIDAD'] = this.uNIDAD;
    data['FOLIO'] = this.fOLIO;
    data['ID'] = this.iD;
    data['DIA'] = this.dIA;
    data['MES'] = this.mES;
    data['ANI'] = this.aNI;
    data['FECHA_HORA'] = this.fECHAHORA;
    data['FECHA'] = this.fECHA;
    data['HORA'] = this.hORA;
    data['TRACKING_NUMBER'] = this.tRACKINGNUMBER;
    data['PUBLICACION'] = this.pUBLICACION;
    data['PAQUETERIA'] = this.pAQUETERIA;
    data['PRODUCTO'] = this.pRODUCTO;
    data['DESCRIPCION_DEL_PRODUCTO'] = this.dESCRIPCIONDELPRODUCTO;
    data['OBSERVACIONES'] = this.oBSERVACIONES;
    data['NICKNAME'] = this.nICKNAME;
    data['NOMBRE'] = this.nOMBRE;
    data['VENTA'] = this.vENTA;
    data['REVISO'] = this.rEVISO;
    data['STATUS'] = this.sTATUS;
    data['ORDER_DATE_CREATED'] = this.oRDERDATECREATED;
    data['LLEGADA_DEVOLUCION'] = this.lLEGADADEVOLUCION;
    data['POR_REVISAR'] = this.pORREVISAR;
    data['USER_ID'] = this.uSERID;
    data['LINK_REVISADO'] = this.link_checked;
    data['EXCLUSION_REEMBOLSO']= this.exclusion_rembolso;
    data['NOTAS']=this.notas;
    data['RESOLUCION']=this.resolucion;
    data['REPUTATION'] = this.reputation;
    data['MONEY_RETURN']=this.money_rturn;
    return data;
  }
}


class dev_getter {
  Future dv_list(String fecha,int status,String user) async{
    var url = Uri.parse('http://45.56.74.34:5558/ml/devoluciones/list?fecha=${fecha}&status=${status}&user_id=${user}');
    print(Uri.parse('http://45.56.74.34:5558/ml/devoluciones/list?fecha=${fecha}&status=${status}&user_id=${user}'));
    var response = await http.get(url,headers: {'Content-type': 'application/json; charset=utf-8',});
    List<dev_model> lista = <dev_model>[];
    if(response.statusCode ==200){
      //String sJson =response.body.toString();
      String sJson =utf8.decode(response.bodyBytes);
      var Json = json.decode(sJson);
      var Jsonv = Json["data"] as List;
      print(Jsonv);
      for (var noteJson in Jsonv) {
        lista.add(dev_model.fromJson(noteJson));
      }
      return lista;
    }else
      throw Exception('NO se pudo');
  }
  ADD_link(String id,String order_id,String url,String exclusion,String notas) async {
    var request = http.Request('POST', Uri.parse('http://45.56.74.34:5558/ml/devoluciones/revisado?id=${id}&order=${order_id}&url=${url}&exclusion=${exclusion}&notas=${notas}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }

  }
}

