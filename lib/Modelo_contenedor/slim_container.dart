import 'dart:convert';
import 'dart:typed_data';
import 'package:datatable/sub_folios.dart';
import 'package:datatable/xls/container_layout.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../Modelo_traspaso/modelo_traspaso.dart';
import '../folios_screen.dart';
import '../main.dart';
import 'Slim_model.dart';

class container_data{
  String cODIGO;
  String dESCRIPCION;
  String sKU;
  int sTOCKCEDIS;
  num cOSTOULTIMO;
  String sUBLINEA2NOMBRE;
  int sUBLINEA2ID;
  String cONTAINER;
  int qUANTITY;
  int pEDIDAS;
  int aMAZON30D;
  String pROVEEDORES;
  int vTA30NATURALES;
  int vTA30HISTORICAS;
  int fULL;
  String iMAGEN;
  int fULLENVIOS;
  int cOMPRACAMINO;
  int fBA;
  int aMAZONSOLD;
  int unidades_caja;
  int sold;
  int transfer;
  String ubicaciones;
  String agotar;

  container_data(
      {required this.cODIGO,
        required this.dESCRIPCION,
        required this.sKU,
        required this.sTOCKCEDIS,
        required this.cOSTOULTIMO,
        required this.sUBLINEA2NOMBRE,
        required this.sUBLINEA2ID,
        required this.cONTAINER,
        required this.qUANTITY,
        required this.pEDIDAS,
        required this.aMAZON30D,
        required this.pROVEEDORES,
        required this.vTA30NATURALES,
        required this.vTA30HISTORICAS,
        required this.fULL,
        required this.iMAGEN,
        required this.fULLENVIOS,
        required this.cOMPRACAMINO,
        required this.fBA,
        required this.aMAZONSOLD,
        required this.unidades_caja,
        required this.sold,
        required this.transfer,
        required this.ubicaciones,
        required this.agotar});

  factory container_data.from(Map<String, dynamic>json){
    return container_data(
      cODIGO : json['CODIGO'],
      dESCRIPCION : json['DESCRIPCION'],
      sKU: json['SKU']??'SIN SKU',
      sTOCKCEDIS : json['STOCK_CEDIS'],
      cOSTOULTIMO : json['COSTO_ULTIMO'],
      sUBLINEA2NOMBRE : json['SUBLINEA2_NOMBRE'],
      sUBLINEA2ID : json['SUBLINEA2_ID'],
      cONTAINER : json['CONTAINER'],
      qUANTITY : json['QUANTITY'],
      pEDIDAS : json['PEDIDAS'],
      aMAZON30D : json['AMAZON30D'],
      pROVEEDORES : json['PROVEEDORES'],
      vTA30NATURALES : json['VTA30_NATURALES'],
      vTA30HISTORICAS : json['VTA30_HISTORICAS'],
      fULL : json['FULL'],
      iMAGEN : json['IMAGEN'],
      fULLENVIOS : json['FULL_ENVIOS'],
      cOMPRACAMINO : json['COMPRA_CAMINO'],
      fBA : json['FBA'],
      aMAZONSOLD : json['AMAZON_SOLD'],
      unidades_caja: json['UNIDADES_POR_CAJA'],
      sold: json['ML_SOLD'],
      transfer: json['TRANSFER'],
      ubicaciones: json['UBICACIONES'],
      agotar:  json['AGOTAR']
    );
  }
}

class container_class{
  Future Slim_container(String proveedor,String sublinea,String contenedor,String title,String tipo) async{
    if(title ==''){
      title='*';
    }
    if(contenedor ==''){
      contenedor='*';
    }
    if(sublinea ==''){
      sublinea='*';
    }
    if(tipo==''){
      tipo='*';
    }
    if(proveedor ==''){
      proveedor='*';
    }
    var url = Uri.parse('http://45.56.74.34:6660/container?proveedor=$proveedor&sublinea=$sublinea&container=$contenedor&codigo=$title&tipo=$tipo');
    print(url);
    var response = await http.get(url);
    List<container_data> containerSLIM = <container_data>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        containerSLIM.add(container_data.from(noteJson));
      }
      return containerSLIM;
    }else
      throw Exception('NO se pudo');
  }
 }

  class Confirmar {
   String Cod_Slim;
   int quantity;
   String folio;
   String user;
   Confirmar({required this.Cod_Slim,required this.quantity,required this.folio,required this.user}){
      http.post(
       Uri.parse('http://45.56.74.34:8890/container/set?container=$folio&codigo=$Cod_Slim&descripcion=''&id=''&title=''&variation_id=''&quantity=$quantity&user_id=$user'),
       headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       },
       //body: _pedidojson,
     );
   }
}

class Folio_Container{
  String folio;
  String referencia;
  String fechaCreacion;
  String proveedor;
  String tipo;
  int dias;
  int lead;
  String? fechaTermino;
  int productosConfirmados;
  String apartado;
  String status;

  Folio_Container({required this.folio,
    required this.referencia,
    required this.fechaCreacion,
    required this.proveedor,
    required this.tipo,
    required this.dias,
    required this.lead,
    required this.fechaTermino,
    required this.productosConfirmados,
    required this.apartado,
    required this.status});
  
  factory Folio_Container.from(Map<String,dynamic>json){
    return Folio_Container(
      folio : json['Folio'],
      referencia : json['Referencia'],
      fechaCreacion : json['Fecha_Creacion'],
      proveedor : json['Proveedor'],
      tipo : json['Tipo'],
      dias : json['Dias'],
      lead : json['Lead'],
      fechaTermino : json['Fecha_Termino'],
      productosConfirmados : json['Productos_Confirmados'],
      apartado : json['Apartado'],
      status : json['Status'],
    );
  }
}

class Selec_Folios{
  Future All_Folios()async{
    var url = Uri.parse('http://45.56.74.34:6660/folios');
    print(url);
    var response = await http.get(url);
    List<Folio_Container> all_folios= <Folio_Container>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        all_folios.add(Folio_Container.from(noteJson));
      }
      return all_folios;
    }else
      throw Exception('NO se pudo');
  }
}

class Selec_SUB{
  Future All_Folios(String subfolios)async{
    var url = Uri.parse('http://45.56.74.34:6660/subfolios/${subfolios}');
    print(url);
    var response = await http.get(url);
    List<Folio_Container> all_folios= <Folio_Container>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        all_folios.add(Folio_Container.from(noteJson));
      }
      return all_folios;
    }else
      throw Exception('NO se pudo');
  }
}

class Create_Folios{
  ADDFolios(String folio,
  String referencia,
  String fechaCreacion,
  String proveedor,
  String tipo,
  int dias,
  int lead,
  String apartado,
  String status){
     return http.get(
    Uri.parse('http://45.56.74.34:6660/addfolio?folio=${folio}&referencia=${referencia}&fec_creacion=${fechaCreacion}&proveedor=${proveedor}&tipo=${tipo}&dias=${dias}&lead=${lead}&apartado=${apartado}&status=${status}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    //body: _pedidojson,
  );}
}
class Sublinea{
  final String Nombre;
  final int ID;

  Sublinea({required this.Nombre,required this.ID});

  factory Sublinea.from(Map<String, dynamic>json){
    return Sublinea(
        Nombre: json['NOMBRE'],
        ID: json['ID']);
  }
}

class Slimsublinea{
  Future<List<Sublinea>> Subline() async{
    var url = Uri.parse('http://45.56.74.34:5558/productos/sublineas2/list');
    var response = await http.get(url);
    List<Sublinea> sublinea = <Sublinea>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(36, count-1);
      var Jsonv = json.decode(_sub);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        sublinea.add(Sublinea.from(noteJson));
      }
      return sublinea;
    }else
      throw Exception('NO se pudo');
  }
}

class ProveedoresACCMX{
  final String Nombre;
  final String ID;

  ProveedoresACCMX({required this.Nombre,required this.ID});

  factory ProveedoresACCMX.from(Map<String, dynamic>json){
    return ProveedoresACCMX(
        Nombre: json['NOMBRE'],
        ID: json['ID']);
  }
}

class Slim_Proveedores{
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
}

class ProveedoresACCMXCon{
  Future<List<ProveedoresACCMX>> ProveACC()async{
    var url = Uri.parse('http://45.56.74.34:6660/subfolios/todo');
    var response = await http.get(url);
    List<ProveedoresACCMX> proveedores = <ProveedoresACCMX>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        proveedores.add(ProveedoresACCMX.from(noteJson));
      }
      return proveedores;
    }else
      throw Exception('NO se pudo');
  }
}

class Alert_AddFolio extends StatefulWidget {
  String user;
  Alert_AddFolio({Key? key,required this.user}) : super(key: key);

  @override
  State<Alert_AddFolio> createState() => _Alert_AddFolioState();
}

class _Alert_AddFolioState extends State<Alert_AddFolio> {
  String tipo="";
  List<Proveedores> provs = <Proveedores>[];
  List<String>item =['*'];
  @override
  void initState() {
    Slim_Proveedores().Prove().then((value){
      setState((){
        provs.addAll(value);
        for(int x=0;x<provs.length;x++){
          item.add(provs[x].Nombre.toString());
        }
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController folio = TextEditingController();
    TextEditingController refer = TextEditingController();
    TextEditingController dias= TextEditingController();
    TextEditingController lead = TextEditingController();
    return AlertDialog(
      title: Text('Generar Folio'),
      content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Folio'),
              TextField(controller: folio),
              Text('Referencia'),
              TextField(controller: refer,),
              Text('Dias'),
              TextField(controller: dias,),
              Text('Lead'),
              TextField(controller: lead,),
              Radio_TIPO(),
              Apartado(),
              Proveedores_alrt(provs: provs,item:item)
            ],
          ),
      ),
      actions: <Widget>[
        TextButton(onPressed: ()async{
          var now = DateTime.now().toIso8601String();
          String Folio = folio.text.toString();
          String referencia = refer.text.toString();
          String days = dias.text.toString().trim();
          String lead_days = lead.text.toString().trim();
          String apartado = Provider.of<Lead_>(context,listen: false).apartado;
          String proveedor = Provider.of<Lead_>(context,listen: false).provider_id;
          String Status = 'Proceso';
          tipo=Provider.of<Lead_>(context,listen: false).tipo;
          try{
            print(Folio+'-'+referencia+'-'+days+'-'+lead_days+'-'+apartado+'-'+proveedor+'-'+Status+'-'+now);
            await Create_Folios().ADDFolios(Folio.trim(),referencia.trim(),now,proveedor,tipo,int.parse(days),int.parse(lead_days),apartado, Status);
            Accion_realizada('Folio creado');
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>List_Folios(user: widget.user)), (Route<dynamic> route) => false);
          }on Exception catch(e){
            Accion_realizada('Error al crear folio');
            print(e);
          }
        }, child: Text('Generar'))
      ],
    );
  }
}

class Radio_TIPO extends StatefulWidget {
  const Radio_TIPO({Key? key}) : super(key: key);

  @override
  State<Radio_TIPO> createState() => _Radio_TIPOState();
}

class _Radio_TIPOState extends State<Radio_TIPO> {
  String tipo="";
  String _verticalGroup = "Accesorios";
  List<String> _status = ["Accesorios", "Refacciones"];
  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>.builder(
        direction: Axis.horizontal,
        groupValue: _verticalGroup,
        onChanged: (value){
          setState((){
            _verticalGroup= value!;
            switch(_verticalGroup){
              case'Accesorios':tipo='A'; break;
              case'Refacciones':tipo='R'; break;
            }
            Provider.of<Lead_>(context,listen: false).tipo_(tipo);
          });
        },
        items: _status,
        itemBuilder: (itemrb)=>RadioButtonBuilder(itemrb));
  }
}

class Apartado extends StatefulWidget {
  const Apartado({Key? key}) : super(key: key);

  @override
  State<Apartado> createState() => _ApartadoState();
}

class _ApartadoState extends State<Apartado> {
  var item=['*','Ref China','Ref MX','Acc MX','Contenedor'];
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        dropdownColor: Colors.indigo,
        value: Provider.of<Lead_>(context,listen: false).apartado,
        items: item.map((String items){
          return DropdownMenuItem(
            child: Text(items),value: items,);
        }).toList(),
        onChanged: (String? newValue){
        setState(() {
          Provider.of<Lead_>(context,listen: false).apartado_(newValue!);
        });
      }
    );
  }
}

class Proveedores_alrt extends StatefulWidget {
  List<Proveedores> provs;
  List<String>item;
  Proveedores_alrt({Key? key,required this.provs,required this.item}) : super(key: key);

  @override
  State<Proveedores_alrt> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores_alrt> {
String provider = '';
String? dropdownvaluep = '';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        underline: Text('Proveedores',style:
        TextStyle(fontSize: 10,height: 15),),
        value: Provider.of<Lead_>(context,listen: false).provider,
        items: widget.item.map((String items){
          return DropdownMenuItem(
              value: items,
              child: Text(items));
        }).toList(),
        onChanged: (String? newValue){
          setState(() {
            Provider.of<Lead_>(context,listen: false).providedropb(newValue!);
            if(newValue!='*'){
              List <Proveedores> valor= widget.provs.where((element){
                var id_prov = element.Nombre;
                return id_prov.contains(newValue);
              }).toList();
              String val = valor[0].ID.toString();
              switch(val.length){
                case 1:
                  provider = '00$val';
                  Provider.of<Lead_>(context,listen: false).id_provider(provider);
                  break;
                case 2:
                  provider = '0$val';
                  Provider.of<Lead_>(context,listen: false).id_provider(provider);
                  break;
                case 3:
                  provider = '$val';
                  Provider.of<Lead_>(context,listen: false).id_provider(provider);
                  break;
              }
             print(valor[0].Nombre);
            }else{
              Provider.of<Lead_>(context,listen: false).providedropb('*');
              Provider.of<Lead_>(context,listen: false).id_provider('0');
            }
          });
        }
    );
  }
}

class AccMXAlrt extends StatefulWidget {
  Folio_Container folio;
  ProveedoresACCMX item_prov;
  String user;
  String persona;
  AccMXAlrt({Key? key,required this.item_prov,required this.folio,required this.user,required this.persona}) : super(key: key);

  @override
  State<AccMXAlrt> createState() => _AccMXAlrtState();
}

class _AccMXAlrtState extends State<AccMXAlrt> {
  @override
  Widget build(BuildContext context) {
    TextEditingController refer = TextEditingController();
    TextEditingController dias= TextEditingController();
    TextEditingController lead = TextEditingController();
    refer.text = widget.persona;
    return AlertDialog(
      title: Text('Generar Subfolio'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Referencia'),
            TextField(controller: refer,),
            Text('Dias'),
            TextField(controller: dias,),
            Text('Lead'),
            TextField(controller: lead,),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: ()async{
          var now = DateTime.now().toIso8601String();
          String Folio = widget.folio.folio+'_'+widget.item_prov.ID;
          String referencia = refer.text.toString();
          String days = dias.text.toString().trim();
          String lead_days = lead.text.toString().trim();
          String apartado = 'Acc MX';
          String proveedor = widget.item_prov.ID;
          String Status = 'Proceso';
          String tipo = 'A';
          try{
            print(Folio+'-'+referencia+'-'+days+'-'+lead_days+'-'+apartado+'-'+proveedor+'-'+Status+'-'+now);
            await Create_Folios().ADDFolios(Folio.trim(),referencia.trim(),now,proveedor,tipo,int.parse(days),int.parse(lead_days),apartado, Status);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>AccMX_Screen(user: widget.user, item_folio: widget.folio)), (route) => false);
          }on Exception catch(e){
            print(e);
          }
        }, child: Text('Generar'))
      ],
    );
  }

}

class confirmadas_container {
  String cODIGO;
  String dESCRIPCION;
  String sku;
  int sTOCKCEDIS;
  num cOSTOULTIMO;
  String sUBLINEA2NOMBRE;
  int sUBLINEA2ID;
  String cONTAINER;
  int qUANTITY;
  String pROVEEDORES;
  String iMAGEN;
  String cOLOR;
  String dESCCHINA;
  String iNSTRUCCIONES;
  String eXAMPLE;
  String dESCMX;
  String bRAND;
  String tYPE;
  String mODELO;
  String fRAME;
  String uSUARIO;
  String proveedor;
  confirmadas_container({
    required this. cODIGO,
    required this. dESCRIPCION,
    required this. sTOCKCEDIS,
    required this.sku,
    required this. cOSTOULTIMO,
    required this. sUBLINEA2NOMBRE,
    required this. sUBLINEA2ID,
    required this. cONTAINER,
    required this. qUANTITY,
    required this. pROVEEDORES,
    required this. iMAGEN,
    required this. cOLOR,
    required this. dESCCHINA,
    required this. iNSTRUCCIONES,
    required this. eXAMPLE,
    required this. dESCMX,
    required this. bRAND,
    required this. tYPE,
    required this. mODELO,
    required this. fRAME,
    required this. uSUARIO,
    required this.proveedor
});
  factory confirmadas_container.from(Map<String,dynamic>json){
    return confirmadas_container(
      cODIGO : json['CODIGO'],
      dESCRIPCION : json['DESCRIPCION'],
      sku: json['SKU'],
      sTOCKCEDIS : json['STOCK_CEDIS'],
      cOSTOULTIMO : json['COSTO_ULTIMO'],
      sUBLINEA2NOMBRE : json['SUBLINEA2_NOMBRE'],
      sUBLINEA2ID : json['SUBLINEA2_ID'],
      cONTAINER : json['CONTAINER'],
      qUANTITY : json['QUANTITY'],
      pROVEEDORES : json['PROVEEDORES'],
      iMAGEN : json['IMAGEN'],
      cOLOR : json['COLOR'],
      dESCCHINA : json['DESC_CHINA'],
      iNSTRUCCIONES : json['INSTRUCCIONES'],
      eXAMPLE : json['EXAMPLE'],
      dESCMX : json['DESC_MX'],
      bRAND : json['BRAND'],
      tYPE : json['TYPE'],
      mODELO : json['MODELO'],
      fRAME : json['FRAME'],
      uSUARIO : json['USUARIO'],
      proveedor: json['PROVEEDOR'],
    );
  }
}

class confirm_view{
  Future Slim_container(String proveedor,String sublinea,String contenedor,String title,String tipo) async{
    if(title ==''){
      title='*';
    }
    if(contenedor ==''){
      contenedor='*';
    }
    if(sublinea ==''){
      sublinea='*';
    }
    if(tipo==''){
      tipo='*';
    }
    if(proveedor ==''){
      proveedor='*';
    }
    var url = Uri.parse('http://45.56.74.34:6660/confirmadas?proveedor=$proveedor&sublinea=$sublinea&container=$contenedor&codigo=$title&tipo=$tipo');
    print(url);
    var response = await http.get(url);
    List<confirmadas_container> containerSLIM = <confirmadas_container>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Jsonv = json.decode(sJson);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        containerSLIM.add(confirmadas_container.from(noteJson));
      }
      return containerSLIM;
    }else
      throw Exception('NO se pudo');
  }
}
class Confirm_color {
  String color;
  String cod_slim;
  Confirm_color({required this.color,required this.cod_slim}){
    http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$cod_slim&color=${Uri.encodeComponent(color)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}

class Exmpl{
  String exmple;
  String cod_slim;
  Exmpl({required this.exmple,required this.cod_slim}){
    http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$cod_slim&url_example=$exmple'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class Instruc {
  String instruc;
  String cond_slim;

  Instruc({required this.instruc,required this.cond_slim}){
    http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$cond_slim&instrucciones_uso=$instruc'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class DSChina {
  String dchina;
  String cond_slim;

  DSChina({required this.dchina,required this.cond_slim}){
    http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$cond_slim&descripcion_china=$dchina'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class DCMX{
  String dcmx;
  String cond_slim;

 DCMX({required this.dcmx,required this.cond_slim}){
    http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$cond_slim&descripcion_mx=$dcmx'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class Brand {
  String brand;
  String cond_slim;

  Brand({required this.brand,required this.cond_slim}){
    http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$cond_slim&brand=$brand'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class Frame {
  String frame;
  String cond_slim;

  Frame({required this.frame,required this.cond_slim}){
    http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$cond_slim&frame=$frame'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class Type {
  String type;
  String cond_slim;

  Type({required this.type,required this.cond_slim}){
    http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$cond_slim&type=$type'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class Modelo {
  String modelo;
  String cond_slim;

  Modelo({required this.modelo,required this.cond_slim}){
    http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$cond_slim&modelo=$modelo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}


class imagenCH extends StatefulWidget{
  String cod_slim;
  imagenCH({Key? key, required this.cod_slim}) : super(key: key);

  @override
  State<imagenCH> createState() => _imagenCH();
}

class _imagenCH extends State<imagenCH>{

  Uint8List? bytes;
  String titulo = 'Agregar imagen';
  initState(){
    _imagenxst(widget.cod_slim).then((value) {
      setState((){
        titulo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(titulo){
      case'SI':setState((){
        titulo = 'Imagen cargada';
      }); break;
      case'NO': setState(() {
        titulo = 'Falta imagen';
      });  break;
    }
    return GestureDetector(
      onDoubleTap: () async {
        final bytes = await Pasteboard.image;
        setState(() {
          if(bytes != null){
            this.bytes = bytes;
            Imagesend(bytes,widget.cod_slim);
            //print(bytes);
          }else{
            titulo = 'Sin imagen';
          }
        });
      }, child: Container(child: Text(titulo,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple),),alignment: Alignment.center,),
      onLongPress: () async {
        Uint8List bytes_;
        final bites_=await _imagen_visual(widget.cod_slim);
        bytes_=bites_;
        if(bytes_.isNotEmpty){
          showDialog(context: context,
              builder: (BuildContext context){
                return  AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  content: FittedBox(child: Image.memory(bytes_,height: 100,width: 100,)),
                );
              });
         }
      },
      key: UniqueKey(),
    );
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
  Future<http.Response> Imagesend(base64,name) async{
    return await http.post(
      Uri.parse('http://45.56.74.34:9091/?filename=CH_$name.jpg'),
      headers: <String, String>{
        'Content-Type': 'multipart/form-data; charset=UTF-8',
      },
      body: base64,
    );
  }
  Future<Uint8List> _imagen_visual(name) async {
    var url = Uri.parse('http://45.56.74.34:9091/?filename=CH_$name.jpg');
    print(url);
    var response = await http.get(url);
    Uint8List result;
    if (response.statusCode ==200){
      List<int> list = response.body.codeUnits;
      result = Uint8List.fromList(list);
      return result;
    }else{
      throw Exception('No se pudo');
    }
  }
}

ProveedorbyName(String id,List<ProveedoresACCMX> provider_list){
  String provider_convert='';
    for(int x=0;x<provider_list.length;x++){
      print(provider_list[x].ID.toString()+'-'+id);
      if(provider_list[x].ID.toString()==id){
        provider_convert = provider_list[x].Nombre;
      }
    }
    //if(provider_convert==''){provider_convert=='N/A';}
  //print(provider_convert);
  return provider_convert;
}

ProveedoresbyID(String name,List<ProveedoresACCMX> provider_list){
  String provider_convert='';
  for(int x=0;x<provider_list.length;x++){
    //print(provider_list[x].Nombre.toString()+'-'+name);
    if(provider_list[x].Nombre.toString()==name){
      provider_convert = provider_list[x].ID.toString();
    }
  }
  //print(provider_convert);
  return provider_convert;
}

class Done_folio {
    Future<http.Response> finish(String Folio,
        String status) async {
      var now = DateTime.now().toIso8601String();
      var url = Uri.parse("http://45.56.74.34:6660/finish?fec_termino="+now+"&folio="+Folio+"&status="+status);
      print(url);
      return await http.get(url);
    }
}


class camino_china {
  String? cONTENEDOR;
  String? dATECREATED;
  bool? aCTIVE;

  camino_china({this.cONTENEDOR, this.dATECREATED, required this.aCTIVE});

  camino_china.fromJson(Map<String, dynamic> json) {
    cONTENEDOR = json['CONTENEDOR'];
    dATECREATED = json['DATE_CREATED'];
    aCTIVE = json['ACTIVE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CONTENEDOR'] = this.cONTENEDOR;
    data['DATE_CREATED'] = this.dATECREATED;
    data['ACTIVE'] = this.aCTIVE;
    return data;
  }
}

class get_CH{
  Future<List<camino_china>> foliosCH() async {
  var url = Uri.parse('http://45.56.74.34:6660/getch_mx');
  print(url);
  List<camino_china> lista = <camino_china>[];
  var response = await http.get(url);
  if (response.statusCode ==200){
  String sJson =response.body.toString();
  var Jsonv = json.decode(sJson);
  for(var notejson in Jsonv){
    lista.add(camino_china.fromJson(notejson));
  }
  return lista;
  }else{
  throw Exception('No se pudo');
  }
  }
}


class DialogChina extends StatefulWidget {
  const DialogChina({Key? key}) : super(key: key);

  @override
  State<DialogChina> createState() => _DialogChinaState();
}

class _DialogChinaState extends State<DialogChina> {
  List<camino_china> listach = <camino_china>[];
  @override
  void initState() {
    get_CH().foliosCH().then((value){
      setState(() {
        listach.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 500,
        height: 500,
        child: ListView.builder(
                    itemCount: listach.length,
                    itemBuilder: (context,index){
                      bool valor = listach[index].aCTIVE??false;
                      return ListTile(
                        title: Text(listach[index].cONTENEDOR??'',style: TextStyle(color: Colors.black),),
                        subtitle: Text(listach[index].dATECREATED??''),
                        selected: valor,
                        trailing: Checkbox(value: valor,
                            onChanged: (bool? val){
                              setState(() async {
                                //valor = !valor;
                                var request = http.Request('GET', Uri.parse('http://45.56.74.34:6660/upch_mx/${listach[index].cONTENEDOR}?status=${val}'));
                                http.StreamedResponse response = await request.send();
                                if (response.statusCode == 200) {
                                  print(await response.stream.bytesToString());
                                  Navigator.of(context).pop();
                                }
                                else {
                                print(response.reasonPhrase);
                                Navigator.of(context).pop();
                                }
                              });
                            }),
                      );
                    }
                ),
      ),
      actions: [
        TextButton(onPressed: () async {
          try{
            String? selectedDirectory = await FilePicker.platform.saveFile();
            if(selectedDirectory ==null){

            }else{
              Accion_realizada('Accion en proceso Favor de no alterar el evento');
              String direccion= selectedDirectory.replaceAll(r'\','/');
              String container_name = '';
              List<String> excelitems = <String>[];
              var bytes= File('$direccion').readAsBytesSync();
              var excel = Excel.decodeBytes(bytes);
              for (var table in excel.tables.keys) {
                for (var row in excel.tables[table]!.rows) {
                  var jaime = row.map((e) =>
                  e?.value).toList();
                  if(jaime[1].toString().trim()!='CODIGO'){
                    print('${jaime[1]},${jaime[0]},${table.replaceAll(' ','')}');
                    container_name = table.replaceAll(' ','');
                    excelitems.add('{"CODIGO":"${jaime[1]}","CANTIDAD":${jaime[0]},"CONTENEDOR":"${container_name}"}');
              }
             }
            }
              var  jsonvid = jsonDecode(excelitems.toString());
              http.post(
                Uri.parse('http://45.56.74.34:6660/ch_mx/${container_name}'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(jsonvid),
              );Accion_realizada('Compra en camino agregada');
           }
          }on Exception catch(e){
          print(e);
          }
        }, child: Text('Agregar Folio'))
      ],
    );
  }
}

class AlrtUpdate extends StatefulWidget {
  String folio;
  int dias;
  int lead;
  AlrtUpdate({Key? key,required this.folio,required this.dias,required this.lead}) : super(key: key);

  @override
  State<AlrtUpdate> createState() => _AlrtUpdateState();
}

class _AlrtUpdateState extends State<AlrtUpdate> {
  TextEditingController control_days = TextEditingController();
  TextEditingController control_lead = TextEditingController();
  @override
  Widget build(BuildContext context) {
    control_days.text= widget.dias.toString();
    control_lead.text = widget.lead.toString();
    return AlertDialog(
      title: Text('Modificar Dias y Lead'),
      content:  Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.folio),
                Text('Dias'),
                TextField(controller: control_days,),
                Text('Lead'),
                TextField(controller: control_lead,)
              ],
            ),
      ),
      actions: [TextButton(onPressed: () async {
        var request = http.Request('GET', Uri.parse('http://45.56.74.34:6660/upfolio/${widget.folio}?days=${control_days.text}&lead=${control_lead.text}'));
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          print(await response.stream.bytesToString());
          Accion_realizada('Update realizado correctamente');
        }
        else {
          Accion_realizada('Error al actualizar folio');
        print(response.reasonPhrase);
        }

      }, child: Text('Actualizar'))],
    );
  }
}


class full_envios {
  String? envio;
  String? dATECREATED;
  bool? aCTIVE;

  full_envios({this.envio, this.dATECREATED, required this.aCTIVE});

  full_envios.fromJson(Map<String, dynamic> json) {
    envio = json['ENVIO'];
    dATECREATED = json['DATE_CREATED'];
    aCTIVE = json['ACTIVE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ENVIO'] = this.envio;
    data['DATE_CREATED'] = this.dATECREATED;
    data['ACTIVE'] = this.aCTIVE;
    return data;
  }
}

class get_FULENV{
  Future<List<full_envios>> foliosFUL() async {
    var url = Uri.parse('http://45.56.74.34:6660/getfull_envios');
    print(url);
    List<full_envios> lista = <full_envios>[];
    var response = await http.get(url);
    if (response.statusCode ==200){
      String sJson =response.body.toString();
      var Jsonv = json.decode(sJson);
      for(var notejson in Jsonv){
        lista.add(full_envios.fromJson(notejson));
      }
      return lista;
    }else{
      throw Exception('No se pudo');
    }
  }
}
class Dialog_full extends StatefulWidget {
  const Dialog_full({Key? key}) : super(key: key);

  @override
  State<Dialog_full> createState() => _Dialog_fullState();
}

class _Dialog_fullState extends State<Dialog_full> {
  List<full_envios> listafull = <full_envios>[];
  @override
  void initState() {
    get_FULENV().foliosFUL().then((value){
      setState(() {
        listafull.addAll(value);
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(width: 500,height: 500,
        child:ListView.builder(
          itemCount: listafull.length,
          itemBuilder: (context,index){
            bool valor = listafull[index].aCTIVE??false;
            return ListTile(
              title: Text(listafull[index].envio??'',style: TextStyle(color: Colors.black),),
              subtitle: Text(listafull[index].dATECREATED??''),
              selected: valor,
              trailing: Checkbox(value: valor,
                  onChanged: (bool? val){
                    setState(() async {
                      //valor = !valor;
                      var request = http.Request('GET', Uri.parse('http://45.56.74.34:6660/upfull/${listafull[index].envio}?status=${val}'));
                      http.StreamedResponse response = await request.send();
                      if (response.statusCode == 200) {
                        print(await response.stream.bytesToString());
                        Navigator.of(context).pop();
                      }
                      else {
                        print(response.reasonPhrase);
                        Navigator.of(context).pop();
                      }
                    });
                  }),
            );
          }
      ),),
      actions: [
        TextButton(onPressed: () async {
          try{
            String? selectedDirectory = await FilePicker.platform.saveFile();
            if(selectedDirectory ==null){

            }else{
              Accion_realizada('Accion en proceso Favor de no alterar el evento');
              String direccion= selectedDirectory.replaceAll(r'\','/');
              String container_name = '';
              List<String> excelitems = <String>[];
              var bytes= File('$direccion').readAsBytesSync();
              var excel = Excel.decodeBytes(bytes);
              for (var table in excel.tables.keys) {
                for (var row in excel.tables[table]!.rows) {
                  var jaime = row.map((e) =>
                  e?.value).toList();
                  if(jaime[0].toString().trim()!='Item ID'){
                    print('MLM${jaime[0]},${jaime[2]},${table.replaceAll(' ','')}');
                    container_name = table.replaceAll(' ','');
                    excelitems.add('{"ITEM_ID":"MLM${jaime[0]}","QUANTITY":${jaime[2]},"ENVIO":"${container_name}"}');
                  }
                }
              }
              var  jsonvid = jsonDecode(excelitems.toString());
              http.post(
                Uri.parse('http://45.56.74.34:6660/full_envios/${container_name}'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(jsonvid),
              );Accion_realizada('Compra en camino agregada');
            }
          }on Exception catch(e){
            print(e);
          }
        }, child: Text('Agregar Folio'))
      ],
    );
  }
}

/*class atm_cont {
  String? cODIGO;
  String? dESCRIPCION;
  int? sTOCKCEDIS;
  int? sUBLINEA2ID;
  int? cOSTOULTIMO;
  int? aMZ;
  int? mL;
  int? sHEIN;
  int? fUL;
  String? iMAGE;
  int? vtas30;
  int? cam_CH;

  atm_cont(
      {this.cODIGO,
        this.dESCRIPCION,
        this.sTOCKCEDIS,
        this.sUBLINEA2ID,
        this.cOSTOULTIMO,
        this.aMZ,
        this.mL,
        this.sHEIN,
        this.fUL,
        this.iMAGE,
        this.vtas30,
        this.cam_CH});

  atm_cont.fromJson(Map<String, dynamic> json) {
    cODIGO = json['CODIGO'];
    dESCRIPCION = json['DESCRIPCION'];
    sTOCKCEDIS = json['STOCK_CEDIS'];
    sUBLINEA2ID = json['SUBLINEA2_ID'];
    cOSTOULTIMO = json['COSTO_ULTIMO'];
    aMZ = json['AMZ'];
    mL = json['ML'];
    sHEIN = json['SHEIN'];
    fUL = json['FUL'];
    iMAGE = json['IMAGE'];
    vtas30=json['AMZ']+json['ML']+json['SHEIN'];
    cam_CH = json['CAMINO_CH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO'] = this.cODIGO;
    data['DESCRIPCION'] = this.dESCRIPCION;
    data['STOCK_CEDIS'] = this.sTOCKCEDIS;
    data['SUBLINEA2_ID'] = this.sUBLINEA2ID;
    data['COSTO_ULTIMO'] = this.cOSTOULTIMO;
    data['AMZ'] = this.aMZ;
    data['ML'] = this.mL;
    data['SHEIN'] = this.sHEIN;
    data['FUL'] = this.fUL;
    data['IMAGE'] = this.iMAGE;
    data['vtas30'] = this.vtas30;
    data['CAMINO_CH'] =  this.cam_CH;
    return data;
  }
}

class get_ATM{
  Future<List<atm_cont>> ATM_CONTAINER() async {
    var url = Uri.parse('http://45.56.74.34:6660/container_atm');
    print(url);
    List<atm_cont> lista = <atm_cont>[];
    var response = await http.get(url);
    if (response.statusCode ==200){
      String sJson =response.body.toString();
      var Json = json.decode(sJson);
      var Jsonv = Json["data"] as List;
      toast_dsgn(Json["message"], true);
      for(var notejson in Jsonv){
        lista.add(atm_cont.fromJson(notejson));
      }
      return lista;
    }else{
      String sJson =response.body.toString();
      var Json = json.decode(sJson);
      toast_dsgn(Json["message"], false);
      throw Exception('No se pudo');
    }
  }
}
*/
