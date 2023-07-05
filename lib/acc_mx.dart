import 'dart:convert';
import 'dart:io';
import 'package:datatable/Modelo_contenedor/model.dart';
import 'package:datatable/folios.dart';
import 'package:datatable/grid_confirm.dart';
import 'package:datatable/grid_confirm_ref.dart';
import 'package:datatable/main.dart';
import 'package:datatable/pedidos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'Modelo_contenedor/Slim_model.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

class Acc_MX extends StatefulWidget {
  folios folio;
  String user;
  Acc_MX({Key? key,required this.user,required this.folio}) : super(key: key);

  @override
  State<Acc_MX> createState() => _Acc_MXState();
}

class _Acc_MXState extends State<Acc_MX> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Acc_MX_Screen(user:widget.user,folio: widget.folio,),
    );
  }
}

class Acc_MX_Screen extends StatefulWidget {
  folios folio;
  String user;
  Acc_MX_Screen({Key? key,required this.user,required this.folio}) : super(key: key);

  @override
  State<Acc_MX_Screen> createState() => _Acc_MX_ScreenState();
}

class _Acc_MX_ScreenState extends State<Acc_MX_Screen> {
  List<folios> folios_list=<folios>[];
  List<folios> folios_apartado=<folios>[];
  List<Proveedores> provider_list = <Proveedores>[];
  List<Folios_ACCMX> prover_folios =<Folios_ACCMX>[];
  List<slim_order>ExclMX = <slim_order>[];

@override
  void initState() {
    prover_folios.addAll(Lista_foliosACCMX());
    Consul_folios().Folios().then((value){
      setState(() {
        folios_apartado.addAll(value);
        for(int x=0;x<folios_apartado.length;x++){
          if(folios_apartado[x].Folio.contains(widget.folio.Folio+'_')){
            folios_list.add(folios_apartado[x]);
          }
        }
        for(int x=0;x<folios_list.length;x++){
          for(int x_=0;x_<prover_folios.length;x_++){
            print(folios_list[x].Proveedor+'-'+prover_folios[x_].id_proveedor);
            if(folios_list[x].Proveedor==prover_folios[x_].id_proveedor){
              prover_folios.remove(prover_folios[x_]);
            }
          }
        }
      });
    });
    Consul_Provider().Prove().then((value){
      setState(() {
        provider_list.addAll(value);
      });
    });
    super.initState();
  }

  Future<void> ExcelACCMX(List<slim_order>ExcelistMX,String folio)async{
    Stopwatch stopwatch = new Stopwatch()..start();
    List<slim_order> Excelist = <slim_order>[];
    for(int x=0;x<ExcelistMX.length;x++){
      if(ExcelistMX[x].folio==folio&&ExcelistMX[x].confimadas!=0){
        Excelist.add(ExcelistMX[x]);
        //print(Excelist[x].folio!+'-'+Excelist[x].codigo_slim);
      }
    }
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
      switch(Excelist[x-2].Color){
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
        default: color = Excelist[x-2].Color; break;
      }
      sheet.getRangeByName('A$x').setNumber(Excelist[x-2].confimadas.toDouble());
      sheet.getRangeByName('B$x').setText(Excelist[x-2].desc_mx);
      sheet.getRangeByName('C$x').setText(color);
      sheet.getRangeByName('D$x').setText(Excelist[x-2].desc_mx+''+'-'+''+color!+''+Excelist[x-2].confimadas.toString());
    }
    var hoy = DateTime.now();
    var formatDate1 =new DateFormat('ddMMy');
    String fecha = formatDate1.format(hoy);
    String fechasub = fecha.replaceAll('/','');
    final List<int> bytes = workbook.saveAsStream();
    try{
      await File('//192.168.10.108/Public/VICTOR/SlimData/Excel_AccMX/'+folio+'_$fechasub.xlsx').writeAsBytes(bytes).then((value){
        workbook.dispose();
        print('doSomething() executed in ${stopwatch.elapsed}');
        imagen_mostrar('Excel exportado');
      });
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
        /*actions: <Widget>[
          TextButton(onPressed: (){

          }, child: Text('Insertar Imagenes'),)
        ],*/
      );
      }
    );
  }
  Lista_foliosACCMX(){
    List<Folios_ACCMX> lista_=<Folios_ACCMX>[
      Folios_ACCMX(
          Proveedor_Nombre: 'ELE-GATE',
          Usuario:'JAIR',
          id_proveedor: '002'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'LITOY / MEI',
          Usuario:'PEDRO',
          id_proveedor: '009'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'CELULAR HIT',
          Usuario:'PEDRO',
          id_proveedor: '043'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'EVA',
          Usuario:'GIOVANNI',
          id_proveedor: '012'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'MASCOTAS',
          Usuario:'JAIR',
          id_proveedor: '001'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'CELMEX',
          Usuario:'JORGE',
          id_proveedor: '016'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'BEST TERESA',
          Usuario:'JORGE',
          id_proveedor: '011'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'AMAZING',
          Usuario:'GIOVANNI',
          id_proveedor: '017'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'PAPELERIA',
          Usuario:'JORGE',
          id_proveedor: '035'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'WEI DAN',
          Usuario:'JORGE',
          id_proveedor: '027'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'KP/HANG',
          Usuario:'JORGE',
          id_proveedor: '003'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'MING',
          Usuario:'GIOVANNI',
          id_proveedor: '014'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'MEGAFIRE',
          Usuario:'JORGE',
          id_proveedor: '010'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'VIMI',
          Usuario:'JAIR',
          id_proveedor: '006'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: '247°',
          Usuario:'PEDRO/AYDE',
          id_proveedor: '005'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'DNS',
          Usuario:'JAIR',
          id_proveedor: '019'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'XIAOMI',
          Usuario:'PEDRO/AYDE',
          id_proveedor: '008'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'PENDRIVE',
          Usuario:'JAIR',
          id_proveedor: '004'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'CHEN',
          Usuario:'PEDRO',
          id_proveedor: '028'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'KINKETE',
          Usuario:'GIOVANNI',
          id_proveedor: '044'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'MAI',
          Usuario:'',
          id_proveedor: '045'
      ),
      Folios_ACCMX(
          Proveedor_Nombre: 'SHUN',
          Usuario:'JORGE',
          id_proveedor: '046'
      ),
    ];
    return lista_;
  }
  Future<List<slim_order>> ModeloSlim(String provider,String sub2,String tipo) async {
    String PR = '&proveedor=$provider';
    var url = Uri.parse('http://45.56.74.34:8890/container/condensado?title=&confirmados=yes'+PR+'&dias=0&leadtime=0&sublinea2=$sub2&tipo=$tipo');
    print(url);
    var response = await http.get(url);
    List<slim_order> pconfirm = <slim_order>[];
    if(response.statusCode ==200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv){
        pconfirm.add(slim_order.from(noteJson));
      }
      return pconfirm;
    }else{
      throw Exception('No se pudo');
    }
  }

  @override
  Widget build(BuildContext context) {

  Color? getColor(String status){
    switch(status){
      case'Proceso':return Colors.orange; break;
      case'Listo':return Colors.green;
      default: return Colors.deepPurple;
    }
  }
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Folio(user: widget.user)));
          }, icon: Icon(Icons.arrow_back)),
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Folio: '+widget.folio.Folio),
            ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: folios_list.length,
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      switch(folios_list[index].Status){
                        case'Listo':if(folios_list[index].Tipo=='A'){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Grid_Confirmados(user: widget.user, folio: folios_list[index])), (route) => false);
                        }else{
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Grid_Confirm_ref(user: widget.user, folio: folios_list[index])), (route) => false);
                        }; break;
                        case'Proceso':Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Pedidos(user: widget.user, folio: folios_list[index])), (route) => false);
                      }
                    },
                    onDoubleTap: (){
                      ModeloSlim(folios_list[index].Proveedor, '000',folios_list[index].Tipo).then((value){
                        setState(() {
                          ExclMX.addAll(value);
                          ExcelACCMX(ExclMX, folios_list[index].Folio);
                        });
                      });
                    },
                    child: Card(
                      color: getColor(folios_list[index].Status!),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:  Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(padding:EdgeInsets.all(12.0),child: Text('Folio:'+folios_list[index].Folio,style: TextStyle(fontSize: 25,color:Colors.black,fontWeight: FontWeight.bold),)),
                          Container(padding:EdgeInsets.all(12.0),child: Text('Proveedor:'+provider_conv(folios_list[index].Proveedor.substring(1,3)),style: TextStyle(fontSize: 25,color:Colors.black,fontWeight: FontWeight.bold),)),
                          Container(padding:EdgeInsets.all(12.0),child: Text(folios_list[index].Referencia,style: TextStyle(fontSize: 25,color:Colors.black,fontWeight: FontWeight.bold))),
                          Container(padding:EdgeInsets.all(12.0),child: Text('Status: '+folios_list[index].Status.toString(),style: TextStyle(fontSize: 25,color:Colors.black,fontWeight: FontWeight.bold))),
                          Container(padding:EdgeInsets.all(12.0),child: Text('Productos Confirmados:'+folios_list[index].items_conf.toString(),style: TextStyle(fontSize: 25,color:Colors.black,fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,childAspectRatio: 6,crossAxisSpacing: 10,mainAxisSpacing: 10),
            itemCount: prover_folios.length,
            itemBuilder: (context,index){
                return GestureDetector(
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(padding: EdgeInsets.all(12.0),child: Text(prover_folios[index].Usuario,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
                        Container(padding: EdgeInsets.all(12.0),child: Text('Proveedor: '+prover_folios[index].Proveedor_Nombre,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
                      ],
                    ),
                  ),
                  onLongPress: (){
                    showDialog(context: context, builder:(BuildContext context){
                      return Alrt_Acc_MX(folio:widget.folio,user: widget.user,proveedor:prover_folios[index].id_proveedor,name_prover:prover_folios[index].Proveedor_Nombre);
                    });
                  },
                );
            }),
          )
        ],
      ),
    );
  }

  provider_conv(String provider_){
      print(provider_);
      String provider_convert='Sin proveedor';
      String provider_desconv ='';
      if(provider_[0]=='0'){
        provider_desconv=provider_.substring(1);
      }else{
        provider_desconv=provider_;
      }
      print(provider_desconv);
      for(int x=0;x<provider_list.length;x++){
        if(provider_list[x].ID.toString()==provider_desconv){
          provider_convert = provider_list[x].Nombre;
        }
      }
      return provider_convert;
  }
}

class Alrt_Acc_MX extends StatefulWidget {
  folios folio;
  //List<Proveedores> provider_list = <Proveedores>[];
  String name_prover;
  String user;
  String proveedor;
  Alrt_Acc_MX({Key? key,required this.folio,required this.user, required this.proveedor, required this.name_prover}) : super(key: key);

  @override
  State<Alrt_Acc_MX> createState() => _Alrt_Acc_MXState();
}

class _Alrt_Acc_MXState extends State<Alrt_Acc_MX> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller_ref = TextEditingController();
    TextEditingController controller_Dias = TextEditingController();
    TextEditingController controller_Lead = TextEditingController();
    return AlertDialog(
      title: Text('Generar Folio a proveedor'),
      content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Referencia'),
              TextField(controller: controller_ref,),
              Text('Dias'),
              TextField(controller: controller_Dias,),
              Text('Lead'),
              TextField(controller:  controller_Lead,),
              Text('Proveedor: '+widget.name_prover),
              //Drop_prov_accmx(provs: widget.provider_list),
            ],
          ),
      ),
      actions: <Widget>[
          TextButton(
              onPressed: () async{
                var now = DateTime.now().toIso8601String();
                String Foliojson =
                (
                        //'{"Folio":"'+widget.folio.Folio+'_'+zeroprovider(Provider.of<Lead_>(context,listen: false).provider_AccMX_id)+
                        '{"Folio":"'+widget.folio.Folio+'_'+widget.proveedor+
                        '","Referencia":"'+controller_ref.text+
                        '","Fecha_Creacion":"'+now+
                        //'","Proveedor":"'+zeroprovider(Provider.of<Lead_>(context,listen: false).provider_AccMX_id)+
                        '","Proveedor":"'+widget.proveedor+
                        '","Tipo":"'+widget.folio.Tipo+
                        '","Dias":'+controller_Dias.text+
                        ',"Lead":'+controller_Lead.text+
                        ',"Apartado":"'+widget.folio.Apartado!+
                        '","Fecha_Termino":"'+now+
                        '","Status":"'+'Proceso'+
                        '","Productos_Confirmados":'+'0'+'}'
                );
                try{
                  var items_json = jsonDecode(Foliojson);
                  String encoder = jsonEncode(items_json);
                  await Check(encoder);
                  print(encoder);
                  Provider.of<Lead_>(context,listen: false).provider_ACC_MX('*');
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Acc_MX(user:widget.user, folio: widget.folio)), (route) => false);
                }on Exception catch(e){
                    print(e);
                }
              },
              child: Text('Generar'))
       ],
    );
  }
  zeroprovider(String proveedor){
    String zeroprovider='';
    switch(proveedor.length){
      case 1:zeroprovider = '00'+proveedor; break;
      case 2:zeroprovider = '0'+proveedor; break;
      default :zeroprovider = proveedor; break;
    }
    return zeroprovider;
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

class Drop_prov_accmx extends StatefulWidget {
  List<Proveedores> provs;
  Drop_prov_accmx({Key? key, required this.provs}) : super(key: key);

  @override
  State<Drop_prov_accmx> createState() => _Drop_prov_accmxState();
}

class _Drop_prov_accmxState extends State<Drop_prov_accmx> {
  var item = ['*'];

  @override
  void initState() {
    for(int x=0;x<widget.provs.length;x++){
      setState(() {
        item.add(widget.provs[x].Nombre);
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        underline: Text('Proveedores',
        style: TextStyle(fontSize: 10,height: 15),),
        value: Provider.of<Lead_>(context,listen: false).provider_AccMX,
        dropdownColor: Colors.deepPurple,
        items: item.map((String items){
          return DropdownMenuItem(
              child: Text(items),
              value: items,
          );
        }).toList(),
        onChanged: (String? newValue){
          setState(() {
            Provider.of<Lead_>(context,listen: false).provider_ACC_MX(newValue!);
            for(int x=0;x<widget.provs.length;x++){
              if(Provider.of<Lead_>(context,listen: false).provider_AccMX==widget.provs[x].Nombre){
                //print(Provider.of<Lead_>(context,listen: false).provider_AccMX+'-'+widget.provs[x].Nombre);
                Provider.of<Lead_>(context,listen: false).provider_ACC_MX_id(widget.provs[x].ID.toString());
              }else if(Provider.of<Lead_>(context,listen: false).provider_AccMX=='*'){
               Provider.of<Lead_>(context,listen: false).provider_ACC_MX_id('0');
              }
            }
            print(Provider.of<Lead_>(context,listen: false).provider_AccMX_id+'-'+Provider.of<Lead_>(context,listen: false).provider_AccMX);
          });
        },
    );
  }
}

