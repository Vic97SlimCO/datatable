
import 'dart:collection';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:datatable/widgets_contenedor/widgets_confirmados.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'dart:convert';
import 'dart:typed_data';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Modelo_contenedor/Slim_model.dart';
import 'listaorders.dart';
import 'main.dart';
import 'package:path/path.dart' as p;

class Confirm extends StatelessWidget {
  String user;
  Confirm({required this.user});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Pedidos Confirmados',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: _Confirm(user:user),
    );
  }
}

class _Confirm extends StatefulWidget{
  String user;
  _Confirm({Key ? key,required this.user}) : super(key: key);

  @override
  State<_Confirm> createState() => Confirm_();
}

class Confirm_ extends State<_Confirm>{
  Duration? executionTime;
  int rows =100;
  Confirm_();
  List<slim_order> _lista= <slim_order>[];
  List<Proveedores> provs= <Proveedores>[];
  Map<String, dynamic> filtro = {};
  int _currentSortColumn = 0;
  bool _isAscending = true;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  PaginatorController? _controller;
  List<String> _status = ["Accesorios", "Refacciones", "Ambas"];
  String _verticalGroupValue = "Ambas";

  @override
  void initState(){
    ModeloSlim('0',sub2,tipo).then((value) {
      setState((){
        _lista.addAll(value);
      });
    });
    Prove().then((value){
      setState((){
        provs.addAll(value);
      });
    });

  }

  Future<List<slim_order>> ModeloSlim(String provider,String sub2,String tipo) async {
    String PR = '&proveedor=$provider';
    var url = Uri.parse('http://45.56.74.34:8890/container/condensado?title=&confirmados=yes'+PR+'&dias=0&leadtime=0&sublinea2=$sub2&tipo=$tipo');
    print(url);
    var response = await http.get(url);
    List<slim_order> pconfirm = <slim_order>[];
    if(response.statusCode ==200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv){
        pconfirm.add(slim_order.from(noteJson));
      }
      return pconfirm;
    }else{
      throw Exception('No se pudo');
    }
  }
  Future<List<Proveedores>> Prove() async{
    var url = Uri.parse('http://45.56.74.34:5558/proveedores/list');
    var response = await http.get(url);
    List<Proveedores> proveedores = <Proveedores>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(36, count-1);
      var Jsonv = json.decode(_sub);
      //print(Jsonv);
      for (var noteJson in Jsonv) {
        proveedores.add(Proveedores.from(noteJson));
        //print(proveedores[0].ID);
      }
      return proveedores;
    }else
      throw Exception('NO se pudo');
  }

  var item = [
    '*', '247?', 'AMAZING',
    'ASTRON',
    'BEST TERESA',
    'BRASONIC',
    'CAPITAL MOVILE',
    'CELMEX',
    'Celular Hit',
    'CH ACCESORIES',
    'CHEN',
    'CONSTELACIÓN ORIENTAL',
    'DNS',
    'EAUPULEY',
    'ELE-GATE',
    'ESTEFANO',
    'EVA',
    'HAP TECH INC',
    'IPHONE E.U',
    'IPLUS',
    'KAIPING',
    'LITOY',
    'MARDI',
    'MC',
    'MEGAFIRE',
    'MING',
    'MK',
    'MOBILSHOP',
    'NUNBELL',
    'PAPELERIA',
    'PENDRIVE CITY',
    'RAZZY',
    'RELX',
    'SEO',
    'SIVIVI',
    'SKYROAM',
    'SLIM-CO',
    'SLIM-CO REFACCIONES',
    'VIMI',
    'WEI DAN',
    'XIAOMI',
    'XMOVILE',
    'XP',
    'ZHENG'
  ];
  var item_s2 = [
    '*',
    'BATERIAS GENERICAS',
    'BATERIAS SC','CHAROLA SIM',
    'CRISTAL DE CAMARA','FLEXORES',
    'GORILLA GLASS','LCD DISPLAY',
    'PANTALLA COMPLETA','TAPA','TORNILLOS',
    'TOUCH TACTIL'
  ];

  String dropdownvalue = '*';
  String provider='';
  Uint8List? bytes;
  List<slim_order> Excelist = <slim_order>[];
  String tittle_button = 'Sin imagen';
  String dropdownsub2 = '*';
  String tipo = "";
  String sub2 = '000';
  @override
  Widget build(BuildContext context) {
    bool choice = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Pedidos Confirmados'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Orders(user: widget.user),
                ),
                    (route) => false,
              );
            },
          ),
          IconButton(onPressed: (){
            Excelist.clear();
            ModeloSlim(provider,'000','').then((value) {
              setState((){
                Excelist.addAll(value);
                //exportToExcel(Excelist);
                if(provider=='030' || provider=='031' || provider=='029' ||
                    provider=='020'|| provider=='021' || provider=='025'||
                    provider=='022' || provider=='032'|| provider=='042'||provider=='0'){
                  Excel_Refacciones(Excelist);
                }else{
                  generateExcel(Excelist,provider);
                }
              });
            });
          }, icon: const Icon (Icons.save)),
          IconButton(onPressed: (){
            ModeloSlim('','','').then((value) {
              setState((){
                _lista.clear();
                _controller?.goToFirstPage();
                _lista.addAll(value);
              });
            });
          }, icon: const Icon (Icons.refresh))
        ],),
      body: PaginatedDataTable2(
               controller: _controller,
               columnSpacing: 12.0,
               horizontalMargin: 12.0,
               minWidth: 600,
               smRatio: 0.75,
               lmRatio: 1.5,
               autoRowsToHeight: true,
               fit: FlexFit.loose,
               headingRowColor: MaterialStateColor.resolveWith((states) => Colors.deepPurple[500]!),
               border: TableBorder(
               bottom: BorderSide(color: Colors.purple[500]!),
               horizontalInside: const BorderSide(color: Colors.deepPurple, width: 1)
                ),
        onRowsPerPageChanged: (value){
          if(value != null){
            _rowsPerPage = value;
          }
          print(_rowsPerPage);
        },
               header: Row(
                 children: [
                   Container(
                     color: Colors.deepPurple,
                     child: DropdownButton(
                     focusColor: Colors.deepPurple,
                     autofocus: true,
                     underline: Text('Proveedores',style:
                     TextStyle(
                         fontSize: 10,
                         height: 15),),
                     dropdownColor: Colors.deepPurple,
                     style: TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: 20
                     ),
                     value: dropdownvalue,
                     onChanged: (String? newValue) {
                       setState(() {
                         _lista.clear();
                         dropdownvalue = newValue!;
                         provider='';
                         print(dropdownvalue);
                         for(int x=0;x<provs.length;x++){
                           if(dropdownvalue==provs[x].Nombre){
                             switch(provs[x].ID.toString().length){
                               case 1:
                                 String val =provs[x].ID.toString();
                                 provider = '00$val';
                                 break;
                               case 2:
                                 String val =provs[x].ID.toString();
                                 provider = '0$val';
                                 break;
                               case 3:
                                 String val =provs[x].ID.toString();
                                 provider = '$val';
                                 break;
                             }
                           }else if(dropdownvalue=='*'){
                             provider = '0';
                           }
                         }
                         ModeloSlim(provider,sub2,tipo).then((value) {
                           setState((){
                             _lista.addAll(value);
                           });
                         });
                       });
                     },
                     items: item.map((String items) {
                       return DropdownMenuItem(
                         value: items,
                         child: Text(items),
                       );
                     }).toList(),
                   ),),
                   Container(
                     color: Colors.deepPurple,
                     child:DropdownButton(
                         underline: Text('Sublinea 2',
                         style: TextStyle(fontSize: 10,height: 15),),
                         value: dropdownsub2,
                         dropdownColor: Colors.deepPurple,
                         style: TextStyle(
                             color: Colors.white,
                             fontWeight: FontWeight.bold,
                             fontSize: 20
                         ),
                         items: item_s2.map((String items) {
                           return DropdownMenuItem(
                               value: items,
                               child: Text(items));
                         }).toList(),
                         onChanged: (String? newValor){
                           setState((){
                             _lista.clear();
                             dropdownsub2 = newValor!;
                             switch(dropdownsub2){
                               case '*':sub2='000'; break;
                               case 'BATERIAS GENERICAS':sub2='200'; break;
                               case 'BATERIAS SC':sub2='201'; break;
                               case 'CHAROLA SIM': sub2='202';break;
                               case 'CRISTAL DE CAMARA':sub2='203'; break;
                               case 'FLEXORES':sub2='204'; break;
                               case 'GORILLA GLASS':sub2='205'; break;
                               case 'LCD DISPLAY':sub2='206'; break;
                               case 'PANTALLA COMPLETA':sub2='207'; break;
                               case 'TAPA':sub2='208'; break;
                               case 'TOUCH TACTIL':sub2='210'; break;
                               case 'TORNILLOS':sub2='209'; break;
                             }
                             ModeloSlim(provider,sub2,tipo).then((value) {
                               setState((){
                                 _lista.addAll(value);
                               });
                             });
                           });
                         }),),
                   Container(
                     color: Colors.deepPurple,
                     child: RadioGroup<String>.builder(
                         direction: Axis.horizontal,
                         groupValue: _verticalGroupValue,
                         onChanged: (value) {
                           setState((){
                             _verticalGroupValue = value!;
                             switch(_verticalGroupValue){
                               case'Accesorios':tipo='A'; break;
                               case'Refacciones':tipo='R'; break;
                               case'Ambas':tipo=''; break;
                             }
                             _lista.clear();
                             ModeloSlim(provider,sub2,tipo).then((value) {
                               setState((){
                                 _lista.addAll(value);
                               });
                             });
                             print(_verticalGroupValue);
                           });
                         },
                         activeColor: Colors.white,
                         textStyle: TextStyle(
                             fontSize: 15,
                             fontWeight: FontWeight.bold,
                             color: Colors.white),
                         items: _status,
                         itemBuilder: (itemrb) => RadioButtonBuilder(
                           itemrb,
                         )),
                   ),
                 ],
               ),
               columns: [
                 DataColumn2(label: Text('Cod\nSlim',
                   style: TextStyle(
                     color: Colors.white
                 ),)),
                 DataColumn2(label: Text('Desc',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 //DataColumn(label: Text('SKU')),
                 DataColumn2(label: Text('Color',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('Costo\nUltimo',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 //DataColumn(label: Text('Nuevo\nprecio')),
                 DataColumn2(label: Text('Cantidad',
                   style: TextStyle(
                       color: Colors.white
                   ),),
                     onSort: (indexcolumn,_){
                       setState((){
                         _controller?.goToFirstPage();
                         _currentSortColumn = indexcolumn;
                         if(_isAscending ==true){
                           _isAscending = false;
                           _lista.sort((CodA,CodB) =>
                               CodB.confimadas.compareTo(CodA.confimadas));
                         } else{
                           _isAscending = true;
                           _lista.sort((CodA,CodB)=>
                               CodA.confimadas.compareTo(CodB.confimadas));
                         }
                       });
                     }
                 ),
                 DataColumn2(label: Text('Total',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('Imagen',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('Example',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('Instrucciones',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('Desc\nChina',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('Anexar\nImagen',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('BRAND',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('FRAME',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('TYPE',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('MODELO',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 DataColumn2(label: Text('Eliminar',
                   style: TextStyle(
                       color: Colors.white
                   ),)),
                 //DataColumn(label: Text('Guardar')),
               ],
                source: items_confirmados(_lista,widget.user,provs),
           ),

    );
  }

  Future<http.Response> UConfirm(String codigo,String desc,int quantity,String user,String title,String variation,String id){
    return http.post(
      //Uri.parse('http://45.56.74.34:8890/container/set?container=SC22-3&codigo=$codigo&descripcion=$desc&quantity=$quantity&user_id=$user'),
      Uri.parse('http://45.56.74.34:8890/container/set?container=SC22-3&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }

  FilePickers() async{
    Future<void> _openFile(String file) async {
      final Uri uri = Uri.file(file);
      print(uri);
      if (!File(uri.toFilePath()).existsSync()) {
        throw '$uri does not exist!';
      }
      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
    }
    _openFile('//192.168.10.108/Public/VICTOR/instalador_windows/Complementos/Excelimagenes.exe');
  }

  Future<void> generateExcel(List<slim_order> Excelist, String provider) async{
    int indx = Excelist.length+2;
    List<slim_order> _lista_prov2 = <slim_order>[];
    List<slim_order> _lista_prov3 = <slim_order>[];
    String importador= 'Importador: importador y exportador crown sa de cv \nDirección: pina 264, nueva santa maria, azcapotzalco, cdmx, cp: 02800 \nrfc: IEC141020Q36 \ntel: 5589427000';
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
    final xls.Worksheet Hoja_Prov2 = workbook.worksheets.add();
    final xls.Worksheet Hoja_Prov3 = workbook.worksheets.add();

    sheet.showGridlines = true;
    sheet.enableSheetCalculations();

    sheet.getRangeByName('A1:N1').columnWidth=35.0;
    sheet.getRangeByName('A1:M1').cellStyle.fontColor='#FFFFFF';
    sheet.getRangeByName('A1:N1').cellStyle.backColor='#0071FF';
    sheet.getRangeByName('A1:N$indx').rowHeight = 100.0;
    sheet.getRangeByName('A1:N$indx').cellStyle.hAlign=xls.HAlignType.center;
    sheet.getRangeByName('A1:N$indx').cellStyle.vAlign=xls.VAlignType.center;
    sheet.getRangeByName('A1:M$indx').cellStyle.wrapText= true;
    sheet.getRangeByName('A2:N$indx').cellStyle.backColor='#A4CDFF';
    sheet.getRangeByName('A1:N$indx').cellStyle.bold;
    sheet.getRangeByName('A1:H$indx').cellStyle.fontSize=30;
    sheet.getRangeByName('I1:N1').cellStyle.fontSize=30;
    sheet.getRangeByName('N2:N$indx').cellStyle.fontSize=30;
    sheet.getRangeByName('N2:N$indx').cellStyle.fontName='Archon Code 39 Barcode';

    sheet.getRangeByName('A1').setText('Piezas');
    sheet.getRangeByName('B1').setText('Codigo Slim');
    sheet.getRangeByName('C1').setText('Producto');
    sheet.getRangeByName('D1').setText('Color');
    sheet.getRangeByName('E1').setText('SKU');
    sheet.getRangeByName('F1').setText('Precio');
    sheet.getRangeByName('G1').setText('New Price');
    sheet.getRangeByName('H1').setText('Stock');
    sheet.getRangeByName('I1').setText('Imagen');
    sheet.getRangeByName('J1').setText('Example');
    sheet.getRangeByName('K1').setText('Instrucciones');
    sheet.getRangeByName('L1').setText('Importador');
    sheet.getRangeByName('M1').setText('Etiqueta Importador');

    Stopwatch stopwatch = new Stopwatch()..start();
    for(int x=2;x<Excelist.length+2;x++){
      String? color;
      //String Example = Excelist[x].Example;
      switch(Excelist[x-2].Color){
        case 'NEGRO':color='BK'; break;
        case 'ROSA':color='PK'; break;
        case 'BLANCO':color='WT'; break;
        case 'GRIS':color='GY'; break;
        case 'AZUL':color='BL'; break;
        case 'AMARILLO':color='YW'; break;
        case 'ROJO':color='RD'; break;
        case 'VERDE':color='GR'; break;
        case 'NARANJA':color='OR'; break;
        case 'MORADO':color='PP'; break;
        case 'CAFÉ':color='BR'; break;
        case 'DORADO':color='GD'; break;
        case 'GRIS ORSCURO':color='DG'; break;
        case 'GRIS CLARO':color='LG'; break;
        case 'AZUL CLARO':color='LG'; break;
        case 'SALMON':color='SM'; break;
        case 'KAKI':color='KK'; break;
        default: color = Excelist[x-2].Color; break;
      }
      String china='',example='',inst='';
      if(Excelist[x-2].DChina!=null){
          china =Excelist[x-2].DChina!;
      }
      if(Excelist[x-2].Example!=null){
          example =Excelist[x-2].Example!;
      }
      if(Excelist[x-2].Inst!=null){
          inst =Excelist[x-2].Inst!;
      }
      String equalprov = Excelist[x-2].proveedores.replaceAll('}','');
      String equalprov1 = equalprov.replaceAll('{','');
      String equalprov2 = equalprov1.replaceAll('"','');
      List<String> st = equalprov2.split(',');
      List<String> filter =<String>[];
      st.forEach((element) {
        if(filter.contains(element)){
        }else if(element!='NULL'){
          filter.add(element);
        }
      });
      /*if(filter.contains(provider)&&filter.length != 1){
        _lista_prov2.add(Excelist[x-2]);
        filter.remove(provider);
      }*/
      sheet.getRangeByName('B$x').setText(Excelist[x-2].codigo_slim);
      sheet.getRangeByName('C$x').setText(china);
      sheet.getRangeByName('A$x').setText(Excelist[x-2].confimadas.toString());
      sheet.getRangeByName('F$x').setText(Excelist[x-2].costo_ultimo.toStringAsFixed(2));
      sheet.getRangeByName('E$x').setText(Excelist[x-2].SKU);
      sheet.getRangeByName('D$x').setText(color);
      sheet.hyperlinks.add(sheet.getRangeByName('J$x'),xls.HyperlinkType.url, example);
      sheet.getRangeByName('K$x').setText(Excelist[x-2].Inst);
      sheet.getRangeByName('M$x').setText('Descripcion:'+Excelist[x-2].SKU+', Marca:SC, Cantidad: 1Pcs, '+inst+', Hecho en China,'+importador);
      sheet.getRangeByName('N$x').setFormula('=IF(D$x="","*"&B$x&"*","*"&B$x&" "&D$x&"*")');
      sheet.getRangeByName('L$x').setText(importador);
      }
    await ModeloSlim('003', '', '').then((value){
      _lista_prov2.addAll(value);
    });
    for(int y=2;y<_lista_prov2.length+2;y++){
      String? color;
      switch(_lista_prov2[y-2].Color){
        case 'NEGRO':color='BK'; break;
        case 'ROSA':color='PK'; break;
        case 'BLANCO':color='WT'; break;
        case 'GRIS':color='GY'; break;
        case 'AZUL':color='BL'; break;
        case 'AMARILLO':color='YW'; break;
        case 'ROJO':color='RD'; break;
        case 'VERDE':color='GR'; break;
        case 'NARANJA':color='OR'; break;
        case 'MORADO':color='PP'; break;
        case 'CAFÉ':color='BR'; break;
        case 'DORADO':color='GD'; break;
        case 'GRIS ORSCURO':color='DG'; break;
        case 'GRIS CLARO':color='LG'; break;
        case 'AZUL CLARO':color='LG'; break;
        case 'SALMON':color='SM'; break;
        case 'KAKI':color='KK'; break;
        default: color = Excelist[y-2].Color; break;
      }
      String china='',example='',inst='';
      if(_lista_prov2[y-2].DChina!=null){
        china =_lista_prov2[y-2].DChina!;
      }
      if(_lista_prov2[y-2].Example!=null){
        example =_lista_prov2[y-2].Example!;
      }
      if(_lista_prov2[y-2].Inst!=null){
        inst =_lista_prov2[y-2].Inst!;
      }
      String equalprov = _lista_prov2[y-2].proveedores.replaceAll('}','');
      String equalprov1 = equalprov.replaceAll('{','');
      String equalprov2 = equalprov1.replaceAll('"','');
      List<String> st = equalprov2.split(',');
      List<String> filter =<String>[];
      st.forEach((element) {
        if(filter.contains(element)){
        }else if(element!='NULL'&&element!='003'){
          filter.add(element);
        }
      });
      /*if(filter.length != 1){
        _lista_prov3.add(_lista_prov2[y-2]);
      }*/
      int confirm = 2;
      if(filter.length == 1){
        confirm = 1;
      }
      Hoja_Prov2.getRangeByName('B$y').setText(_lista_prov2[y-2].codigo_slim);
      Hoja_Prov2.getRangeByName('C$y').setText(china);
      Hoja_Prov2.getRangeByName('A$y').setText((_lista_prov2[y-2].confimadas/confirm).toStringAsFixed(0));
      Hoja_Prov2.getRangeByName('F$y').setText(_lista_prov2[y-2].costo_ultimo.toStringAsFixed(2));
      Hoja_Prov2.getRangeByName('E$y').setText(_lista_prov2[y-2].SKU);
      Hoja_Prov2.getRangeByName('D$y').setText(color);
      Hoja_Prov2.hyperlinks.add(Hoja_Prov2.getRangeByName('J$y'),xls.HyperlinkType.url, example);
      Hoja_Prov2.getRangeByName('K$y').setText(_lista_prov2[y-2].Inst);
      Hoja_Prov2.getRangeByName('M$y').setText('Descripcion:'+_lista_prov2[y-2].SKU+', Marca:SC, Cantidad: 1Pcs, '+inst+', Hecho en China,'+importador);
      Hoja_Prov2.getRangeByName('N$y').setFormula('=IF(D$y="","*"&B$y&"*","*"&B$y&" "&D$y&"*")');
      Hoja_Prov2.getRangeByName('L$y').setText(importador);
    }

    await ModeloSlim('002', '', '').then((value){
      _lista_prov3.addAll(value);
    });

    for(int y=2;y<_lista_prov3.length+2;y++){
      String? color;
      switch(_lista_prov3[y-2].Color){
        case 'NEGRO':color='BK'; break;
        case 'ROSA':color='PK'; break;
        case 'BLANCO':color='WT'; break;
        case 'GRIS':color='GY'; break;
        case 'AZUL':color='BL'; break;
        case 'AMARILLO':color='YW'; break;
        case 'ROJO':color='RD'; break;
        case 'VERDE':color='GR'; break;
        case 'NARANJA':color='OR'; break;
        case 'MORADO':color='PP'; break;
        case 'CAFÉ':color='BR'; break;
        case 'DORADO':color='GD'; break;
        case 'GRIS ORSCURO':color='DG'; break;
        case 'GRIS CLARO':color='LG'; break;
        case 'AZUL CLARO':color='LG'; break;
        case 'SALMON':color='SM'; break;
        case 'KAKI':color='KK'; break;
        default: color = _lista_prov3[y-2].Color; break;
      }
      String china='',example='',inst='';
      if(_lista_prov3[y-2].DChina!=null){
        china =_lista_prov3[y-2].DChina!;
      }
      if(_lista_prov3[y-2].Example!=null){
        example =_lista_prov3[y-2].Example!;
      }
      if(_lista_prov3[y-2].Inst!=null){
        inst =_lista_prov3[y-2].Inst!;
      }
      String equalprov = _lista_prov3[y-2].proveedores.replaceAll('}','');
      String equalprov1 = equalprov.replaceAll('{','');
      String equalprov2 = equalprov1.replaceAll('"','');
      List<String> st = equalprov2.split(',');
      List<String> filter =<String>[];
      st.forEach((element) {
        if(filter.contains(element)){
        }else if(element!='NULL'&&element!='002'){
          filter.add(element);
        }
      });
      int confirm = 4;
      if(filter.length == 1){
        confirm = 1;
      }
      Hoja_Prov3.getRangeByName('B$y').setText(_lista_prov3[y-2].codigo_slim);
      Hoja_Prov3.getRangeByName('C$y').setText(china);
      Hoja_Prov3.getRangeByName('A$y').setText((_lista_prov3[y-2].confimadas/confirm).toStringAsFixed(0));
      Hoja_Prov3.getRangeByName('F$y').setText(_lista_prov3[y-2].costo_ultimo.toStringAsFixed(2));
      Hoja_Prov3.getRangeByName('E$y').setText(_lista_prov3[y-2].SKU);
      Hoja_Prov3.getRangeByName('D$y').setText(color);
      Hoja_Prov3.hyperlinks.add(Hoja_Prov3.getRangeByName('J$y'),xls.HyperlinkType.url, example);
      Hoja_Prov3.getRangeByName('K$y').setText(_lista_prov3[y-2].Inst);
      Hoja_Prov3.getRangeByName('M$y').setText('Descripcion:'+_lista_prov3[y-2].SKU+', Marca:SC, Cantidad: 1Pcs, '+inst+', Hecho en China,'+importador);
      Hoja_Prov3.getRangeByName('N$y').setFormula('=IF(D$y="","*"&B$y&"*","*"&B$y&" "&D$y&"*")');
      Hoja_Prov3.getRangeByName('L$y').setText(importador);
    }
    //sheet.pictures.worksheet.getRangeByName('O1');
    //_insertar_imagen('AM20001245', sheet);
    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('ddMMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    try{
        await File('//192.168.10.108/Public/VICTOR/SlimData/Excel_Contenedor/$fechasub.xlsx').writeAsBytes(bytes).then((value){
          workbook.dispose();
          print('doSomething() executed in ${stopwatch.elapsed}');
          imagen_mostrar('Excel exportado');
        });
    }on Exception catch(e){
      print(e);
      imagen_mostrar('El archivo esta siendo ocupado,\nO la ruta no es correcta');
    }
  }

  Future<void> Excel_Refacciones(List<slim_order>Excel_Ref) async {
    Stopwatch stopwatch = new Stopwatch()..start();
    List<slim_order>Pantallas_list = Excel_Ref;
    List<slim_order>Touch_list = Excel_Ref;
    List<slim_order>LCD_list = Excel_Ref;
    List<slim_order>Tapas_list = Excel_Ref;
    List<slim_order>Flexores_list = Excel_Ref;
    List<slim_order>Lentecamara_list = Excel_Ref;
    List<slim_order>Sim_list = Excel_Ref;
    List<slim_order>Gorilla_list = Excel_Ref;

    Pantallas_list = Excel_Ref.where((element){
      var lista = element.sublinea2;
      return lista.isEqual(207);
    }).toList();
    Touch_list = Excel_Ref.where((element){
      var lista = element.sublinea2;
      return lista.isEqual(210);
    }).toList();
    LCD_list = Excel_Ref.where((element){
      var lista = element.sublinea2;
      return lista.isEqual(206);
    }).toList();
    Tapas_list = Excel_Ref.where((element){
      var lista = element.sublinea2;
      return lista.isEqual(208);
    }).toList();
    Flexores_list = Excel_Ref.where((element){
      var lista = element.sublinea2;
      return lista.isEqual(204);
    }).toList();
    Lentecamara_list = Excel_Ref.where((element){
      var lista = element.sublinea2;
      return lista.isEqual(203);
    }).toList();
    Sim_list = Excel_Ref.where((element){
      var lista = element.sublinea2;
      return lista.isEqual(202);
    }).toList();
    Gorilla_list = Excel_Ref.where((element){
      var lista = element.sublinea2;
      return lista.isEqual(205);
    }).toList();

    int Pantalla_indx =Pantallas_list.length+2;
    int Touch_indx =Touch_list.length+2;
    int LCD_indx =LCD_list.length+2;
    int Tapas_indx =Tapas_list.length+2;
    int Flexores_indx =Flexores_list.length+2;
    int LenteCamara_indx =Lentecamara_list.length+2;
    int Sim_indx =Sim_list.length+2;
    int Gorilla_indx =Gorilla_list.length+2;

    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet_Pantalla = workbook.worksheets[0];
    sheet_Pantalla.name = 'Pantallas';
    final xls.Worksheet sheet_Touch = workbook.worksheets.add();
    sheet_Touch.name = 'Touch';
    final xls.Worksheet sheet_LCD = workbook.worksheets.add();
    sheet_LCD.name = 'LCD';
    final xls.Worksheet sheet_Tapas = workbook.worksheets.add();
    sheet_Tapas.name = 'Tapas';
    final xls.Worksheet sheet_Flexores = workbook.worksheets.add();
    sheet_Flexores.name = 'Flexores';
    final xls.Worksheet sheet_LenteCamara = workbook.worksheets.add();
    sheet_LenteCamara.name = 'Lente de Camara';
    final xls.Worksheet sheet_Sim = workbook.worksheets.add();
    sheet_Sim.name = 'Sim';
    final xls.Worksheet sheet_Gorilla = workbook.worksheets.add();
    sheet_Gorilla.name = 'Gorilla';

    sheet_Pantalla.showGridlines = true;
    sheet_Pantalla.enableSheetCalculations();
    sheet_Touch.showGridlines = true;
    sheet_Touch.enableSheetCalculations();
    sheet_LCD.showGridlines = true;
    sheet_LCD.enableSheetCalculations();
    sheet_Tapas.showGridlines = true;
    sheet_Tapas.enableSheetCalculations();
    sheet_Flexores.showGridlines = true;
    sheet_Flexores.enableSheetCalculations();
    sheet_LenteCamara.showGridlines = true;
    sheet_LenteCamara.enableSheetCalculations();
    sheet_Sim.showGridlines = true;
    sheet_Sim.enableSheetCalculations();
    sheet_Gorilla.showGridlines = true;
    sheet_Gorilla.enableSheetCalculations();

    sheet_Pantalla.getRangeByName('A1:G1').cellStyle.backColor='#0071FF';
    sheet_Pantalla.getRangeByName('G2:G$Pantalla_indx').cellStyle.fontName='Archon Code 39 Barcode';
    //sheet_Pantalla.getRangeByName('G2:G$Pantalla_indx').cellStyle.wrapText;
    sheet_Pantalla.getRangeByName('G2:G$Pantalla_indx').cellStyle.fontSize=14;
    sheet_Pantalla.getRangeByName('A2:G$Pantalla_indx').cellStyle.hAlign=xls.HAlignType.center;
    sheet_Pantalla.getRangeByName('G2:G$Pantalla_indx').columnWidth=12.0;
    sheet_Pantalla.getRangeByName('F2:F$Pantalla_indx').columnWidth=12;
    sheet_Pantalla.getRangeByName('A2:G$Pantalla_indx').cellStyle.vAlign=xls.VAlignType.center;
    sheet_Pantalla.getRangeByName('A1').setText('Brand');
    sheet_Pantalla.getRangeByName('B1').setText('Model');
    sheet_Pantalla.getRangeByName('C1').setText('Color');
    sheet_Pantalla.getRangeByName('D1').setText('QTY');
    sheet_Pantalla.getRangeByName('E1').setText('WHIT FRAME');
    sheet_Pantalla.getRangeByName('F1').setText('CODIGO SLIM');
    sheet_Pantalla.getRangeByName('G1').setText('Codigo');

    for(int x=2;x<Pantallas_list.length+2;x++){
      sheet_Pantalla.getRangeByName('A$x').setText(Pantallas_list[x-2].Brand);
      sheet_Pantalla.getRangeByName('B$x').setText(Pantallas_list[x-2].Modelo);
      sheet_Pantalla.getRangeByName('C$x').setText(Pantallas_list[x-2].Color);
      sheet_Pantalla.getRangeByName('D$x').setText(Pantallas_list[x-2].confimadas.toString());
      sheet_Pantalla.getRangeByName('E$x').setText(Pantallas_list[x-2].Frame);
      sheet_Pantalla.getRangeByName('F$x').setText(Pantallas_list[x-2].codigo_slim);
      sheet_Pantalla.getRangeByName('G$x').setFormula('=IF(C$x="","*"&F$x&"*","*"&F$x&"*"&" "&C$x&"*")');
    }
    sheet_Touch.getRangeByName('A1:F1').cellStyle.backColor='#0071FF';
    sheet_Touch.getRangeByName('F2:F$Touch_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_Touch.getRangeByName('A1').setText('BRAND');
    sheet_Touch.getRangeByName('B1').setText('MODEL');
    sheet_Touch.getRangeByName('C1').setText('COLOR');
    sheet_Touch.getRangeByName('D1').setText('QTY');
    sheet_Touch.getRangeByName('E1').setText('CODIGO_SLIM');
    sheet_Touch.getRangeByName('F1').setText('CODIGO');

    for(int x=2;x<Touch_list.length+2;x++){
      print(Touch_list[x-2].Brand!+Touch_list[x-2].Modelo!+Touch_list[x-2].Color!+Touch_list[x-2].confimadas.toString()+Touch_list[x-2].codigo_slim);
      sheet_Touch.getRangeByName('A$x').setText(Touch_list[x-2].Brand);
      sheet_Touch.getRangeByName('B$x').setText(Touch_list[x-2].Modelo);
      sheet_Touch.getRangeByName('C$x').setText(Touch_list[x-2].Color);
      sheet_Touch.getRangeByName('D$x').setText(Touch_list[x-2].confimadas.toString());
      sheet_Touch.getRangeByName('E$x').setText(Touch_list[x-2].codigo_slim);
      sheet_Touch.getRangeByName('F$x').setFormula('=IF(C$x="","*"&E$x&"*","*"&E$x&"*"&" "&C$x&"*")');
    }
    sheet_LCD.getRangeByName('A1:E1').cellStyle.backColor='#0071FF';
    sheet_LCD.getRangeByName('E2:E$LCD_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_LCD.getRangeByName('A1').setText('BRAND');
    sheet_LCD.getRangeByName('B1').setText('MODEL');
    sheet_LCD.getRangeByName('C1').setText('QTY');
    sheet_LCD.getRangeByName('D1').setText('CODIGO_SLIM');
    sheet_LCD.getRangeByName('E1').setText('CODIGO');
    for(int x=2;x<LCD_list.length+2;x++){
      sheet_LCD.getRangeByName('A$x').setText(LCD_list[x-2].Brand);
      sheet_LCD.getRangeByName('B$x').setText(LCD_list[x-2].Modelo);
      sheet_LCD.getRangeByName('C$x').setText(LCD_list[x-2].confimadas.toString());
      sheet_LCD.getRangeByName('D$x').setText(LCD_list[x-2].codigo_slim);
      sheet_LCD.getRangeByName('E$x').setFormula('="*"&D$x&"*"');
    }

    sheet_Tapas.getRangeByName('A1:F1').cellStyle.backColor='#0071FF';
    sheet_Tapas.getRangeByName('F2:F$Tapas_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_Tapas.getRangeByName('A1').setText('BRAND');
    sheet_Tapas.getRangeByName('B1').setText('MODEL');
    sheet_Tapas.getRangeByName('C1').setText('COLOR');
    sheet_Tapas.getRangeByName('D1').setText('QTY');
    sheet_Tapas.getRangeByName('E1').setText('CODIGO_SLIM');
    sheet_Tapas.getRangeByName('F1').setText('CODIGO');

    for(int x=2;x<Tapas_list.length+2;x++){
      sheet_Tapas.getRangeByName('A$x').setText(Tapas_list[x-2].Brand);
      sheet_Tapas.getRangeByName('B$x').setText(Tapas_list[x-2].Modelo);
      sheet_Tapas.getRangeByName('C$x').setText(Tapas_list[x-2].Color);
      sheet_Tapas.getRangeByName('D$x').setText(Tapas_list[x-2].confimadas.toString());
      sheet_Tapas.getRangeByName('E$x').setText(Tapas_list[x-2].codigo_slim);
      sheet_Tapas.getRangeByName('F$x').setFormula('=IF(C$x="","*"&E$x&"*","*"&E$x&"*"&" "&C$x&"*")');
    }

    sheet_Flexores.getRangeByName('A1:G1').cellStyle.backColor='#0071FF';
    sheet_Flexores.getRangeByName('G2:G$Flexores_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_Flexores.getRangeByName('A1').setText('BRAND');
    sheet_Flexores.getRangeByName('B1').setText('MODEL');
    sheet_Flexores.getRangeByName('C1').setText('COLOR');
    sheet_Flexores.getRangeByName('D1').setText('TYPE');
    sheet_Flexores.getRangeByName('E1').setText('QTY');
    sheet_Flexores.getRangeByName('F1').setText('CODIGO_SLIM');
    sheet_Flexores.getRangeByName('G1').setText('CODIGO');
    for(int x=2;x<Flexores_list.length+2;x++){
      sheet_Flexores.getRangeByName('A$x').setText(Flexores_list[x-2].Brand);
      sheet_Flexores.getRangeByName('B$x').setText(Flexores_list[x-2].Modelo);
      sheet_Flexores.getRangeByName('C$x').setText(Flexores_list[x-2].Color);
      sheet_Flexores.getRangeByName('D$x').setText(Flexores_list[x-2].Type);
      sheet_Flexores.getRangeByName('E$x').setText(Flexores_list[x-2].confimadas.toString());
      sheet_Flexores.getRangeByName('F$x').setText(Flexores_list[x-2].codigo_slim);
      sheet_Flexores.getRangeByName('G$x').setFormula('=IF(C$x="")"*"&F$x&"*"&" "&C$x&"*"');
    }

    sheet_LenteCamara.getRangeByName('A1:G1').cellStyle.backColor='#0071FF';
    sheet_LenteCamara.getRangeByName('G2:G$LenteCamara_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_LenteCamara.getRangeByName('A1').setText('BRAND');
    sheet_LenteCamara.getRangeByName('B1').setText('MODEL');
    sheet_LenteCamara.getRangeByName('C1').setText('COLOR');
    sheet_LenteCamara.getRangeByName('D1').setText('QTY');
    sheet_LenteCamara.getRangeByName('E1').setText('CON MARCO');
    sheet_LenteCamara.getRangeByName('F1').setText('CODIGO_SLIM');
    sheet_LenteCamara.getRangeByName('G1').setText('CODIGO');
    for(int x=2;x<Lentecamara_list.length+2;x++){
      print(Lentecamara_list[x-2].Brand!+Lentecamara_list[x-2].Modelo!+Lentecamara_list[x-2].Color!+Lentecamara_list[x-2].confimadas.toString()+Lentecamara_list[x-2].Frame!+Lentecamara_list[x-2].codigo_slim);
      sheet_LenteCamara.getRangeByName('A$x').setText(Lentecamara_list[x-2].Brand);
      sheet_LenteCamara.getRangeByName('B$x').setText(Lentecamara_list[x-2].Modelo);
      sheet_LenteCamara.getRangeByName('C$x').setText(Lentecamara_list[x-2].Color);
      sheet_LenteCamara.getRangeByName('D$x').setText(Lentecamara_list[x-2].confimadas.toString());
      sheet_LenteCamara.getRangeByName('E$x').setText(Lentecamara_list[x-2].Frame);
      sheet_LenteCamara.getRangeByName('F$x').setText(Lentecamara_list[x-2].codigo_slim);
      sheet_LenteCamara.getRangeByName('G$x').setFormula('=IF(C$x="","*"&F$x&"*","*"&F$x&"*"&" "&C$x&"*")');
    }

    sheet_Sim.getRangeByName('A1:G1').cellStyle.backColor='#0071FF';
    sheet_Sim.getRangeByName('G2:G$Sim_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_Sim.getRangeByName('A1').setText('BRAND');
    sheet_Sim.getRangeByName('B1').setText('MODEL');
    sheet_Sim.getRangeByName('C1').setText('COLOR');
    sheet_Sim.getRangeByName('D1').setText('TYPE');
    sheet_Sim.getRangeByName('E1').setText('QTY');
    sheet_Sim.getRangeByName('F1').setText('CODIGO_SLIM');
    sheet_Sim.getRangeByName('G1').setText('CODIGO');
    for(int x=2;x<Sim_list.length+2;x++){
      sheet_Sim.getRangeByName('A$x').setText(Sim_list[x-2].Brand);
      sheet_Sim.getRangeByName('B$x').setText(Sim_list[x-2].Modelo);
      sheet_Sim.getRangeByName('C$x').setText(Sim_list[x-2].Color);
      sheet_Sim.getRangeByName('D$x').setText(Sim_list[x-2].Type);
      sheet_Sim.getRangeByName('E$x').setText(Sim_list[x-2].confimadas.toString());
      sheet_Sim.getRangeByName('F$x').setText(Sim_list[x-2].codigo_slim);
      sheet_Sim.getRangeByName('G$x').setFormula('=IF(C$x="","*"&F$x&"*","*"&F$x&"*"&" "&C$x&"*")');
    }

    sheet_Gorilla.getRangeByName('A1:F1').cellStyle.backColor='#0071FF';
    sheet_Gorilla.getRangeByName('F2:F$Gorilla_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_Gorilla.getRangeByName('A1').setText('BRAND');
    sheet_Gorilla.getRangeByName('B1').setText('MODEL');
    sheet_Gorilla.getRangeByName('C1').setText('COLOR');
    sheet_Gorilla.getRangeByName('D1').setText('QTY');
    sheet_Gorilla.getRangeByName('E1').setText('CODIGO_SLIM');
    sheet_Gorilla.getRangeByName('F1').setText('CODIGO');
    for(int x=2;x<Gorilla_list.length+2;x++){
      sheet_Gorilla.getRangeByName('A$x').setText(Gorilla_list[x-2].Brand);
      sheet_Gorilla.getRangeByName('B$x').setText(Gorilla_list[x-2].Modelo);
      sheet_Gorilla.getRangeByName('C$x').setText(Gorilla_list[x-2].Color);
      sheet_Gorilla.getRangeByName('D$x').setText(Gorilla_list[x-2].confimadas.toString());
      sheet_Gorilla.getRangeByName('E$x').setText(Gorilla_list[x-2].codigo_slim);
      sheet_Gorilla.getRangeByName('F$x').setFormula('=IF(C$x="","*"&E$x&"*","*"&E$x&"*"&" "&C$x&"*")');
    }

    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('dMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    try{
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if(selectedDirectory==null){

      }else{
       String direccion= selectedDirectory.replaceAll(r'\','/');
        await File('$direccion/$fechasub'+'-$provider'+'.xlsx').writeAsBytes(bytes).then((value){
          //print('//192.168.10.108/Public/VICTOR/SlimData/Excel_Refacciones/$fechasub'+'-$provider'+'.xlsx');
          print('$direccion/$fechasub'+'-$provider'+'.xlsx');
          workbook.dispose();
          print('doSomething() executed in ${stopwatch.elapsed}');
          imagen_mostrar('Excel exportado');
        });
      }
      //await File('//192.168.10.108/Public/VICTOR/SlimData/Excel_Refacciones/$fechasub'+'-$provider'+'.xlsx').writeAsBytes(bytes).then((value){
    }on Exception catch(e){
      print(e);
      imagen_mostrar('El archivo esta siendo ocupado,\nO la ruta no es correcta');
    }
  }

  imagen_mostrar(String s) async {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        content: Text(s,
          style: TextStyle(fontWeight: FontWeight.bold),),
        actions: <Widget>[
          TextButton(onPressed: (){
            FilePickers();
          }, child: Text('Insertar Imagenes'),)
        ],
      );
      FilePickers();
    }
   );
  }

}

class items_confirmados extends DataTableSource{
  List<slim_order> _list = <slim_order>[];
  String user;
  List<Proveedores> provs_list;
  items_confirmados(this._list, this.user, this.provs_list);

  @override
  DataRow? getRow(int index) {
    if(index>=_list.length)throw'No';
    final _item=_list[index];

    return DataRow2.byIndex(
        index: index,
        cells:[
          DataCell(SelectableText(_item.codigo_slim,
            cursorColor: Colors.black,
            showCursor: true,
            toolbarOptions: ToolbarOptions(
              copy: true,
            ),)),
          DataCell(Text(_item.Desc)),
          //DataCell(Text('SKU')),
          DataCell(Colortxt(item: _item, user: user)),
          DataCell(Text(_item.costo_ultimo.toStringAsFixed(0))),
          DataCell(Cantidadtxt(item:_list[index],user:user)),
          DataCell(Text((_item.costo_ultimo*_item.confimadas).toStringAsFixed(2))),
          DataCell(Image.network(_item.Thumbnail.toString())),
          DataCell(Exampletxt(item:_item)),
          DataCell(Instxt(item: _item,)),
          DataCell(DChina(item: _item,)),
          DataCell(imagenlist(item:_item,)),
          DataCell(BRAND(item: _item)),
          DataCell(FRAME(item: _item)),
          DataCell(TYPE(item: _item)),
          DataCell(MODELO(item: _item)),
          /*DataCell(Eliminar_confirmado(item:_item,user:user,folio:''),
          onTap: (){
            _list.remove(_item);
          },
        ),*/
     ]);
  }

  @override
  int get rowCount => _list.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

}
