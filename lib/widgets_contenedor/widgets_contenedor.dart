
import 'dart:convert';

import 'package:contextmenu/contextmenu.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datatable/Modelo_contenedor/Slim_model.dart';
import 'package:datatable/Modelo_traspaso/modelo_traspaso.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:syncfusion_flutter_datagrid/src/datagrid_widget/sfdatagrid.dart';

import '../Modelo_contenedor/model.dart';
import '../listaorders.dart';
import 'dta_table_ml.dart';

class UnidadesConf extends StatefulWidget{
  TextEditingController controllerUnidadesConf = TextEditingController();
  int indice=0;
  String Slim,Desc,User,Title,Variation,ID;
  UnidadesConf({Key? key,required this.Slim,
    required this.Desc,required this.User,
    required this.Title,required this.Variation,
    required this.ID});

  @override
  State<UnidadesConf> createState() => _UnidadesC();
}
class _UnidadesC extends State<UnidadesConf> {

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: widget.controllerUnidadesConf,
      onSubmitted: (String valor) {
        int pedidoC = int.parse(widget.controllerUnidadesConf.text);
        try {
          print('Cod_Slim: ' + widget.Slim + ' Desc_Corta: ' + widget.Desc +
              ' Unidades a pedir: ' + pedidoC.toString() + ' Usuario: ' +
              widget.User);
          UConfirm(
              widget.Slim,
              widget.Desc,
              pedidoC,
              widget.User,
              widget.Title,
              widget.Variation,
              widget.ID);
        } catch (error) {
          print(error);
        }
      },
    );
  }
  Future<http.Response> UConfirm(String codigo, String desc, int quantity, String user, String title, String variation, String id) {
    return http.post(
      Uri.parse(
          'http://45.56.74.34:8890/container/set?container=SC22-3&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }

}

class ContextSlim extends StatefulWidget{
  String CoDSlim,SKU;
  ContextSlim({Key? key,required this.CoDSlim,required this.SKU});

  @override
  State<ContextSlim> createState() => _ContextSlim();
}

class _ContextSlim extends State<ContextSlim>{

  @override
  Widget build(BuildContext context) {

    return Padding(padding: EdgeInsets.all(1.0),
      child: ContextMenuArea(
          child: GestureDetector(child: Text(widget.CoDSlim),onDoubleTap: (){
            Clipboard.setData(ClipboardData(text: widget.CoDSlim));
      },),
          builder: (context)=>[
            ListTile(
              title: Text('Mercado Libre'),
              onTap: (){
                Dialog(context);
              },
            ),
            ListTile(
              title: Text('Copiar Codigo Slim'),
              onTap: (){
                Clipboard.setData(ClipboardData(text:widget.CoDSlim));
              },
            ),
            ListTile(
              title: Text('Copiar SKU'),
              onTap: (){
                Clipboard.setData(ClipboardData(text:widget.SKU));
              },
            ),
          ]
      ),
    );
  }
  void Dialog(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return DtaTable(CoDslim: widget.CoDSlim,);
        });
  }

}

class Amzn_Table extends StatefulWidget{
  List<Slim> lista_amzn;
  Amzn_Table({required this.lista_amzn});

  @override
  State<StatefulWidget> createState() => _Amazn_Table();

}

class _Amazn_Table extends State<Amzn_Table>{

  String Asin='';
  String Titulo='';
  String v30='';
  String FBA='';
  String Cross='';


  @override
  Widget build(BuildContext context) {
    if(widget.lista_amzn.length>0){
      if(widget.lista_amzn[0].asin!=''){
        Asin = widget.lista_amzn[0].asin;
        Titulo = widget.lista_amzn[0].title;
        v30 = widget.lista_amzn[0].vta30amzn.toString();
        FBA = widget.lista_amzn[0].amznfba.toString();
        Cross = widget.lista_amzn[0].amzncross.toString();
      } else{
        Asin='No Aplica';
        Titulo='No Aplica';
        v30='No Aplica';
        FBA='No Aplica';
        Cross='No Aplica';
      }
    }

      return DataTable2(
          columns: [
            DataColumn2(label: SelectableText('Asin')),
            DataColumn2(label: Text('Titulo')),
            DataColumn2(label: Text('V30')),
            DataColumn2(label: Text('FBA')),
            DataColumn2(label: Text('Cross')),
          ],
          rows: <DataRow2>[
            DataRow2(cells:<DataCell>[
              DataCell(SelectableText(Asin,
              style: TextStyle(
              fontWeight: FontWeight.bold,
              ))),
              DataCell(Text(Titulo)),
              DataCell(Text(v30)),
              DataCell(Text(FBA)),
              DataCell(Text(Cross)),
            ]
            ),
          ]);
  }
}

class Confirmados_txt extends StatefulWidget {
   slim_order value;
   String user;
   folios folio;
   Confirmados_txt( {Key? key,required this.value,required this.user, required this.folio}) : super(key: key);
  @override
  State<Confirmados_txt> createState() => _Confirmados_txtState();
}

class _Confirmados_txtState extends State<Confirmados_txt> {

  TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
      onSubmitted: (String value){
        int pedido = int.parse(controller.text);
        try{
          Confirm_Folio(widget.folio.Folio, widget.value.codigo_slim,'', pedido, widget.user, '', '', '');
          UConfirm(widget.value.codigo_slim,'', 0, widget.user,'', '', '');
          controller.text='';
        } catch(error){
           print(error);
        }
      },
    );
  }
  Future<http.Response> Confirm_Folio(String folio,String codigo, String desc, int quantity,
      String user, String title, String variation, String id) {
    print('http://45.56.74.34:8890/container/set?container=$folio&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user');
    return http.post(
      Uri.parse(
          //'http://45.56.74.34:8890/container/set?container=SC22-3&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
          'http://45.56.74.34:8890/container/set?container=$folio&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
  Future<http.Response> UConfirm(String codigo, String desc, int quantity, String user, String title, String variation, String id) {
    print('http://45.56.74.34:8890/container/set?container=&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user');
    return http.post(
      Uri.parse(
          'http://45.56.74.34:8890/container/set?container=&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }

}

class txtbox_conf extends StatefulWidget {
  slim_order value;
  String user;
  folios folio;
  txtbox_conf({Key? key,required this.value,required this.folio,required this.user}) : super(key: key);

  @override
  State<txtbox_conf> createState() => _txtbox_confState();
}

class _txtbox_confState extends State<txtbox_conf> {
  List<slim_order> confirm = <slim_order>[];
  List<slim_order> confirm_seg = <slim_order>[];
  String pedidas='0';
  @override
  void initState() {
    Orden(widget.folio.Folio, widget.value.codigo_slim).then((value) {
      confirm.addAll(value);
    });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      for(int x=0;x<confirm.length;x++){
        if(confirm[x].folio==widget.folio.Folio&&confirm[x].codigo_slim==widget.value.codigo_slim){
          pedidas =confirm[x].confimadas.toString();
          print(confirm[x].folio!+widget.folio.Folio);
        }
      }
    });
    return Text(pedidas);
  }
  Future<List<slim_order>> Orden(String folio,String title) async{
    var url = Uri.parse('http://45.56.74.34:8890/container/condensado?folio=$folio&title=$title&dias=0&leadtime=0&sublinea2=000&tipo=&confirmados=yes');
    print(url);
    var response = await http.get(url);
    List<slim_order> publicaciones = <slim_order>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv) {
        publicaciones.add(slim_order.from(noteJson));
      }
      return publicaciones;
    }else throw Exception('NO se pudo');
  }
}



