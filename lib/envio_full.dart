
import 'dart:convert';

import 'package:contextmenu/contextmenu.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datatable/widgets_enviofull/widgets_enviofull.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:multi_sort/multi_sort.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Modelo_contenedor/Slim_model.dart';
import 'Modelo_traspaso/modelo_traspaso.dart';
import 'main.dart';
import 'option_menu.dart';

class envio_full extends StatelessWidget{
  String user_id;
  envio_full({Key? key,required this.user_id}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'envio_tabla',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      home: Envio(user_id: user_id,),
    );
  }
}

class Envio extends StatefulWidget{
  String user_id;
  Envio({required this.user_id});
  @override
  State<StatefulWidget> createState() => _Envio(user_id: user_id);
}

class _Envio extends State<Envio> {
  String user_id;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortAscending = 0;
  bool Ascending = true;
  int? _sortColumnIndex;
  List<Slim> SlimLista = <Slim>[];
  List<Slim> Envio = <Slim>[];
  List<areas_stock> Stock_ML = <areas_stock>[];
  List<Proveedores> provs = <Proveedores>[];
  PaginatorController? _controller;
  _Envio({Key? key,required this.user_id});

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

  initState(){
    SlimData('','000','000','*').then((value){
      setState((){
        SlimLista.addAll(value);
        Envio=SlimLista;
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
    '*', '247?', 'AMAZING', 'ASTRON',
    'BEST TERESA', 'BRASONIC', 'CAPITAL MOVILE',
    'CELMEX', 'Celulr Hit', 'CH ACCESORIES', 'CHEN',
    'CONSTELACIÓN ORIENTAL', 'DNS', 'EAUPULEY',
    'ELE-GATE', 'ESTEFANO', 'EVA', 'HAP TECH INC',
    'IPHONE E.U', 'IPLUS', 'KAIPING', 'LITOY',
    'MARDI', 'MC', 'MEGAFIRE', 'MING', 'MK',
    'MOBILSHOP', 'NUNBELL', 'PAPELERIA', 'PENDRIVE CITY',
    'RAZZY', 'RELX', 'SEO', 'SIVIVI', 'SKYROAM', 'SLIM-CO',
    'SLIM-CO REFACCIONES', 'VIMI', 'WEI DAN', 'XIAOMI',
    'XMOVILE', 'XP', 'ZHENG'
  ];
  String provider = '000';
  String dropdownvalue = '*';
  String dropdownsub2 = '*';
  List<String> _status = ["Accesorios", "Refacciones", "Ambas"];
  String _verticalGroupValue = "Ambas";
  String tipo = "*";
  String sub2 = '000';
  double value = 0;
  TextEditingController daycontroller = TextEditingController();
  List<bool> criteria = [false, false];
  //prefrrence List
  List<String> preferrence = ['vta30ML','status'];

  @override
  Widget build(BuildContext context) {
    TextEditingController txtcontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: <Widget>[
            IconButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Menu(user:widget.user_id,)));
            }, icon: Icon(Icons.arrow_back)),
            Container(
              child: Expanded(
                child: TextField(
                  controller: txtcontroller,
                  onSubmitted: (value){
                    SlimLista.clear();
                    SlimData(txtcontroller.text,provider,sub2,tipo).then((value){
                      setState((){
                        SlimLista.addAll(value);
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
                textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white),
                activeColor: Colors.white,
                direction: Axis.horizontal,
                groupValue: _verticalGroupValue,
                onChanged: (value){
                  setState((){
                    _verticalGroupValue = value!;
                    switch(_verticalGroupValue){
                      case'Accesorios':tipo='A'; break;
                      case'Refacciones':tipo='R'; break;
                      case'Ambas':tipo='*'; break;
                    }
                    SlimLista.clear();
                    SlimData(txtcontroller.text,provider,sub2,tipo).then((value){
                      setState((){
                        SlimLista.addAll(value);
                      });
                    });
                    print(_verticalGroupValue);
                  });
                },
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
                        SlimLista.clear();
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
                            SlimLista.addAll(value);
                          });
                        });
                      });
                    })
            ),
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
                      SlimLista.clear();
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
                          SlimLista.addAll(value);
                        });
                      });
                    });
                  }),
            ),
            FittedBox(
              child: IconButton(onPressed: (){
                setState((){
                  SlimLista.clear();
                  SlimData('','000','000','*').then((value){
                    setState((){
                      SlimLista.addAll(value);
                    });
                  });
                });
              }, icon: Icon(Icons.refresh)),
            ),
          ],
        ),
      ),
      body: PaginatedDataTable2(
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
          children: <Widget>[
            Expanded(
             child: TextField(
                controller: daycontroller,
                onChanged: (String? value){
                  value=daycontroller.text;
                  int valorint = int.parse(value);
                  Provider.of<Lead_>(context,listen: false).pedidodiasML(valorint);
                },
              ),
            )
          ],
        ),
        columns: [
          DataColumn2(label:Text('Imagen',
              style: TextStyle(
                  color: Colors.white
              )),fixedWidth: 75.0,
          ),
          DataColumn2(label:Text('Codigo\nSlim',
              style: TextStyle(
                  color: Colors.white
              )),
              onSort: (columna,_){
                _sortAscending = columna;
                setState((){
                  if(Ascending == false){
                    Ascending=true;
                    SlimLista.sort((A,B)=>
                    A.cod_slim.compareTo(B.cod_slim));
                  }else{
                    Ascending=false;
                    SlimLista.sort((A,B)=>
                    B.cod_slim.compareTo(A.cod_slim));
                  }
                });
              }),
          DataColumn2(label:Text('Desc',
              style: TextStyle(
                  color: Colors.white
              )),onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                SlimLista.sort((A,B)=>
                    A.desc.compareTo(B.desc));
              }else{
                Ascending=false;
                SlimLista.sort((A,B)=>
                    B.desc.compareTo(A.desc));
              }
            });
          }),
          DataColumn2(label:Text('Color',
              style: TextStyle(
                  color: Colors.white
              ))),
          DataColumn2(label:Text('ID\nPublicacion',
              style: TextStyle(
                  color: Colors.white
              ))),
          DataColumn2(label:Text('Status',
              style: TextStyle(
                  color: Colors.white
              )),onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                SlimLista.sort((A,B)=>
                    A.status.compareTo(B.status));
              }else{
                Ascending=false;
                SlimLista.sort((A,B)=>
                    B.status.compareTo(A.status));
              }
            });
          }),
          DataColumn2(label:Text('Flex',
              style: TextStyle(
                  color: Colors.white
              ))),
          DataColumn2(label:Text('Full?',
              style: TextStyle(
                  color: Colors.white
              )),onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                SlimLista.sort((A,B)=>
                    A.es_full.compareTo(B.es_full));
              }else{
                Ascending=false;
                SlimLista.sort((A,B)=>
                    B.es_full.compareTo(A.es_full));
              }
            });
          }),
          DataColumn2(label:Text('Disp\nCross',
              style: TextStyle(
                  color: Colors.white
              )),onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                SlimLista.sort((A,B)=>
                    A.av_quantity.compareTo(B.av_quantity));
              }else{
                Ascending=false;
                SlimLista.sort((A,B)=>
                    B.av_quantity.compareTo(A.av_quantity));
              }
            });
          }),
          DataColumn2(label:Text('Full',
              style: TextStyle(
                  color: Colors.white
              )),onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                SlimLista.sort((A,B)=>
                    A.stockfull.compareTo(B.stockfull));
              }else{
                Ascending=false;
                SlimLista.sort((A,B)=>
                    B.stockfull.compareTo(A.stockfull));
              }
            });
          }),
          DataColumn2(label:Text('WMS\nDisp',
              style: TextStyle(
                  color: Colors.white
              )),onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                SlimLista.sort((A,B)=>
                    A.stock.compareTo(B.stock));
              }else{
                Ascending=false;
                SlimLista.sort((A,B)=>
                    B.stock.compareTo(A.stock));
              }
            });
          }),
          DataColumn2(
            /*label: GestureDetector(
              child: Text('v30\nNaturales'),
              onTap: (){
                setState((){
                  SlimLista.multisort(criteria,preferrence);
                });
              },
            )*/
            label:Text('V30\nNaturales',
              style: TextStyle(
                  color: Colors.white
              )),onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                SlimLista.sort((A,B)=>
                    A.vta30ML.compareTo(B.vta30ML));
              }else{
                Ascending=false;
                SlimLista.sort((A,B)=>
                    B.vta30ML.compareTo(A.vta30ML));
              }
            });
          }
          ),
          DataColumn2(label:Text('V30\nHistoricas',
              style: TextStyle(
                  color: Colors.white
              )),onSort: (columna,_){
            _sortAscending = columna;
            setState((){
              if(Ascending == false){
                Ascending=true;
                SlimLista.sort((A,B)=>
                    A.vta30MLH.compareTo(B.vta30MLH));
              }else{
                Ascending=false;
                SlimLista.sort((A,B)=>
                    B.vta30MLH.compareTo(A.vta30MLH));
              }
            });
          }),
            DataColumn2(label: Text('Precio',
              style: TextStyle(
                  color: Colors.white
              ))),
          DataColumn2(label: Text('Envio\nSugerido',
              style: TextStyle(
                  color: Colors.white
              ))),
          DataColumn2(label: Text('Cantidad',
              style: TextStyle(
                  color: Colors.white
              ))),
          DataColumn2(label: Text('Unidades\nen Envio',
              style: TextStyle(
                  color: Colors.white
              ))),
        ],
        source: items(SlimLista, Stock_ML,context),

      ),
    );
  }
}

class items extends DataTableSource{

  List<Slim> _list = <Slim>[];
  List<areas_stock> stock_ml = <areas_stock>[];
  BuildContext context;
  items(this._list,this.stock_ml, this.context);
  TextEditingController controlEnviosFull = TextEditingController();

  @override
  DataRow? getRow(int index) {
    if(index>=_list.length)throw'No';
    final _item=_list[index];
    num dias = Provider.of<Lead_>(context).pedidoML;
    String EnviosML =(((_item.vta30ML/30)*dias)-_item.stockfull).toStringAsFixed(0);
    controlEnviosFull.text=EnviosML.toString();
    return DataRow2.byIndex(
        index: index,
        specificRowHeight: 60.0,
        cells: [
          DataCell(Image.network(_item.thumbnail)),
          DataCell(ContextSlimCodTXT(_item.cod_slim,_item.sku),
          onTap: (){
            Clipboard.setData(ClipboardData(text: _item.cod_slim));
          }),
          DataCell(Text(_item.desc)),
          DataCell(Text(_item.color)),
          DataCell(ContextMLMTXT(_item.meli),
          onTap: (){
            Clipboard.setData(ClipboardData(text: _item.meli));
          }),
          DataCell(Text(_item.status)),
          DataCell(Text(_item.flex)),
          DataCell(Text(_item.es_full)),
          DataCell(Text(_item.av_quantity.toString())),
          DataCell(Text(_item.stockfull.toString())),
          DataCell(Text(_item.stock.toString()),
          onTap: (){
            showDialog(context: context,
                builder: (BuildContext context){
              return AlertStock(Cod_Slim: _item.cod_slim);
                });
          }),
          DataCell(Text(_item.vta30ML.toString())),
          DataCell(Text(_item.vta30MLH.toString())),
          DataCell(Text(_item.price.toString())),
          DataCell(Text(EnviosML)),
          DataCell(TextField()),
          DataCell(Text('')),
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _list.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  ContextMLMTXT(String mlm){
    return Padding(padding: EdgeInsets.all(1.0),
    child: ContextMenuArea(
      child: Text(mlm,
      style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15),),
      builder: (context)=>[
        ListTile(
          title: Text('ML Publicaciones'),
          onTap: (){
            _Publicaciones(mlm);
          },
        ),
        ListTile(
          title: Text('Gestion de Full'),
          onTap: (){
            _GestionFull(mlm);
          },
        )
      ],
    ),
    );
  }

  ContextSlimCodTXT(String Cod_Slim, String sku){
    return Padding(padding: EdgeInsets.all(1.0),
    child: ContextMenuArea(
      builder: (context)=>[
        ListTile(
          title: Text('Copiar Sku'),
          onTap: (){
            Clipboard.setData(ClipboardData(text: sku));
          },
        ),
      ],
      child: Text(Cod_Slim,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      fontSize: 15),),
    ),);
  }

  _GestionFull(String MLM) async {
    var url = Uri.parse('https://www.mercadolibre.com.mx/publicaciones/listado/fulfillment?filters=with_fulfillment_with_stock_remaining_weeks_in_zero|with_fulfillment_with_stock_remaining_weeks_range_zero_one|with_fulfillment_with_stock_remaining_weeks_range_one_two|with_fulfillment_with_stock_remaining_weeks_range_two_four|with_fulfillment_with_stock_remaining_weeks_range_four_six|with_fulfillment_with_stock_remaining_weeks_more_than_six|with_fulfillment_without_stock_remaining_calculation|top_sales_enviable|without_fulfillment_enviable|no_sales_last_thirty_days|surplus_stock|insufficient_stock|waiting_for_arrival|in_transfer|return_by_buyer|to_withdraw|to_review|temporarily_not_for_sale|ready_to_withdraw&page=1&search=$MLM');
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    } else {
      throw 'no se pudo lanzar navegador';
    }
  }

  _Publicaciones(String MLM) async{
    var url = Uri.parse('https://www.mercadolibre.com.mx/publicaciones/listado?page=1&search=MLM930527541');
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    } else {
      throw 'no se pudo lanzar navegador';
    }
  }

}
