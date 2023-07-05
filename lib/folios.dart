import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:datatable/Modelo_contenedor/model.dart';
import 'package:datatable/acc_mx.dart';
import 'package:datatable/container.dart';
import 'package:datatable/option_menu.dart';
import 'package:datatable/pedidos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

import 'Modelo_contenedor/Slim_model.dart';
import 'main.dart';

class Folio extends StatefulWidget {
  String user;
  Folio({Key? key, required this.user}) : super(key: key);

  @override
  State<Folio> createState() => _FolioState();
}

class _FolioState extends State<Folio> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple,),
      home: Folios_Screen(user:widget.user),
    );
  }
}

class Folios_Screen extends StatefulWidget {
  String user;
  Folios_Screen({Key? key, required this.user}) : super(key: key);

  @override
  State<Folios_Screen> createState() => _Folios_ScreenState();
}

class _Folios_ScreenState extends State<Folios_Screen> {
  List<Proveedores> provs = <Proveedores>[];
  List<Proveedores> provs_segmentada = <Proveedores>[];
  List<Proveedores> provs_folio = <Proveedores>[];
  List<folios> folios_list_buscador =<folios>[];
  List<folios> folios_list =<folios>[];
  List<folios> folios_list_sub =<folios>[];
  List<slim_order> confirmadas = <slim_order>[];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
  void _onLoading() async{
   await Future.delayed(Duration(milliseconds: 1000));
   setState(() {

   });
   _refreshController.loadComplete();
  }
  Future<List<slim_order>> Orden(String folio,String PR,String title, bool? choice,String Dias,String lead,String sublinea2,String tipo)async{
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
  Future<List<folios>> Fol() async{
    var url = Uri.parse('http://45.56.74.34:8890/pedido');
    var response = await http.get(url);
    List<folios> folios_ = <folios>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        folios_.add(folios.from(noteJson));
      }
      return folios_;
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
      print(Jsonv);
      for (var noteJson in Jsonv) {
        proveedores.add(Proveedores.from(noteJson));
      }
      return proveedores;
    }else
      throw Exception('NO se pudo');
  }

  @override
  void initState() {
    Fol().then((value){
      setState(() {
        folios_list_sub.addAll(value);
        for(int x=0;x<folios_list_sub.length;x++){
          if(folios_list_sub[x].Folio.contains('_')!=true){
            folios_list.add(folios_list_sub[x]);
          }
          //print(folios_list[x].Folio+'-'+folios_list[x].Folio.contains('_').toString());
        }
        folios_list.sort((A,B)=> A.Folio.compareTo(B.Folio));
        folios_list_buscador=folios_list;
        print(folios_list.length);
      });
    });
    Prove().then((value){
      setState((){
        provs.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller_folio =TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Menu(user: widget.user)));
            },
            icon: Icon(Icons.arrow_back)),
        title: Row(
          children: <Widget>[
            FittedBox(child:
            Text('Folios'),),
            SizedBox(width: 45,),
            Container(
              width: 250,
              child: TextField(
                showCursor: true,
                cursorColor: Colors.white,
                style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),
                //controller: controller_folio,
                decoration: InputDecoration(hintText: 'Buscar...'),
                onChanged: (text){
                  setState(() {
                    folios_list=folios_list_buscador.where((element){
                      var finder = element.Folio+element.Tipo+element.Referencia+element.Apartado!;
                      return finder.contains(text);
                    }).toList();
                  });
                },
              ),
            ),
          ],
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        elevation: 2,
        onPressed: (){
        showDialog(context: context, builder:(BuildContext context){
          return Alrt_Folio(provs:provs,user:widget.user);
        });
      }, child: Icon(Icons.add,size: 25,color: Colors.black,),),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: WaterDropHeader(),
        controller: _refreshController,
        child: GridView.builder(
            itemCount: folios_list.length,
            addAutomaticKeepAlives: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.0,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15),
            itemBuilder: (context,index){
              return _Item(folios_list[index]);
            }),
      ),
    );
  }

  _Item(folios folios_item){
    String fecha_termino ='';
    Color ? getColor(String folios_item){
      switch(folios_item){
        case 'Ref China':return Colors.blue;
        case 'Ref MX':return Colors.yellow;
        case 'Contenedor':return Colors.brown;
        case 'Acc MX':return Colors.purple.shade400;
      }
    }//
    if(folios_item.Fecha_creacion==folios_item.Fecha_cierre){
      fecha_termino = 'N/A';
    }else{
      fecha_termino = folios_item.Fecha_cierre.toString();
    }
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onDoubleTap: (){
          List<slim_order> provider = <slim_order>[];
          List<String> providers_list = <String>[];
          Orden(folios_item.Folio,folios_item.Proveedor,'',true,folios_item.Dias.toString(),folios_item.Lead.toString(), '000',folios_item.Tipo).then((value){
            setState(() {
              provider.clear();
              providers_list.clear();
              provs_folio.clear();
              confirmadas.clear();
              confirmadas.addAll(value);
              for(int x=0;x<confirmadas.length;x++){
                if(confirmadas[x].folio==folios_item.Folio&&confirmadas[x].confimadas!=0){
                  provider.add(confirmadas[x]);
                }
              }
              for(int x=0;x<provider.length;x++){
               String filtro1= provider[x].proveedores.replaceAll('{','');
               String filtro2 = filtro1.replaceAll('}','');
               String filtro3 = filtro2.replaceAll('"','');
               String filtro4 = filtro3.replaceAll('NULL','');
               String filtro5 = filtro4.replaceAll(' ','');
               List<String> split = filtro5.split(',');
               for(int x=0;x<split.length;x++){
                  if(providers_list.contains(split[x])){

                  }else if(split[x]!=''){
                    providers_list.add(split[x]);
                  }
               }
               //print(split);
              }
              print(providers_list);
              for(int x=0;x<providers_list.length;x++){
                  provs_segmentada=provs.where((element){
                    var proveedor_ = element.ID;
                    return proveedor_.isEqual(int.parse(providers_list[x]));
                  }).toList();
                  provs_folio.addAll(provs_segmentada);
              }
              showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                return Alert_sub(main_folio:folios_item,provs:provs_folio,user: widget.user,confirmadas:confirmadas);
            });
          });
          });
        },
        onTap: (){
          if(folios_item.Apartado=='Acc MX'){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Acc_MX(user: widget.user,folio: folios_item,)), (Route<dynamic>route) => false);
          }else{
            //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Pedidos(user: widget.user, folio: folios_item)), (Route<dynamic> route) => false);
           // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Container_MX(user: widget.user, folio: folios_item)), (Route<dynamic> route) => false);
          }
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>Pedidos(user: widget.user,folio:folios_item)));
        },
        onLongPress: (){},
        child: Neumorphic(
          padding: const EdgeInsets.all(8),
          style: NeumorphicStyle(
            shadowDarkColor: Colors.black,
            shadowLightColor: Colors.deepPurple,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: 2,
            lightSource: LightSource.topLeft,
            color: getColor(folios_item.Apartado.toString()),
            //color: Colors.orange,
            intensity: 1,
            surfaceIntensity: 1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Folio:'+folios_item.Folio,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:Colors.black
                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Referencia: '+folios_item.Referencia,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('Apartado: '+folios_item.Apartado.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('Dias: '+folios_item.Dias.toString()+', Lead: '+folios_item.Lead.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('Status: '+folios_item.Status.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('Proveedor '+folios_item.Proveedor,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('Tipo: '+folios_item.Tipo,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('Fecha de inicio: '+folios_item.Fecha_creacion,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('Fecha de cierre: '+fecha_termino,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
/*_showdialog(){

    return
  }*/
}

class Alrt_Folio extends StatefulWidget {
  List<Proveedores> provs;
  String user;
   Alrt_Folio({Key? key, required this.provs, required this.user}) : super(key: key);

  @override
  State<Alrt_Folio> createState() => _Alrt_FolioState();
}

class _Alrt_FolioState extends State<Alrt_Folio> {
  String tipo= "";


  @override
  Widget build(BuildContext context) {
    TextEditingController folio = TextEditingController();
    TextEditingController refer = TextEditingController();
    TextEditingController dias= TextEditingController();
    TextEditingController lead = TextEditingController();
    return AlertDialog(
      title: Text('Generar orden'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Folio'),
            TextField(controller: folio,),
            Text('Referencia'),
            TextField(controller: refer,),
            Text('Dias'),
            TextField(controller: dias,),
            Text('Lead'),
            TextField(controller: lead,),
            Radio_Alrt(),
            Drop_Apartado(),
            DropAlrt(provs:widget.provs),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: () async {
          var now = DateTime.now().toIso8601String();
          String Foliojson= ('{"Folio":"'+folio.text.toString()+
              '","Referencia":"'+refer.text.toString()+
              '","Fecha_Creacion":"'+now+
              '","Proveedor":"'+Provider.of<Lead_>(context,listen: false).provider_id+
              '","Tipo":"'+Provider.of<Lead_>(context,listen: false).tipo+
              '","Dias":'+dias.text+
              ',"Lead":'+lead.text+
              ',"Apartado":"'+Provider.of<Lead_>(context,listen: false).apartado+
              '","Fecha_Termino":"'+now+
              '","Status":"'+'Proceso'+
              '","Productos_Confirmados":'+'0'+'}');
            try{
              var items_json = jsonDecode(Foliojson);
              String encoder = jsonEncode(items_json);
              await Check(encoder);
              print(encoder);
              Provider.of<Lead_>(context,listen: false).apartado_('*');
            }on Exception catch(e){
              print(e);
            }
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Folios_Screen(user: widget.user)), (Route<dynamic> route) => false);
        }, child: Text('Generar')),
      ],
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
}

class Radio_Alrt extends StatefulWidget {
  const Radio_Alrt({Key? key}) : super(key: key);

  @override
  State<Radio_Alrt> createState() => _Radio_AlrtState();
}

class _Radio_AlrtState extends State<Radio_Alrt> {
  String tipo= "";
  String _verticalGroupValue = "Ambas";
  List<String> _status = ["Accesorios", "Refacciones", "Ambas"];
  @override
  Widget build(BuildContext context) {

    return RadioGroup<String>.builder(
        direction: Axis.horizontal,
        groupValue: _verticalGroupValue,
        onChanged: (value){
          setState(() {
            _verticalGroupValue = value!;
            switch(_verticalGroupValue){
              case'Accesorios':tipo='A'; break;
              case'Refacciones':tipo='R'; break;
              case'Ambas':tipo=''; break;
            }
            print(_verticalGroupValue);
            Provider.of<Lead_>(context,listen: false).tipo_(tipo);
          });
        },
        items: _status,
        itemBuilder: (itemrb)=>RadioButtonBuilder(
          itemrb,
        ));
  }
}

class DropAlrt extends StatefulWidget {
  List<Proveedores> provs;
  DropAlrt({Key? key, required this.provs}) : super(key: key);

  @override
  State<DropAlrt> createState() => _DropAlrtState();
}

class _DropAlrtState extends State<DropAlrt> {
  var item = [
    '*','247?','AMAZING','ASTRON','BEST TERESA','BRASONIC','CAPITAL MOVILE','CELMEX','Celulr Hit',
    'CH ACCESORIES','CHEN','CONSTELACIÓN ORIENTAL','DNS','EAUPULEY','ELE-GATE','ESTEFANO',
    'EVA','HAP TECH INC','IPHONE E.U','IPLUS','KAIPING','LITOY','MARDI','MC',
    'MEGAFIRE','MING','MK','MOBILSHOP','NUNBELL','PAPELERIA','PATTY','PENDRIVE CITY',
    'RAZZY','RELX','SEO','SIVIVI','SKYROAM','SLIM-CO','SLIM-CO REFACCIONES','VIMI',
    'WEI DAN','XIAOMI','XMOVILE','XP','ZHENG'
  ];
  String provider='';
  String? dropdownvaluep = '';
  @override
    Widget build(BuildContext context) {
    return DropdownButton(
        underline: Text('Proveedores',style:
        TextStyle(fontSize: 10,height: 15),),
        value:Provider.of<Lead_>(context,listen: false).provider,
        dropdownColor: Colors.deepPurple,
        items: item.map((String items) {
          return DropdownMenuItem(
              value: items,
              child: Text(items));
        }).toList(),
        onChanged: (String? newValue){
          setState(() {
            Provider.of<Lead_>(context,listen: false).providedropb(newValue!);
            provider='';
            for(int x=0;x<widget.provs.length;x++){
              if(Provider.of<Lead_>(context,listen: false).provider==widget.provs[x].Nombre){
                switch(widget.provs[x].ID.toString().length){
                  case 1:
                    String val =widget.provs[x].ID.toString();
                    provider = '00$val';
                    Provider.of<Lead_>(context,listen: false).id_provider(provider);
                    break;
                  case 2:
                    String val =widget.provs[x].ID.toString();
                    provider = '0$val';
                    Provider.of<Lead_>(context,listen: false).id_provider(provider);
                    break;
                  case 3:
                    String val =widget.provs[x].ID.toString();
                    provider = '$val';
                    Provider.of<Lead_>(context,listen: false).id_provider(provider);
                    break;
                }
              }else if(Provider.of<Lead_>(context,listen: false).provider=='*'){
                provider = '0';
                Provider.of<Lead_>(context,listen: false).id_provider(provider);
              }
            }
          });
          print(provider+Provider.of<Lead_>(context,listen: false).provider);
        });
  }
}

class Alert_sub extends StatefulWidget {
  String user;
  List<Proveedores> provs;
  List<slim_order> confirmadas;
  folios main_folio;

  Alert_sub({Key? key,required this.main_folio,required this.provs,required this.user, required this.confirmadas}) : super(key: key);

  @override
  State<Alert_sub> createState() => _Alert_subState();
}

class _Alert_subState extends State<Alert_sub> {
  @override
  Widget build(BuildContext context) {
    TextEditingController dias= TextEditingController();
    TextEditingController lead = TextEditingController();
    TextEditingController folio = TextEditingController();
    TextEditingController refer = TextEditingController();
    return AlertDialog(
      title: Text('Generar subfolio'),
      content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Folio'),
              Row(
                children: [
                  Text(widget.main_folio.Folio+'-'),
                  Container(child: TextField(controller: folio,),width: 175,),
                ],
              ),
              Text('Referencia'),
              TextField(controller: refer,),
              Text('Dias'),
              TextField(controller: dias,decoration: InputDecoration(hintText: widget.main_folio.Dias.toString())),
              Text('Lead'),
              TextField(controller: lead,decoration: InputDecoration(hintText: widget.main_folio.Lead.toString()),),
              Text('Tipo: '+widget.main_folio.Tipo),
              Drop_Prov_subfolio(provs:widget.provs),
            ],
          )),
      actions: <Widget>[
        TextButton(onPressed: (){
          Provider.of<Lead_>(context,listen: false).providedropb_sub('*');
          Navigator.pop(context);
        }, child: Text('Cancelar')),
        TextButton(onPressed: () async {
          var now = DateTime.now().toIso8601String();
          String Foliojson= ('{"Folio":"'+widget.main_folio.Folio+'-'+folio.text.toString()+
              '","Referencia":"'+refer.text.toString()+
              '","Fecha_Creacion":"'+now+
              '","Proveedor":"'+Provider.of<Lead_>(context,listen: false).provider_id_subfolio+
              '","Tipo":"'+widget.main_folio.Tipo+
              '","Dias":'+dias.text+
              ',"Lead":'+lead.text+'}');
          try{
            var items_json = jsonDecode(Foliojson);
            String encoder = jsonEncode(items_json);
            //Check(encoder);
            print(encoder);
            List<slim_order> subfolio_lista = <slim_order>[];
            List<slim_order> sub_confirmados = <slim_order>[];
           await Orden(widget.main_folio.Folio,Provider.of<Lead_>(context,listen: false).provider_id_subfolio,'',true,dias.text,lead.text,'000', widget.main_folio.Tipo).then((value){
              setState(() {
                sub_confirmados.addAll(value);
               for(int x=0;x<sub_confirmados.length;x++){
                 if(sub_confirmados[x].folio==widget.main_folio.Folio&&sub_confirmados[x].confimadas!=0){
                   subfolio_lista.add(sub_confirmados[x]);
                 }
               }
                for(int x=0;x<subfolio_lista.length;x++){
                  if(subfolio_lista[x].pedidas!=0){
                    if(subfolio_lista[x].confimadas<subfolio_lista[x].pedidas){
                      int diferencia= subfolio_lista[x].confimadas-subfolio_lista[x].pedidas;
                      Confirmar_Folio(widget.main_folio.Folio+'-'+folio.text.toString(),subfolio_lista[x].codigo_slim,'',diferencia,widget.user,'','','');
                    }else{
                      Confirmar_Folio(widget.main_folio.Folio+'-'+folio.text.toString(),subfolio_lista[x].codigo_slim,'',subfolio_lista[x].confimadas,widget.user,'','','');
                    }
                  }
                  print(subfolio_lista[x].folio!+' Conf: '+subfolio_lista[x].confimadas.toString()+' Slim:'+subfolio_lista[x].codigo_slim+' Desc: '+subfolio_lista[x].Desc);
                }
              });
            });

            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Folios_Screen(user: widget.user)), (Route<dynamic> route) => false);
          }on Exception catch(e){
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
                      IconButton(
                        onPressed: (){

                        },
                        icon: Icon(Icons.check_circle,color: Colors.green),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(e.toString()),),
                    ],
                  ),
                ),
              ),
            );
            print(e);
          }
          Provider.of<Lead_>(context,listen: false).providedropb_sub('*');
        }, child: Text('Generar'))
      ],
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
  Future<http.Response> Confirmar_Folio(String folio,String codigo, String desc, int quantity,
      String user, String title, String variation, String id){
    print('http://45.56.74.34:8890/container/set?container=$folio&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user');
    return http.post(
      Uri.parse('http://45.56.74.34:8890/container/set?container=$folio&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers:  <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );
  }

  Future<List<slim_order>> Orden(String folio,String PR,String title, bool? choice,String Dias,String lead,String sublinea2,String tipo)async{
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

}

class Drop_Prov_subfolio extends StatefulWidget {
  List<Proveedores> provs;
  Drop_Prov_subfolio({Key? key,required this.provs}) : super(key: key);

  @override
  State<Drop_Prov_subfolio> createState() => _Drop_Prov_subfolioState();
}

class _Drop_Prov_subfolioState extends State<Drop_Prov_subfolio> {
  var item=[''];
  String provider='';
  String? dropdownvaluep = '';

  @override
  Widget build(BuildContext context) {
    item.clear();
    item.add('*');
    for(int x=0;x<widget.provs.length;x++){
        item.add(widget.provs[x].Nombre);
    }
    return DropdownButton(
        dropdownColor: Colors.deepPurple,
        value:Provider.of<Lead_>(context,listen: false).provider_sub ,
        underline: Text('Proveedores',
        style: TextStyle(fontSize: 10,height: 15,fontWeight: FontWeight.bold),),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),
        items: item.map((String items){
            return DropdownMenuItem(
                child: Text(items,style: TextStyle(fontWeight: FontWeight.bold),),
                value: items);
        }).toList(),
        onChanged: (String? newValue){
          setState(() {
            Provider.of<Lead_>(context,listen: false).providedropb_sub(newValue!);
            provider='';
            for(int x=0;x<widget.provs.length;x++){
              //print(widget.provs[x].Nombre+'-'+widget.provs[x].ID.toString()+'-'+newValue!);
              if(Provider.of<Lead_>(context,listen: false).provider_sub==widget.provs[x].Nombre){
               //print(Provider.of<Lead_>(context,listen: false).provider_sub+'-'+widget.provs[x].Nombre);
                switch(widget.provs[x].ID.toString().length){
                  case 1:
                    String val =widget.provs[x].ID.toString();
                    provider = '00$val';
                    Provider.of<Lead_>(context,listen: false).id_provider_sub(provider);
                    break;
                  case 2:
                    String val =widget.provs[x].ID.toString();
                    provider = '0$val';
                    Provider.of<Lead_>(context,listen: false).id_provider_sub(provider);
                    break;
                  case 3:
                    String val =widget.provs[x].ID.toString();
                    provider = '$val';
                    Provider.of<Lead_>(context,listen: false).id_provider_sub(provider);
                    break;
                }
              }else if(Provider.of<Lead_>(context,listen: false).provider_sub=='*'){
                provider = '0';
                Provider.of<Lead_>(context,listen: false).id_provider_sub(provider);
              }
            }
            print(provider+'-'+Provider.of<Lead_>(context,listen: false).provider_sub);
          });
        });
  }
}

class Drop_Apartado extends StatefulWidget {
  const Drop_Apartado({Key? key}) : super(key: key);

  @override
  State<Drop_Apartado> createState() => _Drop_ApartadoState();
}

class _Drop_ApartadoState extends State<Drop_Apartado> {
  var item=['*','Ref China','Ref MX','Acc MX','Contenedor'];
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        dropdownColor: Colors.deepPurple,
        value: Provider.of<Lead_>(context,listen: false).apartado,
        underline: Text('Apartado',
        style: TextStyle(fontSize: 10,height: 15,fontWeight: FontWeight.bold),),
        style: TextStyle(color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20),
        items: item.map((String items){
          return DropdownMenuItem(
              child:Text(items),
              value: items,);
        }).toList(),
        onChanged: (String? newValue){
          setState(() {
            Provider.of<Lead_>(context,listen: false).apartado_(newValue!);
          });
        });
  }
}









