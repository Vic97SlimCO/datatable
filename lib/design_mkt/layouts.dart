import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

/*
class Reportes_dgnmkt{
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
  */