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

class Grid_Confirmados extends StatelessWidget {
  String user;
  folios folio;
  Grid_Confirmados({Key? key,required this.user,required this.folio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grid_Confirmados',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: grid_confirmados(user:user,folio:folio),
    );
  }
}

class grid_confirmados extends StatefulWidget {
  String user;
  folios folio;
  grid_confirmados({Key? key, required this.user, required this.folio}) : super(key: key);

  @override
  State<grid_confirmados> createState() => _grid_confirmadosState();
}

class _grid_confirmadosState extends State<grid_confirmados> {
  double desccolumnwidth=200;
  double skuccolumnwidth=150;
  late source_conf source;
  List<slim_order> _lista = <slim_order>[];
  List<slim_order> lista_folio = <slim_order>[];
  List<slim_order> Excellist = <slim_order>[];
  List<imagen_exist> imagen_xsist = <imagen_exist>[];
  bool Tipodrop=false;

  Future<List<slim_order>> Orden(String folio,String PR,String title, bool? choice,String Dias,String lead,String sublinea2,String tipo) async{
    String PRR = '&proveedor=$PR';
    String Con = '';
    if(choice==false){
      setState((){
        Con='';
      });
    }
    if(choice==true){
      setState((){
        Con='&confirmados=yes';
      });
    }
    var url = Uri.parse('http://45.56.74.34:8890/container/condensado?folio=$folio&title=$title&dias=$Dias&leadtime=$lead'+PRR+'&sublinea2=$sublinea2&tipo=$tipo'+Con);
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
@override
  void initState() {
   Ordenes();
  }
  Ordenes() async{
    await Orden(widget.folio.Folio,widget.folio.Proveedor,'',true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value) {
      setState(() {
        lista_folio.addAll(value);
        for(int x=0;x<lista_folio.length;x++){
          if(lista_folio[x].folio==widget.folio.Folio&&lista_folio[x].confimadas!=0){
            try{
              /*_imagenxst(lista_folio[x]).then((value){
                  imagen_xsist.add(imagen_exist(Cod_Slim: lista_folio[x].codigo_slim, image_exist: value));
              });*/
              _lista.add(lista_folio[x]);
            }on Exception catch(e){
                print('Error: '+e.toString());
            }
          }
        }
        source=source_conf(lista_confirmados: _lista,user:widget.user,folio: widget.folio,imagen: imagen_xsist);
      });
    });
  }
  Future<String> _imagenxst(name) async {
    var url = Uri.parse('http://45.56.74.34:9091/?filename=CH_$name.jpg&exist=');
    var response = await http.get(url);
    String result;
    if (response.statusCode ==200){
      result = response.body.toString();
      return result;
    }else{
      result='Servicio fallo';
      throw Exception('No se pudo');
    }
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
            },
            icon: Icon(Icons.arrow_back)),
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
                  Orden(widget.folio.Folio,widget.folio.Proveedor,controller.text, true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),sub2 ,widget.folio.Tipo).then((value) {
                    setState(() {
                      lista_folio.addAll(value);
                      for(int x=0;x<lista_folio.length;x++){
                        if(lista_folio[x].folio==widget.folio.Folio&&lista_folio[x].confimadas!=0){
                          _lista.add(lista_folio[x]);
                        }
                      }
                      source=source_conf(lista_confirmados: _lista,user:widget.user,folio: widget.folio,imagen: imagen_xsist);
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
                          Orden(widget.folio.Folio,widget.folio.Proveedor,'',true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),sub2,widget.folio.Tipo).then((value){
                            setState(() {
                              lista_folio.addAll(value);
                              for(int x=0;x<lista_folio.length;x++){
                                if(lista_folio[x].folio==widget.folio.Folio&&lista_folio[x].confimadas!=0){
                                  _lista.add(lista_folio[x]);
                                }
                              }
                              source=source_conf(lista_confirmados: _lista,user:widget.user,folio: widget.folio,imagen: imagen_xsist);
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
              Orden(widget.folio.Folio,widget.folio.Proveedor,'',true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value){
                setState(() {
                  lista_folio.addAll(value);
                  for(int x=0;x<lista_folio.length;x++){
                    if(lista_folio[x].folio==widget.folio.Folio&&lista_folio[x].confimadas!=0){
                      _lista.add(lista_folio[x]);
                    }
                  }
                  source=source_conf(lista_confirmados: _lista,user:widget.user,folio: widget.folio,imagen: imagen_xsist);
                });
              });
          }, icon: Icon(Icons.refresh)),
          IconButton(onPressed: (){
            Excellist.clear();
            Orden(widget.folio.Folio,widget.folio.Proveedor,'',true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value) {
            setState((){
            Excellist.addAll(value);
            try{
                generateExcel(Excellist, widget.folio.Folio);
            } on Exception catch(e){
             print(e);
            }
              });
            });
          }, icon: Icon(Icons.save)),
        ],
      ),
      body: imagen_xsist.isEmpty?
        SfDataGrid(
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
          GridColumn(columnName: 'SKU', label: Text('SKU'),allowSorting: true,allowFiltering: true,width:skuccolumnwidth),
          GridColumn(columnName:'Color', label: Text('Color'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'Costo', label: Text('Costo'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'Confirmadas', label: Text('Confirmadas'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'Total', label: Text('Total'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'Usuario', label: Text('Usuario'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'Imagen', label: Text('Imagen'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'Example', label: Text('Example'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'Instrucciones', label: Text('Instrucciones'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'DChina', label: Text('DChina'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'DMX', label: Text('DMX'),allowSorting: true,allowFiltering: true,),
          GridColumn(columnName:'Image', label: Text('Anexar\nImagen'),allowSorting: true,allowFiltering: true,),
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
      ):CircularProgressIndicator(),

    );
  }
  Future<void> generateExcel(List<slim_order> lista_xls,String folio)async{
    Stopwatch stopwatch = new Stopwatch()..start();
    List<slim_order> Excelist = <slim_order>[];
    for(int x=0;x<lista_xls.length;x++){
      if(lista_xls[x].folio==folio&&lista_xls[x].confimadas!=0){
        Excelist.add(lista_xls[x]);
      }
    }
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
     if(Excelist[x-2].DChina!=null){
       china =Excelist[x-2].DChina!;
     }
     if(Excelist[x-2].Example!=null){
       example =Excelist[x-2].Example!;
     }
     if(Excelist[x-2].Inst!=null){
       inst =Excelist[x-2].Inst!;
     }
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
     sheet.getRangeByName('A$x').setNumber(Excelist[x-2].confimadas.toDouble());
     sheet.getRangeByName('B$x').setText(Excelist[x-2].codigo_slim);
     sheet.getRangeByName('C$x').setText(china);
     sheet.getRangeByName('D$x').setText(color);
     sheet.getRangeByName('E$x').setText(Excelist[x-2].SKU);
     sheet.getRangeByName('F$x').setNumber(Excelist[x-2].costo_ultimo.toDouble());
     sheet.hyperlinks.add(sheet.getRangeByName('J$x'),xls.HyperlinkType.url, example);
     sheet.getRangeByName('K$x').setText(inst);
     sheet.getRangeByName('M$x').setText('Descripcion:'+Excelist[x-2].SKU+', Marca:SC, Cantidad: 1Pcs, '+inst+', Hecho en China,'+importador);
     sheet.getRangeByName('N$x').setFormula('=IF(D$x="","*"&B$x&"*","*"&B$x&" "&D$x&"*")');
     sheet.getRangeByName('L$x').setText(importador);
    }
    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('ddMMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    try{
      if(widget.folio.Apartado=='Acc MX'){
        await File('//192.168.10.108/Public/VICTOR/SlimData/Excel_AccMX/'+widget.folio.Folio+'$fechasub.xlsx').writeAsBytes(bytes).then((value){
          workbook.dispose();
          print('doSomething() executed in ${stopwatch.elapsed}');
          imagen_mostrar('Excel exportado');
        });
      }else{
        await File('//192.168.10.108/Public/VICTOR/SlimData/Excel_Contenedor/$fechasub.xlsx').writeAsBytes(bytes).then((value){
          workbook.dispose();
          print('doSomething() executed in ${stopwatch.elapsed}');
          imagen_mostrar('Excel exportado');
        });
      }

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
  List<imagen_exist> imagen = <imagen_exist>[];
  String user;
  folios folio;

  source_conf({required this.lista_confirmados,required this.user,required this.folio,required this.imagen}){
    _Dataconfirmados = lista_confirmados.map<DataGridRow>((e) =>
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Cod_Slim', value:e.codigo_slim),
          DataGridCell<String>(columnName: 'Desc', value:e.Desc),
          DataGridCell<String>(columnName: 'SKU', value:e.SKU),
          DataGridCell<String>(columnName: 'Color', value:e.Color),
          DataGridCell<String>(columnName: 'Costo', value:e.costo_ultimo.toStringAsFixed(0)),
          DataGridCell<num>(columnName: 'Confirmadas', value:e.confimadas),
          DataGridCell<String>(columnName: 'Total', value:(e.confimadas*e.costo_ultimo).toStringAsFixed(0)),
          DataGridCell<String>(columnName: 'Usuario', value:e.usuario),
          DataGridCell<String>(columnName: 'Imagen', value:e.Thumbnail),
          DataGridCell<String>(columnName: 'Example', value:e.Example),
          DataGridCell<String>(columnName: 'Instrucciones', value:e.Inst),
          DataGridCell<String>(columnName: 'DChina', value:e.DChina),
          DataGridCell<String>(columnName: 'DMX', value:e.desc_mx),
          DataGridCell<slim_order>(columnName: 'Image', value:e),
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
              child: Text(row.getCells()[7].value.toString()),),
            Container(alignment: Alignment.center,
              child: Image.network(row.getCells()[8].value),),
            Container(alignment: Alignment.center,padding: EdgeInsets.all(5.0),
              child: Exampletxt(item:row.getCells()[13].value),),
            Container(alignment: Alignment.center,padding: EdgeInsets.all(5.0),
              child: Instxt(item:row.getCells()[13].value),),
            Container(alignment: Alignment.center,padding: EdgeInsets.all(5.0),
              child: DChina(item:row.getCells()[13].value),),
            Container(alignment: Alignment.center,padding: EdgeInsets.all(5.0),
              child: DMX(item:row.getCells()[13].value),),
            imagenlist(item: row.getCells()[13].value,),
            /*Imagen_existe(imagen: imagen, codSlim: row.getCells()[12].value),*/
            Container(alignment: Alignment.center,
              child: Eliminar_confirmado(item: row.getCells()[13].value, user: user,folio: folio,),),
      ]);
  }
}
