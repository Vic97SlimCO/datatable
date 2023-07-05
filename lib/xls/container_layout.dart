import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:datatable/Modelo_contenedor/slim_container.dart';
import 'package:url_launcher/url_launcher.dart';

class container_layout{
  Future<void> generateExcelContainer(List<confirmadas_container> Excelist,Folio_Container folio,BuildContext context)async{
    Stopwatch stopwatch = new Stopwatch()..start();

    int indx = Excelist.length+2;
    String importador= 'Importador: importador y exportador crown sa de cv \nDirección: pina 264, nueva santa maria, azcapotzalco, cdmx, cp: 02800 \nrfc: IEC141020Q36 \ntel: 5589427000';
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
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

    for(int x=2;x<Excelist.length+2;x++){
      String? color;
      String china='',example='',inst='';
      if(Excelist[x-2].dESCCHINA!=null){
        china =Excelist[x-2].dESCCHINA;
      }
      if(Excelist[x-2].eXAMPLE!=null){
        example =Excelist[x-2].eXAMPLE;
      }
      if(Excelist[x-2].iNSTRUCCIONES!=null){
        inst =Excelist[x-2].iNSTRUCCIONES;
      }
      switch(Excelist[x-2].cOLOR){
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
        default: color = Excelist[x-2].cOLOR; break;
      }
      sheet.getRangeByName('A$x').setNumber(Excelist[x-2].qUANTITY.toDouble());
      sheet.getRangeByName('B$x').setText(Excelist[x-2].cODIGO);
      sheet.getRangeByName('C$x').setText(china);
      sheet.getRangeByName('D$x').setText(color);
      //sheet.getRangeByName('E$x').setText(Excelist[x-2].s);
      sheet.getRangeByName('F$x').setNumber(Excelist[x-2].cOSTOULTIMO.toDouble());
      sheet.hyperlinks.add(sheet.getRangeByName('J$x'),xls.HyperlinkType.url, example);
      sheet.getRangeByName('K$x').setText(inst);
      sheet.getRangeByName('M$x').setText('Descripcion:'+Excelist[x-2].sku+', Marca:SC, Cantidad: 1Pcs, '+inst+', Hecho en China,'+importador);//En codgio va el SKU
      sheet.getRangeByName('N$x').setFormula('=IF(D$x="","*"&B$x&"*","*"&B$x&" "&D$x&"*")');
      sheet.getRangeByName('L$x').setText(importador);
    }
    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('ddMMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    /*String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    selectedDirectory?.replaceAll('/\\/g', '/');
    print(selectedDirectory);*/
    try{
    await File('//192.168.10.109/Public/PROGRA/VICTOR/SlimData/Excel_Contenedor/$fechasub.xlsx').writeAsBytes(bytes).then((value){
          workbook.dispose();
          print('doSomething() executed in ${stopwatch.elapsed}');
          imagen_mostrar('Excel exportado',context,'Container');
        });
    }on Exception catch(e){
      print(e);
      imagen_mostrar('El archivo esta siendo ocupado,\nO la ruta no es correcta',context,'Container');
    }
  }

  Future<void> generateACCMX(List<confirmadas_container>Excelist,String folio,BuildContext context)async{
    Stopwatch stopwatch = new Stopwatch()..start();
    int indx = Excelist.length+2;
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;
    sheet.enableSheetCalculations();
    sheet.getRangeByName('A1:E1').columnWidth=12.0;
    sheet.getRangeByName('A1:E1').cellStyle.fontColor='#FFFFFF';
    sheet.getRangeByName('A1:E1').cellStyle.backColor='#0071FF';
    sheet.getRangeByName('B1:B$indx').columnWidth=80;
    sheet.getRangeByName('D1:D$indx').columnWidth=100;
    //sheet.getRangeByName('A1:E$indx').rowHeight = 80.0;
    sheet.getRangeByName('A1:E$indx').cellStyle.hAlign=xls.HAlignType.center;
    sheet.getRangeByName('A1:E$indx').cellStyle.vAlign=xls.VAlignType.center;
    sheet.getRangeByName('A1:E$indx').cellStyle.wrapText= true;
    sheet.getRangeByName('A2:E$indx').cellStyle.backColor='#A4CDFF';
    sheet.getRangeByName('A1:E$indx').cellStyle.bold;
    sheet.getRangeByName('A1:E$indx').cellStyle.fontSize=25;

    sheet.getRangeByName('A1').setText('Piezas');
    sheet.getRangeByName('B1').setText('Producto');
    sheet.getRangeByName('C1').setText('Color');
    //sheet.getRangeByName('E1').setText('Concatenado');
    sheet.getRangeByName('D1').setText('Concatenado');

    for(int x=2;x<Excelist.length+2;x++){
      String? color='';
      switch(Excelist[x-2].cOLOR){
        case 'BK':color='NEGRO'; break;
        case 'PK':color='ROSA'; break;
        case 'WT':color='BLANCO'; break;
        case 'GY':color='GRIS'; break;
        case 'BL':color='AZUL'; break;
        case 'YW':color='AMARILLO'; break;
        case 'RD':color='ROJO'; break;
        case 'GR':color='VERDE'; break;
        case 'OR':color='NARANJA'; break;
        case 'PP':color='MORADO'; break;
        case 'BR':color='CAFÉ'; break;
        case 'GD':color='DORADO'; break;
        case 'DG':color='GRIS ORSCURO'; break;
        case 'LG':color='GRIS CLARO'; break;
        case 'LB':color='AZUL CLARO'; break;
        case 'SM':color='SALMON'; break;
        case 'KK':color='KAKI'; break;
        case 'WN':color='VINO'; break;
        default: color = Excelist[x-2].cOLOR; break;
      }
      sheet.getRangeByName('A$x').setNumber(Excelist[x-2].qUANTITY.toDouble());
      sheet.getRangeByName('B$x').setText(Excelist[x-2].dESCMX);
      sheet.getRangeByName('C$x').setText(color);
      sheet.getRangeByName('D$x').setText(Excelist[x-2].dESCMX+''+'-'+''+color+''+Excelist[x-2].qUANTITY.toString());
    }
    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('ddMMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    selectedDirectory?.replaceAll('/\\/g', '/');
    print(selectedDirectory);
    try{
        await File('${selectedDirectory}/'+folio+'_$fechasub.xlsx').writeAsBytes(bytes).then((value){
        workbook.dispose();
        print('doSomething() executed in ${stopwatch.elapsed}');
        imagen_mostrar('Excel exportado',context,'ACCMX');
      });
    }on Exception catch(e){
      print(e);
      imagen_mostrar('El archivo esta siendo ocupado,\nO la ruta no es correcta',context,'ACCMX');
    }
  }

  Future<void> Excel_Refacciones(List<confirmadas_container>Excel_Ref,BuildContext context) async {
    Stopwatch stopwatch = new Stopwatch()..start();
    List<confirmadas_container>Pantallas_list = Excel_Ref;
    List<confirmadas_container>Touch_list = Excel_Ref;
    List<confirmadas_container>LCD_list = Excel_Ref;
    List<confirmadas_container>Tapas_list = Excel_Ref;
    List<confirmadas_container>Flexores_list = Excel_Ref;
    List<confirmadas_container>Lentecamara_list = Excel_Ref;
    List<confirmadas_container>Sim_list = Excel_Ref;
    List<confirmadas_container>Gorilla_list = Excel_Ref;
    List<confirmadas_container>Bateria_list = Excel_Ref;
    List<confirmadas_container>BateriaSC_list = Excel_Ref;
    Bateria_list = Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
      return lista.isEqual(200);
    }).toList();
    BateriaSC_list =Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
      return lista.isEqual(201);
    }).toList();
    Pantallas_list = Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
      return lista.isEqual(207);
    }).toList();
    Touch_list = Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
      return lista.isEqual(210);
    }).toList();
    LCD_list = Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
      return lista.isEqual(206);
    }).toList();
    Tapas_list = Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
      return lista.isEqual(208);
    }).toList();
    Flexores_list = Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
      return lista.isEqual(204);
    }).toList();
    Lentecamara_list = Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
      return lista.isEqual(203);
    }).toList();
    Sim_list = Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
      return lista.isEqual(202);
    }).toList();
    Gorilla_list = Excel_Ref.where((element){
      var lista = element.sUBLINEA2ID;
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
    int Bateria_indx = Bateria_list.length+2;
    int BateriaSC_indx = BateriaSC_list.length+2;

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
    final xls.Worksheet sheet_Baterias = workbook.worksheets.add();
    sheet_Baterias.name = 'Baterias';
    final xls.Worksheet sheet_BateriasSC = workbook.worksheets.add();
    sheet_BateriasSC.name = 'BateriasSC';

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
    sheet_Baterias.showGridlines = true;
    sheet_Baterias.enableSheetCalculations();
    sheet_BateriasSC.showGridlines = true;
    sheet_BateriasSC.enableSheetCalculations();

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
    sheet_Pantalla.getRangeByName('H1').setText('Ultimo Proveedor');

    for(int x=2;x<Pantallas_list.length+2;x++){
      sheet_Pantalla.getRangeByName('A$x').setText(Pantallas_list[x-2].bRAND);
      sheet_Pantalla.getRangeByName('B$x').setText(Pantallas_list[x-2].mODELO);
      sheet_Pantalla.getRangeByName('C$x').setText(Pantallas_list[x-2].cOLOR);
      sheet_Pantalla.getRangeByName('D$x').setText(Pantallas_list[x-2].qUANTITY.toString());
      sheet_Pantalla.getRangeByName('E$x').setText(Pantallas_list[x-2].fRAME);
      sheet_Pantalla.getRangeByName('F$x').setText(Pantallas_list[x-2].cODIGO);
      sheet_Pantalla.getRangeByName('G$x').setFormula('=IF(C$x="","*"&F$x&"*","*"&F$x&"*"&" "&C$x&"*")');
      sheet_Pantalla.getRangeByName('H$x').setText(Pantallas_list[x-2].proveedor);
    }
    sheet_Touch.getRangeByName('A1:F1').cellStyle.backColor='#0071FF';
    sheet_Touch.getRangeByName('F2:F$Touch_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_Touch.getRangeByName('A1').setText('BRAND');
    sheet_Touch.getRangeByName('B1').setText('MODEL');
    sheet_Touch.getRangeByName('C1').setText('COLOR');
    sheet_Touch.getRangeByName('D1').setText('QTY');
    sheet_Touch.getRangeByName('E1').setText('CODIGO_SLIM');
    sheet_Touch.getRangeByName('F1').setText('CODIGO');
    sheet_Touch.getRangeByName('G1').setText('Ultimo Proveedor');

    for(int x=2;x<Touch_list.length+2;x++){
      print(Touch_list[x-2].bRAND!+Touch_list[x-2].mODELO!+Touch_list[x-2].cOLOR!+Touch_list[x-2].qUANTITY.toString()+Touch_list[x-2].cODIGO);
      sheet_Touch.getRangeByName('A$x').setText(Touch_list[x-2].bRAND);
      sheet_Touch.getRangeByName('B$x').setText(Touch_list[x-2].mODELO);
      sheet_Touch.getRangeByName('C$x').setText(Touch_list[x-2].cOLOR);
      sheet_Touch.getRangeByName('D$x').setText(Touch_list[x-2].qUANTITY.toString());
      sheet_Touch.getRangeByName('E$x').setText(Touch_list[x-2].cODIGO);
      sheet_Touch.getRangeByName('F$x').setFormula('=IF(C$x="","*"&E$x&"*","*"&E$x&"*"&" "&C$x&"*")');
      sheet_Touch.getRangeByName('G$x').setText(Touch_list[x-2].proveedor);
    }
    sheet_LCD.getRangeByName('A1:E1').cellStyle.backColor='#0071FF';
    sheet_LCD.getRangeByName('E2:E$LCD_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_LCD.getRangeByName('A1').setText('BRAND');
    sheet_LCD.getRangeByName('B1').setText('MODEL');
    sheet_LCD.getRangeByName('C1').setText('QTY');
    sheet_LCD.getRangeByName('D1').setText('CODIGO_SLIM');
    sheet_LCD.getRangeByName('E1').setText('CODIGO');
    sheet_LCD.getRangeByName('F1').setText('Ultimo Proovedor');
    for(int x=2;x<LCD_list.length+2;x++){
      sheet_LCD.getRangeByName('A$x').setText(LCD_list[x-2].bRAND);
      sheet_LCD.getRangeByName('B$x').setText(LCD_list[x-2].mODELO);
      sheet_LCD.getRangeByName('C$x').setText(LCD_list[x-2].qUANTITY.toString());
      sheet_LCD.getRangeByName('D$x').setText(LCD_list[x-2].cODIGO);
      sheet_LCD.getRangeByName('E$x').setFormula('="*"&D$x&"*"');
      sheet_LCD.getRangeByName('F$x').setText(LCD_list[x-2].proveedor);
    }

    sheet_Tapas.getRangeByName('A1:F1').cellStyle.backColor='#0071FF';
    sheet_Tapas.getRangeByName('F2:F$Tapas_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_Tapas.getRangeByName('A1').setText('BRAND');
    sheet_Tapas.getRangeByName('B1').setText('MODEL');
    sheet_Tapas.getRangeByName('C1').setText('COLOR');
    sheet_Tapas.getRangeByName('D1').setText('QTY');
    sheet_Tapas.getRangeByName('E1').setText('CODIGO_SLIM');
    sheet_Tapas.getRangeByName('F1').setText('CODIGO');
    sheet_Tapas.getRangeByName('G1').setText('Ultimo Proveedor');

    for(int x=2;x<Tapas_list.length+2;x++){
      sheet_Tapas.getRangeByName('A$x').setText(Tapas_list[x-2].bRAND);
      sheet_Tapas.getRangeByName('B$x').setText(Tapas_list[x-2].mODELO);
      sheet_Tapas.getRangeByName('C$x').setText(Tapas_list[x-2].cOLOR);
      sheet_Tapas.getRangeByName('D$x').setText(Tapas_list[x-2].qUANTITY.toString());
      sheet_Tapas.getRangeByName('E$x').setText(Tapas_list[x-2].cODIGO);
      sheet_Tapas.getRangeByName('F$x').setFormula('=IF(C$x="","*"&E$x&"*","*"&E$x&"*"&" "&C$x&"*")');
      sheet_Tapas.getRangeByName('E$x').setText(Tapas_list[x-2].proveedor);
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
    sheet_Flexores.getRangeByName('H1').setText('Ultimo Proovedor');
    for(int x=2;x<Flexores_list.length+2;x++){
      sheet_Flexores.getRangeByName('A$x').setText(Flexores_list[x-2].bRAND);
      sheet_Flexores.getRangeByName('B$x').setText(Flexores_list[x-2].mODELO);
      sheet_Flexores.getRangeByName('C$x').setText(Flexores_list[x-2].cOLOR);
      sheet_Flexores.getRangeByName('D$x').setText(Flexores_list[x-2].tYPE);
      sheet_Flexores.getRangeByName('E$x').setText(Flexores_list[x-2].qUANTITY.toString());
      sheet_Flexores.getRangeByName('F$x').setText(Flexores_list[x-2].cODIGO);
      sheet_Flexores.getRangeByName('G$x').setFormula('=IF(C$x="")"*"&F$x&"*"&" "&C$x&"*"');
      sheet_Flexores.getRangeByName('H$x').setText(Flexores_list[x-2].proveedor);
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
    sheet_LenteCamara.getRangeByName('H1').setText('Ultimo Proveedor');
    for(int x=2;x<Lentecamara_list.length+2;x++){
      print(Lentecamara_list[x-2].bRAND!+Lentecamara_list[x-2].mODELO!+Lentecamara_list[x-2].cOLOR!+Lentecamara_list[x-2].qUANTITY.toString()+Lentecamara_list[x-2].fRAME!+Lentecamara_list[x-2].cODIGO);
      sheet_LenteCamara.getRangeByName('A$x').setText(Lentecamara_list[x-2].bRAND);
      sheet_LenteCamara.getRangeByName('B$x').setText(Lentecamara_list[x-2].mODELO);
      sheet_LenteCamara.getRangeByName('C$x').setText(Lentecamara_list[x-2].cOLOR);
      sheet_LenteCamara.getRangeByName('D$x').setText(Lentecamara_list[x-2].qUANTITY.toString());
      sheet_LenteCamara.getRangeByName('E$x').setText(Lentecamara_list[x-2].fRAME);
      sheet_LenteCamara.getRangeByName('F$x').setText(Lentecamara_list[x-2].cODIGO);
      sheet_LenteCamara.getRangeByName('G$x').setFormula('=IF(C$x="","*"&F$x&"*","*"&F$x&"*"&" "&C$x&"*")');
      sheet_LenteCamara.getRangeByName('H$x').setText(Lentecamara_list[x-2].proveedor);
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
    sheet_Sim.getRangeByName('H1').setText('Ultimo Proveedor');
    for(int x=2;x<Sim_list.length+2;x++){
      sheet_Sim.getRangeByName('A$x').setText(Sim_list[x-2].bRAND);
      sheet_Sim.getRangeByName('B$x').setText(Sim_list[x-2].mODELO);
      sheet_Sim.getRangeByName('C$x').setText(Sim_list[x-2].cOLOR);
      sheet_Sim.getRangeByName('D$x').setText(Sim_list[x-2].tYPE);
      sheet_Sim.getRangeByName('E$x').setText(Sim_list[x-2].qUANTITY.toString());
      sheet_Sim.getRangeByName('F$x').setText(Sim_list[x-2].cODIGO);
      sheet_Sim.getRangeByName('G$x').setFormula('=IF(C$x="","*"&F$x&"*","*"&F$x&"*"&" "&C$x&"*")');
      sheet_Sim.getRangeByName('H$x').setText(Sim_list[x-2].proveedor);
    }

    sheet_Gorilla.getRangeByName('A1:F1').cellStyle.backColor='#0071FF';
    sheet_Gorilla.getRangeByName('F2:F$Gorilla_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_Gorilla.getRangeByName('A1').setText('BRAND');
    sheet_Gorilla.getRangeByName('B1').setText('MODEL');
    sheet_Gorilla.getRangeByName('C1').setText('COLOR');
    sheet_Gorilla.getRangeByName('D1').setText('QTY');
    sheet_Gorilla.getRangeByName('E1').setText('CODIGO_SLIM');
    sheet_Gorilla.getRangeByName('F1').setText('CODIGO');
    sheet_Gorilla.getRangeByName('G1').setText('Ultimo Proveedor');
    for(int x=2;x<Gorilla_list.length+2;x++){
      sheet_Gorilla.getRangeByName('A$x').setText(Gorilla_list[x-2].bRAND);
      sheet_Gorilla.getRangeByName('B$x').setText(Gorilla_list[x-2].mODELO);
      sheet_Gorilla.getRangeByName('C$x').setText(Gorilla_list[x-2].cOLOR);
      sheet_Gorilla.getRangeByName('D$x').setText(Gorilla_list[x-2].qUANTITY.toString());
      sheet_Gorilla.getRangeByName('E$x').setText(Gorilla_list[x-2].cODIGO);
      sheet_Gorilla.getRangeByName('F$x').setFormula('=IF(C$x="","*"&E$x&"*","*"&E$x&"*"&" "&C$x&"*")');
      sheet_Gorilla.getRangeByName('G$x').setText(Gorilla_list[x-2].proveedor);
    }

    sheet_Baterias.getRangeByName('A1:F1').cellStyle.backColor='#0071FF';
    sheet_Baterias.getRangeByName('F2:F$Bateria_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_Baterias.getRangeByName('A1').setText('BRAND');
    sheet_Baterias.getRangeByName('B1').setText('MODEL');
    sheet_Baterias.getRangeByName('C1').setText('COLOR');
    sheet_Baterias.getRangeByName('D1').setText('QTY');
    sheet_Baterias.getRangeByName('E1').setText('CODIGO_SLIM');
    sheet_Baterias.getRangeByName('F1').setText('CODIGO');
    sheet_Baterias.getRangeByName('G1').setText('Ultimo Proveedor');
    for(int x=2;x<Bateria_list.length+2;x++){
      sheet_Baterias.getRangeByName('A$x').setText(Bateria_list[x-2].bRAND);
      sheet_Baterias.getRangeByName('B$x').setText(Bateria_list[x-2].mODELO);
      sheet_Baterias.getRangeByName('C$x').setText(Bateria_list[x-2].cOLOR);
      sheet_Baterias.getRangeByName('D$x').setText(Bateria_list[x-2].qUANTITY.toString());
      if(Bateria_list[x-2].qUANTITY<=5){
        sheet_Baterias.getRangeByName('D$x').cellStyle.backColor='#0071FF';
      }
      sheet_Baterias.getRangeByName('E$x').setText(Bateria_list[x-2].cODIGO);
      sheet_Baterias.getRangeByName('F$x').setFormula('=IF(C$x="","*"&E$x&"*","*"&E$x&"*"&" "&C$x&"*")');
      sheet_Baterias.getRangeByName('G$x').setText(Bateria_list[x-2].proveedor);
    }
    sheet_BateriasSC.getRangeByName('A1:F1').cellStyle.backColor='#0071FF';
    sheet_BateriasSC.getRangeByName('F2:F$BateriaSC_indx').cellStyle.fontName='Archon Code 39 Barcode';
    sheet_BateriasSC.getRangeByName('A1').setText('BRAND');
    sheet_BateriasSC.getRangeByName('B1').setText('MODEL');
    sheet_BateriasSC.getRangeByName('C1').setText('COLOR');
    sheet_BateriasSC.getRangeByName('D1').setText('QTY');
    sheet_BateriasSC.getRangeByName('E1').setText('CODIGO_SLIM');
    sheet_BateriasSC.getRangeByName('F1').setText('CODIGO');
    sheet_BateriasSC.getRangeByName('G1').setText('Ultimo Proveedor');
    for(int x=2;x<BateriaSC_list.length+2;x++){
      sheet_BateriasSC.getRangeByName('A$x').setText(BateriaSC_list[x-2].bRAND);
      sheet_BateriasSC.getRangeByName('B$x').setText(BateriaSC_list[x-2].mODELO);
      sheet_BateriasSC.getRangeByName('C$x').setText(BateriaSC_list[x-2].cOLOR);
      sheet_BateriasSC.getRangeByName('D$x').setText(BateriaSC_list[x-2].qUANTITY.toString());
      sheet_BateriasSC.getRangeByName('E$x').setText(BateriaSC_list[x-2].cODIGO);
      sheet_BateriasSC.getRangeByName('F$x').setFormula('=IF(C$x="","*"&E$x&"*","*"&E$x&"*"&" "&C$x&"*")');
      sheet_BateriasSC.getRangeByName('G$x').setText(BateriaSC_list[x-2].proveedor);
    }

    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('dMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    try{
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if(selectedDirectory ==null){

      }else{
        String direccion= selectedDirectory.replaceAll(r'\','/');
        await File('$direccion/$fechasub'+'-REF'+'.xlsx').writeAsBytes(bytes).then((value){
          print('$direccion/$fechasub'+'-REF'+'.xlsx');
          workbook.dispose();
          print('doSomething() executed in ${stopwatch.elapsed}');
          imagen_mostrar('Excel exportado',context,'Ref');
        });
      }
    }on Exception catch(e){
      print(e);
      imagen_mostrar('El archivo esta siendo ocupado,\nO la ruta no es correcta',context,'Ref');
    }
  }
}

imagen_mostrar(String s,BuildContext context,String type) async {
  showDialog(context: context, builder: (BuildContext context){
    bool turnimage = false;
    if(type=='Container'){
      turnimage = true;
    }
    return AlertDialog(
      content: Text(s,
        style: TextStyle(fontWeight: FontWeight.bold),),
      actions: <Widget>[
       Visibility(
         visible: turnimage,
         child: TextButton(onPressed: (){
            FilePickers2();
          }, child: Text('Insertar Imagenes'),),
       )
      ],
    );
  }
  );
}

FilePickers2() async{
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
  _openFile('//192.168.10.109/Public/PROGRA/VICTOR/instalador_windows/Complementos/Excelimagenes.exe');
}

Accion_realizada(String text){
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
            Icon(Icons.check_circle,color: Colors.green),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(text),),
          ],
        ),
      ),
    ),
  );
}
