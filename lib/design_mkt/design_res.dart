
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pluto_grid/pluto_grid.dart';
class tareas_dsgn {
  int? id;
  String? topic;
  String? dateCreated;
  String? lastUpdated;
  String? codigoSlim;
  String? codDesc;
  String? canal;
  bool? checked;
  String? description;
  num? cOSTOULTIMO;
  String? pRECIOPUB;
  int? sTOCK;
  String? cREATEDBY;
  String? tipoPublicacion;
  String? pRIORITY;
  String? nOTAYS;
  String? aREACHECKED;
  String? aREACNAME;
  String? uSERDGN;
  String? statusDgn;
  String? wipDgn;
  String? notaDgn;
  String? uSERMKT;
  String? statusMkt;
  String? wipMkt;
  String? notaMkt;
  String? tipo;
  String? ML;
  String? AMZN;
  String? SHEIN;
  String? status_final;
  String? wip_final;
  String? precio_AMZN;
  String? precio_SHEIN;
  tareas_dsgn(
      {this.id,
        this.topic,
        this.dateCreated,
        this.lastUpdated,
        this.codigoSlim,
        this.codDesc,
        this.canal,
        this.checked,
        this.description,
        this.cOSTOULTIMO,
        this.pRECIOPUB,
        this.sTOCK,
        this.cREATEDBY,
        this.tipoPublicacion,
        this.pRIORITY,
        this.nOTAYS,
        this.aREACHECKED,
        this.aREACNAME,
        this.uSERDGN,
        this.statusDgn,
        this.wipDgn,
        this.notaDgn,
        this.uSERMKT,
        this.statusMkt,
        this.wipMkt,
        this.notaMkt,
        this.tipo,
        this.ML,
       this.AMZN,
        this.SHEIN,
        this.status_final,
        this.wip_final,
      this.precio_AMZN,
      this.precio_SHEIN});

  tareas_dsgn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topic = json['topic'];
    dateCreated = json['date_created'];
    lastUpdated = json['last_updated'];
    codigoSlim = json['codigo_slim'];
    codDesc = json['cod_desc'];
    canal = json['canal'];
    checked = json['checked'];
    description = json['description'];
    cOSTOULTIMO = json['COSTO_ULTIMO'];
    pRECIOPUB = json['PRECIO_PUB'];
    sTOCK = json['STOCK'];
    cREATEDBY = json['CREATED_BY'];
    tipoPublicacion = json['tipo_publicacion'];
    pRIORITY = json['PRIORITY'];
    nOTAYS = json['NOTAYS'];
    aREACHECKED = json['AREA_CHECKED'];
    aREACNAME = json['AREAC_NAME'];
    uSERDGN = json['USER_DGN'];
    statusDgn = json['status_dgn'];
    wipDgn = json['wip_dgn'];
    notaDgn = json['nota_dgn'];
    uSERMKT = json['USER_MKT'];
    statusMkt = json['status_mkt'];
    wipMkt = json['wip_mkt'];
    notaMkt = json['nota_mkt'];
    tipo = json['tipo'];
    ML = json['ML'];
    AMZN = json['AMZN'];
    SHEIN = json['SHEIN'];
    wip_final = json['wip_final'];
    status_final = json['status_final'];
    precio_AMZN = json['precioAMZN'];
    precio_SHEIN = json['precioSHEIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic'] = this.topic;
    data['date_created'] = this.dateCreated;
    data['last_updated'] = this.lastUpdated;
    data['codigo_slim'] = this.codigoSlim;
    data['cod_desc'] = this.codDesc;
    data['canal'] = this.canal;
    data['checked'] = this.checked;
    data['description'] = this.description;
    data['COSTO_ULTIMO'] = this.cOSTOULTIMO;
    data['PRECIO_PUB'] = this.pRECIOPUB;
    data['STOCK'] = this.sTOCK;
    data['CREATED_BY'] = this.cREATEDBY;
    data['tipo_publicacion'] = this.tipoPublicacion;
    data['PRIORITY'] = this.pRIORITY;
    data['NOTAYS'] = this.nOTAYS;
    data['AREA_CHECKED'] = this.aREACHECKED;
    data['AREAC_NAME'] = this.aREACNAME;
    data['USER_DGN'] = this.uSERDGN;
    data['status_dgn'] = this.statusDgn;
    data['wip_dgn'] = this.wipDgn;
    data['nota_dgn'] = this.notaDgn;
    data['USER_MKT'] = this.uSERMKT;
    data['status_mkt'] = this.statusMkt;
    data['wip_mkt'] = this.wipMkt;
    data['nota_mkt'] = this.notaMkt;
    data['tipo'] = this.tipo;
    data['ML'] = this.ML;
    data['AMZN'] = this.AMZN;
    data['SHEIN'] = this.SHEIN;
    data['status_final'] =  this.status_final;
    data['wip_final'] = this.wip_final;
    data['precioAMZN'] =  this.precio_AMZN;
    data['precioSHEIN'] = this.precio_SHEIN;
    return data;
  }
}
/*class tareas_dsgn {
  int? id;
  String? topic;
  String? dateCreated;
  String? lastUpdated;
  String? codigoSlim;
  String? codDesc;
  String? canal;
  String? publicacion;
  bool? checked;
  int? userId;
  String? user;
  String? description;
  String? depto;
  num? cOSTOULTIMO;
  String? pRECIOPUB;
  int? sTOCK;
  String? cREATEDBY;
  String? tipoPublicacion;
  String? status;
  String? nOTA;
  String? wIP;
  String? PRIORITY;
  String? notays;
  String? area_checked;
  String? areac_name;
  tareas_dsgn(
      {this.id,
        this.topic,
        this.dateCreated,
        this.lastUpdated,
        this.codigoSlim,
        this.codDesc,
        this.canal,
        this.publicacion,
        this.checked,
        this.userId,
        this.user,
        this.description,
        this.depto,
        this.cOSTOULTIMO,
        this.pRECIOPUB,
        this.sTOCK,
        this.cREATEDBY,
        this.tipoPublicacion,
        this.status,
        this.nOTA,
        this.wIP,
        this.PRIORITY,
        this.notays,
        this.area_checked,
        this.areac_name});

  tareas_dsgn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topic = json['topic'];
    dateCreated = json['date_created'];
    lastUpdated = json['last_updated'];
    codigoSlim = json['codigo_slim'];
    codDesc = json['cod_desc'];
    canal = json['canal'];
    publicacion = json['publicacion'];
    checked = json['checked'];
    userId = json['user_id'];
    user = json['user'];
    description = json['description'];
    depto = json['depto'];
    cOSTOULTIMO = json['COSTO_ULTIMO'];
    pRECIOPUB = json['PRECIO_PUB'];
    sTOCK = json['STOCK'];
    cREATEDBY = json['CREATED_BY'];
    tipoPublicacion = json['tipo_publicacion'];
    status = json['status'];
    nOTA = json['NOTA'];
    wIP = json['WIP'];
    PRIORITY = json['PRIORITY'];
    notays = json['NOTAYS'];
    area_checked = json['AREA_CHECKED'];
    areac_name = json['AREAC_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic'] = this.topic;
    data['date_created'] = this.dateCreated;
    data['last_updated'] = this.lastUpdated;
    data['codigo_slim'] = this.codigoSlim;
    data['cod_desc'] = this.codDesc;
    data['canal'] = this.canal;
    data['publicacion'] = this.publicacion;
    data['checked'] = this.checked;
    data['user_id'] = this.userId;
    data['user'] = this.user;
    data['description'] = this.description;
    data['depto'] = this.depto;
    data['COSTO_ULTIMO'] = this.cOSTOULTIMO;
    data['PRECIO_PUB'] = this.pRECIOPUB;
    data['STOCK'] = this.sTOCK;
    data['CREATED_BY'] = this.cREATEDBY;
    data['tipo_publicacion'] = this.tipoPublicacion;
    data['status'] = this.status;
    data['NOTA'] = this.nOTA;
    data['WIP'] = this.wIP;
    data['PRIORITY'] = this.PRIORITY;
    data['NOTAYS'] = this.notays;
    data['AREA_CHECKED']=this.area_checked;
    data['AREAC_NAME']=this.areac_name;
    return data;
  }
}*/

class designmkt_class {
  Future gettask(String init_dt,String final_dt,String checked,String USER,String FINDER) async {
    var url = Uri.parse('http://45.56.74.34:6660/get_dsgn-mkt_tsk?INIT_DT=${init_dt}&FINAL_DT=${final_dt}&CHECKED=${checked}&USER=${USER}&FINDER=${FINDER}');
    print(url);
    var response = await http.get(url);
    List<tareas_dsgn> tasks = <tareas_dsgn>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Json = json.decode(sJson);
      print(Json["message"]);
      toast_dsgn(Json["message"], true);
      //Promo_toast(Json["message"]);
      var Jsonv = Json["data"] as List;
      for(var noteJson in Jsonv){
        tasks.add(tareas_dsgn.fromJson(noteJson));
      }
      return tasks;
    }else
      //throw Exception('NO se pudo');
    toast_dsgn('ERROR INTERNO', false);
  }

  update_tasks(String ATTRIB,var VALUE,int? ID)async{
    var request = http.Request('POST', Uri.parse('http://45.56.74.34:6660/update_task?ATTRIB=${ATTRIB}&VALUE=${VALUE}&ID=${ID}'));
    print('http://45.56.74.34:6660/update_task?ATTRIB=${ATTRIB}&VALUE=${VALUE}&ID=${ID}');
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
  delete_tasks(int id)async{
    var request = http.Request('GET', Uri.parse('http://45.56.74.34:6660/deleteTSKS?ID=${id}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      toast_dsgn('Tarea Eliminada', true);
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
}



class users_dsgn {
  int? id;
  String? nickname;
  String? name;

  users_dsgn({this.id, this.nickname, this.name});

  users_dsgn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['name'] = this.name;
    return data;
  }
}

class Users_mkt {
  Future getUSRS() async {
    var url = Uri.parse('http://45.56.74.34:6660/dsgn_users');
    print(url);
    var response = await http.get(url);
    List<users_dsgn> users = <users_dsgn>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json["message"]);
      var Jsonv = Json["data"] as List;
      for (var noteJson in Jsonv) {
        users.add(users_dsgn.fromJson(noteJson));
      }
      return users;
    } else
      throw Exception('NO se pudo');
  }
}

class areas_stock {
  String? cODIGO;
  String? dSC;
  String? sTOCK;
  int? sHEIN;
  int? aMZN;
  int? mL;

  areas_stock(
      {this.cODIGO, this.dSC, this.sTOCK, this.sHEIN, this.aMZN, this.mL});

  areas_stock.fromJson(Map<String, dynamic> json) {
    cODIGO = json['CODIGO'];
    dSC = json['DSC'];
    sTOCK = json['STOCK'];
    sHEIN = json['SHEIN'];
    aMZN = json['AMZN'];
    mL = json['ML'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO'] = this.cODIGO;
    data['DSC'] = this.dSC;
    data['STOCK'] = this.sTOCK;
    data['SHEIN'] = this.sHEIN;
    data['AMZN'] = this.aMZN;
    data['ML'] = this.mL;
    return data;
  }
}

class Stock_getter {
  Future getStock(String codslim) async {
    var url = Uri.parse('http://45.56.74.34:6660/areas_stck?CODIGO=${codslim}');
    print(url);
    var response = await http.get(url);
    List<areas_stock> stock = <areas_stock>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json["message"]);
      var Jsonv = Json["data"] as List;
      for (var noteJson in Jsonv) {
        stock.add(areas_stock.fromJson(noteJson));
      }
      return stock;
    } else
      throw Exception('NO se pudo');
  }
}

toast_dsgn(String text,bool goodrq){
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
              child: Text(text),),
          ],
        ),
      ),
    ),
  );
}


class users_task {
  int? id;
  String? topic;
  String? dateCreated;
  String? codigoSlim;
  String? codDesc;
  String? canal;
  bool? checked;
  String? userDiseO;
  String? userMarketing;
  String? description;
  String? pRECIOPUB;
  int? sTOCK;
  String? cREATEDBY;
  String? tipoPublicacion;
  String? statusDgn;
  String? statusMkt;
  String? statusFinal;
  String? notaDgn;
  String? notaMkt;
  String? wipDgn;
  String? wipMkt;
  String? wipFinal;
  String? pRIORITY;
  String? mL;
  String? aMZN;
  String? sHEIN;
  String? tipo;
  String? precio_AMZN;
  String? precio_SHEIN;

  users_task(
      {this.id,
        this.topic,
        this.dateCreated,
        this.codigoSlim,
        this.codDesc,
        this.canal,
        this.checked,
        this.userDiseO,
        this.userMarketing,
        this.description,
        this.pRECIOPUB,
        this.sTOCK,
        this.cREATEDBY,
        this.tipoPublicacion,
        this.statusDgn,
        this.statusMkt,
        this.statusFinal,
        this.notaDgn,
        this.notaMkt,
        this.wipDgn,
        this.wipMkt,
        this.wipFinal,
        this.pRIORITY,
        this.mL,
        this.aMZN,
        this.sHEIN,
        this.tipo,
  this.precio_AMZN,
  this.precio_SHEIN});

  users_task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topic = json['topic'];
    dateCreated = json['date_created'];
    codigoSlim = json['codigo_slim'];
    codDesc = json['cod_desc'];
    canal = json['canal'];
    checked = json['checked'];
    userDiseO = json['user_diseño'];
    userMarketing = json['user_marketing'];
    description = json['description'];
    pRECIOPUB = json['PRECIO_PUB'];
    sTOCK = json['STOCK'];
    cREATEDBY = json['CREATED_BY'];
    tipoPublicacion = json['tipo_publicacion'];
    statusDgn = json['status_dgn'];
    statusMkt = json['status_mkt'];
    statusFinal = json['status_final'];
    notaDgn = json['nota_dgn'];
    notaMkt = json['nota_mkt'];
    wipDgn = json['wip_dgn'];
    wipMkt = json['wip_mkt'];
    wipFinal = json['wip_final'];
    pRIORITY = json['PRIORITY'];
    mL = json['ML'];
    aMZN = json['AMZN'];
    sHEIN = json['SHEIN'];
    tipo = json['tipo'];
    precio_AMZN = json['precioAMZN'];
    precio_SHEIN = json['precioSHEIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic'] = this.topic;
    data['date_created'] = this.dateCreated;
    data['codigo_slim'] = this.codigoSlim;
    data['cod_desc'] = this.codDesc;
    data['canal'] = this.canal;
    data['checked'] = this.checked;
    data['user_diseño'] = this.userDiseO;
    data['user_marketing'] = this.userMarketing;
    data['description'] = this.description;
    data['PRECIO_PUB'] = this.pRECIOPUB;
    data['STOCK'] = this.sTOCK;
    data['CREATED_BY'] = this.cREATEDBY;
    data['tipo_publicacion'] = this.tipoPublicacion;
    data['status_dgn'] = this.statusDgn;
    data['status_mkt'] = this.statusMkt;
    data['status_final'] = this.statusFinal;
    data['nota_dgn'] = this.notaDgn;
    data['nota_mkt'] = this.notaMkt;
    data['wip_dgn'] = this.wipDgn;
    data['wip_mkt'] = this.wipMkt;
    data['wip_final'] = this.wipFinal;
    data['PRIORITY'] = this.pRIORITY;
    data['ML'] = this.mL;
    data['AMZN'] = this.aMZN;
    data['SHEIN'] = this.sHEIN;
    data['tipo'] = this.tipo;
    data['precioAMZN'] =  this.precio_AMZN;
    data['precioSHEIN'] = this.precio_SHEIN;
    return data;
  }
}

class users_dsgn_tsk {
  Future getdata(String USER,String CHECKED,String INIT_DT,String FINAL_DT) async {
    var url = Uri.parse('http://45.56.74.34:6660/get_userstask?USER=${USER}&CHECKED=${CHECKED}&INIT_DT=${INIT_DT}&FINAL_DT=${FINAL_DT}');
    print(url);
    var response = await http.get(url);
    List<users_task> list = <users_task>[];
    if (response.statusCode == 200) {
      String sJson = response.body.toString();
      var Json = json.decode(sJson);
      print(Json["message"]);
      toast_dsgn("CONSULTA EXITOSA", true);
      var Jsonv = Json["data"] as List;
      for (var noteJson in Jsonv) {
        list.add(users_task.fromJson(noteJson));
      }
      return list;
    } else {
      toast_dsgn("ERROR INTERNO", false);
    }//throw Exception('NO se pudo');
  }
}

