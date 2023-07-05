import 'dart:convert';
import 'package:datatable/acc_mx.dart';
import 'package:datatable/folios.dart';
import 'package:datatable/widgets_contenedor/widgets_contenedor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'Modelo_contenedor/Slim_model.dart';
import 'Modelo_contenedor/model.dart';
import 'Modelo_traspaso/modelo_traspaso.dart';
import 'grid_confirm.dart';
import 'grid_confirm_ref.dart';
import 'package:transition/transition.dart' as trans;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'dart:io';
import 'dart:ui';

class Pedido_Stless extends StatelessWidget {
  String user;
  folios folio;
  Pedido_Stless({Key? key, required this.user,required this.folio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grid',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Pedidos(user:user,folio:folio,),
    );
  }
}

class Pedidos extends StatefulWidget {
  String user;
  folios folio;
  Pedidos({Key? key, required this.user, required this.folio}) : super(key: key);

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  List<slim_order> _lista = <slim_order>[];
  List<slim_order> _lista_pedidas = <slim_order>[];
  List<slim_order> _lista_pedidas_subfolio = <slim_order>[];
  List<slim_order> Excel_lista = <slim_order>[];
  List<Slim> pubs = <Slim>[];

  String dropdownsub2 = '*';
  double orderIdColumnWidth=150;
  double orderDescColumnWidth=150;
  double orderSKUColumnWidth=200;
  int _rowsPerPage = 15;
  late source_list source;
  var item_s2 = [
    '*',
    'BATERIAS GENERICAS',
    'BATERIAS SC','CHAROLA SIM',
    'CRISTAL DE CAMARA','FLEXORES',
    'GORILLA GLASS','LCD DISPLAY',
    'PANTALLA COMPLETA','TAPA','TORNILLOS',
    'TOUCH TACTIL'
  ];
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
  Future<List<Slim>> Publicaciones(String prov,String tipo)async{
    var url = Uri.parse('http://45.56.74.34:8081/publicaciones_all_select?title=&tipo=$tipo&index=0&proveedor=$prov&sublinea2=000');
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
  public() async {
    await Publicaciones(widget.folio.Proveedor,widget.folio.Tipo).then((value){
      setState(() {
        pubs.addAll(value);
      });
    });
  }
  Pedidas()async{
    _lista_pedidas.clear();
    _lista_pedidas_subfolio.clear();
    await Orden(widget.folio.Folio,widget.folio.Proveedor,'',true,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value){
      setState(() {
        _lista_pedidas.addAll(value);
        for(int x=0;x<_lista_pedidas.length;x++){
          if(_lista_pedidas[x].folio==widget.folio.Folio&&_lista_pedidas[x].confimadas!=0){
              _lista_pedidas_subfolio.add(_lista_pedidas[x]);
          }
        }
      });
    });
  }
  Ordenes() async{
    await Orden(widget.folio.Folio,widget.folio.Proveedor,'',false,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value) {
      setState((){
        _lista.addAll(value);
        source=source_list(pedido: _lista,publicaciones:pubs,user:widget.user,folio: widget.folio);
      });
    });
  }


  @override
  void initState() {
    public();
    Ordenes();
  }
  TextEditingController  controllertxt =TextEditingController();
  bool _boolconfimr = false;
  String sub2 = '000';
  NeumorphicCheckboxListener<T>(T value) {
  }
  
  @override
  Widget build(BuildContext context) {
    EditingGestureType editingGestureType = EditingGestureType.doubleTap;
    bool AR =false;
    double pagecount =1;
    if(source._Datapedido.length>0){
      pagecount=source._Datapedido.length/_rowsPerPage;
    }
    if(widget.folio.Tipo=='A'){
      AR=false;
    }else{
      AR=true;
    }
    return Scaffold(
      appBar: AppBar(
        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FittedBox(
              child:IconButton(
                onPressed: (){
                  _lista.clear();
                  if(widget.folio.Apartado=='Acc MX'){
                    List<String> acc_mxfolio = widget.folio.Folio.split('_');
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Acc_MX(user: widget.user, folio:folios(Folio: acc_mxfolio[0], Referencia: widget.folio.Referencia, Fecha_creacion: widget.folio.Fecha_creacion, Proveedor: '0', Tipo: widget.folio.Tipo, Dias: widget.folio.Dias, Lead: widget.folio.Lead, Apartado: widget.folio.Apartado, Fecha_cierre: widget.folio.Fecha_cierre, items_conf: 0, Status: widget.folio.Status))), (Route<dynamic> route) => false);
                  }else{Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Folio(user: widget.user)), (Route<dynamic> route) => false);}
                },
                icon:  const Icon(Icons.arrow_back),
              ),
            ),
            Expanded(child: Text('Folio:'+widget.folio.Folio)),
            Expanded(child: Text('Dias:'+widget.folio.Dias.toString())),
            Expanded(child: Text('Lead:'+widget.folio.Lead.toString())),
            Expanded(child: Text('Tipo:'+widget.folio.Tipo.toString())),
            Expanded(child: Text('Proveedor:'+widget.folio.Proveedor)),
            Expanded(flex:2,
                child: TextField(
                  showCursor: true,
                  cursorColor: Colors.white,
                  controller: controllertxt,
                style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),
                  decoration: InputDecoration(hintText:'Buscar...'),
                  onSubmitted: (text){
                      text = controllertxt.text.toUpperCase().trim();
                      setState((){
                        _lista.clear();
                        Orden(widget.folio.Folio,widget.folio.Proveedor,text,_boolconfimr,widget.folio.Dias.toString(),widget.folio.Lead.toString(),sub2,widget.folio.Tipo).then((value) {
                          setState((){
                            _lista.addAll(value);
                            source=source_list(pedido: _lista,publicaciones:pubs,user:widget.user,folio: widget.folio);
                          });
                        });
                      });
                  },)),
            /*Expanded(child: Checkbox(
                value: _boolconfimr,
                onChanged: (bool? value){
                  _boolconfimr = value!;
                  if(_boolconfimr==true){
                    _lista.clear();
                    Orden(widget.folio.Folio,widget.folio.Proveedor,controllertxt.text,_boolconfimr,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value) {
                      setState(() {
                        _lista.addAll(value);
                        source=source_list(pedido: _lista,publicaciones:pubs,user:widget.user,folio: widget.folio);
                      });
                    });
                  }else{
                    _lista.clear();
                    Orden(widget.folio.Folio,widget.folio.Proveedor,controllertxt.text,_boolconfimr,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value){
                        setState(() {
                        _lista.addAll(value);
                        source=source_list(pedido: _lista,publicaciones:pubs,user:widget.user,folio: widget.folio);
                       });
                    });
                  }
                }),
            ),*/
            Visibility(
              visible: AR,
              child: Expanded(
                  flex: 2,
                  child: DropdownButton(
                    value: dropdownsub2,
                    underline: Text('Sublinea 2',style:
                    TextStyle(fontSize: 10,height: 15),),
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
                      setState(() {
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
                        Orden(widget.folio.Folio,widget.folio.Proveedor,controllertxt.text, _boolconfimr,widget.folio.Dias.toString(),widget.folio.Lead.toString(),sub2,widget.folio.Tipo).then((value) {
                          setState(() {
                            _lista.addAll(value);
                            source=source_list(pedido: _lista,publicaciones:pubs,user:widget.user,folio: widget.folio);
                         });
                      });
                    });
                 })),
            ),
            Expanded(child: TextButton(onPressed: (){
                Orden(widget.folio.Folio,widget.folio.Proveedor,'', false,widget.folio.Dias.toString(),widget.folio.Lead.toString(),sub2,widget.folio.Tipo).then((value){
                  setState(() {
                    Excel_lista.clear();
                    Excel_lista.addAll(value);
                    Excel_ABC(Excel_lista,pubs);
                    //Excel_SlimCo(Excel_lista);
                  });
                });
            }, child: Text('ABC\nV30Hist',style: TextStyle(color: Colors.white),))),
            Expanded(child: TextButton(onPressed: (){
                if(widget.folio.Tipo=='A'){
                  Navigator.push(context,trans.Transition(child:Grid_Confirmados(user:widget.user, folio:widget.folio)));
                }else if(widget.folio.Tipo=='R'){
                  Navigator.push(context, trans.Transition(child: Grid_Confirm_ref(user: widget.user, folio: widget.folio)));
                }

            }, child: Text('Confimados',style: TextStyle(color: Colors.white)))),

            Expanded(child: IconButton(onPressed: (){
              _lista.clear();
              Orden(widget.folio.Folio,widget.folio.Proveedor,'',_boolconfimr,widget.folio.Dias.toString(),widget.folio.Lead.toString(),'000',widget.folio.Tipo).then((value) {
                setState((){
                  _lista.addAll(value);
                  source=source_list(pedido: _lista,publicaciones:pubs,user:widget.user,folio: widget.folio);
                });
              });
            }, icon: Icon(Icons.refresh))),
            Expanded(child: TextButton(onPressed: () async {
               await Pedidas();
               String prod_conf= _lista_pedidas_subfolio.length.toString();
               var now = DateTime.now().toIso8601String();
               String Foliojson =(
                       '{"Folio":"'+widget.folio.Folio+
                       '","Referencia":"'+widget.folio.Referencia+
                       '","Fecha_Creacion":"'+now+
                       '","Proveedor":"'+widget.folio.Proveedor+
                       '","Tipo":"'+widget.folio.Tipo+
                       '","Dias":'+widget.folio.Dias.toString()+
                       ',"Lead":'+widget.folio.Lead.toString()+
                       ',"Apartado":"'+widget.folio.Apartado!+
                       '","Fecha_Termino":"'+widget.folio.Fecha_cierre!+
                       '","Status":"'+widget.folio.Status!+
                       '","Productos_Confirmados":'+prod_conf+'}'
                    );
               try{
                 var items_json = jsonDecode(Foliojson);
                 String encoder = jsonEncode(items_json);
                 await Check(encoder);
                 print(encoder);
               }on Exception catch(e){
                 print(e);
               }
            },
              child: Text('Actualizar\nStatus',style: TextStyle(color: Colors.white)),)),
            Expanded(child: TextButton(onPressed: ()async{
                var now = DateTime.now().toIso8601String();
                String Foliojson =(
                    '{"Folio":"'+widget.folio.Folio+
                        '","Referencia":"'+widget.folio.Referencia+
                        '","Fecha_Creacion":"'+widget.folio.Fecha_creacion+
                        '","Proveedor":"'+widget.folio.Proveedor+
                        '","Tipo":"'+widget.folio.Tipo+
                        '","Dias":'+widget.folio.Dias.toString()+
                        ',"Lead":'+widget.folio.Lead.toString()+
                        ',"Apartado":"'+widget.folio.Apartado!+
                        '","Fecha_Termino":"'+now+
                        '","Status":"'+'Listo'+
                        '","Productos_Confirmados":'+widget.folio.items_conf.toString()+'}'
                );
                try{
                  var items_json = jsonDecode(Foliojson);
                  String encoder = jsonEncode(items_json);
                  await Check(encoder);
                  print(encoder);
                }on Exception catch(e){
                  print(e);
                }
            },
              child: Text('Terminar\nPedido',style: TextStyle(color: Colors.white)),)),
          ],
        ) ,),
     body:_lista.isEmpty? Center(child: Image(image: NetworkImage('https://i.stack.imgur.com/81VAF.jpg'))):
          SfDataGrid(
          allowFiltering: true,
          selectionMode: SelectionMode.single,
          navigationMode: GridNavigationMode.cell,
          allowSorting: true,
          allowColumnsResizing: true,
          columnResizeMode: ColumnResizeMode.onResizeEnd,
          columnWidthMode: ColumnWidthMode.fill,
          source: source,
          editingGestureType: editingGestureType,
          columns: <GridColumn>[
            GridColumn(
              columnName:'Cod_Slim',
              label: Text('Cod\nSlim'),
              allowSorting: true,
              width: orderIdColumnWidth,
              ),
            GridColumn(columnName:'Desc', label: Text('Desc'),allowSorting: true,allowFiltering: true,width: orderDescColumnWidth),
            GridColumn(columnName:'Imagen', label: Text('Imagen'),allowSorting: true),
            GridColumn(columnName:'SKU', label: Text('SKU'),allowSorting: true,width: orderSKUColumnWidth),
            GridColumn(columnName:'V30_Nat', label: Text('V30\nNat'),allowSorting: true),
            GridColumn(columnName:'V30_Hist', label: Text('V30\nHist'),allowSorting: true),
            GridColumn(columnName:'AMZN_30D', label: Text('V30\nAMZN'),allowSorting: true),
            GridColumn(columnName:'AMZN_Sold', label: Text('AMZN\nSold'),allowSorting: true),
            GridColumn(columnName:'Stock_Cedis', label: Text('Stock\nCedis'),allowSorting: true),
            GridColumn(columnName:'Full', label: Text('Full'),allowSorting: true),
            GridColumn(columnName:'Camino', label: Text('Camino'),allowSorting: true),
            GridColumn(columnName:'ContA', label: Text('ContA'),allowSorting: true),
            GridColumn(columnName:'ContB', label: Text('ContB'),allowSorting: true),
            GridColumn(columnName:'CaminoChina', label: Text('Camino\nChina'),allowSorting: true),
            GridColumn(columnName:'Sugerido', label: Text('Sugerido'),allowSorting: true),
            GridColumn(columnName:'Confirmadas', label: Text('Confirmadas'),allowSorting: true),
            GridColumn(columnName:'Pedidas', label: Text('Pedidas'),allowSorting: true),
            GridColumn(columnName:'Caja', label: Text('Unidades\npor caja'),allowSorting: true),
            GridColumn(columnName:'Precio_Ultimo', label: Text('Precio\nUltimo'),allowSorting: true),
            GridColumn(columnName:'Agotar', label: Text('Agotar\nDescatalogar'),allowSorting: true),
          ],
     onColumnResizeUpdate: (ColumnResizeUpdateDetails args){
            setState(() {
              if(args.column.columnName=='Cod_Slim'){
              orderIdColumnWidth=args.width;
              }
              if(args.column.columnName=='Desc'){
                orderDescColumnWidth=args.width;
              }
              if(args.column.columnName=='SKU'){
                orderSKUColumnWidth=args.width;
              }
            });
            return true;
     },),
      bottomNavigationBar:
      SfDataPager(
          availableRowsPerPage: const <int>[15,20,50,100],
          pageCount: pagecount,
          delegate: source,
          onRowsPerPageChanged: (int? rowPerPage){
            setState(() {
              _rowsPerPage=rowPerPage!;
            });
        },
      ),
    );
  }
  Future<http.Response> Check(_listajson) {
    return http.post(
      Uri.parse('http://45.56.74.34:8890/pedido'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: _listajson,
    );
  }
  Future<void>Excel_ABC(List<slim_order>Excelist, List<Slim> pubs)async {
    Stopwatch stopwatch = new Stopwatch()..start();
    List<slim_order>listaABC=<slim_order>[];
    List<Slim>publi_precio=<Slim>[];
    for(int x=0;x<Excelist.length;x++){
        if(Excelist[x].folio==null){
          listaABC.add(Excelist[x]);
        }
    }
    setState(() {
      listaABC.sort((A,B)=>B.v30hist.compareTo(A.v30hist));
    });
    int index = listaABC.length+2;
    int vhistoricas_totales=0;
    num Acumulado = 0;
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;
    sheet.enableSheetCalculations();

    sheet.getRangeByName('A1').columnWidth=15.0;
    sheet.getRangeByName('C1:N1').columnWidth=15.0;
    sheet.getRangeByName('B1').columnWidth=25.0;
    sheet.getRangeByName('A1:O1').cellStyle.backColor='#0071FF';
    sheet.getRangeByName('A1:O1').cellStyle.fontColor='#FFFFFF';
    sheet.getRangeByName('A1:O1').cellStyle.bold;
    sheet.getRangeByName('A1:O$index').cellStyle.hAlign=xls.HAlignType.center;
    sheet.getRangeByName('A1:O$index').cellStyle.vAlign=xls.VAlignType.center;
    sheet.getRangeByName('A1:O$index').cellStyle.wrapText= true;
    sheet.getRangeByName('J2:J$index').cellStyle.fontColor='#008BFF';
    sheet.getRangeByName('F2:F$index').cellStyle.fontColor='#07BA00';

    sheet.getRangeByName('A1').setText('Slim');
    sheet.getRangeByName('B1').setText('Desc');
    sheet.getRangeByName('C1').setText('SKU');
    sheet.getRangeByName('D1').setText('V30\nhistoricas');
    sheet.getRangeByName('E1').setText('Precio de venta');
    sheet.getRangeByName('F1').setText('UltimoCosto');
    sheet.getRangeByName('G1').setText('CEDIS');
    sheet.getRangeByName('H1').setText('FULL');
    sheet.getRangeByName('I1').setText('STOCK\nTOTAL');
    sheet.getRangeByName('J1').setText('STOCK\nMESES');
    sheet.getRangeByName('K1').setText('V3M');
    sheet.getRangeByName('L1').setText('PEDIR');
    sheet.getRangeByName('M1').setText('% UNIDADES');
    sheet.getRangeByName('N1').setText('% Acumulado');
    sheet.getRangeByName('O1').setText('ABC');

    for(int x=2;x<listaABC.length+2;x++){
      vhistoricas_totales = vhistoricas_totales + listaABC[x-2].v30hist;
    }
    print(vhistoricas_totales);
    for(int x=2;x<listaABC.length+2;x++){
      String price='0';
      publi_precio = pubs.where((element){
        var precio = element.cod_slim;
        return precio.contains(listaABC[x-2].codigo_slim);
      }).toList();
      setState(() {
        publi_precio.sort((A,B)=>A.price.compareTo(B.price));
      });
      if(publi_precio.isNotEmpty){
       price= publi_precio[0].price.toString();
      }
      Acumulado = Acumulado +(listaABC[x-2].v30hist/vhistoricas_totales);
      sheet.getRangeByName('A$x').setText(listaABC[x-2].codigo_slim);
      sheet.getRangeByName('B$x').setText(listaABC[x-2].Desc);
      sheet.getRangeByName('C$x').setText(listaABC[x-2].SKU.toString());
      sheet.getRangeByName('D$x').setText(listaABC[x-2].v30hist.toString());
      sheet.getRangeByName('E$x').setText(price);
      sheet.getRangeByName('F$x').setText(listaABC[x-2].costo_ultimo.toStringAsFixed(2));
      sheet.getRangeByName('G$x').setText(listaABC[x-2].cedis.toString());
      sheet.getRangeByName('H$x').setText(listaABC[x-2].full.toString());
      sheet.getRangeByName('I$x').setText(listaABC[x-2].stock_total.toString());
      sheet.getRangeByName('J$x').setText(listaABC[x-2].stockMeses.toStringAsFixed(9));
      sheet.getRangeByName('K$x').setText((listaABC[x-2].v30hist*3).toString());
      if(listaABC[x-2].pedir>0){
        sheet.getRangeByName('L$x').setText(listaABC[x-2].pedir.toString());
        sheet.getRangeByName('B$x').cellStyle.backColor='#00FFB3';
        sheet.getRangeByName('L$x').cellStyle.fontColor='#008BFF';

      }else{
        sheet.getRangeByName('L$x').setText('NO PEDIR');
        sheet.getRangeByName('L$x').cellStyle.backColor='#FCA2A2';
        sheet.getRangeByName('B$x').cellStyle.backColor='#FCA2A2';
        sheet.getRangeByName('L$x').cellStyle.fontColor='#FF0000';
        sheet.getRangeByName('L$x').cellStyle.bold;
        sheet.getRangeByName('L$x').cellStyle.fontSize=15;
      }
      sheet.getRangeByName('M$x').setValue(((listaABC[x-2].v30hist/vhistoricas_totales)*100).toStringAsFixed(2)+'%');
      sheet.getRangeByName('N$x').setValue((Acumulado*100).toStringAsFixed(2)+'%');
      if((Acumulado*100)<80){
        sheet.getRangeByName('O$x').setText('A');
        sheet.getRangeByName('O$x').cellStyle.backColor='#00FFB3';
        sheet.getRangeByName('O$x').cellStyle.fontColor='#00986A';
      }else if((Acumulado*100)<95){
        sheet.getRangeByName('O$x').setText('B');
        sheet.getRangeByName('O$x').cellStyle.backColor='#E6FF65';
        sheet.getRangeByName('O$x').cellStyle.fontColor='#657900';
      }else{
        sheet.getRangeByName('O$x').setText('C');
        sheet.getRangeByName('O$x').cellStyle.backColor='#FCA2A2';
        sheet.getRangeByName('O$x').cellStyle.fontColor='#FF0000';
      }
    }
    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('dMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    try{
      await File('//192.168.10.108/Public/VICTOR/SlimData/Excel_Ventasproveedor/$fechasub-'+widget.folio.Proveedor+'.xlsx').writeAsBytes(bytes).then((value){
        workbook.dispose();
        print('doSomething() executed in ${stopwatch.elapsed}');
        //imagen_mostrar('Excel exportado');
      });

    }on Exception catch(e){
      print(e);
      //imagen_mostrar('El archivo esta siendo ocupado,\nO la ruta no es correcta');
    }
  }
  Future<void>Excel_SlimCo(List<slim_order>Excelist)async {
    Stopwatch stopwatch = new Stopwatch()..start();
    List<slim_order>listaABC=<slim_order>[];

    for(int x=0;x<Excelist.length;x++){
      if(Excelist[x].folio==null){
        listaABC.add(Excelist[x]);
      }
    }
    setState(() {
      listaABC.sort((A,B)=>B.caja.compareTo(A.caja));
    });
    int index = listaABC.length+2;

    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;
    sheet.enableSheetCalculations();

    sheet.getRangeByName('A1').columnWidth=15.0;
    sheet.getRangeByName('C1:N1').columnWidth=15.0;
    sheet.getRangeByName('B1').columnWidth=25.0;
    sheet.getRangeByName('A1:O1').cellStyle.backColor='#0071FF';
    sheet.getRangeByName('A1:O1').cellStyle.fontColor='#FFFFFF';
    sheet.getRangeByName('A1:O1').cellStyle.bold;
    sheet.getRangeByName('A1:O$index').cellStyle.hAlign=xls.HAlignType.center;
    sheet.getRangeByName('A1:O$index').cellStyle.vAlign=xls.VAlignType.center;
    sheet.getRangeByName('A1:O$index').cellStyle.wrapText= true;
    sheet.getRangeByName('J2:J$index').cellStyle.fontColor='#008BFF';
    sheet.getRangeByName('F2:F$index').cellStyle.fontColor='#07BA00';

    sheet.getRangeByName('A1').setText('Slim');
    sheet.getRangeByName('B1').setText('Desc');
    sheet.getRangeByName('C1').setText('Unidades por caja');


    for(int x=2;x<listaABC.length+2;x++){
      sheet.getRangeByName('A$x').setText(listaABC[x-2].codigo_slim);
      sheet.getRangeByName('B$x').setText(listaABC[x-2].Desc);
      sheet.getRangeByName('C$x').setText(listaABC[x-2].caja.toString());

    }
    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('dMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    try{
      await File('//192.168.10.108/Public/VICTOR/SlimData/Excel_Ventasproveedor/$fechasub-'+widget.folio.Proveedor+'Caja'+'.xlsx').writeAsBytes(bytes).then((value){
        workbook.dispose();
        print('doSomething() executed in ${stopwatch.elapsed}');
        //imagen_mostrar('Excel exportado');
      });

    }on Exception catch(e){
      print(e);
      //imagen_mostrar('El archivo esta siendo ocupado,\nO la ruta no es correcta');
    }
  }
}

class source_list extends DataGridSource{
  List<slim_order> pedido = <slim_order>[];
  List<slim_order> confirmadas = <slim_order>[];
  List<Slim>? publicaciones;
  List<Slim> _lista_variante_ = <Slim>[];
  List<slim_order> folios_confirm = <slim_order>[];
  folios folio;
  String user;

  source_list({required this.pedido, this.publicaciones, required this.user,required this.folio}){

    List<slim_order> lista_slim = <slim_order>[];
    for(int x=0;x<pedido.length;x++){
      if(pedido[x].folio==null){
        lista_slim.add(pedido[x]);
      }else{
        folios_confirm.add(pedido[x]);
      }
    }
    /*for(int x=0;x<confirmadas.length;x++){
        if(confirmadas[x].folio==folio.Folio){
          folios_confirm.add(confirmadas[x]);
        }
    }*/
    _lista_variante_ = publicaciones!;
    _Datapedido = lista_slim.map<DataGridRow>((e) =>
    //_Datapedido = pedido.map<DataGridRow>((e) =>
    DataGridRow(cells: [
      DataGridCell<String>(columnName: 'Cod_Slim', value: e.codigo_slim),
      DataGridCell<String>(columnName: 'Desc', value: e.Desc),
      DataGridCell<String>(columnName: 'Imagen', value: e.Thumbnail),
      DataGridCell<String>(columnName: 'SKU', value: e.SKU),
      DataGridCell<int>(columnName: 'V30_Nat', value: e.v30nat),
      DataGridCell<int>(columnName: 'V30_Hist', value: e.v30hist),
      DataGridCell<int>(columnName: 'AMZN_30D', value: e.amzn30v),
      DataGridCell<int>(columnName: 'AMZN_Sold', value: e.amznsold),
      DataGridCell<int>(columnName: 'Stock_Cedis', value: e.cedis),
      DataGridCell<int>(columnName: 'Full', value: e.full),
      DataGridCell<int>(columnName: 'Camino', value: 0),
      DataGridCell<int>(columnName: 'ContA', value: e.camino_china),
      DataGridCell<int>(columnName: 'ContB', value: e.camino_china),
      DataGridCell<int>(columnName: 'CaminoChina', value: e.camino_china),
      DataGridCell<int>(columnName: 'Sugerido', value: e.sugerido),
      DataGridCell<slim_order>(columnName: 'Confirmadas', value:e),
      DataGridCell<int>(columnName: 'Pedidas', value: e.confimadas),
      DataGridCell<int>(columnName: 'Caja', value: e.caja),
      DataGridCell<String>(columnName: 'Precio_Ultimo', value: e.costo_ultimo.toStringAsFixed(2)),
      DataGridCell<String>(columnName: 'Agotar', value: e.Agotar),
    ])).toList();
  }
  List<DataGridRow> _Datapedido = [];
  @override
  List<DataGridRow> get rows => _Datapedido;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
  //TextEditingController controller =TextEditingController();
  int encamino =0;
  int amznv30 =0;
  int caminoCH =0;
  //print(row.getCells()[0].value.toString()+'-'+caminoCH.toString());
  if(row.getCells()[6].value>0){
    amznv30=((row.getCells()[6].value/30)*(folio.Dias+folio.Lead)).round();
    print('Amazon:'+((row.getCells()[6].value/30)*(folio.Dias+folio.Lead)).toString());
    print('Sugerido'+row.getCells()[14].value.toString());
  }
  if(row.getCells()[0].value!=''){
    _lista_variante_ = publicaciones!.where((element) => element.cod_slim.contains(row.getCells()[0].value)).toList();
    for(int x=0;x<_lista_variante_.length;x++){encamino=encamino+_lista_variante_[x].en_camino; }}
  int sugest =0;
  if(folio.Apartado=='Acc MX'){
    caminoCH = row.getCells()[13].value;
  }
  if(row.getCells()[14].value>0||amznv30>0){
    sugest = row.getCells()[14].value+amznv30.round()+caminoCH;
    print(sugest.toString()[sugest.toString().length-1]);
    switch(sugest.toString()[sugest.toString().length-1]){
      case '9': sugest=sugest+1;break;
      case '8': sugest=sugest+2;break;
      case '7': sugest=sugest-2;break;
      case '6': sugest=sugest-1;break;
      case '4': sugest=sugest+1;break;
      case '3': sugest=sugest+2;break;
      case '2': sugest=sugest-2;break;
      case '1': sugest=sugest-1;break;
    }
  }else{
    sugest=row.getCells()[14].value;
  }
  int unidades_confirmadas=0;
  List<slim_order> lista_secundaria = <slim_order>[];
  if(row.getCells()[0].value!=''){
   lista_secundaria= folios_confirm.where((element) => element.codigo_slim.contains(row.getCells()[0].value)).toList();
   if(lista_secundaria.length>0){
     for(int x=0;x<lista_secundaria.length;x++){
       if(lista_secundaria[x].folio==folio.Folio){
         unidades_confirmadas = lista_secundaria[x].confimadas;
       }
     }
   }
  }
    return DataGridRowAdapter(
        cells:<Widget>[
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: ContextSlim(CoDSlim: row.getCells()[0].value, SKU: row.getCells()[3].value)
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[1].value,
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Image.network(row.getCells()[2].value,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[3].value,
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[4].value.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[5].value.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[6].value.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[7].value.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[8].value.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[9].value.toString(),
              overflow: TextOverflow.ellipsis,),
            /**/
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(encamino.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text('0',
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child:Text('0',
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[13].value.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child:Text(sugest.toString(),
              overflow: TextOverflow.ellipsis,),

            /*UnidadesConf(
                Slim: row.getCells()[0].value,
                Desc: row.getCells()[1].value,
                User: user,
                Title: '',
                Variation: '',
                ID: ''),*/
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Confirmados_txt(folio:folio,user: user, value:row.getCells()[15].value,),
            //child: Text(row.getCells()[11].value.toString()),
            //child: txtbox_conf(value: row.getCells()[11].value, user: user, folio: folio),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child:Text(unidades_confirmadas.toString()),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[17].value.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[18].value.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(8),
            child: Text(row.getCells()[19].value.toString(),
              overflow: TextOverflow.ellipsis,),
          ),
        ]
    );
  }
}
