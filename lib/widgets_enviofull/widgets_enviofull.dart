
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Modelo_traspaso/modelo_traspaso.dart';

class AlertStock extends StatefulWidget{
  String Cod_Slim;
  AlertStock({Key? key,required this.Cod_Slim}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AlertStock();
}

class _AlertStock extends State<AlertStock>{
  List<areas_stock> areas = <areas_stock>[];

  Future<List<areas_stock>> AreaStock (String text) async {
    var url = Uri.parse('http://45.56.74.34:5559/areas/stock?search=$text');
    print(url);
    var response = await http.get(url);
    List<areas_stock> area = <areas_stock>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      print(_sub);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv) {
        area.add(areas_stock.from(noteJson));
      }
      return area;
    }else
      throw Exception('NO se pudo');
  }

  void initState(){
    AreaStock(widget.Cod_Slim).then((value) {
      setState((){
        areas.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String Cross='0',acc_racks='0',acc_mz='0',ref_mz='0',amz='0',rev='0',merma='0';
    if(areas.length!=0){
      Cross=areas[0].cross.toString();
      acc_racks=areas[0].acc_racks.toString();
      acc_mz=areas[0].acc_mz.toString();
      ref_mz=areas[0].ref_mz.toString();
      amz=areas[0].amz.toString();
      rev=areas[0].rev.toString();
      merma=areas[0].merma.toString();
    }
    return AlertDialog(
      title: Text(widget.Cod_Slim),
      content:Container(
        height: 450,
        width: 200,
        child:ListView(
          shrinkWrap: true,
          children: [
            Card(
              child: ListTile(
                title: Text('Crossdock'),
                subtitle: Text(Cross,
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 18),),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Accesorios Racks'),
                subtitle: Text(acc_racks,
                  style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 18),),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Accesorios MZ'),
                subtitle: Text(acc_mz,
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 18),),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Refacciones\nMZ'),
                subtitle: Text(ref_mz,
                style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 18),),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Amazon'),
                subtitle: Text(amz,
                style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 18),),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Revision'),
                subtitle: Text(rev,
                style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 18),),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Merma'),
                subtitle: Text(merma,
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 18),),
              ),
            ),
          ],
        ),
      )
    );
  }
}