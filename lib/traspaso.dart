
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datatable/widget_traspaso/widgets_traspaso.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Modelo_contenedor/Slim_model.dart';
import 'Modelo_traspaso/modelo_traspaso.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:path/path.dart';

import 'option_menu.dart';

class inicio extends StatelessWidget{
  String user;
   inicio({Key? key,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tabla Demo',
      theme: ThemeData(
       primaryColor:Colors.deepPurple,
      ),
      home: DTSlim(user:user),
    );
  }
}

class DTSlim extends StatefulWidget{
  //List<Slim> dataslim;
  String user;
  DTSlim({Key? key, required this.user});

  @override
  State<DTSlim> createState() => _DTSlim(user:user);

}

class _DTSlim extends State<DTSlim> with TickerProviderStateMixin{
  String user;
  _DTSlim({required this.user});
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortAscending = 0;
  bool Ascending = true;
  int? _sortColumnIndex;
  List<Slim> dataslim = <Slim>[];
  List<Slim> Excelist = <Slim>[];
  List<Slim> Exl_ref = <Slim>[];
  List<Slim> Exl_acc = <Slim>[];
  List<productos> Exl_SN = <productos>[];
  List<ubicaciones_stock> Stock_list = <ubicaciones_stock>[];
  List<Proveedores> provs = <Proveedores>[];
  List<areas_stock> Stock_ML = <areas_stock>[];
  PaginatorController? _controller;


  Future<List<Slim>> SlimData(String text, String provider, String sub2, String tipo) async {
    var url = Uri.parse('http://45.56.74.34:8081/publicaciones_all_select?title=$text&tipo=$tipo&index=0&proveedor=$provider&sublinea2=$sub2');
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
  Future<List<productos>> Productos() async {
    var url = Uri.parse('http://45.56.74.34:5558/productos/list/all?search=&sublinea2_id=0&proveedor_id=000');
    print(url);
    var response = await http.get(url);
    List<productos> productos_list = <productos>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(36, count-1);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv) {
        productos_list.add(productos.from(noteJson));
      }
      return productos_list;
    }else
      throw Exception('NO se pudo');
  }

  Future<List<ubicaciones_stock>> Ubicaciones() async{
    var url = Uri.parse('http://45.56.74.34:5558/productos/list/all?search=&sublinea2_id=0&proveedor_id=000');
    print(url);
    var response = await http.get(url);
    List<ubicaciones_stock> publicaciones = <ubicaciones_stock>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(36, count-1);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv) {
        publicaciones.add(ubicaciones_stock.from(noteJson));
      }
      return publicaciones;
    }else
      throw Exception('NO se pudo');
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
      }
      return proveedores;
    }else
      throw Exception('NO se pudo');
  }

  Future<List<areas_stock>> AreaStock () async {
    var url = Uri.parse('http://45.56.74.34:5559/areas/stock?search=');
    print(url);
    var response = await http.get(url);
    List<areas_stock> area = <areas_stock>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      //print(_sub);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv) {
        area.add(areas_stock.from(noteJson));
      }
      return area;
    }else
      throw Exception('NO se pudo');
  }
  FileOpen() async{
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
    _openFile('//192.168.10.108/Public/VICTOR/instalador_windows/Complementos/EXCEL_STOCK.exe');
  }

  void progress(){
   new Timer.periodic(Duration(seconds: 1),
           (Timer timer) {
          setState((){
            if(value ==1){
              timer.cancel();
            } else{
              value = value + 0.1;
            }
          });
      });
  }

  initState(){
    SlimData('','000','000','*').then((value){
      setState((){
        //progress();
        dataslim.addAll(value);
      });
    });

    Prove().then((value){
      setState((){
        provs.addAll(value);
      });
    });
    AreaStock().then((value) {
      setState((){
        Stock_ML.addAll(value);
      });
    });
  }
  var item_s2 = [
    '*',
    'BATERIAS GENERICAS',
    'BATERIAS SC','CHAROLA SIM',
    'CRISTAL DE CAMARA','FLEXORES',
    'GORILLA GLASS','LCD DISPLAY',
    'PANTALLA COMPLETA','TAPA','TORNILLOS',
    'TOUCH TACTIL'
  ];
  var item = [
    '*',
    '247?',
    'AMAZING',
    'ASTRON',
    'BEST TERESA',
    'BRASONIC',
    'CAPITAL MOVILE',
    'CELMEX',
    'Celulr Hit',
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
  String provider = '000';
  String dropdownvalue = '*';
  String dropdownsub2 = '*';
  List<String> _status = ["Accesorios", "Refacciones", "Ambas"];
  String _verticalGroupValue = "Ambas";
  String tipo = "*";
  String sub2 = '000';
  double value = 0;
  @override
  Widget build(BuildContext context) {
    TextEditingController txtcontroller = TextEditingController();
    _controller = PaginatorController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            IconButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Menu(user:widget.user,)));
            }, icon: Icon(Icons.arrow_back)),
            Container(
              child: Expanded(
                child:TextField(
                  controller: txtcontroller,
                  onSubmitted: (value){
                    dataslim.clear();
                    SlimData(txtcontroller.text,provider,sub2,tipo).then((value){
                      setState((){
                        _controller!.goToFirstPage();
                        dataslim.addAll(value);
                      });
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Slim Company',
                  ),
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            RadioGroup<String>.builder(
                direction: Axis.horizontal,
                groupValue: _verticalGroupValue,
                onChanged: (value) {
                  setState((){
                    _verticalGroupValue = value!;
                    switch(_verticalGroupValue){
                      case'Accesorios':tipo='A'; break;
                      case'Refacciones':tipo='R'; break;
                      case'Ambas':tipo='*'; break;
                    }
                    dataslim.clear();
                    SlimData(txtcontroller.text,provider,sub2,tipo).then((value){
                      setState((){
                        dataslim.addAll(value);
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
            FittedBox(
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
                      dataslim.clear();
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
                      SlimData(txtcontroller.text,provider,sub2,tipo).then((value){
                        setState((){
                          dataslim.addAll(value);
                        });
                      });
                    });
                  }),),
            FittedBox(
              child: DropdownButton(
                  underline: Text('Proveedores',style:
                  TextStyle(fontSize: 10,height: 15),),
                  dropdownColor: Colors.deepPurple,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                  value: dropdownvalue,
                  items: item.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Text(items));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dataslim.clear();
                      _controller!.goToFirstPage();
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
                          provider = '000';
                        }
                      }
                      SlimData(txtcontroller.text,provider,sub2,tipo).then((value){
                        setState((){
                          dataslim.addAll(value);
                        });
                      });
                    });
                  }),
            ),
            FittedBox(
              child: IconButton(onPressed: (){
                setState((){
                  dataslim.clear();
                  SlimData('','000','000','*').then((value){
                    setState((){
                      _controller!.goToFirstPage();
                      dataslim.addAll(value);
                    });
                  });
                });
              }, icon: Icon(Icons.refresh)),
            )
          ],
        ),
      ),
      body:
      PaginatedDataTable2(
        controller: _controller,
        horizontalMargin: 20,
        columnSpacing: 5,
        showFirstLastButtons: true,
        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.deepPurple[500]!),
        initialFirstRowIndex: 0,
        rowsPerPage: _rowsPerPage,
        autoRowsToHeight: true,
        minWidth: 800,
        fit: FlexFit.loose,
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
        sortColumnIndex: _sortColumnIndex,
        sortArrowIcon: Icons.keyboard_arrow_up,
        availableRowsPerPage: [5,10,15,20],
        empty: Center(
            child: Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                )

        ),),
        header: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () async {
                 /*await SlimData('','000','000','A').then((value){
                    setState(() {
                      Exl_acc.addAll(value);
                    });
                  });*/
                 await SlimData('', '000', '000', '').then((value) {
                    setState(() {
                      Exl_ref.addAll(value);
                    });
                  });
                  Excelcampana(Exl_ref);
              }, icon: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Facebook_f_logo_%282019%29.svg/2048px-Facebook_f_logo_%282019%29.svg.png')),
              IconButton(onPressed: (){
                SlimData('','000','000','*').then((value){
                  setState((){
                    //progress();
                    Excelist.addAll(value);
                    Excelgenerate(Excelist);
                  });
                });
              }, icon: Image.network('https://http2.mlstatic.com/D_NP_772429-MLA43752501682_102020-T.jpg',),),
              IconButton(onPressed: (){
                Productos().then((value){
                  setState(() {
                    Exl_SN.addAll(value);
                    Excel_SNRelacion(Exl_SN);
                  });
                });
              }, icon: Image.network('https://soporte.mygestion.com/media/wp-content/uploads/tipos-de-stock-700x394.jpg',),),
              IconButton(onPressed: (){
                FileOpen();
              }, icon: Image.network('https://definicion.de/wp-content/uploads/2014/10/stock-1.jpg'),)
            ]
        ),
        columns:[
          DataColumn2(label:Text('Imagen',
              style: TextStyle(
                  color: Colors.white
              )),fixedWidth: 75.0),
          DataColumn2(label: Text('CoD Slim',
            style: TextStyle(
                color: Colors.white
            ),),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.cod_slim.compareTo(B.cod_slim));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.cod_slim.compareTo(A.cod_slim));
                  }
                });
              }),
          DataColumn2(label: Text('Desc',
            style: TextStyle(
                color: Colors.white
            ),),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.cod_slim.compareTo(B.cod_slim));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.cod_slim.compareTo(A.cod_slim));
                  }
                });
              }),
          DataColumn2(label: Text('Status',
            style: TextStyle(
                color: Colors.white
            ),),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.status.compareTo(B.status));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.status.compareTo(A.status));
                  }
                });
              },fixedWidth: 85.0),
          DataColumn2(label: Text('ID_ML',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              )),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.meli.compareTo(B.meli));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.meli.compareTo(A.meli));
                  }
                });
              }
          ),
          DataColumn2(label: Text('Flex',
              style: TextStyle(
                  color: Colors.white
              )),
              size: ColumnSize.S,
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.flex.compareTo(B.flex));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.flex.compareTo(A.flex));
                  }
                });
              },fixedWidth: 50.0),
          DataColumn2(label: Text('Full?',
              style: TextStyle(
                  color: Colors.white
              )),
              size: ColumnSize.S,
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.es_full.compareTo(B.es_full));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.es_full.compareTo(A.es_full));
                  }
                });
              },fixedWidth: 55.0),
          DataColumn2(label: Text('Disp\nCross',
              style: TextStyle(
                  color: Colors.white
              )),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.av_quantity.compareTo(B.av_quantity));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.av_quantity.compareTo(A.av_quantity));
                  }
                });
              }),
          DataColumn2(label: Text('Full',
              style: TextStyle(
                  color: Colors.white
              )),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.stockfull.compareTo(B.stockfull));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.stockfull.compareTo(A.stockfull));
                  }
                });
              }),
          DataColumn2(label: Text('WMS\nDisp',
              style: TextStyle(
                  color: Colors.white
              )),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.wmsunidades.compareTo(B.wmsunidades));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.wmsunidades.compareTo(A.wmsunidades));
                  }
                });
              }),
          DataColumn2(label: Text('V30\nML',
              style: TextStyle(
                  color: Colors.white
              )),onSort:(columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                dataslim.sort((A,B)=>
                    A.vta30ML.compareTo(B.vta30ML));
              }else{
                Ascending=false;
                dataslim.sort((A,B)=>
                    B.vta30ML.compareTo(A.vta30ML));
              }
            });
          }),
          DataColumn2(label: Text('V30\nhist',
              style: TextStyle(
                  color: Colors.white
              )),onSort:(columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                dataslim.sort((A,B)=>
                    A.vta30MLH.compareTo(B.vta30MLH));
              }else{
                Ascending=false;
                dataslim.sort((A,B)=>
                    B.vta30MLH.compareTo(A.vta30MLH));
              }
            });
          }),
          DataColumn2(label: Text('ML\nPrecio',
              style: TextStyle(
                  color: Colors.white
              )),fixedWidth: 60.0),
          DataColumn2(label: Text('Precio\nNeto',
              style: TextStyle(
                  color: Colors.white
              )),fixedWidth: 60.0,
          onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                dataslim.sort((A,B)=>
                    A.costo_publicacion.compareTo(B.costo_publicacion));
              }else{
                Ascending=false;
                dataslim.sort((A,B)=>
                    B.costo_publicacion.compareTo(A.costo_publicacion));
              }
            });
          }),
          DataColumn2(label: Text('Comision',
              style: TextStyle(
                  color: Colors.white
              )),fixedWidth: 60.0,
          onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                dataslim.sort((A,B)=>
                    A.comision_porcentaje.compareTo(B.comision_porcentaje));
              }else{
                Ascending=false;
                dataslim.sort((A,B)=>
                    B.comision_porcentaje.compareTo(A.comision_porcentaje));
              }
            });
          }),
          DataColumn2(label: Text('Asin',
              style: TextStyle(
                  color: Colors.white
              )),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.asin.compareTo(B.asin));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.asin.compareTo(A.asin));
                  }
                });
              }),
          DataColumn2(label: Text('FBA',
              style: TextStyle(
                  color: Colors.white
              )),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.amznfba.compareTo(B.amznfba));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.amznfba.compareTo(A.amznfba));
                  }
                });
              }),
          DataColumn2(label: Text('CROSS',
              style: TextStyle(
                  color: Colors.white
              )),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.amzncross.compareTo(B.amzncross));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.amzncross.compareTo(A.amzncross));
                  }
                });
              }),
          DataColumn2(label: Text('WMS\nDisp',
              style: TextStyle(
                  color: Colors.white
              )),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.stockamazon.compareTo(B.stockamazon));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.stockamazon.compareTo(A.stockamazon));
                  }
                });
              }),
          DataColumn2(label: Text('V30',
              style: TextStyle(
                  color: Colors.white
              )),
              onSort:(columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    dataslim.sort((A,B)=>
                        A.vta30amzn.compareTo(B.vta30amzn));
                  }else{
                    Ascending=false;
                    dataslim.sort((A,B)=>
                        B.vta30amzn.compareTo(A.vta30amzn));
                  }
                });
              }),
          DataColumn2(label: Text('V30\nHist',
              style: TextStyle(
                  color: Colors.white
              )),fixedWidth: 50,
         onSort:(columna,_){
    _sortAscending = columna;
    setState((){
          if(Ascending == false){
           Ascending=true;
          dataslim.sort((A,B)=>
          A.amazon30_hist.compareTo(B.amazon30_hist));
          }else{
            Ascending=false;
             dataslim.sort((A,B)=>
           B.amazon30_hist.compareTo(A.amazon30_hist));
          }
         });
        }),
          DataColumn2(label: Text('Amazon\nPrecio',
              style: TextStyle(
                  color: Colors.white
              )),onSort:(columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                dataslim.sort((A,B)=>
                    A.amazon_precio.compareTo(B.amazon_precio));
              }else{
                Ascending=false;
                dataslim.sort((A,B)=>
                    B.amazon_precio.compareTo(A.amazon_precio));
              }
            });
          }),
        ],
        source: items(dataslim,Stock_ML,widget.user),
      ),
    );
  }

  Future<void> Excelgenerate(List<Slim>Excelist) async{
    int indx = dataslim.length+2;
    List<Slim>Excelist2 = Excelist;
    setState((){
      Excelist = Excelist2.where((element) {
        var lista = element.asin;
        return lista.isNotEmpty;
      }).toList();
    });
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;
    sheet.enableSheetCalculations();

    sheet.getRangeByName('A1').columnWidth=15.0;
    sheet.getRangeByName('B1').columnWidth=35.0;
    sheet.getRangeByName('C1:D1').columnWidth=8.0;
    sheet.getRangeByName('A1:D1').cellStyle.backColor='#0071FF';
    sheet.getRangeByName('A1:D$indx').cellStyle.hAlign=xls.HAlignType.center;
    sheet.getRangeByName('A1:D$indx').cellStyle.vAlign=xls.VAlignType.center;
    sheet.getRangeByName('A1:D$indx').cellStyle.wrapText= true;


    sheet.getRangeByName('A1').setText('Slim');
    sheet.getRangeByName('B1').setText('Desc');
    sheet.getRangeByName('C1').setText('Cross');
    sheet.getRangeByName('D1').setText('WMS\nDisp');

    Stopwatch stopwatch = new Stopwatch()..start();

    for(int x=2;x<Excelist.length+2;x++){
      sheet.getRangeByName('A$x').setText(Excelist[x-2].cod_slim);
      sheet.getRangeByName('B$x').setText(Excelist[x-2].desc);
      sheet.getRangeByName('C$x').setText(Excelist[x-2].amzncross.toString());
      sheet.getRangeByName('D$x').setText(Excelist[x-2].stockamazon.toString());
    }
    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('dMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    try{
      await File('//192.168.10.108/Public/VICTOR/SlimData/Excel_ML_AMZN/$fechasub.xlsx').writeAsBytes(bytes).then((value){
        workbook.dispose();
        print('doSomething() executed in ${stopwatch.elapsed}');
        //imagen_mostrar('Excel exportado');
      });

    }on Exception catch(e){
      print(e);
      //imagen_mostrar('El archivo esta siendo ocupado,\nO la ruta no es correcta');
    }

  }

  Future<void> Excelcampana(List<Slim>MLM_Ref)async {
    Stopwatch stopwatch = new Stopwatch()..start();
    List<Slim> CNASIN = <Slim>[];
    for(int x=0;x<MLM_Ref.length;x++){
     if(MLM_Ref[x].asin.isNotEmpty){
       CNASIN.add(MLM_Ref[x]);
     }
    }
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
    sheet.enableSheetCalculations();
    sheet.getRangeByName('A1').columnWidth=50.0;
    sheet.getRangeByName('B1').columnWidth=50.0;
    sheet.getRangeByName('C1').columnWidth=50.0;
    sheet.getRangeByName('D1').columnWidth=50.0;
    sheet.getRangeByName('E1').columnWidth=50.0;
    sheet.getRangeByName('F1').columnWidth=50.0;
    sheet.getRangeByName('G1').columnWidth=50.0;
    sheet.getRangeByName('H1').columnWidth=50.0;
    sheet.getRangeByName('I1').columnWidth=50.0;
    sheet.getRangeByName('J1').columnWidth=50.0;
    sheet.getRangeByName('K1').columnWidth=50.0;

    for(int x=2;x<CNASIN.length+2;x++){
      sheet.getRangeByName('A$x').setText(CNASIN[x-2].cod_slim);
      sheet.getRangeByName('B$x').setText(CNASIN[x-2].wmsunidades.toString());
      sheet.getRangeByName('C$x').setText(CNASIN[x-2].asin);
      sheet.getRangeByName('D$x').setText(CNASIN[x-2].title);
      sheet.getRangeByName('E$x').setText(CNASIN[x-2].price.toString());
      sheet.getRangeByName('F$x').setText(CNASIN[x-2].amazon_precio.toString());
      sheet.getRangeByName('G$x').setText(CNASIN[x-2].wms_amazon.toString());
      sheet.getRangeByName('H$x').setText(CNASIN[x-2].amznfba.toString());
      sheet.getRangeByName('I$x').setText(CNASIN[x-2].amzncross.toString());
      sheet.getRangeByName('J$x').setText(CNASIN[x-2].vta30amzn.toString());
      //sheet.getRangeByName('K$x').setText(CNASIN[x-2].descripcion.toString());
    }
  }

  Future<void> Excel_stock(List<ubicaciones_stock>Stock)async{
    Stopwatch stopwatch = new Stopwatch()..start();
    List<ubicaciones_stock> Stock_Ref=<ubicaciones_stock>[];
    List<ubicaciones_stock> Stock_Acc=<ubicaciones_stock>[];
    List<ubicaciones_stock> Stock_Otros=<ubicaciones_stock>[];
    for(int x=0;x<Stock.length;x++){
      if(Stock[x].ubicaciones.contains('REFACCIONES')){
        Stock_Ref.add(Stock[x]);
      }else if(Stock[x].ubicaciones.contains('ACCESORIOS')){
        Stock_Acc.add(Stock[x]);
      }else if(Stock[x].ubicaciones!=''){
        Stock_Otros.add(Stock[x]);
      }
    }
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
    final xls.Worksheet sheet2 = workbook.worksheets.add();
    final xls.Worksheet sheet3 = workbook.worksheets.add();

    sheet.enableSheetCalculations();
    sheet.getRangeByName('A1').columnWidth=15.0;
    sheet.getRangeByName('B1').columnWidth=80.0;
    sheet.getRangeByName('C1').columnWidth=180.0;
    sheet2.enableSheetCalculations();
    sheet2.getRangeByName('A1').columnWidth=15.0;
    sheet2.getRangeByName('B1').columnWidth=80.0;
    sheet2.getRangeByName('C1').columnWidth=180.0;
    sheet3.enableSheetCalculations();
    sheet3.getRangeByName('A1').columnWidth=15.0;
    sheet3.getRangeByName('B1').columnWidth=80.0;
    sheet3.getRangeByName('C1').columnWidth=180.0;

    for(int x=2;x<Stock_Acc.length+2;x++){
      sheet.getRangeByName('A$x').setText(Stock_Acc[x-2].codigo_slim);
      sheet.getRangeByName('B$x').setText(Stock_Acc[x-2].descripcion);
      List<String> ubicaciones = Stock_Acc[x-2].ubicaciones.split('|');
      sheet.getRangeByName('C$x').setText(ubicaciones.toString());
    }
    for(int x=2;x<Stock_Ref.length+2;x++){
      sheet2.getRangeByName('A$x').setText(Stock_Ref[x-2].codigo_slim);
      sheet2.getRangeByName('B$x').setText(Stock_Ref[x-2].descripcion);
      List<String> ubicaciones = Stock_Ref[x-2].ubicaciones.split('|');
      sheet2.getRangeByName('C$x').setText(ubicaciones.toString());
    }
    for(int x=2;x<Stock_Otros.length+2;x++){
      sheet3.getRangeByName('A$x').setText(Stock_Otros[x-2].codigo_slim);
      sheet3.getRangeByName('B$x').setText(Stock_Otros[x-2].descripcion);
      List<String> ubicaciones = Stock_Otros[x-2].ubicaciones.split('|');
      sheet3.getRangeByName('C$x').setText(ubicaciones.toString());
    }

    final List<int> bytes = workbook.saveAsStream();
    try{
      await File('//192.168.10.108/Public/VICTOR/SlimData/Stock.xlsx').writeAsBytes(bytes);
      workbook.dispose();
      print('accion realizada en ${stopwatch.elapsed}');
    }on Exception catch(e){
      print(e);
    }
  }

Future<void> Excel_SNRelacion(List<productos>lista_slim)async {
    Stopwatch stopwatch = new Stopwatch()..start();
    List<productos> segmentada= <productos>[];

    for(int x=0;x<lista_slim.length;x++){
      if(lista_slim[x].canales!=null){
        if(lista_slim[x].canales.contains('ML')){
        }else{
          if(lista_slim[x].Stock!=0&&lista_slim[x].sub2!=0){
            segmentada.add(lista_slim[x]);
          }
        }
      }
    }
    for(int x=0;x<lista_slim.length;x++){
      if(lista_slim[x].canales==null&&lista_slim[x].Stock!=0&&lista_slim[x].sub2!=0){
        segmentada.add(lista_slim[x]);
      }
    }
      /*else if(lista_slim[x].Stock==0&&lista_slim[x].sub2!=0){
        segmentada.add(lista_slim[x]);
      }*/

    int indnx =segmentada.length+2;
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1:D$indnx').cellStyle.backColor='#0071FF';
    sheet.getRangeByName('A1').columnWidth=15.0;
    sheet.getRangeByName('A1').setText('Codigo Slim');
    sheet.getRangeByName('B1').setText('Descripcion');
    sheet.getRangeByName('C1').setText('Stock');
    sheet.getRangeByName('D1').setText('Ubicacion');

    for(int x=2;x<segmentada.length+2;x++){
      sheet.getRangeByName('A$x').setText(segmentada[x-2].cod_slim);
      sheet.getRangeByName('B$x').setText(segmentada[x-2].descripcion);
      sheet.getRangeByName('C$x').setText(segmentada[x-2].Stock.toString());
      sheet.getRangeByName('D$x').setText(segmentada[x-2].ubicaciones.toString());
    }
    final List<int> bytes = workbook.saveAsStream();
    try{
      await File('//192.168.10.108/Public/VICTOR/SlimData/SNRelacion.xlsx').writeAsBytes(bytes);
      workbook.dispose();
      print('accion realizada en ${stopwatch.elapsed}');
    }on Exception catch(e){
      print(e);
    }
}


}
class items extends DataTableSource {
  List<Slim> _list = <Slim>[];
  List<areas_stock> stock_ml = <areas_stock>[];
  List<areas_stock> stock_ml_ = <areas_stock>[];
  String user;
  items(this._list, this.stock_ml,this.user);

  @override
  DataRow getRow(int index){
    final format = NumberFormat.decimalPercentPattern(
      locale: 'en',
      decimalDigits: 0,
    );
    if(index>=_list.length)throw'No';
    final _item=_list[index];
    String FBA ='No\naplica';
    String Cross ='No\naplica';
    String V30AMZN ='No\naplica';
    String V30AMZN_HIST ='No\naplica';
    String PRICEAMZN ='No\naplica';
    String DispPlat ='No\naplica';

    String V30SHN ='No\naplica';
    String PRICESHOP ='No\naplica';
    if(_item.amznfba!=-1){FBA=_item.amznfba.toString();}
    if(_item.amzncross!=-1){Cross=_item.amzncross.toString();}
    if(_item.vta30amzn!=-1){V30AMZN=_item.vta30amzn.toString();}
    if(_item.ofertado_shopee!=-1){DispPlat=_item.ofertado_shopee.toString();}
    if(_item.amazon_precio!=-1){PRICEAMZN=_item.amazon_precio.toString();}
    if(_item.amazon30_hist!=-1){V30AMZN_HIST=_item.amazon30_hist.toString();}

    stock_ml_ = stock_ml.where((element) => element.cod_slim.contains(_item.cod_slim)).toList();
    int Stock_en_ML =0;
    if(stock_ml_.isNotEmpty){
      Stock_en_ML = stock_ml_[0].acc_racks+stock_ml_[0].ref_mz+stock_ml_[0].acc_mz;
    }

    return DataRow2.byIndex(
      index: index,
      onTap:(){
        print(_item.cod_slim);
      },
      specificRowHeight: 60.0,
      cells: [
        DataCell(Image.network(_item.thumbnail)),
        DataCell(MenucontextCslim(cod_slim:_item.cod_slim,asin: _item.asin,SKU: _item.sku,IDML: _item.meli,)),
        DataCell(Text(_item.desc)),
        DataCell(Text(_item.status)),
        DataCell(ContxtID(ID: _item.meli,item:_item,user_id:user)),
        DataCell(Text(_item.flex,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),)),
        DataCell(Text(_item.es_full)),
        DataCell(Text(_item.av_quantity.toString())),
        DataCell(Text(_item.stockfull.toString())),
        DataCell(Text(Stock_en_ML.toString())),
        DataCell(Text(_item.vta30ML.toString())),
        DataCell(Text(_item.vta30MLH.toString())),
        DataCell(Text(_item.price.toStringAsFixed(2))),
        DataCell(
              //Text(_item.costo_publicacion.toString()),
            historial_button(precio_neto: _item.costo_publicacion, user:user,ID:_item.meli)
        ),
        DataCell(Text(_item.comision_porcentaje.toStringAsFixed(1)+'%')),
        DataCell(ContxtID(ID: _item.asin,item:_item,user_id: user,)),
        DataCell(Text(FBA)),
        DataCell(Text(Cross)),
        DataCell(Text(_item.stockamazon.toString())),
        DataCell(Text(V30AMZN)),
        DataCell(Text(V30AMZN_HIST)),
        DataCell(Text(PRICEAMZN)),
      ],
    );
  }

  @override
  int get rowCount => _list.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;

}
