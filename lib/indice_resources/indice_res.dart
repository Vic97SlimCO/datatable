import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class indices_model {
  String? iD;
  String? fecha;
  int? active;
  int? paused;
  int? activeFull;
  int? activeCross;
  int? pausedFull;
  int? pausedCross;
  int? vtasTotales;
  int? vtasTotalesAcc;
  int? vtasTotalesRef;
  int? vtasTotalesAccFull;
  int? vtasTotalesAccCross;
  int? vtasTotalesRefFull;
  int? vtasTotalesRefCross;
  int? vtasUnidades;
  int? vtasUnidadesAcc;
  int? vtasUnidadesRef;
  int? vtasUnidadesAccFull;
  int? vtasUnidadesAccCross;
  int? vtasUnidadesRefFull;
  int? vtasUnidadesRefCross;

  indices_model(
      {this.iD,
        this.fecha,
        this.active,
        this.paused,
        this.activeFull,
        this.activeCross,
        this.pausedFull,
        this.pausedCross,
        this.vtasTotales,
        this.vtasTotalesAcc,
        this.vtasTotalesRef,
        this.vtasTotalesAccFull,
        this.vtasTotalesAccCross,
        this.vtasTotalesRefFull,
        this.vtasTotalesRefCross,
        this.vtasUnidades,
        this.vtasUnidadesAcc,
        this.vtasUnidadesRef,
        this.vtasUnidadesAccFull,
        this.vtasUnidadesAccCross,
        this.vtasUnidadesRefFull,
        this.vtasUnidadesRefCross});

  indices_model.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    fecha = json['fecha'];
    active = json['active'];
    paused = json['paused'];
    activeFull = json['active_full'];
    activeCross = json['active_cross'];
    pausedFull = json['paused_full'];
    pausedCross = json['paused_cross'];
    vtasTotales = json['vtas_totales'];
    vtasTotalesAcc = json['vtas_totales_acc'];
    vtasTotalesRef = json['vtas_totales_ref'];
    vtasTotalesAccFull = json['vtas_totales_acc_full'];
    vtasTotalesAccCross = json['vtas_totales_acc_cross'];
    vtasTotalesRefFull = json['vtas_totales_ref_full'];
    vtasTotalesRefCross = json['vtas_totales_ref_cross'];
    vtasUnidades = json['vtas_unidades'];
    vtasUnidadesAcc = json['vtas_unidades_acc'];
    vtasUnidadesRef = json['vtas_unidades_ref'];
    vtasUnidadesAccFull = json['vtas_unidades_acc_full'];
    vtasUnidadesAccCross = json['vtas_unidades_acc_cross'];
    vtasUnidadesRefFull = json['vtas_unidades_ref_full'];
    vtasUnidadesRefCross = json['vtas_unidades_ref_cross'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['fecha'] = this.fecha;
    data['active'] = this.active;
    data['paused'] = this.paused;
    data['active_full'] = this.activeFull;
    data['active_cross'] = this.activeCross;
    data['paused_full'] = this.pausedFull;
    data['paused_cross'] = this.pausedCross;
    data['vtas_totales'] = this.vtasTotales;
    data['vtas_totales_acc'] = this.vtasTotalesAcc;
    data['vtas_totales_ref'] = this.vtasTotalesRef;
    data['vtas_totales_acc_full'] = this.vtasTotalesAccFull;
    data['vtas_totales_acc_cross'] = this.vtasTotalesAccCross;
    data['vtas_totales_ref_full'] = this.vtasTotalesRefFull;
    data['vtas_totales_ref_cross'] = this.vtasTotalesRefCross;
    data['vtas_unidades'] = this.vtasUnidades;
    data['vtas_unidades_acc'] = this.vtasUnidadesAcc;
    data['vtas_unidades_ref'] = this.vtasUnidadesRef;
    data['vtas_unidades_acc_full'] = this.vtasUnidadesAccFull;
    data['vtas_unidades_acc_cross'] = this.vtasUnidadesAccCross;
    data['vtas_unidades_ref_full'] = this.vtasUnidadesRefFull;
    data['vtas_unidades_ref_cross'] = this.vtasUnidadesRefCross;
    return data;
  }
}

class get_indices {
  Future indice_req(String init_dt,String final_dt) async{
    var url = Uri.parse('http://45.56.74.34:6660/indice?init_dt=${init_dt}&final_dt=${final_dt}');
    var response = await http.get(url);
    List<indices_model> indices = <indices_model>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        indices.add(indices_model.fromJson(noteJson));
      }
      return indices;
    }else
      throw Exception('Error al generar la peticion');
  }
}

class FLEX {
  String? cODIGO;
  String? tITLE;
  String? iD;
  String? sTATUS;
  String? fULL;
  String? fLEX;
  int? vENTASTOTALES;
  int? vENTASFLEX;
  int? vENTASCROSS;
  int? vENTASFULL;

  FLEX(
      {this.cODIGO,
        this.tITLE,
        this.iD,
        this.sTATUS,
        this.fULL,
        this.fLEX,
        this.vENTASTOTALES,
        this.vENTASFLEX,
        this.vENTASCROSS,
        this.vENTASFULL});

  FLEX.fromJson(Map<String, dynamic> json) {
    cODIGO = json['CODIGO'];
    tITLE = json['TITLE'];
    iD = json['ID'];
    sTATUS = json['STATUS'];
    fULL = json['FULL'];
    fLEX = json['FLEX'];
    vENTASTOTALES = json['VENTAS_TOTALES'];
    vENTASFLEX = json['VENTAS_FLEX'];
    vENTASCROSS = json['VENTAS_CROSS'];
    vENTASFULL = json['VENTAS_FULL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO'] = this.cODIGO;
    data['TITLE'] = this.tITLE;
    data['ID'] = this.iD;
    data['STATUS'] = this.sTATUS;
    data['FULL'] = this.fULL;
    data['FLEX'] = this.fLEX;
    data['VENTAS_TOTALES'] = this.vENTASTOTALES;
    data['VENTAS_FLEX'] = this.vENTASFLEX;
    data['VENTAS_CROSS'] = this.vENTASCROSS;
    data['VENTAS_FULL'] = this.vENTASFULL;
    return data;
  }
}

class FlexFull {
  Future getFlex(String initdt,String finaldt) async{
    var url = Uri.parse('http://45.56.74.34:6660/flex?entrydate=${initdt}&finaldate=${finaldt}&proveedor=*&tipo=*&subject=*&sublinea=*');
    var response = await http.get(url);
    List<FLEX> flexlst = <FLEX>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Json = json.decode(sJson);
      print(Json);
      var Jsonv = Json["data"] as List;
      for (var noteJson in Jsonv) {
        flexlst.add(FLEX.fromJson(noteJson));
      }
      return flexlst;
    }else
      throw Exception('Error al generar la peticion');
  }
}