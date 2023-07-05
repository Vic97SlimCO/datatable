
import 'dart:convert';
import 'package:contextmenu/contextmenu.dart';
import 'package:datatable/Modelo_contenedor/Slim_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:datatable/main.dart';
import 'package:datatable/Modelo_contenedor/model.dart';
import 'package:flutter/material.dart';
import 'package:datatable/widgets_contenedor/widgets_contenedor.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as box;
import 'package:intl/intl.dart';
import 'Modelo_traspaso/modelo_traspaso.dart' as tras;
import 'confirmados.dart';
import 'option_menu.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'dart:io';
import 'dart:ui';


class ordenes extends StatelessWidget{
  String user;
  ordenes({Key? key,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context){
        return MaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          title: 'Lista Orden',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: Orders(user: user,),
        );
  }
}

class Orders extends StatefulWidget{

  String user;
  Orders({Key? key,required this.user}):super(key: key);


  @override
  State<Orders> createState() => _Orders();
}

class _Orders extends State<Orders>{
  TextEditingController controllerorden = TextEditingController();
  TextEditingController controllerdias = TextEditingController();
  TextEditingController controllerlead = TextEditingController();
  List<String> _status = ["Accesorios", "Refacciones", "Ambas"];
  String _verticalGroupValue = "Ambas";
  String? dropdownvaluep ='*';
  String dropdownsub2 = '*';
  String tipo = "";
  String sub2 = '000';
  List<slim_order> _lista = <slim_order>[];
  List<slim_order> desc_lista = <slim_order>[];
  List<slim_order> Excel_lista = <slim_order>[];
  List<Variant> pubs = <Variant>[];
  String provider='';
  final inxpage = new GlobalKey<PaginatedDataTableState>();
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  List<Proveedores> provs = <Proveedores>[];
  bool descatalogar = false;
  bool ispressedbtn = true;

  Future<List<slim_order>> Orden(String PR,String title, bool? choice,String Dias,String lead,String sublinea2,String tipo) async{
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
    var url = Uri.parse('http://45.56.74.34:8890/container/condensado?&title=$title&dias=$Dias&leadtime=$lead'+PRR+'&sublinea2=$sublinea2&tipo=$tipo'+Con);
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
  Future<List<tras.Slim>> SlimData(String provider) async {
    var url = Uri.parse('http://45.56.74.34:8081/publicaciones_all_select?title=&tipo=*&index=0&proveedor=$provider&sublinea2=000');
    print(url);
    var response = await http.get(url);
    List<tras.Slim> publicaciones = <tras.Slim>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv) {
        publicaciones.add(tras.Slim.from(noteJson));
      }
      return publicaciones;
    }else
      throw Exception('NO se pudo');
  }
  Future<List<Variant>> Publicaciones()async{
    var url = Uri.parse('http://45.56.74.34:8890/container?title=');
    print(url);
    var response = await http.get(url);
    List<Variant> publicaciones = <Variant>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      //print(Jsonv);
      for (var noteJson in Jsonv) {
        publicaciones.add(Variant.from(noteJson));
      }
      return publicaciones;
    }else
      throw Exception('NO se pudo');
  }
  initState(){
    Prove().then((value){
      setState((){
        provs.addAll(value);
      });
    });
    public();
  }

  public() async {
    await Publicaciones().then((value){
      setState(() {
        pubs.addAll(value);
      });
    });
  }

  var item = [
    '*','247?','AMAZING','ASTRON','BEST TERESA','BRASONIC','CAPITAL MOVILE','CELMEX','Celulr Hit',
    'CH ACCESORIES','CHEN','CONSTELACIÓN ORIENTAL','DNS','EAUPULEY','ELE-GATE','ESTEFANO',
    'EVA','HAP TECH INC','IPHONE E.U','IPLUS','KAIPING','LITOY','MARDI','MC',
    'MEGAFIRE','MING','MK','MOBILSHOP','NUNBELL','PAPELERIA','PENDRIVE CITY',
    'RAZZY','RELX','SEO','SIVIVI','SKYROAM','SLIM-CO','SLIM-CO REFACCIONES','VIMI',
    'WEI DAN','XIAOMI','XMOVILE','XP','ZHENG'
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

int _currentColumn =0;
bool _isAscending = true;
bool finderhide = true;
bool secondrow = false;
bool? _boolconfimr = false;
TextEditingController  controllertxt =TextEditingController();
 PaginatorController? _controller;

  @override
  Widget build(BuildContext context) {
    Offset distance = ispressedbtn ? Offset(10, 10) : Offset(28, 28);
    String dias =controllerdias.text;
    String lead = controllerlead.text;
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FittedBox(
            child:IconButton(
              onPressed: (){
                _lista.clear();
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Menu(user:widget.user,)));
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          FittedBox(
            child: Text('Lista\norden'),
          ),
          /*Visibility(child: Expanded(
            child:TextField(
              controller: controllerorden,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,

                fontSize: 20,),
              decoration: InputDecoration(
                  hintText: '   No.Orden'
              ),
            ),),
            visible: finderhide,
          ),*/
          Visibility(child: Expanded(
            child: TextField(
            showCursor: true,
              cursorColor: Colors.white,
            controller: controllerdias,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,),
            decoration: InputDecoration(
                hintText: 'Dias de Pedido'
            ),
          ),),
            visible: finderhide,),
          Visibility(child:Expanded(
            child: TextField(
              showCursor: true,
              cursorColor: Colors.white,
            controller: controllerlead,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Lead Time'
            ),
          ),),
            visible: finderhide,
          ),
          Visibility(child: Expanded(child: DropdownButton(
            underline: Text('Proveedores',style:
            TextStyle(fontSize: 10,height: 15),),
            value:dropdownvaluep,
            dropdownColor: Colors.deepPurple,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),
            onChanged: (String? newValue) {
              setState(() {
                print(dropdownvaluep);
                dropdownvaluep = newValue!;
                provider='';
                print(dropdownvaluep);
                for(int x=0;x<provs.length;x++){
                  if(dropdownvaluep==provs[x].Nombre){
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
                  }else if(dropdownvaluep=='*'){
                    provider = '0';
                  }
                }
              });
            },
            items: item.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
          ),),
            visible: finderhide,
          ),
          Visibility(child:Container(
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
                )),) ,visible: finderhide,),
          Visibility(child:
          Expanded(child:
          TextButton(onPressed: (){
            inxpage.currentState?.pageTo(0);
            print(controllerdias.text+dropdownvaluep!+controllerlead.text+controllerorden.text);
            setState((){
              _lista.clear();
              if(controllerlead.text.isNotEmpty&&controllerdias.text.isNotEmpty){
               // if(provider=='0'||provider==''){
                  /*showDialog(context: context,
                      builder: (BuildContext context){
                        return  AlertDialog(
                            content: Text('Elige un proveedor')
                        );
                      }
                  );*/
               // }else{
                  Orden(provider,'',false,dias,lead,'000',tipo).then((value) {
                    setState((){
                      _lista.addAll(value);
                      desc_lista=_lista;
                      finderhide = false;
                      secondrow = true;
                      print(finderhide);
                    });
                  });
                //}
              }else{
                showDialog(context: context,
                    builder: (BuildContext context){
                      return  AlertDialog(
                          content: Text('Ingresar Datos de la Orden')
                      );
                    }
                );
              }
            });
          }, child: Text('Generar',
            style: TextStyle(
              color: Colors.white
          ),)) ),
            visible: finderhide,),
          Visibility(child:
          Expanded(child:
          TextButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Confirm(user:widget.user)));
          }, child: Text('Confirmados',
            style: TextStyle(
                color: Colors.white
            ),), ) ),
            visible: finderhide,),
        ],
      ),
      ),
                    body:
                        PaginatedDataTable2(
                                onRowsPerPageChanged: (value){
                                  rowsPerPage = value!;
                                  print(rowsPerPage);
                                },
                                showFirstLastButtons: true,
                                fit: FlexFit.tight,
                                controller: _controller,
                                horizontalMargin: 20,
                                columnSpacing: 5,
                                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.deepPurple[500]!),
                                minWidth: 800,
                                autoRowsToHeight: false,
                                rowsPerPage: rowsPerPage,
                                //availableRowsPerPage: [20,50,100],
                            border: TableBorder(
                                bottom: BorderSide(color: Colors.purple[500]!),
                                horizontalInside: const BorderSide(color: Colors.deepPurple, width: 1)
                            ),
                            empty: Center(
                                child: Container(
                                    width: 200,
                                    height: 200,
                                    padding: const EdgeInsets.all(20),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                                    ))),
                          header: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Visibility(child: Expanded(
                                flex: 2,
                                child: TextField(
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black),
                                  controller: controllertxt,
                                  decoration:  InputDecoration(
                                      hintText: 'Cod Slim , MLM , SKU'
                                  ),
                                  onSubmitted: (text){
                                    text = controllertxt.text.toUpperCase();
                                    //areaList.clear();
                                    setState((){
                                      _lista.clear();
                                      inxpage.currentState?.pageTo(0);
                                      if(provider == null){
                                        provider = '0';
                                      }
                                      Orden(provider,text,_boolconfimr!,dias,lead,sub2,tipo).then((value) {
                                        setState((){
                                          _lista.addAll(value);
                                        });
                                      });
                                    });
                                  },
                                ),
                              ),
                                visible: secondrow,),
                              Visibility(child: Container(
                                color: Colors.deepPurple,
                                child:DropdownButton(
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
                                      Orden(provider,controllertxt.text,_boolconfimr!,dias,lead,sub2,tipo).then((value) {
                                        setState((){
                                          _lista.addAll(value);
                                        });
                                      });
                                    });
                                  }),) ,visible: secondrow,),
                              Visibility(child: FittedBox(
                                child: Checkbox(value: _boolconfimr,
                                    onChanged:((bool? value){
                                      setState((){
                                        inxpage.currentState?.pageTo(0);
                                        _boolconfimr = value!;
                                        if(_boolconfimr == true){
                                          _lista.clear();
                                          Orden(provider,controllertxt.text.toUpperCase(),_boolconfimr!,dias,lead,sub2,tipo).then((value) {
                                            setState((){
                                              _lista.addAll(value);
                                            });
                                          });
                                        }else{
                                          _lista.clear();
                                          Orden(provider,controllertxt.text.toUpperCase(),_boolconfimr!,dias,lead,sub2,tipo).then((value) {
                                            setState((){
                                              _lista.addAll(value);
                                            });
                                          });
                                        }
                                      });
                                    })
                                ),
                              ),
                                visible: secondrow,
                              ),
                              Visibility(child: FittedBox(
                                child: TextButton(
                                  onPressed: () {
                                    Orden(provider,'',false,'0','0',sub2,tipo).then((value) {
                                      setState((){
                                        Excel_lista.clear();
                                        Excel_lista.addAll(value);
                                          ExcelProveedor(Excel_lista);
                                      });
                                    });
                                  },
                                  child: Text('V30D\nProveedor'),
                                ),
                              ),
                                visible: secondrow,
                              ),
                              Visibility(child:FittedBox(child: TextButton(
                                  style: TextButton.styleFrom(primary: Colors.deepPurple),
                                  onPressed: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => new Confirm(user:widget.user)));
                                  }
                                  , child: Text('Confirmados')),),
                                visible: secondrow,),
                              Visibility(
                                child:FittedBox(
                                child: TextButton(
                                    style: TextButton.styleFrom(primary: Colors.deepPurple),
                                    onPressed: (){
                                      setState(() {
                                        ispressedbtn = !ispressedbtn;
                                        if(descatalogar==false){
                                          descatalogar = true;
                                          _lista= desc_lista.where((element) {
                                            var agotar = element.Agotar;
                                            return agotar.contains('X');
                                          }).toList();
                                        }else{
                                          descatalogar = false;
                                          _lista = desc_lista.where((element) {
                                            var agotar = element.Agotar;
                                            return agotar.contains(' ');
                                          }).toList();
                                        }
                                        print(ispressedbtn);
                                        print(descatalogar);
                                      });
                                    }
                                    , child: Text('Quitar\nAgotar')),),
                                visible: secondrow,),
                              Visibility(child: FittedBox(
                                child: IconButton(onPressed: (){
                                  Orden(provider,'',_boolconfimr!,dias,lead,'000',tipo).then((value) {
                                    setState((){
                                      _lista.clear();
                                      _lista.addAll(value);
                                    });
                                  });
                                }, icon: Icon(Icons.refresh,color: Colors.deepPurple,)),
                              ),visible: secondrow,),
                              Visibility(child: FittedBox(
                                child: IconButton(
                                  onPressed: (){
                                  setState(() {
                                    _lista.clear();
                                    finderhide = true;
                                    secondrow = false;
                                  });
                                  }, icon: Icon(Icons.cancel_sharp,color: Colors.deepPurple,),
                                ),
                              ),visible: secondrow,),
                              Visibility(
                                  child: FittedBox(
                                    child: TextButton(
                                        onPressed: (){

                                        },
                                        child:Text('Terminar\nPedido'),),
                                  ),visible: secondrow,)
                            ],
                          ),
                                columns: [
                                  DataColumn2(label: Text('Cod_Slim',
                                      style: TextStyle(
                                          color: Colors.white
                                      )),
                                      onSort:(columna,_){
                                        setState((){
                                          _currentColumn = columna;
                                          if(_isAscending == false){
                                            _isAscending = true;
                                            _lista.sort((A,B)=>
                                                A.codigo_slim.compareTo(B.codigo_slim));
                                          } else{
                                            _isAscending = false;
                                            _lista.sort((A,B)=>
                                                B.codigo_slim.compareTo(A.codigo_slim));
                                          }
                                        });
                                      }),
                                  DataColumn2(label: Text('Desc_Corta',
                                    style: TextStyle(
                                      color: Colors.white
                                  ),),
                                      onSort: (columna,_){
                                        setState((){
                                          _currentColumn = columna;
                                          if(_isAscending == false){
                                            _isAscending = true;
                                            _lista.sort((A,B)=>
                                                A.Desc.compareTo(B.Desc));
                                          } else{
                                            _isAscending = false;
                                            _lista.sort((A,B)=>
                                                B.Desc.compareTo(A.Desc));
                                          }
                                        });
                                      }),
                                  DataColumn2(label: Text('Imagen',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),)),
                                  DataColumn2(label: Text('SKU',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),)),
                                  //DataColumn(label: Text('Cantidad')),
                                  DataColumn2(label: Text('V30 Nat',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),),
                                      onSort:(columna,_){
                                        setState((){
                                          _currentColumn = columna;
                                          if(_isAscending == false){
                                            _isAscending = true;
                                            _lista.sort((A,B)=>
                                                A.v30nat.compareTo(B.v30nat));
                                          } else{
                                            _isAscending = false;
                                            _lista.sort((A,B)=>
                                                B.v30nat.compareTo(A.v30nat));
                                          }
                                        });
                                      }
                                  ),
                                  DataColumn2(label: Text('V30 Hist',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),),
                                  onSort: (columna,_){
                                    setState((){
                                      _currentColumn = columna;
                                      if(_isAscending == false){
                                        _isAscending = true;
                                        _lista.sort((A,B)=>
                                            A.v30hist.compareTo(B.v30hist));
                                      } else{
                                        _isAscending = false;
                                        _lista.sort((A,B)=>
                                            B.v30hist.compareTo(A.v30hist));
                                      }
                                    });
                                  }),
                                  DataColumn2(label: Text('Stock Cedis',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),)),
                                  DataColumn2(label: Text('Full',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),)),
                                  DataColumn2(label: Text('Camino',
                                      style: TextStyle(
                                          color: Colors.white
                                      ))),
                                  DataColumn2(label: Text('PedidoSugerido',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),),
                                  onSort:(columna,_){
                                    setState((){
                                      _currentColumn = columna;
                                      if(_isAscending == false){
                                        _isAscending = true;
                                        _lista.sort((A,B)=>
                                            A.sugerido.compareTo(B.sugerido));
                                      } else{
                                        _isAscending = false;
                                        _lista.sort((A,B)=>
                                            B.sugerido.compareTo(A.sugerido));
                                      }
                                    });
                                  }),
                                  DataColumn2(label: Text('Confirmadas',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),)),
                                  DataColumn2(label: Text('Unidades Pedidas',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),),
                                      onSort: (columna,_){
                                        setState((){
                                          _currentColumn = columna;
                                          if(_isAscending == false){
                                            _isAscending = true;
                                            _lista.sort((A,B)=>
                                                A.confimadas.compareTo(B.confimadas));
                                          } else{
                                            _isAscending = false;
                                            _lista.sort((A,B)=>
                                                B.confimadas.compareTo(A.confimadas));
                                          }
                                        });
                                      }
                                  ),
                                  DataColumn2(label: Text('Unidades por caja',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),)),
                                  DataColumn2(label: Text('Precio ultimo',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),)),
                                  //DataColumn(label: Text('Color')),
                                  DataColumn2(label: Text('Agotar_Descatalogar',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),),
                                      onSort: (columna,_){
                                        setState((){
                                          _currentColumn = columna;
                                          if(_isAscending == false){
                                            _isAscending = true;
                                            _lista.sort((A,B)=>
                                                A.Agotar.compareTo(B.Agotar));
                                          } else{
                                            _isAscending = false;
                                            _lista.sort((A,B)=>
                                                B.Agotar.compareTo(A.Agotar));
                                          }
                                        });
                                      }),
                                ],
                                source: items(_lista,widget.user,pubs),
                              ),
                        );
                      }
                      Future<void> ExcelProveedor(List<slim_order>Excelist) async{
                          Stopwatch stopwatch = new Stopwatch()..start();
                          int indx = Excelist.length+2;
                          setState((){
                            Excelist.sort((A,B)=>
                                B.v30hist.compareTo(A.v30hist));
                          });

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
                          sheet.getRangeByName('A1:O$indx').cellStyle.hAlign=xls.HAlignType.center;
                          sheet.getRangeByName('A1:O$indx').cellStyle.vAlign=xls.VAlignType.center;
                          sheet.getRangeByName('A1:O$indx').cellStyle.wrapText= true;
                          sheet.getRangeByName('J2:J$indx').cellStyle.fontColor='#008BFF';
                          sheet.getRangeByName('F2:F$indx').cellStyle.fontColor='#07BA00';

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
                          for(int x=2;x<Excelist.length+2;x++){
                            vhistoricas_totales = vhistoricas_totales + Excelist[x-2].v30hist;
                          }
                          print(vhistoricas_totales);
                          for(int x=2;x<Excelist.length+2;x++){
                            Acumulado = Acumulado +(Excelist[x-2].v30hist/vhistoricas_totales);
                            sheet.getRangeByName('A$x').setText(Excelist[x-2].codigo_slim);
                            sheet.getRangeByName('B$x').setText(Excelist[x-2].Desc);
                            sheet.getRangeByName('C$x').setText(Excelist[x-2].SKU.toString());
                            sheet.getRangeByName('D$x').setText(Excelist[x-2].v30hist.toString());
                            //sheet.getRangeByName('E$x').setText(Excelist[x-2].;
                            sheet.getRangeByName('F$x').setText(Excelist[x-2].costo_ultimo.toStringAsFixed(2));
                            sheet.getRangeByName('G$x').setText(Excelist[x-2].cedis.toString());
                            sheet.getRangeByName('H$x').setText(Excelist[x-2].full.toString());
                            sheet.getRangeByName('I$x').setText(Excelist[x-2].stock_total.toString());
                            sheet.getRangeByName('J$x').setText(Excelist[x-2].stockMeses.toStringAsFixed(9));
                            sheet.getRangeByName('K$x').setText((Excelist[x-2].v30hist*3).toString());
                            if(Excelist[x-2].pedir>0){
                              sheet.getRangeByName('L$x').setText(Excelist[x-2].pedir.toString());
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
                            sheet.getRangeByName('M$x').setValue(((Excelist[x-2].v30hist/vhistoricas_totales)*100).toStringAsFixed(2)+'%');
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
                            await File('//192.168.10.108/Public/VICTOR/SlimData/Excel_Ventasproveedor/$fechasub-$dropdownvaluep.xlsx').writeAsBytes(bytes).then((value){
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

class items extends DataTableSource{
  List<slim_order> _list = <slim_order>[];
  List<Variant> _lista_variante = <Variant>[];
  List<Variant> _lista_variante_ = <Variant>[];
  String user;
  items(this._list,this.user,this._lista_variante);
  bool color_row=false;

  @override
  DataRow? getRow(int index){
if(index>=_list.length)return null;
final _item = _list[index];
int encamino = 0;
if(_item.codigo_slim!=''){
  _lista_variante_ = _lista_variante.where((element) => element.Slim.contains(_item.codigo_slim)).toList();
  for(int x=0;x<_lista_variante_.length;x++){encamino=encamino+_lista_variante_[x].Cam; }}
int sugest=0;
if(_item.sugerido >0){
  sugest = _item.sugerido;
  //print(_item.sugerido.toString().length.toString()[_item.sugerido.toString().length]);
  print(_item.sugerido.toString()[_item.sugerido.toString().length-1]);
switch(_item.sugerido.toString()[_item.sugerido.toString().length-1]){
  case '9': sugest =sugest+1;break;
  case '8': sugest=sugest+2;break;
  case '7': sugest=sugest-2;break;
  case '6': sugest=sugest-1;break;
  case '4': sugest=sugest+1;break;
  case '3': sugest=sugest+2;break;
  case '2': sugest=sugest-2;break;
  case '1': sugest=sugest-1;break;
}
}

    return DataRow2.byIndex(index: index,
      specificRowHeight: 60.0,
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: _item.codigo_slim));
        //getColors();
      },
      //color: getColors(),
      cells: [
        DataCell(ContextSlim(CoDSlim:_item.codigo_slim,SKU: _item.SKU,)),
        DataCell(Text(_item.Desc)),
        DataCell(Image.network(_item.Thumbnail)),
        DataCell(Text(_item.SKU)),
        DataCell(Text(_item.v30nat.toString())),
        DataCell(Text(_item.v30hist.toString()),),
        DataCell(Text(_item.cedis.toString())),
        DataCell(Text(_item.full.toString())),
        DataCell(Text(encamino.toString())),
        DataCell(Text(sugest.toString())),
        DataCell(UnidadesConf(Slim: _item.codigo_slim, Desc: _item.Desc, User: user,
          Title: '',Variation: '',ID: '',)),
        DataCell(Text(_item.confimadas.toString())),
        DataCell(Text(_item.caja.toString())),
        DataCell(Text(_item.costo_ultimo.toStringAsFixed(2))),
        //DataCell(Text(_item.Color)),
        DataCell(Text(_item.Agotar,
          style: TextStyle(
            color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20)))
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => true;

  @override
  // TODO: implement rowCount
  int get rowCount => _list.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}

