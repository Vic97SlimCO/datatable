import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui';
import 'package:contextmenu/contextmenu.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:datatable/Modelo_contenedor/model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:pasteboard/pasteboard.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'Login.dart';
import 'Modelo_contenedor/Slim_model.dart';
import 'confirmados.dart';
import 'package:intl/intl.dart';
import 'listaorders.dart';
import 'package:path/path.dart' as p;

import 'option_menu.dart';

void main() => runApp(
    //tree()
  ChangeNotifierProvider(
      create: (_) => Lead_(),
  child: LoginTable(),)
);

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

class MyApp extends StatelessWidget {
  String user;
  MyApp({Key? key, required this.user}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'DataTable Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home:  MyHomePage(title: 'Slim Co-Pedidos',user: user),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String user;
   MyHomePage({Key? key, required this.title, required this.user}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(user:user);
}

class _MyHomePageState extends State<MyHomePage> {
  String user;
  _MyHomePageState({required this.user});
   List<Variant> areaList=<Variant>[];
   final ScrollController _controllerS=ScrollController();
   TextEditingController controllertxt = TextEditingController();
   List<Variant> finder=<Variant>[];
   List<Variant> finder_prov=<Variant>[];
   final inxpage = new GlobalKey<PaginatedDataTableState>();
   List<Proveedores> provs = <Proveedores>[];
   List<Pv> Puntov2=<Pv>[];
   List<PvStock> Puntov2s = <PvStock>[];
   List<Pv> Puntov=<Pv>[];
   List<PvStock> Puntovs = <PvStock>[];

   bool VSlim = true;
   int? sortColumn;

   Future<List<Variant>> Variante(String ML,String PR, bool confirm) async{
     String MLM = ML;
     String PRR = '&proveedor=$PR';
     String CON = '';
     if(confirm == true){
          CON ='&confirmados=yes';
     } else {
       CON ='';
     }

     //var url = Uri.parse('http://45.56.74.34:8081/publicaciones_all_select?title=$MLM&tipo=*&index=0&proveedor=$PRR&sublinea2=000');
     var url = Uri.parse('http://45.56.74.34:8890/container?title=$ML'+PRR+CON);
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

Future<List<Pv>> Punto2()async{
     var hoy = DateTime.now();
     var dias30 = hoy.subtract(Duration(days: 30));
     var formatDate =new DateFormat('yyyy-MM-dd');
     String fhoy = formatDate.format(hoy);
     String d30 = formatDate.format(dias30);
     print(d30+'_'+fhoy);
     var url = Uri.parse("http://45.56.74.34:5558/clientes/ventas/list/productos?almacen_id=2&fecha1=$d30&fecha2=$fhoy&token=288c6a77cdc4af2c0834fac271eb58f9");
     var response = await http.get(url);
     List<Pv> puntov2 = <Pv>[];
     if(response.statusCode == 200){
       String sJson = response.body.toString();
       int count = sJson.toString().length;
       String _sub = sJson.toString().substring(34,count-1);
       var Jsonv = json.decode(_sub);
       for(var noteJson in Jsonv){
         puntov2.add(Pv.from(noteJson));
       }
       return puntov2;
     } else{
       throw Exception('No pudo');
     }
}

Future<List<PvStock>> Punto2S() async{
     var url=Uri.parse("http://45.56.74.34:5558/productos/lineas/inventario?almacen_id=2&token=288c6a77cdc4af2c0834fac271eb58f9");
     var response = await http.get(url);
     List<PvStock> PV2S = <PvStock>[];
     if(response.statusCode==200){
       String sJson = response.body.toString();
       int count = sJson.toString().length;
       String _sub = sJson.toString().substring(36,count-1);
       var Jsonv = json.decode(_sub);
       for(var notejson in Jsonv){
         PV2S.add(PvStock.from(notejson));
       }
       return PV2S;
     } else {
       throw Exception('No se pudo');
     }
}

   Future<List<Pv>> Punto()async{
     var hoy = DateTime.now();
     var dias30 = hoy.subtract(Duration(days: 30));
     var formatDate =new DateFormat('yyyy-MM-dd');
     String fhoy = formatDate.format(hoy);
     String d30 = formatDate.format(dias30);
     print(d30+'_'+fhoy);
     var url = Uri.parse("http://45.56.74.34:5558/clientes/ventas/list/productos?almacen_id=1&fecha1=$d30&fecha2=$fhoy&token=288c6a77cdc4af2c0834fac271eb58f9");
     var response = await http.get(url);
     List<Pv> puntov = <Pv>[];
     if(response.statusCode == 200){
       String sJson = response.body.toString();
       int count = sJson.toString().length;
       String _sub = sJson.toString().substring(34,count-1);
       var Jsonv = json.decode(_sub);
       for(var noteJson in Jsonv){
         puntov.add(Pv.from(noteJson));
       }
       return puntov;
     } else{
       throw Exception('No pudo');
     }
   }

   Future<List<PvStock>> PuntoS() async {
     var url = Uri.parse(
         "http://45.56.74.34:5558/productos/lineas/inventario?almacen_id=1&token=288c6a77cdc4af2c0834fac271eb58f9");
     var response = await http.get(url);
     List<PvStock> PVS = <PvStock>[];
     if (response.statusCode == 200) {
       String sJson = response.body.toString();
       int count = sJson
           .toString()
           .length;
       String _sub = sJson.toString().substring(36, count - 1);
       var Jsonv = json.decode(_sub);
       for (var notejson in Jsonv) {
         PVS.add(PvStock.from(notejson));
       }
       return PVS;
     } else {
       throw Exception('No se pudo');
     }
   }

   bool? value = false;
   bool? _boolconfimr = false;
  bool? _hide = false;
   var rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
   int _currentSortColumn = 0;
   bool _isAscending = true;
   @override
   void initState(){
     String MLM='';
     Variante(MLM,'0',_boolconfimr!).then((value) {
       setState((){
         areaList.addAll(value);
       });
     });
     finder=areaList;
     finder_prov=areaList;
     Prove().then((value){
       setState((){
         provs.addAll(value);
       });
     });
     Punto2().then((value){
       setState((){
         Puntov2.addAll(value);
       });
     });
     Punto2S().then((value){
       setState((){
         Puntov2s.addAll(value);
       });
     });
     Punto().then((value){
       setState((){
         Puntov.addAll(value);
       });
     });
     PuntoS().then((value){
       setState((){
         Puntovs.addAll(value);
       });
     });
     super.initState();
   }

   String dropdownvalue = '*';
   String provider = '';
   String dropdownday = '15 dias';
   TextEditingController daycontroller = TextEditingController();
   TextEditingController leadcontroller = TextEditingController();
var days= ['15 dias','30 dias','45 dias','60 dias','75 dias','90 dias'];
   // List of items in our dropdown menu
   var item = [
     '*','247?','AMAZING','ASTRON','BEST TERESA','BRASONIC','CAPITAL MOVILE','CELMEX','Celulr Hit',
     'CH ACCESORIES','CHEN','CONSTELACIÓN ORIENTAL','DNS','EAUPULEY','ELE-GATE','ESTEFANO',
     'EVA','HAP TECH INC','IPHONE E.U','IPLUS','KAIPING','LITOY','MARDI','MC',
     'MEGAFIRE','MING','MK','MOBILSHOP','NUNBELL','PAPELERIA','PENDRIVE CITY',
     'RAZZY','RELX','SEO','SIVIVI','SKYROAM','SLIM-CO','SLIM-CO REFACCIONES','VIMI',
     'WEI DAN','XIAOMI','XMOVILE','XP','ZHENG'
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //body:FittedBox(
        body: Column(
          children: <Widget>[
        Padding(padding: const EdgeInsets.all(8.0),
     child: Row(
       children: <Widget>[
         Expanded(
           flex: 2,
         child: TextField(
           controller: controllertxt,
           decoration:  InputDecoration(
               hintText: 'Cod Slim , MLM , SKU'
           ),
           onSubmitted: (text){
             text = controllertxt.text.toUpperCase();
             //areaList.clear();
             setState((){
               areaList.clear();
               inxpage.currentState?.pageTo(0);
               if(provider == null){
                 provider = '0';
               }
               Variante(text,provider,_boolconfimr!).then((value){
                setState((){
                  areaList.addAll(value);
                });
              });

             });
           },
         ),
       ),
         Expanded(
          flex: 1,
           child: IconButton(
           icon: const Icon(Icons.refresh),
           onPressed: (){
             setState((){
               inxpage.currentState?.pageTo(0);
               areaList.clear();
               finder.clear();

               Variante('','0',_boolconfimr!).then((value) {
                 setState((){
                   areaList.addAll(value);
                 });
               });
               finder=areaList;
             });
           },
         ),),
        Expanded(
            flex: 1,
          child:
              DropdownButton(
                value: dropdownvalue,
                onChanged: (String? newValue) {
                  setState(() {
                    areaList.clear();
                    inxpage.currentState?.pageTo(0);
                      dropdownvalue = newValue!;
                     /* areaList = finder_prov.where((SRC){
                        var MLM = SRC.Proveedor.toString().toLowerCase()+SRC.Slim.toLowerCase()+SRC.SKU.toLowerCase()+SRC.ID.toLowerCase();*/
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
                      Variante(controllertxt.text,provider,_boolconfimr!).then((value) {
                      setState((){
                        areaList.addAll(value);
                      });
                    });
                        /*return MLM.contains(provider)&&MLM.contains(controllertxt.text.toLowerCase());
                      }).toList();*/
                  });
                },
                items: item.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              ),
         ),
         Expanded(
           flex: 1,
           child: TextField(
             controller: daycontroller,
             onSubmitted: (String value){
               value=daycontroller.text;
               int valorint = int.parse(value);
               Provider.of<Lead_>(context,listen: false).pedidodiasML(valorint);
             },
             decoration: InputDecoration(
               hintText: 'Dias',
             )
           )

         ),
         
         Expanded(
             flex:1,
             child:TextField(
                 controller: leadcontroller,
                 onSubmitted: (String value){
                   value=leadcontroller.text;
                   int diaslead = int.parse(value);
                   Provider.of<Lead_>(context,listen: false).dias_leadML(diaslead);
                 },
                 decoration: InputDecoration(
                   hintText: 'Lead Time',
                 )
             ) ),
         FittedBox(
           child: Checkbox(
             value: _boolconfimr,
             onChanged: ((bool? value){
               setState((){
                  _boolconfimr=value!;
                  if(_boolconfimr==true){
                    areaList.clear();
                    Variante(controllertxt.text,provider,_boolconfimr!).then((valor){
                      setState((){
                        areaList.addAll(valor);
                      });
                    });
                  } else{
                    areaList.clear();
                    Variante(controllertxt.text,provider,_boolconfimr!).then((valor){
                      setState((){
                        areaList.addAll(valor);
                      });
                    });
                  }
               });
             }),
         ),
         ),
         Expanded(
             flex:1,
             child:TextButton(onPressed: (){
               Navigator.push(context,
                   MaterialPageRoute(builder: (context) => new Confirm(user:user)));
             }, child: Text('Confirmados')) ),
         Expanded(
           child: TextButton(
             child: Text('Orden'),
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) =>  ordenes(user:user)),
               );
               //DialogOrden(provs:provs, context: context);
             },
           ),
         ),
       ],


     ),

    ),
        Expanded(
          child:
           /*  SizedBox(child:  SingleChildScrollView(
                   scrollDirection: Axis.horizontal,*/
                   SingleChildScrollView(
                     scrollDirection: Axis.vertical,
                     child: PaginatedDataTable(
                       key: inxpage,
                          //showCheckboxColumn: true,
                         checkboxHorizontalMargin: 10.0,
                         dataRowHeight: 55,
                         columnSpacing: 15.0,
                         showFirstLastButtons: true,
                         /*onSelectAll: (bool? isSelected){
                         setState((){
                              this.value=isSelected;
                         });
                         },*/
                         columns: [
                           DataColumn(label: Text("Codigo SLIM",textAlign: TextAlign.center,),
                               onSort:(columnIndex,_){
                                 setState((){
                                   _currentSortColumn = columnIndex;
                                   if(_isAscending ==true){
                                     _isAscending = false;
                                     areaList.sort((CodA, CodB) =>
                                         CodB.Slim.compareTo(CodA.Slim));
                                   } else {
                                     _isAscending=true;
                                     areaList.sort((CodA,CodB) =>
                                         CodA.Slim.compareTo(CodB.Slim));
                                   }
                                 });
                               }
                          ),
                           const DataColumn(label: Text("SKU",textAlign: TextAlign.center)),
                            DataColumn(label: Text("Descripcion Corta",textAlign: TextAlign.center),
                               onSort:(columnIndex,_){
                                 setState((){
                                   _currentSortColumn = columnIndex;
                                   if(_isAscending ==true){
                                     _isAscending = false;
                                     areaList.sort((CodA, CodB) =>
                                         CodB.Desc.compareTo(CodA.Desc));
                                   } else {
                                     _isAscending=true;
                                     areaList.sort((CodA,CodB) =>
                                         CodA.Desc.compareTo(CodB.Desc));
                                   }
                                 });
                               }),
                           DataColumn(label: Text("Factor",textAlign: TextAlign.center),
                               onSort:(columnIndex,_){
                                 setState((){
                                   _currentSortColumn = columnIndex;
                                   if(_isAscending ==true){
                                     _isAscending = false;
                                     areaList.sort((CodA, CodB) =>
                                         CodB.WMS_Factor.compareTo(CodA.WMS_Factor));
                                   } else {
                                     _isAscending=true;
                                     areaList.sort((CodA,CodB) =>
                                         CodA.WMS_Factor.compareTo(CodB.WMS_Factor));
                                   }
                                 });
                               }),
                           DataColumn(label: Text("V30 Dias Canales",textAlign: TextAlign.center),
                               onSort:(columnIndex,_){
                                 setState((){
                                   _currentSortColumn = columnIndex;
                                   if(_isAscending ==true){
                                     _isAscending = false;
                                     areaList.sort((CodA, CodB) =>
                                         CodB.V30ML.compareTo(CodA.V30ML));
                                   } else {
                                     _isAscending=true;
                                     areaList.sort((CodA,CodB) =>
                                         CodA.V30ML.compareTo(CodB.V30ML));
                                   }
                                 });
                               }),
                           DataColumn(label: Text('Stock Cedis',textAlign: TextAlign.center,)),
                           //DataColumn(label: Text('V.Calc + Lead',textAlign: TextAlign.center,)),
                           DataColumn(label: Text('Stock total',textAlign: TextAlign.center,)),
                           DataColumn(label: Text('Pedido_Sugerido',textAlign: TextAlign.center,),
                           onSort: (columnIndex,_){
                             setState((){
                               _currentSortColumn = columnIndex;
                               if(_isAscending == true){
                                 _isAscending = false;

                               } else {
                                 _isAscending = true;

                               }
                             });
                           }),
                           DataColumn(label: Text('Pedido',textAlign: TextAlign.center,),),
                           DataColumn(label: Text('Unidades pedidas',textAlign: TextAlign.center,),
                               onSort: (columnIndex,_){
                                 setState((){
                                   _currentSortColumn = columnIndex;
                                   if(_isAscending == true){
                                     _isAscending = false;
                                     areaList.sort((CodA, CodB) =>
                                         CodB.Pedido_quantity.compareTo(CodA.Pedido_quantity));
                                   } else {
                                     _isAscending=true;
                                     areaList.sort((CodA,CodB) =>
                                         CodA.Pedido_quantity.compareTo(CodB.Pedido_quantity));
                                   }
                                 });
                               }),
                           DataColumn(label: Text("Unidades por caja",textAlign: TextAlign.center)),
                           //DataColumn(label: Text('LEAD Prov',textAlign: TextAlign.center,)),
                           const  DataColumn(label: Text("Imagen",textAlign: TextAlign.center)),
                            DataColumn(label: Text("CH-MX",textAlign: TextAlign.center),
                           onSort: (columnIndex,_){
                             setState((){
                               _currentSortColumn = columnIndex;
                               if(_isAscending ==true){
                                 _isAscending = false;
                                 areaList.sort((CodA, CodB) =>
                                     CodB.Compras_Camino.compareTo(CodA.Compras_Camino));
                               } else {
                                 _isAscending=true;
                                 areaList.sort((CodA,CodB) =>
                                     CodA.Compras_Camino.compareTo(CodB.Compras_Camino));
                               }
                             });
                           }),
                           const DataColumn(label: Text("WMS EXI",textAlign: TextAlign.center)),
                           const  DataColumn(label: Text("DISP",textAlign: TextAlign.center)),
                           //DataColumn(label: Text("Stock Full",textAlign: TextAlign.center)),
                            DataColumn(label: Text("Status",textAlign: TextAlign.center),
                               onSort:(columnIndex,_){
                                 setState((){
                                   _currentSortColumn = columnIndex;
                                   if(_isAscending ==true){
                                     _isAscending = false;
                                     areaList.sort((CodA, CodB) =>
                                         CodB.Status.compareTo(CodA.Status));
                                   } else {
                                     _isAscending=true;
                                     areaList.sort((CodA,CodB) =>
                                         CodA.Status.compareTo(CodB.Status));
                                   }
                                 });
                               }),
                           DataColumn(label: Text("SOLD_QUANTITY",textAlign: TextAlign.center,),
                               onSort:(columnIndex,_){
                        setState((){
                        _currentSortColumn = columnIndex;
                     if(_isAscending ==true){
                    _isAscending = false;
                  areaList.sort((CodA, CodB) =>
                  CodB.Soldq.compareTo(CodA.Soldq));
                  } else {
                  _isAscending=true;
                  areaList.sort((CodA,CodB) =>
                  CodA.Soldq.compareTo(CodB.Soldq));
                    }
                  });
                    }),
                           DataColumn(label: Text("COMPRAS",textAlign: TextAlign.center,),
                               onSort:(columnIndex,_){
                                 setState((){
                                   _currentSortColumn = columnIndex;
                                   if(_isAscending ==true){
                                     _isAscending = false;
                                     areaList.sort((CodA, CodB) =>
                                         CodB.Compras.compareTo(CodA.Compras));
                                   } else {
                                     _isAscending=true;
                                     areaList.sort((CodA,CodB) =>
                                         CodA.Compras.compareTo(CodB.Compras));
                                   }
                                 });
                               }),

                           const  DataColumn(label: Text("COLOR",textAlign: TextAlign.center)),
                             DataColumn(label: Text("Precio",textAlign: TextAlign.center),
                               onSort:(columnIndex,_){
                                 setState((){
                                   _currentSortColumn = columnIndex;
                                   if(_isAscending ==true){
                                     _isAscending = false;
                                     areaList.sort((CodA, CodB) =>
                                         CodB.price.compareTo(CodA.price));
                                   } else {
                                     _isAscending=true;
                                     areaList.sort((CodA,CodB) =>
                                         CodA.price.compareTo(CodB.price));
                                   }
                                 });
                               }),
                           DataColumn(label: Text("Marca",textAlign: TextAlign.center),
                               onSort:(columnIndex,_){
                                 setState((){
                                   _currentSortColumn = columnIndex;
                                   if(_isAscending ==true){
                                     _isAscending = false;
                                     areaList.sort((CodA, CodB) =>
                                         CodB.Marca.compareTo(CodA.Marca));
                                   } else {
                                     _isAscending=true;
                                     areaList.sort((CodA,CodB) =>
                                         CodA.Marca.compareTo(CodB.Marca));
                                   }
                                 });
                               }),
                           DataColumn(label: Text('Flex',textAlign: TextAlign.center,)),
                           DataColumn(label: Text('Agotar_Descatalogar',textAlign: TextAlign.center,),
                           onSort:(columnIndex,_){
                             setState((){
                               _currentSortColumn = columnIndex;
                               if(_isAscending ==true){
                                 _isAscending = false;
                                 areaList.sort((CodA, CodB) =>
                                     CodB.Agotar.compareTo(CodA.Agotar));
                               } else {
                                 _isAscending=true;
                                 areaList.sort((CodA,CodB) =>
                                     CodA.Agotar.compareTo(CodB.Agotar));
                               }
                             });
                           }),

                         ],

                         rowsPerPage: rowsPerPage,
                         availableRowsPerPage: [5,10,15,20,35,50],
                         onRowsPerPageChanged: (r){

                           if(r != null){
                             setState((){
                               rowsPerPage = r ;
                             });
                             print(rowsPerPage);
                           }
                         },
                       source: items(context: context, areaList: areaList,
                           Puntov2: Puntov2, Puntov2s: Puntov2s,Puntov: Puntov,
                           Puntovs: Puntovs,listprovi: provs,user:user),

                     ),
                   ),
                 ),
             //))
          ],
        ),

    //),
    );
  }
void DialogOrden({required List<Proveedores> provs,
  required BuildContext context}){
  TextEditingController controllerorden = TextEditingController();
  TextEditingController controllerdias = TextEditingController();
  TextEditingController controllerlead = TextEditingController();
  String? dropdownvaluep = Provider.of<Lead_>(context,listen: false).provider;
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Orden'),
          content: Form(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controllerorden,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,),
                decoration: InputDecoration(
                    hintText: 'No.Orden'
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    value:dropdownvaluep,
                    onChanged: (String? newValue) {
                      setState(() {
                        print(dropdownvaluep);
                        dropdownvaluep = newValue!;
                        Provider.of<Lead_>(context,listen: false).providedropb(newValue);
                        provider='';
                        print(Provider.of<Lead_>(context,listen: false).provider);
                        for(int x=0;x<provs.length;x++){
                          if(Provider.of<Lead_>(context,listen: false).provider==provs[x].Nombre){
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
                          }else if(Provider.of<Lead_>(context,listen: false).provider=='*'){
                            provider = '0';
                          }
                        }
                      });
                    },
                    dropdownColor: Colors.cyanAccent,
                    items: item.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                  ),
                ],
              ),
              TextField(
                  controller: controllerdias,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,),
                decoration: InputDecoration(
                    hintText: 'Dias de Pedido'
                ),
              ),
              TextField(
                  controller: controllerlead,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,),
                    decoration: InputDecoration(
                      hintText: 'Lead Time'
                    ),
              ),
            ],
          )
          ),

            actions: <Widget>[
              TextButton(onPressed: (){
                print(controllerorden.text+'-'+provider+'-'+controllerdias.text+'-'+controllerlead.text);
              }, child: Text('Crear orden'))
            ],
          );
        });
  }

}

class items extends DataTableSource {
  List<Variant> areaList=<Variant>[];
  List<Pv> Puntov2=<Pv>[];
  List<PvStock> Puntov2s=<PvStock>[];
  List<Pv> Puntov=<Pv>[];
  List<PvStock> Puntovs=<PvStock>[];
  List<Proveedores> listprovi = <Proveedores>[];
  BuildContext context;
  String user;
  items({required this.areaList, required this.Puntov2, required this.Puntov2s,
    required this.Puntov,required this.Puntovs,required this.listprovi,
    required this.context, required this.user});
  bool? chkbox = false;
  bool? _selected = false;
  bool? _editable = true;
  int Stock_total = 0;
  int TotalV30 = 0;
  int Stock_pv1=0;
  int Stock_shop=0;
  String cod_pv2='';
  num total_pv2=0;
  int cant30v_pv2=0;
  int Stock_pv2=0;
  String cod_pv='';
  num total_pv=0;
  int cant30v_pv=0;
  int Stock_pv=0;
  bool _isvariant = false;
  TextEditingController controlPedidosML = TextEditingController();
  @override
  DataRow? getRow(int index) {

    //_isvariant = areaList[index].is_variant;
    if(index>=areaList.length)return null;
    final _item = areaList[index];

if(areaList[index].Stock_Pv1==null){
  Stock_pv1 =0;
}else{
  Stock_pv1 = areaList[index].Stock_Pv1;
}
    if(areaList[index].Stock_Sh==null){
      Stock_shop =0;
    }else{
      Stock_shop = areaList[index].Stock_Sh!;
    }
    for(int x=0;x<Puntov2.length;x++){
      if(areaList[index].Slim==Puntov2[x].Cod_Slim){
        cod_pv2 =Puntov2[x].Cod_Slim;
        total_pv2 = Puntov2[x].total;
        cant30v_pv2 = Puntov2[x].Cantidad;
      }
    }
    for(int x=0;x<Puntov2s.length;x++){
      if(areaList[index].Slim==Puntov2s[x].Cod_Slim){
        Stock_pv2 = Puntov2s[x].Stock;
      }
    }
    for(int x=0;x<Puntov.length;x++){
      if(areaList[index].Slim==Puntov[x].Cod_Slim){
        cod_pv =Puntov[x].Cod_Slim;
        total_pv = Puntov[x].total;
        cant30v_pv = Puntov[x].Cantidad;
      }
    }
    for(int x=0;x<Puntovs.length;x++){
      if(areaList[index].Slim==Puntovs[x].Cod_Slim){
        Stock_pv = Puntovs[x].Stock;
      }
    }

    //Stock_total = areaList[index].Stock+areaList[index].Stock_Ama+areaList[index].Stock_F+Stock_pv1+Stock_shop+areaList[index].Stock_Shop+Stock_pv2+Stock_pv;
    Stock_total = areaList[index].Stock+areaList[index].Stock_F+Stock_pv+Stock_pv2;
    TotalV30 = (areaList[index].VTA30*areaList[index].WMS_Factor)+cant30v_pv2+cant30v_pv;
    double ventaspordia= _item.V30ML/30;
    num dias = Provider.of<Lead_>(context).pedidoML;
    num dias_lead =Provider.of<Lead_>(context).diaslead;
    int Stock =_item.Stock_F+_item.Stock+_item.Compras_Camino;
    //int Factor =_item.WMS_Factor;
    double PedidosML = double.parse((((ventaspordia)*(dias+dias_lead))-Stock).toStringAsFixed(0));
    //double PedidosML =double.parse(((((_item.VTA30/30))*(Provider.of<Lead_>(context).pedidoML+Provider.of<Lead_>(context).diaslead))-(_item.Stock_F+_item.Stock)).toStringAsFixed(0));
    controlPedidosML.text=PedidosML.toString();
   return  DataRow.byIndex(index: index,
       cells: [
     DataCell(ContextMenu(SlimC: _item.Slim,MLM: _item.ID,SKU: _item.SKU,contxtidn: 1),
       //Text(_item.Slim,textAlign: TextAlign.center,),
     ),
     /*DataCell(ContextMenu(SlimC: _item.Slim,MLM: _item.ID,SKU: _item.SKU,contxtidn: 2),
           //Text(_item.Slim,textAlign: TextAlign.center,),
     ),*/
     //DataCell(Text(_item.ID.toString(),textAlign: TextAlign.center,),),
     DataCell(Text(_item.SKU.toString(),textAlign: TextAlign.center,)),
     DataCell(Text(_item.Desc,textAlign: TextAlign.center,),),
     DataCell(Text(_item.WMS_Factor.toString(),textAlign: TextAlign.center,),),
     DataCell(ContextV30(texto: _item.VTA30,Stock_fullMerca:_item.Stock_F,
       Stock_fullShop:_item.Stock_Sh,Stock_Ama: _item.Stock_Ama,
       Stock_Pv1: _item.Stock_Pv1,Stock_shopee: _item.Stock_Shop,
       Stock_Pv2:Stock_pv2,V30_PV2:cant30v_pv2,Stock_Pv:Stock_pv,
       V30_PV:cant30v_pv,Stock_FBA:_item.Amazn_FBA ,
       Stock_Cedis: _item.Stock,Factor: _item.WMS_Factor,VTA30DML:_item.V30ML)),
     DataCell(Text(_item.Stock.toString(),textAlign: TextAlign.center,)),
     DataCell(Text(Stock_total.toString(),textAlign: TextAlign.center,)),
     DataCell(Text(PedidosML.toString().substring(0,PedidosML.toString().length-2),
         style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
     DataCell(Pedidostxt(indexlista: areaList.length,Pedidos: PedidosML,id: index,MLM:areaList[index].ID,
         SKU:areaList[index].SKU,Slim:areaList[index].Slim,Variation:areaList[index].VariationID,
         title: areaList[index].Title,desc: areaList[index].Desc,user:user)),
     DataCell(Text(_item.Pedido_quantity.toString(),
         style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
     DataCell(Text(_item.UCaja.toString())),
     DataCell(Image.network(_item.Thumbnail)),
     DataCell(Text(_item.Compras_Camino.toString())),
     DataCell(Text(_item.WMS.toString(),textAlign: TextAlign.center,)),
     DataCell(Text(_item.Disp.toString(),textAlign: TextAlign.center,)),
     DataCell(Text(_item.Status,textAlign: TextAlign.center,)),
     DataCell(Text(_item.Soldq.toString(),textAlign: TextAlign.center,),),
     DataCell(Text(_item.Compras.toString(),textAlign: TextAlign.center,),),
     DataCell(Text(_item.Color,textAlign: TextAlign.center,),),
     DataCell(Text(_item.price.toString(),textAlign: TextAlign.center,)),
     DataCell(Text(_item.Marca,textAlign: TextAlign.center,)),
     DataCell(Text(_item.Flex,textAlign: TextAlign.center,
       style: TextStyle(
         fontSize: 25,
       ),),),
     DataCell(Text(_item.Agotar,textAlign: TextAlign.center,
       style: TextStyle(
         fontSize: 30,
         fontWeight: FontWeight.bold,
         color: Colors.red
       ),),),
     /* DataCell( Checkbox(value: prov.isChecked,
         onChanged: (bool? chkbox) async{
          //this.chkbox = chkbox;
           prov.isChecked = chkbox ?? true;
     }
     ),
     ),*/
         //DataCell(new CheckBoxs(ID:_item.Slim,Unidades:PedidosML)),
         //DataCell(Text(_item.Proveedor.toString(),textAlign: TextAlign.center,))
         //DataCell(Text(_item.Proveedor.toString(),textAlign: TextAlign.center,)),
   ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => true;

  @override
  // TODO: implement rowCount
  int get rowCount => areaList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}

class Pedidostxt extends StatefulWidget{
  TextEditingController controlPedidosML = TextEditingController();
  int indexlista,id,Variation;
  double Pedidos;
  String MLM,SKU,Slim,title,desc,user;
  Pedidostxt({Key? key,required this.indexlista, required this.Pedidos,required this.id,
    required this.MLM,required this.SKU,required this.Slim,required this.Variation,
    required this.title, required this.desc, required this.user});

  @override
  State<Pedidostxt> createState() => _Pedidostxt();
}
class _Pedidostxt extends State<Pedidostxt>{

  @override
  Widget build(BuildContext context){

    return TextField(
      controller: widget.controlPedidosML,
      onSubmitted: (String valor){
        print(widget.MLM+' '+widget.Slim+' '+widget.SKU+' Unidades a pedir:'+widget.controlPedidosML.text+' Usuario:'+widget.user);
        int pedido = int.parse(widget.controlPedidosML.text);
        try{
          Check(widget.Slim,widget.MLM,widget.title,widget.desc,widget.Variation,pedido,widget.user);
        } catch(error){
          print(error);
        }
      },
    );
  }
  Future<http.Response> Check(String codigo,String id,String title,String desc,int variation,int quantity,String user) {//Metodo para enviar el token y los MLM de los productos de la lista
    return http.post(
      Uri.parse('http://45.56.74.34:8890/container/set?container=SC22-3&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class CheckBoxs extends StatefulWidget{
String ID;
double Unidades;
   CheckBoxs({Key? key, required this.ID, required this.Unidades}) : super(key: key);

  @override
 State<CheckBoxs> createState() => _CheckBox();
}

class _CheckBox extends State<CheckBoxs>{
  bool? value = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(value: value,
        onChanged: (bool? value){
          setState((){
            this.value = value;
            if(this.value==true){
              print(widget.ID+' '+widget.Unidades.toString());
            }
          });
        });

  }
}

class ContextMenu extends StatelessWidget{
  String SlimC,MLM,SKU;
  int contxtidn;
  ContextMenu({Key? key, required this.SlimC,required this.MLM,required this.SKU, required  this.contxtidn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String txt='';
switch (contxtidn){
  case 1:txt=SlimC;  break;
  case 2:txt=MLM;  break;

}
  return Padding(padding: const EdgeInsets.all(10.0),
    child: ContextMenuArea(
      child: Text(txt),
        builder: (context) => [
          ListTile(
            title: Text('Copiar Codigo Slim'),
            onTap: (){
              Clipboard.setData(ClipboardData(text:SlimC));
            },
          ),
          ListTile(
            title: Text('Copiar MLM'),
            onTap: (){
              Clipboard.setData(ClipboardData(text:MLM));
            },
          ),
          ListTile(
            title: Text('Copiar SKU'),
            onTap: (){
              Clipboard.setData(ClipboardData(text:SKU));
            },
          ),
        ]),
  );
  }

}

class ContextV30 extends StatefulWidget {
  int texto,Stock_fullMerca,Stock_Ama,Stock_shopee,Stock_FBA,Stock_Cedis,VTA30DML;
  int? Stock_Pv1;
  int?  Stock_fullShop;
  int V30_PV2;
  num Stock_Pv2;
  int V30_PV;
  num Stock_Pv;
  int Factor;
  ContextV30({Key? key, required this.texto, required this.Stock_fullMerca, required this.Stock_fullShop,required this.Stock_Ama,
    required this.Stock_Pv1,required this.Stock_shopee, required this.Stock_Pv2, required this.V30_PV2, required this.V30_PV,
    required this.Stock_Pv,required this.Stock_FBA,required this.Stock_Cedis,required this.Factor, required this.VTA30DML}) : super(key: key);
  int TotalV30=0;
  @override
  State<StatefulWidget> createState() => _ContextV30();
}

class _ContextV30 extends State<ContextV30>{

  @override
  Widget build(BuildContext context) {
    widget.TotalV30=widget.texto+widget.V30_PV2+widget.V30_PV;
    return Padding(padding: const EdgeInsets.all(10.0),
      child: ContextMenuArea(
          child: Text(widget.VTA30DML.toString()),
          builder: (context) => [
            ListTile(
              title: Text('Canales de Venta '),
              onTap: (){
                AlertD(context);
              },
            ),
          ]),
    );
  }
void AlertD(BuildContext context){
String values = '1 Mes';
var VMes = ['1 Mes','2 Mes','3 Mes'];
num Dias_SML = 0;
num Dias_PV2 =0;
num Dias_PV =0;
Dias_PV =(widget.Stock_Pv/(widget.V30_PV/30));
double SPV =double.parse((Dias_PV).toStringAsFixed(0));
Dias_PV2 =(widget.Stock_Pv2/(widget.V30_PV2/30));
double SPV2 =double.parse((Dias_PV2).toStringAsFixed(0));
Dias_SML =(widget.Stock_fullMerca/(widget.texto/30));
double SML = double.parse((Dias_SML).toStringAsFixed(0));
if(widget.V30_PV==0){
  SPV=0;
};
if(widget.V30_PV2==0){
  SPV2=0;
};
if(widget.texto==0){
  SML=0;
};

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Canales de Venta'+'         Stock Cedis: '+widget.Stock_Cedis.toString()),
            content: Column(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child:
                        DropdownButton(
                          value: Provider.of<Lead_>(context).mes,
                          onChanged: (String? newvalor) {
                            setState((){
                              Provider.of<Lead_>(context,listen: false).dropv30(newvalor!);
                              Provider.of<Lead_>(context,listen: false).pedidomesML(newvalor, widget.texto, widget.Stock_fullMerca, widget.Stock_Cedis);
                            });
                          },
                          items: VMes.map((String items){
                            return DropdownMenuItem(
                              child: Text(items),
                              value: items,
                            );
                          }).toList(),
                        ),
                            flex: 2,
                        ),
                      ],
                    ),

                  ),
                  Padding(padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: DataTable(
                              columns: [
                                DataColumn(
                                    label:Text('Canal')
                                ),
                                DataColumn(
                                    label:Text('V30')
                                ),
                                DataColumn(
                                    label:Text('Stock Full/FBA')
                                ),
                                DataColumn(
                                    label:Text('Shopee')
                                ),
                                DataColumn(
                                    label:Text('Apartado')
                                ),
                                DataColumn(
                                    label:Text('7.Stock')
                                ),
                                DataColumn(
                                    label:Text('Pedido')
                                ),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text('Amazon')),
                                  DataCell(Text('0')),
                                  DataCell(Text(widget.Stock_FBA.toString())),
                                  DataCell(Text('N/A')),
                                  DataCell(Text(widget.Stock_Ama.toString(),textAlign: TextAlign.center,)),
                                  DataCell(Text('0')),
                                  DataCell(Text('0')),
                                ], //color: MaterialStateProperty.all(Colors.deepPurple),
                                ),
                                DataRow(cells: [
                                  DataCell(Text('Mercado')),
                                  DataCell(Text(widget.VTA30DML.toString())),
                                  DataCell(Text((widget.Factor*widget.Stock_fullMerca).toString(),textAlign: TextAlign.center)),
                                  DataCell(Text('N/A')),
                                  DataCell(Text('0')),
                                  DataCell(Text(SML.toString().substring(0,SML.toString().length-2)+' Dias',textAlign: TextAlign.center,)),
                                  DataCell(Text(Provider.of<Lead_>(context).pedidoml.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('PV1')),
                                  DataCell(Text(widget.V30_PV.toString())),
                                  DataCell(Text('N/A')),
                                  DataCell(Text('N/A')),
                                  DataCell(Text(widget.Stock_Pv.toString())),
                                  DataCell(Text(SPV.toString().substring(0,SPV.toString().length-2)+' Dias',textAlign: TextAlign.center,)),
                                  DataCell(Text('0')),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Shopee')),
                                  DataCell(Text('0')),
                                  DataCell(Text('N/A')),
                                  DataCell(Text(widget.Stock_fullShop.toString(),textAlign: TextAlign.center,)),
                                  DataCell(Text(widget.Stock_shopee.toString(),textAlign: TextAlign.center,)),
                                  DataCell(Text('0')),
                                  DataCell(Text('0')),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('PV2')),
                                  DataCell(Text(widget.V30_PV2.toString())),
                                  DataCell(Text('N/A')),
                                  DataCell(Text('N/A')),
                                  DataCell(Text(widget.Stock_Pv2.toString())),
                                  DataCell(Text(SPV2.toString().substring(0,SPV2.toString().length-2)+' Dias')),
                                  DataCell(Text('0')),
                                ]),
                              ]
                          ),
                          )
                        ],
                      ),
                  ),
                ],
            ),
          );
        });
}


}

class LeadButton extends StatefulWidget{

  String? Providers;
  String ID;
  List<Proveedores> Provlist;
  LeadButton({Key? key, required this.Providers, required this.ID, required this.Provlist});

  @override
  State<StatefulWidget> createState() => _LeadButton();
}
class _LeadButton extends State<LeadButton>{
  TextEditingController control = TextEditingController();
  @override
  Widget build(BuildContext context){
    String? listprov;
    String arrayprov='';
    List<String>? st ;
    if(widget.Providers==null){
      listprov = 'No prov';
    }else{
      listprov = widget.Providers?.substring(1,widget.Providers!.length-1);
      arrayprov= listprov!;
      st=arrayprov.split(',');
      arrayprov = 'lead';
    }

      return Padding(padding: const EdgeInsets.all(10.0),
      child:  TextButton(
          onPressed: (){
            LeadProveedor(context, st!,widget.Provlist);
          },
          child: Text(arrayprov))
      );
  }
  void LeadProveedor(BuildContext context,List Prov, List<Proveedores> provlist){
    String provider='';
    String val = '';
    List idn = List.filled(Prov.length,[]);

    setState((){
      int y=0;
      for(int x=0;x<provlist.length;x++){

        switch(provlist[x].ID.toString().length){
          case 1:
            provider = provlist[x].ID.toString();
            val='00$provider';
            print(val+' '+provlist[x].ID.toString());
            break;
          case 2:
            provider = provlist[x].ID.toString();
            val='0$provider';
            print(val+' '+provlist[x].ID.toString());
            break;
          case 3:
            provider = provlist[x].ID.toString();
            val='$provider';
            print(val+' '+provlist[x].ID.toString());
            break;
        }

      for(int yy=0;yy<Prov.length;yy++){
        if(val==Prov[yy]){
          idn[yy] = (provlist[x].Nombre) ;
          print(Prov[yy]+' '+val+' '+provlist[x].Nombre);
            }
          }
        }
    });
for(int t=0;t<idn.length;t++){
  print(idn[t]);
}
print(idn.length);
    showDialog(context: context,
        builder: (BuildContext contexto){
          return AlertDialog(
              title: const Text('Proveedores'),
              content:  DataTable(columns: [
          DataColumn(label: Text('Id Provedor')),
          DataColumn(label: Text('Proveedor')),
          DataColumn(label: Text('Lead')),
          DataColumn(label: Text('Costo')),
          DataColumn(label: Text('State')),
          ],
          rows:List.generate(Prov.length, (index) =>
          DataRow(cells: [
          DataCell(Text(Prov[index].toString())),
          DataCell(Text(idn[index].toString())),
          //DataCell(Text(Prov[index].toString())),
          DataCell( TextLead(lead: 10,idprov: Prov[index],proveedor: idn[index],Cod_Slim: widget.ID,index:index),),
          DataCell(Textprice(price: 50.0,)),
          DataCell(txtlead(lead: control.text,leadlist: List.filled(Prov.length,[]),index:index)),
          ])
          )
          ),
          actions: <Widget>[
          Row(
          children: <Widget>[
          Expanded(
          child: TextButton(
          onPressed: ()
          {
          Provider.of<Lead_>(context,listen: false).leadc('',0);
          Navigator.of(context).pop();
          },
          child: Text('Aceptar'),
          ),
          ),
          ],
          )
          ],
          );
        }
         );
        }
}

class TextLead extends StatefulWidget{
int lead,index;
String proveedor,Cod_Slim,idprov;
  TextLead({Key? key,required this.lead,required this.proveedor,required this.Cod_Slim,required this.idprov,required this.index});

  @override
  State<StatefulWidget> createState() => _TextButton();
}
class _TextButton extends State<TextLead>{
  TextEditingController controller = TextEditingController();
  initState(){
    controller.text = widget.lead.toString();
  }

  @override
  Widget build(BuildContext context) {
   return  GestureDetector(
       child: TextField(
         keyboardType: TextInputType.number,
         controller: controller,
         showCursor: true,
         autofocus: false,
         onSubmitted: (String valor){
           print('Cod_Slim: '+widget.Cod_Slim+' ID_Proveedor: '+widget.idprov.toString()+' Proveedor: '+widget.proveedor+' Lead: '+controller.text);
           int leads = int.parse(controller.text);
           leads = leads *2;
           Provider.of<Lead_>(context,listen: false).leadc(leads.toString(),widget.index);
         },
       ),
       onTap: (){

       },
     );
   
  }
}

class Textprice extends StatefulWidget{
  double price;
  Textprice({Key? key,required this.price});

  @override
  State<StatefulWidget> createState() => _Textprice();
}
class _Textprice extends State<Textprice>{
  TextEditingController controlador = TextEditingController();

  initState(){
      controlador.text= widget.price.toString();
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      child: TextField(
            controller: controlador,
            showCursor: true,
            autofocus: false,
            onSubmitted: (String valor){
              print(controlador.text);
            },
      ),
    );
  }
}


class txtlead extends StatelessWidget{
  final String lead;
  final int index;
  final List leadlist;
  txtlead({required this.lead,required this.leadlist, required this.index});

  @override
  Widget build(BuildContext context) {
    return Text(Provider.of<Lead_>(context).lead[index]);
  }
}

class Lead_ extends ChangeNotifier{

   List lead=['','','','','','','',''];
   //List v30=['','','','',''];
   String mes = '1 Mes';
   num pedidoml =0;
   num pedidoML =0;
   num diaslead = 0;
   String provider = '*';
   String provider_sub='*';

   String solicitud= '*';
   String imagenexist = 'NO';
   String tipo_radio= 'Ambos';
   List<Variant> lista = <Variant>[];
   String provider_id = '0';
   String provider_id_subfolio = '0';
   String tipo = 'Accesorios';
   String apartado = '*';
   String provider_AccMX = '*';
   String provider_AccMX_id = '0';

  void tipo_(String type){
    tipo = type;
    notifyListeners();
  }
  void id_provider(String id){
    provider_id = id;
    notifyListeners();
  }
   void id_provider_sub(String id){
     provider_id_subfolio = id;
     notifyListeners();
   }
   void apartado_(String apartado){
     this.apartado =apartado;
     notifyListeners();
   }
   void provider_ACC_MX(String prov){
     this.provider_AccMX = prov;
     notifyListeners();
   }
   void provider_ACC_MX_id(String id_prov){
     this.provider_AccMX_id = id_prov;
     notifyListeners();
   }
  void leadc(String change, int index){
    lead[index]=change;
    print(index);
    notifyListeners();
  }

  void dropv30(String drop){
    mes = drop;
    notifyListeners();
  }
  void pedidomesML(String mes,int v30,int full,int cedis){
    num Resta=(v30-(full+cedis));
        switch (mes){
          case '1 Mes':pedidoml = Resta *1; break;
          case '2 Mes':pedidoml = Resta *2; break;
          case '3 Mes':pedidoml = Resta *3; break;
        }
  }
  void pedidodiasML(int dias){
    pedidoML = dias;
    notifyListeners();
  }
  void dias_leadML(int diaslead){
    this.diaslead = diaslead;
    notifyListeners();
  }

  void providedropb(String prov) {
    this.provider = prov;
    //print(provider);
    notifyListeners();
  }
   void providedropb_sub(String prov_sub) {
     this.provider_sub = prov_sub;
     //print(provider);
     notifyListeners();
   }
   void tiporadio(String tipo) {
     this.tipo_radio = tipo;
     //print(provider);
     notifyListeners();
   }

   void destinatario(String area){
     this.solicitud = area;
     notifyListeners();
   }

   void hay_imagen(String imagen){
      this.imagenexist = imagen;
      notifyListeners();
   }
   Future<List<Variant>> Variante(String Slim) async{
     var url = Uri.parse('http://45.56.74.34:8890/container?title=$Slim');
     print(url);
     var response = await http.get(url);
     List<Variant> _lista = <Variant>[];
     if(response.statusCode == 200){
       String sJson = response.body.toString();
       int count = sJson.toString().length;
       String _sub = sJson.toString().substring(34, count-1);
       var Jsonv = json.decode(_sub);
       //print(Jsonv);
       for (var noteJson in Jsonv) {
         _lista.add(Variant.from(noteJson));

       }
       notifyListeners();
       return _lista;
     }else
       throw Exception('NO se pudo');

   }


}






