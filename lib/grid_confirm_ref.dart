import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:datatable/Modelo_contenedor/Slim_model.dart';
import 'package:datatable/pedidos.dart';
import 'package:datatable/widgets_contenedor/widgets_confirmados.dart';
import 'package:datatable/widgets_contenedor/widgets_contenedor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Modelo_contenedor/model.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

class Grid_Confirm_ref extends StatelessWidget {
  String user;
  folios folio;
  Grid_Confirm_ref({Key? key,required this.user,required this.folio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: grid_ref(user: user, folio: folio),
    );
  }
}

class grid_ref extends StatefulWidget {
  String user;
  folios folio;
  grid_ref({Key? key,required this.user, required this.folio}) : super(key: key);

  @override
  State<grid_ref> createState() => _grid_refState();
}

class _grid_refState extends State<grid_ref> {
  double desccolumnwidth=250;
  double skuccolumnwidth=250;
  late source_conf source;
  List<slim_order> _lista = <slim_order>[];
  List<slim_order> lista_folio = <slim_order>[];
  List<slim_order> Excellist = <slim_order>[];
  bool Tipodrop=false;
@override
  void initState() {
    Ordenes();
    super.initState();
  }
  Ordenes()async{
    await Orden_class().Orden(widget.folio.Folio,widget.folio.Proveedor,'',true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value){
      setState(() {
        lista_folio.addAll(value);
        for(int x=0;x<lista_folio.length;x++){
          if(lista_folio[x].folio==widget.folio.Folio&&lista_folio[x].confimadas!=0){
            _lista.add(lista_folio[x]);
          }
        }
        source=source_conf(lista_confirmados: _lista,user:widget.user,folio: widget.folio);
      });
    });
  }
  String dropdownsub2 = '*';
  String sub2 = '000';
  var item_s2 = [
    '*',
    'BATERIAS GENERICAS',
    'BATERIAS SC','CHAROLA SIM',
    'CRISTAL DE CAMARA','FLEXORES',
    'GORILLA GLASS','LCD DISPLAY',
    'PANTALLA COMPLETA','TAPA','TORNILLOS',
    'TOUCH TACTIL'
  ];
  @override
  Widget build(BuildContext context) {
    if(widget.folio.Tipo=='R'){
      Tipodrop = true;
    }
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Pedidos(user: widget.user, folio: widget.folio)), (Route<dynamic> route) => false);
        }, icon: Icon(Icons.arrow_back)),
        title: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              width: 250,
              child: TextField(
                showCursor: true,
                cursorColor: Colors.white,
                style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),
                decoration: InputDecoration(hintText: 'Buscar...'),
                controller: controller,
                onSubmitted: (String? value){
                  _lista.clear();
                  lista_folio.clear();
                  Orden_class().Orden(widget.folio.Folio,widget.folio.Proveedor,controller.text, true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),sub2 ,widget.folio.Tipo).then((value) {
                    setState(() {
                      lista_folio.addAll(value);
                      for(int x=0;x<lista_folio.length;x++){
                        if(lista_folio[x].folio==widget.folio.Folio&&lista_folio[x].confimadas!=0){
                          _lista.add(lista_folio[x]);
                        }
                      }
                      source=source_conf(lista_confirmados: _lista,user:widget.user,folio: widget.folio);
                    });
                  });
                },
              ),
            ),
            Visibility(
                visible: Tipodrop,
                child: FittedBox(
                  child: DropdownButton(
                      underline: Text('Sublinea 2',style:
                      TextStyle(fontSize: 10,height: 15),),
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
                          lista_folio.clear();
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
                          Orden_class().Orden(widget.folio.Folio,widget.folio.Proveedor,'',true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),sub2,widget.folio.Tipo).then((value){
                            setState(() {
                              lista_folio.addAll(value);
                              for(int x=0;x<lista_folio.length;x++){
                                if(lista_folio[x].folio==widget.folio.Folio&&lista_folio[x].confimadas!=0){
                                  _lista.add(lista_folio[x]);
                                }
                              }
                              source=source_conf(lista_confirmados: _lista,user:widget.user,folio: widget.folio);
                            });
                          });
                        });
                      }),
                )
            ),
          ],
        ),
        actions: <Widget>[
        IconButton(onPressed: (){
          _lista.clear();
          lista_folio.clear();
          Orden_class().Orden(widget.folio.Folio,widget.folio.Proveedor,'',true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value){
            setState(() {
              lista_folio.addAll(value);
              for(int x=0;x<lista_folio.length;x++){
                if(lista_folio[x].folio==widget.folio.Folio&&lista_folio[x].confimadas!=0){
                  _lista.add(lista_folio[x]);
                }
              }
              source=source_conf(lista_confirmados: _lista,user:widget.user,folio: widget.folio);
            });
          });
        }, icon: Icon(Icons.refresh)),
        IconButton(onPressed: (){
          Excellist.clear();
          Orden_class().Orden(widget.folio.Folio,widget.folio.Proveedor,'',true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value) {
            setState((){
              Excellist.addAll(value);
              try{
                  Excel_Refacciones(Excellist, widget.folio.Folio,widget.folio.Proveedor);
              } on Exception catch(e){
                print(e);
              }
            });
          });
        }, icon: Icon(Icons.save)),
        ],
      ),
      body: SfDataGrid(
          allowFiltering: true,
          selectionMode: SelectionMode.single,
          navigationMode: GridNavigationMode.cell,
          allowSorting: true,
          allowColumnsResizing: true,
          columnResizeMode: ColumnResizeMode.onResizeEnd,
          columnWidthMode: ColumnWidthMode.fill,
          source: source,
          columns: <GridColumn>[
            GridColumn(columnName:'Cod_Slim', label: Text('Codigo\nSlim'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Desc', label: Text('Descripcion'),allowSorting: true,allowFiltering: true,width: desccolumnwidth),
            GridColumn(columnName:'SKU', label: Text('SKU'),allowSorting: true,allowFiltering: true,width:skuccolumnwidth),
            GridColumn(columnName:'Color', label: Text('Color'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Costo', label: Text('Costo'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Confirmadas', label: Text('Confirmadas'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Total', label: Text('Total'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Usuario', label: Text('Usuario'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Imagen', label: Text('Imagen'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Brand', label: Text('Brand'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Frame', label: Text('Frame'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Type', label: Text('Type'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Modelo', label: Text('Modelo'),allowSorting: true,allowFiltering: true,),
            GridColumn(columnName:'Eliminar', label: Text('Eliminar'),allowSorting: true,allowFiltering: true,),
          ],
        onColumnResizeUpdate: (ColumnResizeUpdateDetails args){
          setState(() {
            if(args.column.columnName=='Desc'){
              desccolumnwidth = args.width;
            }
            if(args.column.columnName=='SKU'){
              skuccolumnwidth = args.width;
            }
          });
          return true;
        },
      ),
    );
  }
  Future<void> Excel_Refacciones(List<slim_order>Excel_Ref,String folio,String provider)async{
    Stopwatch stopwatch = new Stopwatch()..start();
    List<slim_order>Pantallas_list = <slim_order>[];
    List<slim_order>Touch_list = <slim_order>[];
    List<slim_order>LCD_list = <slim_order>[];
    List<slim_order>Tapas_list = <slim_order>[];
    List<slim_order>Flexores_list = <slim_order>[];
    List<slim_order>Lentecamara_list = <slim_order>[];
    List<slim_order>Sim_list = <slim_order>[];
    List<slim_order>Gorilla_list = <slim_order>[];
    for(int x=0;x<Excel_Ref.length;x++){
      switch(Excel_Ref[x].sublinea2){
        case 207: if(Excel_Ref[x].folio==folio&&Excel_Ref[x].confimadas!=0){Pantallas_list.add(Excel_Ref[x]);}break;
        case 210: if(Excel_Ref[x].folio==folio&&Excel_Ref[x].confimadas!=0){Touch_list.add(Excel_Ref[x]);}break;
        case 206: if(Excel_Ref[x].folio==folio&&Excel_Ref[x].confimadas!=0){LCD_list.add(Excel_Ref[x]);}break;
        case 208: if(Excel_Ref[x].folio==folio&&Excel_Ref[x].confimadas!=0){Tapas_list.add(Excel_Ref[x]);}break;
        case 204: if(Excel_Ref[x].folio==folio&&Excel_Ref[x].confimadas!=0){Flexores_list.add(Excel_Ref[x]);}break;
        case 203: if(Excel_Ref[x].folio==folio&&Excel_Ref[x].confimadas!=0){Lentecamara_list.add(Excel_Ref[x]);}break;
        case 202: if(Excel_Ref[x].folio==folio&&Excel_Ref[x].confimadas!=0){Sim_list.add(Excel_Ref[x]);}break;
        case 205: if(Excel_Ref[x].folio==folio&&Excel_Ref[x].confimadas!=0){Gorilla_list.add(Excel_Ref[x]);}break;
      }
    }
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
}

class source_conf extends DataGridSource{
  List<slim_order> lista_confirmados = <slim_order>[];
  String user;
  folios folio;

  source_conf({required this.lista_confirmados,required this.user,required this.folio}){
    _Dataconfirmados = lista_confirmados.map<DataGridRow>((e) =>
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Cod_Slim', value:e.codigo_slim),
          DataGridCell<String>(columnName: 'Desc', value:e.Desc),
          DataGridCell<String>(columnName: 'SKU', value:e.SKU),
          DataGridCell<String>(columnName: 'Color', value:e.Color),
          DataGridCell<String>(columnName: 'Costo', value:e.costo_ultimo.toStringAsFixed(0)),
          DataGridCell<num>(columnName: 'Confirmadas', value:e.confimadas),
          DataGridCell<String>(columnName: 'Total', value:(e.confimadas*e.costo_ultimo).toStringAsFixed(0)),
          DataGridCell<String>(columnName: 'Usuario', value: e.usuario),
          DataGridCell<String>(columnName: 'Imagen', value:e.Thumbnail),
          DataGridCell<String>(columnName: 'Brand', value:e.Brand),
          DataGridCell<String>(columnName: 'Frame', value:e.Frame),
          DataGridCell<String>(columnName: 'Type', value:e.Type),
          DataGridCell<String>(columnName: 'Modelo', value:e.Modelo),
          DataGridCell<slim_order>(columnName: 'Eliminar', value:e),
        ])).toList();
  }
  List<DataGridRow> _Dataconfirmados = [];
  @override
  List<DataGridRow> get rows => _Dataconfirmados;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: <Widget>[
          Container(alignment: Alignment.center,
            child: GestureDetector(child: Text(row.getCells()[0].value),onTap:(){Clipboard.setData(ClipboardData(text:row.getCells()[0].value));},),),
          Container(alignment: Alignment.center,
            child: Text(row.getCells()[1].value),),
          Container(alignment: Alignment.center,
            child: Text(row.getCells()[2].value),),
          Container(alignment: Alignment.center,
            child: Colortxt(item:row.getCells()[13].value, user: user),),
          Container(alignment: Alignment.center,
              child: Text(row.getCells()[4].value)),
          Container(alignment: Alignment.center,
            child: Confirmados_txt2(value:row.getCells()[13].value, user: user, folio: folio),),
          Container(alignment: Alignment.center,
            child: Text(row.getCells()[6].value.toString()),),
          Container(alignment: Alignment.center,
            child: Text(row.getCells()[7].value),),
          Container(alignment: Alignment.center,
            child: Image.network(row.getCells()[8].value),),
          Container(alignment: Alignment.center,padding: EdgeInsets.all(5.0),
            child: BRAND(item:row.getCells()[13].value),),
          Container(alignment: Alignment.center,padding: EdgeInsets.all(5.0),
            child: FRAME(item:row.getCells()[13].value),),
          Container(alignment: Alignment.center,padding: EdgeInsets.all(5.0),
            child: TYPE(item:row.getCells()[13].value),),
          Container(alignment: Alignment.center,padding: EdgeInsets.all(5.0),
            child: MODELO(item:row.getCells()[13].value),),
          Container(alignment: Alignment.center,
            child: Eliminar_confirmado(item: row.getCells()[13].value, user: user,folio: folio,),),
        ]);
  }
}

