import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datatable/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Modelo_contenedor/model.dart';
import '../Modelo_traspaso/modelo_traspaso.dart';
import 'package:datatable/main.dart';

class MenucontextCslim extends StatefulWidget{
  String cod_slim,asin,SKU,IDML;
  MenucontextCslim({Key? key,required this.cod_slim,required this.asin,required this.SKU,required this.IDML});

  @override
  State<MenucontextCslim> createState() => _MenuCSlim();
}

class _MenuCSlim extends State<MenucontextCslim>{
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(1.0),
      child: ContextMenuArea(
        child: Text(widget.cod_slim),
        builder: (context) => [
          ListTile(
            title: Text('Copiar Codigo Slim'),
            onTap: (){
              Clipboard.setData(ClipboardData(text:widget.cod_slim));
            },
          ),
          ListTile(
            title: Text('Copiar ID Publicacion'),
            onTap: (){
              Clipboard.setData(ClipboardData(text:widget.IDML));
            },
          ),
          ListTile(
            title: Text('Copiar Asin'),
            onTap: (){
              Clipboard.setData(ClipboardData(text:widget.asin));
            },
          ),
          ListTile(
            title: Text('Copiar SKU'),
            onTap: (){
              Clipboard.setData(ClipboardData(text:widget.SKU));
            },
          ),
          
        ],
      ),);
  }
}

class ContxtID extends StatefulWidget{
  String ID,user_id;
  Slim item;
  ContxtID({Key? key,required this.ID,required this.item, required this.user_id});

  @override
  State<StatefulWidget> createState() => _ContxtID();
}
class _ContxtID extends State<ContxtID>{

  @override
  Widget build(BuildContext context) {
    String ID = widget.ID;
    String op1='';
    String IDsub3 = '';
    if(widget.ID != ''){
      IDsub3 =widget.ID.substring(0,2);
      switch(IDsub3){
        case 'ML':
          setState(() {
            op1 = 'Pedir unidades a Amazon';
          });
          break;

        case 'B0':
          setState((){
            op1 = 'Pedir unidades a ML';
          });
          break;
      }

    }

    return Padding(padding: const EdgeInsets.all(1.0),
      child: ContextMenuArea(
        child: Text(ID,style:TextStyle(
          //fontWeight: FontWeight.bold,
            color: Colors.white,
            backgroundColor: Colors.deepPurple[500]
          //background: Paint()..color=Colors.deepPurple,
        )),
        builder: (context) => [
          ListTile(
            title: Text(op1),
            onTap: (){
              switch(IDsub3){
                case 'ML':
                  print('Unidades en Cod_Slim'+widget.item.cod_slim+' De ML:'+widget.item.meli+' A Amazon:'+widget.item.asin);
                  showDialog(context: context, builder: (BuildContext context){
                    return Acomodo(De:widget.item.asin,Para:widget.item.meli,ID:widget.item.cod_slim);
                  });

                  break;
                case 'B0':
                  print('Cod_Slim'+widget.item.cod_slim+' Pedir de ML:'+widget.item.asin+' A Amazon:'+widget.item.meli);
                  showDialog(context: context, builder: (BuildContext context)
                  {
                    return Acomodo(De: widget.item.meli,
                        Para: widget.item.asin,
                        ID: widget.item.cod_slim);
                  });
                  break;
              }
            },
          ),
          ListTile(
            title: Text('Poner Disponibles en M. Envios'),
            onTap: (){
                Tabla_Disp(context);
            },
          )
        ],
      ),);
  }
  void Tabla_Disp(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return Disp_Envios(ID_ML: widget.item.meli,Cod_Slim:widget.item.cod_slim,user_id: widget.user_id,);
        });
  }
}
//
class Acomodo extends StatefulWidget{
  String De,Para,ID;

  Acomodo({Key? key,required this.De,required this.Para,required this.ID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Acomodo();

}

class _Acomodo extends State<Acomodo>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _destinatario = TextEditingController();
  TextEditingController _ID = TextEditingController();
  TextEditingController _remitente = TextEditingController();
  TextEditingController _unidades = TextEditingController();
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
    AreaStock(widget.ID).then((value){
      setState((){
        areas.addAll(value);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    _ID.text = widget.ID;
    _destinatario.text = widget.Para;
    _remitente.text = widget.De;
    String Acc_Racks='', Acc_MZ='', Ref_MZ='', AMZ='',SHOP='',Cross='',Areas='No hay Stock';
    if(areas.length != 0){
      Acc_Racks='Accesorios Racks: '+areas[0].acc_racks.toString()+'\n';
      Acc_MZ='Accesorios MZ: '+areas[0].acc_mz.toString()+'\n';
      Ref_MZ='Refacciones MZ: '+areas[0].ref_mz.toString()+'\n';
      AMZ='Amazon: '+areas[0].amz.toString()+'\n';
      SHOP='Shopee: '+areas[0].shp.toString()+'\n';
      Cross='Cross: '+areas[0].cross.toString();
      //Rev='\nRev: '+areas[0].rev.toString();
      if(areas[0].acc_racks == 0){
        Acc_Racks = '';
      }
      if(areas[0].acc_mz == 0){
        Acc_MZ = '';
      }
      if(areas[0].ref_mz == 0){
        Ref_MZ = '';
      }
      if(areas[0].amz == 0){
        AMZ = '';
      }
      if(areas[0].shp == 0){
        SHOP = '';
      }
      if(areas[0].cross == 0){
        Cross = '';
      }
      Areas = Acc_Racks+Acc_MZ+Ref_MZ+AMZ+SHOP+Cross;
    }
    //var item = ['*','Accesorios Rack-Pedro','Accesorios Mz-Pedro','Refacciones Mz-Alejandro','Shopee-Selene','Amazon-Aide'];
    String dropdownvalue = '*';
    return AlertDialog(
      //contentPadding: EdgeInsets.fromLTRB(24, 4, 50, 4),
      title: Text('Reubicar Unidades'),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('ID',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
            TextFormField(controller: _ID,),
            Text('Destinatario:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                )),
            TextFormField(controller: _destinatario,),
            Text('Remitente:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                )),
            TextFormField(controller: _remitente,),
            Text('Stock en Areas:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                )),
            Text(Areas),
            Text('Solicitar a:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                )),
            DropArea(),
            Text('Unidades:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                )),
            TextFormField(controller: _unidades,),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: (){
            print('ID_Producto: '+_ID.text+' Destinatario: '+_destinatario.text+
                '\nRemitente: '+_remitente.text+'---'+Provider.of<Lead_>(context,listen: false).solicitud+
            '\nUnidades: '+_unidades.text);
        }, child: Text('Enviar Peticion'),),
      ],
    );
  }

}

class DropArea extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _DropArea();

}
class _DropArea extends State<DropArea>{
  var item = ['*','Accesorios Rack-Pedro','Accesorios Mz-Pedro','Refacciones Mz-Alejandro Alvarez','Shopee-Selene Alvarez','Amazon-Ayde Hernandez'];
  String? dropdownvaluep = '';

  @override
  Widget build(BuildContext context) {
    dropdownvaluep = Provider.of<Lead_>(context,listen: false).solicitud;
    return DropdownButton(
        value:dropdownvaluep,
        items: item.map((String items){
          return DropdownMenuItem(child: Text(items),value: items,);
        }).toList(),
        onChanged: (String? newValue){
          setState((){
            Provider.of<Lead_>(context,listen:false).destinatario(newValue!);
            print(Provider.of<Lead_>(context,listen: false).solicitud);
          });
        });
  }
}

class Disp_Envios extends StatefulWidget{
  String Cod_Slim,ID_ML;
  String user_id;
  Disp_Envios({Key? key,required this.ID_ML, required this.Cod_Slim,required this.user_id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Disp();

}

class _Disp extends State<Disp_Envios>{
  List<Slim>  publicaciones = <Slim>[];
  List QTY = [];
  Future<List<Slim>> SlimData(String slim) async {
    var url = Uri.parse('http://45.56.74.34:8081/publicaciones_all_select?title=$slim&tipo=*&index=0&proveedor=000&sublinea2=000');
    print(url);
    var response = await http.get(url);
    List<Slim> publicaciones = <Slim>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv) {
        publicaciones.add(Slim.from(noteJson));
      }
      return publicaciones;
    }else
      throw Exception('NO se pudo');
  }

void initState(){
SlimData(widget.ID_ML).then((value) {
  setState((){
    publicaciones.addAll(value);
    for(int x=0;x<publicaciones.length;x++){
      QTY.add(publicaciones[x].av_quantity);
    }
  });
});

}

  @override
  Widget build(BuildContext context) {

  return AlertDialog(
    title: TxTFull(),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns:[
              DataColumn(label: Text('ID_ML')),
              DataColumn(label: Text('Titulo')),
              DataColumn(label: Text('SKU')),
              DataColumn(label: Text('QTY')),
            ],
            rows: publicaciones.map((e) =>
                DataRow(cells: [
                  DataCell(Text(e.meli)),
                  DataCell(Text(e.title)),
                  DataCell(Text(e.sku)),
                  DataCell(QTY_TXT(e.av_quantity,e.sku,publicaciones))
                  //DataCell(Txt_Disp(variantes:publicaciones,item: e,)),
                ])).toList()
            ),
        ),
    actions: <Widget>[
      TextButton(onPressed: () async {
        String ArrayQTy='';
        //String json='';
          if(publicaciones.length==1){
              if(publicaciones[0].variation_id==0){
                ArrayQTy = '{"available_quantity":'+QTY[0].toString()+'}';
                var json=jsonDecode(ArrayQTy);
                String json_enc=jsonEncode(json);
                try{
                  Av_QTY(json_enc, widget.ID_ML, widget.user_id);
                } catch(error){
                  print(error);
                }
              }else{
                ArrayQTy = ArrayQTy+'{"id":"'+publicaciones[0].variation_id.toString()+'","available_quantity":'+QTY[0].toString()+'}';
                var json =jsonDecode('{"variations":['+ArrayQTy+']}');
                String json_enc = jsonEncode(json);
                try{
                  Av_QTY(json_enc, widget.ID_ML, widget.user_id);
                } catch(error){
                  print(error);
              }
            }
          }else{
            for(int z=0;z<publicaciones.length;z++){
             ArrayQTy = ArrayQTy+'{"id":"'+publicaciones[z].variation_id.toString()+'","available_quantity":'+QTY[z].toString()+'},';
            }
            print('{"variations":['+ArrayQTy.substring(0,ArrayQTy.length-1)+']}');

            var json =jsonDecode('{"variations":['+ArrayQTy.substring(0,ArrayQTy.length-1)+']}');
            String json_enc = jsonEncode(json);
            try{
              await Av_QTY(json_enc, widget.ID_ML, widget.user_id);
            } catch(error){
              print(error);
            }
          }
        Navigator.pop(context);
        BotToast.showCustomText(
          duration: Duration(seconds: 2),
          onlyOne: true,
          clickClose: true,
          crossPage: true,
          ignoreContentClick: false,
          backgroundColor: Color(0x00000000),
          backButtonBehavior: BackButtonBehavior.none,
          animationDuration: Duration(milliseconds: 200),
          animationReverseDuration: Duration(milliseconds: 200),
          toastBuilder: (_) => Align(
            alignment: Alignment(0,0),
            child: Card(
              //color: Colors.deepPurple,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.check_circle,color: Colors.green),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Peticion Realizada"),),
                ],
              ),
            ),
          ),
        );
      }, child: Text('OK'))
    ],
  );
  }


  QTY_TXT(int av_quantity, String sku, List<Slim> publicacionestxt){
    TextEditingController _controller = TextEditingController();
    _controller.text=av_quantity.toString();
    return TextField(
      keyboardType: TextInputType.number,
      controller: _controller,
      onChanged: (String? value){
        for(int y=0;y<publicacionestxt.length;y++){
          if(sku==publicacionestxt[y].sku){
            if(_controller.text.isEmpty){
              QTY[y] = 0;
            }else{
              QTY[y]=_controller.text;
            }
          }
        }
      },
    );
  }

  Future<http.Response> Av_QTY(json,mlm,user_id){
    print('http://45.56.74.34:8088/available_quantity_change?id=$mlm&user_id=$user_id');
    print(json);
    return http.post(
      Uri.parse('http://45.56.74.34:8088/available_quantity_change?id=$mlm&user_id=$user_id'),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
  }

  TxTFull(){
  return GestureDetector(
    child: Text(widget.ID_ML),
    onTap: (){
      _MLFullNav(widget.ID_ML);
    },
  );
  }

  _MLFullNav(String idmlm) async{
    var url = Uri.parse('https://www.mercadolibre.com.mx/publicaciones/listado/fulfillment?filters=with_fulfillment_with_stock_remaining_weeks_in_zero|with_fulfillment_with_stock_remaining_weeks_range_zero_one|with_fulfillment_with_stock_remaining_weeks_range_one_two|with_fulfillment_with_stock_remaining_weeks_range_two_four|with_fulfillment_with_stock_remaining_weeks_range_four_six|with_fulfillment_with_stock_remaining_weeks_more_than_six|with_fulfillment_without_stock_remaining_calculation|top_sales_enviable|without_fulfillment_enviable|no_sales_last_thirty_days|surplus_stock|insufficient_stock|waiting_for_arrival|in_transfer|return_by_buyer|to_withdraw|to_review|temporarily_not_for_sale|ready_to_withdraw&page=1&search=$idmlm');
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    }else{
      throw 'No se puede abrir el navegador';
    }
  }

}


class historial_costos extends StatefulWidget{
  String ID;
  historial_costos({Key? key, required this.ID}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _historial_costos();
}

class _historial_costos extends State<historial_costos>{
  List<historial> historial_lista = <historial>[];

  Future<List<historial>> Costos_Hist (String MLM) async {
    var url = Uri.parse('http://45.56.74.34:8088/historial_costos?id=$MLM&variation_id=0');
    print(url);
    var response = await http.get(url);
    List<historial> Costos = <historial>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      //print(_sub);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv) {
        Costos.add(historial.from(noteJson));
      }
      return Costos;
    }else
      throw Exception('NO se pudo');
  }


  initState(){
      Costos_Hist(widget.ID).then((value){
        setState((){
          historial_lista.addAll(value);
        });
      });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Historial de Costos'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(columns: [
          DataColumn(label: Text('Fecha')),
          DataColumn(label: Text('ID\nCompra')),
          DataColumn(label: Text('Proveedor')),
          DataColumn(label: Text('SKU')),
          DataColumn(label: Text('Cantidad')),
          DataColumn(label: Text('IVA')),
          DataColumn(label: Text('VENTAS')),
          DataColumn(label: Text('COSTO')),
          DataColumn(label: Text('TOTAL')),
        ], rows: historial_lista.map((e) =>
            DataRow(cells: [
              DataCell(Text(e.fecha.substring(0,10))),
              DataCell(Text(e.compra_ID)),
              DataCell(Text(e.Proveedor)),
              DataCell(Text(e.SKU)),
              DataCell(Text(e.cantidad.toString())),
              DataCell(Text(e.iva.toString())),
              DataCell(Text(e.ventas.toString())),
              DataCell(Text(e.costo.toString())),
              DataCell(Text(e.total.toStringAsFixed(2))),
            ])).toList(),
        ),
      )
    );
  }
}

class historial_button extends StatefulWidget{
  num precio_neto;
  String user,ID;
  historial_button({Key? key,required this.precio_neto,required this.user,required this.ID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _historialButton();
}

class _historialButton extends State<historial_button>{
String imagen = '';
  @override
  Widget build(BuildContext context) {
    if(widget.precio_neto==0.0){
      imagen = 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Solid_red.svg/512px-Solid_red.svg.png';
    } else{
      imagen = 'https://www.laparisina.mx/media/catalog/product/cache/c687aa7517cf01e65c009f6943c2b1e9/5/6/5616l27_01.jpg';
    }
    return GestureDetector(
      child: Image.network(imagen,height: 25,width: 25,),
      onTap: (){
        if(widget.user=='103'||widget.user=='1057'){
          if(widget.precio_neto!=0.0){
            showDialog(context: context,
                builder: (BuildContext context){
                  return historial_costos(ID: widget.ID,);
            });
          }
        }
      },
    );
  }
}