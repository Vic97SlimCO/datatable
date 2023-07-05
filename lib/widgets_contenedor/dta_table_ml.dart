import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Modelo_contenedor/model.dart';
import 'package:http/http.dart' as http;

import '../Modelo_traspaso/modelo_traspaso.dart';

class DtaTable extends StatefulWidget{
  String CoDslim;
  DtaTable({Key? key,required this.CoDslim}) : super(key: key);
  @override
  State<DtaTable> createState() => _DtaTable(CodSlim: CoDslim);
}

class _DtaTable extends State<DtaTable>{
  String CodSlim;
  List<Slim> publicaciones = <Slim>[];
  List<Slim> pubs = <Slim>[];
  _DtaTable({required this.CodSlim});
  Future<List<Slim>> Publicaciones(String CodSlim)async{
    //http://45.56.74.34:8890/container/condensado?folio=10210&title=&dias=20&leadtime=3&proveedor=0&sublinea2=000&tipo=A
    var url = Uri.parse('http://45.56.74.34:8081/publicaciones_all_select?title=$CodSlim&tipo=*&index=0&proveedor=000&sublinea2=000');
    print(url);
    var response = await http.get(url);
    List<Slim> publicaciones = <Slim>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      //print(Jsonv);
      for (var noteJson in Jsonv) {
        publicaciones.add(Slim.from(noteJson));
      }
      return publicaciones;
    }else
      throw Exception('NO se pudo');
  }
  void initState(){
    Publicaciones(CodSlim).then((value) {
      setState((){
        publicaciones.addAll(value);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Mercado Libre'),
        content:
          DataTable(columns: [
          DataColumn(label: Text('Cod Slim')),
          DataColumn(label: Text('MLM')),
          DataColumn(label: Text('Titulo')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('V30')),
          DataColumn(label: Text('Full')),
          DataColumn(label: Text('Camino')),
        ], rows: publicaciones.map((pub) =>
            DataRow(cells: [
              DataCell(SelectableText(pub.cod_slim)),
              DataCell(SelectableText(pub.meli)),
              DataCell(Text(pub.title)),
              DataCell(Text(pub.status)),
              DataCell(Text(pub.vta30ML.toString())),
              DataCell(Text(pub.stockfull.toString())),
              DataCell(Text(pub.en_camino.toString())),
            ])
        ).toList(),
        )
    );
  }
}