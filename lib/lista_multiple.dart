
import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:datatable/Modelo_contenedor/Slim_model.dart';
import 'package:datatable/main.dart';
import 'package:datatable/option_menu.dart';
import 'package:datatable/widgets_contenedor/widgets_contenedor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'Modelo_contenedor/model.dart';
import 'Modelo_traspaso/modelo_traspaso.dart' as model_traspaso;
import 'Modelo_traspaso/modelo_traspaso.dart';


class multi_list extends StatelessWidget{
  String user;
  multi_list({Key? key,required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MultiList(user:user),
    );
  }
}

class MultiList extends StatefulWidget{
  String user;
  MultiList({Key? key,required this.user}):super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiList();

}

class _MultiList extends State<MultiList>{
  final duration = Duration(milliseconds: 500);
  List<model_traspaso.Slim> lista_ml = <model_traspaso.Slim>[];
  List<model_traspaso.Slim> lista_amzn = <model_traspaso.Slim>[];
  List<slim_order> lista = <slim_order>[];
  bool Ascending = true;
  String _verticalGroupValue = "Ambas";
  String sub2 = '000';
  List<String> _status = ["Accesorios", "Refacciones", "Ambas"];
  String tipo = "";
  String dropdownvalue = '*';
  String dropdownsub2 = '*';
  String provider = '0';
  List<model_traspaso.Proveedores> provs = <model_traspaso.Proveedores>[];
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
    '*', '247?', 'AMAZING', 'ASTRON', 'BEST TERESA',
    'BRASONIC', 'CAPITAL MOVILE', 'CELMEX', 'Celular Hit',
    'CH ACCESORIES', 'CHEN', 'CONSTELACIÓN ORIENTAL', 'DNS',
    'EAUPULEY', 'ELE-GATE', 'ESTEFANO', 'EVA', 'HAP TECH INC',
    'IPHONE E.U', 'IPLUS', 'KAIPING', 'LITOY', 'MARDI', 'MC',
    'MEGAFIRE', 'MING', 'MK', 'MOBILSHOP', 'NUNBELL', 'PAPELERIA',
    'PENDRIVE CITY', 'RAZZY', 'RELX', 'SEO', 'SIVIVI', 'SKYROAM',
    'SLIM-CO', 'SLIM-CO REFACCIONES', 'VIMI', 'WEI DAN', 'XIAOMI',
    'XMOVILE', 'XP', 'ZHENG'
  ];

  initState(){
    Condensado('','0','000','').then((value) {
      setState((){
        lista.addAll(value);
      });
    });
    Prove().then((value) {
      setState((){
        provs.addAll(value);
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    TextEditingController txtcontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new Menu(user: widget.user)));
        }, icon: Icon(Icons.arrow_back)),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:TextField(
                controller: txtcontroller,
                onSubmitted: (value){
                  lista.clear();
                  Condensado(txtcontroller.text.toUpperCase(),provider,sub2,tipo).then((value){
                    setState((){
                      lista.addAll(value);
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
            FittedBox(
              child: Text('Items:\n'+lista.length.toString(),
              style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.white),),
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
                      case'Ambas':tipo=''; break;
                    }
                    lista.clear();
                    Condensado(txtcontroller.text,provider,sub2,tipo).then((value){
                      setState((){
                        lista.addAll(value);
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
                      lista.clear();
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
                      Condensado(txtcontroller.text,provider,sub2,tipo).then((value){
                        setState((){
                          lista.addAll(value);
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
                      lista.clear();
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
                      Condensado(txtcontroller.text,provider,sub2,tipo).then((value){
                        setState((){
                          lista.addAll(value);
                        });
                      });
                    });
                  }),
            ),
            FittedBox(
              child: IconButton(onPressed: (){
                setState((){
                  lista.clear();
                  Condensado('','0','000','').then((value){
                    setState((){

                      lista.addAll(value);
                    });
                  });
                });
              }, icon: Icon(Icons.refresh)),
            ),
            TextButton(onPressed: (){
              setState((){
                if(Ascending == false){
                  Ascending=true;
                  lista.sort((A,B)=>
                      A.v30nat.compareTo(B.v30nat));
                }else{
                  Ascending=false;
                  lista.sort((A,B)=>
                      B.v30nat.compareTo(A.v30nat));
                }
              });
            }, child: Text('Ordenar\nV30\nNaturales',
              style: TextStyle(color: Colors.white),)),
            TextButton(onPressed: (){
              setState((){
                if(Ascending == false){
                  Ascending=true;
                  lista.sort((A,B)=>
                      A.v30hist.compareTo(B.v30hist));
                }else{
                  Ascending=false;
                  lista.sort((A,B)=>
                      B.v30hist.compareTo(A.v30hist));
                }
              });
            }, child: Text('Ordenar\nV30\nHistoricas',
              style: TextStyle(color: Colors.white),)),
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //Expanded(child: Main_Table()),
                Expanded(child: GridView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: lista.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 25,
                    ),
                    itemBuilder: (context,index){
                      return Card(
                          elevation: 10,
                           surfaceTintColor: Colors.yellow,
                           shadowColor: Colors.deepPurple,
                           child: Column(
                             children: [
                               ListTile(
                                 leading:GestureDetector(
                                  child:Image.network(lista[index].Thumbnail),
                                   onDoubleTap: (){
                                    String imagenfull = lista[index].Thumbnail.substring(0,lista[index].Thumbnail.length-5)+'O.jpg';
                                    print(imagenfull);
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        transitionDuration: duration,
                                        reverseTransitionDuration: duration,
                                          pageBuilder: (context,animation,_){
                                          return FadeTransition(
                                              opacity: animation,
                                            child: Scaffold(
                                              appBar: AppBar(),
                                              body: SizedBox.expand(
                                                child: Hero(
                                                  tag: 'image',
                                                  child: Image.network(imagenfull,
                                                  fit: BoxFit.contain,),
                                                ),
                                              ),
                                            ),
                                          );
                                          },
                                      )
                                    );
                                   },
                                ),
                                 title: SelectableText(lista[index].codigo_slim,
                                 toolbarOptions: ToolbarOptions(
                                   selectAll: true,
                                   copy: true,
                                 ),
                                 style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                 ),),
                                 subtitle:Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   textDirection: TextDirection.ltr,
                                   children: [
                                     Text('Titulo: '+lista[index].Desc,
                                       textAlign: TextAlign.left,
                                       style: TextStyle(
                                           color: Colors.black
                                       ),),
                                      Text('SKU: '+lista[index].SKU,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black
                                          )),
                                      Text('V30DNat: '+lista[index].v30nat.toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black
                                          )),
                                      Text('V30Hist: '+lista[index].v30hist.toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black
                                          )),
                                   ],
                                 ),
                                 onTap: (){
                                   print(lista[index].codigo_slim);
                                   if(lista[index].codigo_slim!=''){
                                     lista_ml.clear();
                                     SlimData(lista[index].codigo_slim).then((value){
                                       setState((){
                                         lista_ml.addAll(value);
                                         lista_amzn=lista_ml;
                                       });
                                     });
                                   }
                                 },
                               ),
                             ],
                           ),
                        );
                    })),
              ],
            ),
          ),
          Expanded(child:
          new Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          Expanded(flex:1,
            child:
            DataTable2(
              columns: [
                DataColumn2(label: Text('ID_ML')),
                DataColumn2(label: Text('Titulo')),
                DataColumn2(label: Text('Status')),
                DataColumn2(label: Text('V30')),
                DataColumn2(label: Text('V30Hist')),

              ],
              rows:lista_ml.map((pub) =>
                  DataRow2(cells: [
                    DataCell(SelectableText(pub.meli,
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),)),
                    DataCell(Text(pub.title)),
                    DataCell(Text(pub.status)),
                    DataCell(Text(pub.vta30ML.toString())),
                    DataCell(Text(pub.vta30MLH.toString())),
                  ])
              ).toList(),
            ),
            //ML_list(lista:Provider.of<Lead_>(context,listen: false).lista),
          ),
    Expanded(flex: 1,
        child: Amzn_Table(lista_amzn: lista_amzn),)
        ]
    )
     ),
     ],
     ),
   );
  }


  Future<List<slim_order>> Condensado(String text,String provider,String sublinea2,String tipo) async{
    var url = Uri.parse('http://45.56.74.34:8890/container/condensado?title=$text&dias=0&leadtime=0&proveedor=$provider&sublinea2=$sublinea2&tipo=$tipo');
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

  Future<List<Slim>> SlimData(String CSlim) async {
    var url = Uri.parse('http://45.56.74.34:8081/publicaciones_all_select?title=$CSlim&tipo=*&index=0&proveedor=000&sublinea2=000');
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

  Future<List<model_traspaso.Proveedores>> Prove() async{
    var url = Uri.parse('http://45.56.74.34:5558/proveedores/list');
    var response = await http.get(url);
    List<model_traspaso.Proveedores> proveedores = <model_traspaso.Proveedores>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(36, count-1);
      var Jsonv = json.decode(_sub);
      //print(Jsonv);
      for (var noteJson in Jsonv) {
        proveedores.add(model_traspaso.Proveedores.from(noteJson));
      }
      return proveedores;
    }else
      throw Exception('NO se pudo');
  }

}

