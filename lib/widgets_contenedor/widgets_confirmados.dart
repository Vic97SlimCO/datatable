import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Modelo_contenedor/Slim_model.dart';
import '../Modelo_contenedor/model.dart';
import '../main.dart';

class Cantidadtxt extends StatefulWidget{
  slim_order item;
  String user;

  Cantidadtxt({Key? key,required this.item, required this.user}) : super(key: key);
  @override
  State<Cantidadtxt> createState() => _Cantidadtxt(item:item,user:user);
}
class _Cantidadtxt extends State<Cantidadtxt>{
  slim_order item;
  String user;
  _Cantidadtxt({required this.item,required this.user});
  TextEditingController Cantidad =TextEditingController();
  @override
  Widget build(BuildContext context) {
    Cantidad.text=widget.item.confimadas.toString();
    return TextField(
      controller: Cantidad,
      onSubmitted: (String? value){
        String text = Cantidad.text;
        print('Cantidad Confirmada'+Cantidad.text+' Slim: '+widget.item.codigo_slim);
        UConfirm(widget.item.codigo_slim, widget.item.Desc, int.parse(Cantidad.text), user,'', '', '');
      },
    );
  }
  Future<http.Response> UConfirm(String codigo,String desc,int quantity,String user,String title,String variation,String id){
    return http.post(
      Uri.parse('http://45.56.74.34:8890/container/set?container=SC22-4&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}

class Eliminar_confirmado extends StatefulWidget{
  slim_order item;
  folios folio;
  String user;
  Eliminar_confirmado({Key? key, required this.item, required this.user,required this.folio}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _Eliminar();
}

class _Eliminar extends State<Eliminar_confirmado>{
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){
      setState((){
        UConfirm(widget.item.codigo_slim, widget.item.Desc,0, widget.user,'','','');
        Confirm_Folio(widget.folio.Folio, widget.item.codigo_slim,'',0,widget.user,'','','');
      });
    }, icon: Icon(Icons.delete_forever_rounded),color: Colors.red,);
  }
  Future<http.Response> UConfirm(String codigo,String desc,int quantity,String user,String title,String variation,String id){
    return http.post(
      Uri.parse('http://45.56.74.34:8890/container/set?container=&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
  Future<http.Response> Confirm_Folio(String folio,String codigo, String desc, int quantity,
      String user, String title, String variation, String id) {
    print('http://45.56.74.34:8890/container/set?container=$folio&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user');
    return http.post(
      Uri.parse(
        //'http://45.56.74.34:8890/container/set?container=SC22-3&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
          'http://45.56.74.34:8890/container/set?container=$folio&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class Colortxt extends StatefulWidget{
  slim_order item;
  String user;
  Colortxt({Key? key,required this.item,required this.user}) :super(key:key);
  @override
  State<StatefulWidget> createState() => _Colortxt();
}
class _Colortxt extends State<Colortxt>{

  TextEditingController color = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String encoding = '';
    String? colores = widget.item.Color;
    if(colores != null){
      encoding = Uri.decodeComponent(colores);
    }
   color.text = encoding;
    return TextField(
      controller: color,
      onSubmitted: (String? value){
        Color(color.text,widget.item.codigo_slim);
      },
      selectionWidthStyle: BoxWidthStyle.tight,
    );
  }

  Future<http.Response> Color(String txt,String slim) {
    String xt_c = Uri.encodeComponent(txt);
    var uri = ('http://45.56.74.34:8890/container/producto/set?codigo=$slim&color=$xt_c');
    print(Uri.encodeFull(uri));
    return http.post(
      Uri.parse(Uri.encodeFull(uri)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },//Si es que pues eramos como mejores amigos y haciamos un buen cosas juntos yo en particular el jugar el halo
      //body: _pedidojson,
    );
  }
}

class imagenlist extends StatefulWidget{
  slim_order item;
  imagenlist({Key? key, required this.item}) : super(key: key);

  @override
  State<imagenlist> createState() => _imagenlist();
}

class _imagenlist extends State<imagenlist>{

  Uint8List? bytes;
  String titulo = 'Agregar imagen';
  initState(){
    _imagenxst(widget.item.codigo_slim).then((value) {
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
          Imagesend(bytes,widget.item.codigo_slim);
          //print(bytes);
        }else{
          titulo = 'Sin imagen';
        }
      });
      }, child: Container(child: Text(titulo,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple),),alignment: Alignment.center,),
      onLongPress: () async {
       Uint8List bytes_;
       final bites_=await _imagen_visual(widget.item.codigo_slim);
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

class Exampletxt extends StatefulWidget{

  slim_order item;
  Exampletxt({Key? key, required this.item}) : super(key: key);

  @override
  State<Exampletxt> createState() => _Exampletxt(item: item);
}

class _Exampletxt extends State<Exampletxt>{
  slim_order item;
  _Exampletxt({required this.item});

  TextEditingController exampletxt =TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? Exampl ='';
    String? widgetExampl = widget.item.Example;
    if(widgetExampl != null){
      Exampl = widgetExampl;
    }
    exampletxt.text = Exampl;
    return TextField(controller: exampletxt,
      onSubmitted: (String? value){
        String text= exampletxt.text;
        print('Example: '+exampletxt.text+' Desc:'+widget.item.codigo_slim);
        Example(text, widget.item.codigo_slim);
      },
    );
  }
  Future<http.Response> Example(String txt,String slim) {//Metodo para enviar el token y los MLM de los productos de la lista
    return http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$slim&url_example=$txt'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}
class Instxt extends StatefulWidget{
  slim_order item;

  Instxt({Key? key,required this.item}) : super(key: key);
  @override
  State<Instxt> createState() => _Instxt(item: item);
}

class _Instxt extends State<Instxt>{
  slim_order item;
  _Instxt({required this.item});
  TextEditingController instxt =TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? instruc = '';
    String? widget_instrucc=widget.item.Inst;
    if(widget_instrucc !=null){
      instruc = widget_instrucc;
    }
    instxt.text = instruc;
    return TextField(controller: instxt,
      onSubmitted: (String? value){
        String text= instxt.text;
        print('ID:'+widget.item.codigo_slim+'Topic:Instrucciones'+' Texto:'+instxt.text.toString());
        Inst(text, widget.item.codigo_slim);
      },
    );
  }
  Future<http.Response> Inst(String txt,String slim) {//Metodo para enviar el token y los MLM de los productos de la lista
    return http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$slim&instrucciones_uso=$txt'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class DChina extends StatefulWidget{
  slim_order item;
  DChina({Key? key,required this.item}) : super(key: key);

  @override
  State<DChina> createState() => _DChina(item:item);
}

class _DChina extends State<DChina>{
  slim_order item;
  _DChina({required this.item});

  TextEditingController imptxt =TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? DChina = '';
   String? widgetChina = widget.item.DChina;
    if(widgetChina != null){
      DChina = widget.item.DChina;
    }
    imptxt.text = DChina!;
    return TextField(controller: imptxt,
      onSubmitted: (String? value){

        String text= imptxt.text;
        print('Pedido:'+widget.item.confimadas.toString()+'Topic:Importador'+' Texto:'+imptxt.text.toString());
        ChinaD(text,widget.item.codigo_slim);
      },
      style: TextStyle(fontSize:15.0),
    );
  }
  Future<http.Response> ChinaD(String dsc,String slim) {//Metodo para enviar el token y los MLM de los productos de la lista
    return http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$slim&descripcion_china=$dsc'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}

class DMX extends StatefulWidget {
  slim_order item;
  DMX({Key? key,required this.item}) : super(key: key);

  @override
  State<DMX> createState() => _DMXState();
}

class _DMXState extends State<DMX> {
  TextEditingController imptxt =TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? DMX = '';
    String? widgetChina = widget.item.desc_mx;
    if(widgetChina != null){
      DMX = widget.item.desc_mx;
    }
    imptxt.text = DMX!;
    return TextField(controller: imptxt,
      onSubmitted: (String? value){

        String text= imptxt.text;
        print('Pedido:'+widget.item.confimadas.toString()+'Topic:DSC_MX'+' Texto:'+imptxt.text.toString());
        D_MX(text,widget.item.codigo_slim);
      },
      style: TextStyle(fontSize:15.0),
    );
  }
  Future<http.Response> D_MX(String dsc,String slim) {//Metodo para enviar el token y los MLM de los productos de la lista
    return http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$slim&descripcion_mx=$dsc'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
}


class BRAND extends StatefulWidget{
  slim_order item;

  BRAND({required this.item});

  @override
  State<StatefulWidget> createState() => _BRAND();
}

class _BRAND extends State<BRAND>{

  TextEditingController brndtxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? Brand = '';
    String? widgetbrand = widget.item.Brand;
    if(widgetbrand != null){
      Brand = widget.item.Brand;
    }
    brndtxt.text= Brand!;
    return TextField(
      controller: brndtxt,
      onSubmitted: (String? value){
        String text=brndtxt.text;
        print('Pedido:'+widget.item.confimadas.toString()+'Topic:BRAND'+' Texto:'+brndtxt.text);
        BRAND_actualizar(text, widget.item.codigo_slim);
      },
      style: TextStyle(fontSize: 15.0),
    );
  }

  Future<http.Response> BRAND_actualizar(String brand,String slim){
    return http.post(
      Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$slim&brand=$brand'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );
  }
}

class FRAME extends StatefulWidget{
  slim_order item;

  FRAME({required this.item});

  @override
  State<StatefulWidget> createState() => _FRAME();
}

class _FRAME extends State<FRAME>{
  TextEditingController frametxt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? Frame = '';
    String? widgetframe = widget.item.Frame;
    if(widgetframe != null){
      Frame = widget.item.Frame;
    }
    frametxt.text= Frame!;
    return TextField(
      controller: frametxt,
      onSubmitted: (String? value){
        String text=frametxt.text;
        print('Pedido:'+widget.item.confimadas.toString()+'Topic:FRAME'+' Texto:'+frametxt.text);
        FRAME_actualizar(text, widget.item.codigo_slim);
      },
      style: TextStyle(fontSize: 15.0),
    );
  }
  Future<http.Response> FRAME_actualizar(String frame,String slim){
    return http.post(
        Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$slim&frame=$frame'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
  }

}

class TYPE extends StatefulWidget{
  slim_order item;

  TYPE({required this.item});

  @override
  State<StatefulWidget> createState() => _TYPE();
}

class _TYPE extends State<TYPE>{
  TextEditingController typetxt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? Type = '';
    String? widgettype = widget.item.Type;
    if(widgettype != null){
      Type = widget.item.Type;
    }
    typetxt.text= Type!;
    return TextField(
      controller: typetxt,
      onSubmitted: (String? value){
        String text=typetxt.text;
        print('Pedido:'+widget.item.confimadas.toString()+'Topic:TYPE'+' Texto:'+typetxt.text);
        TYPE_actualizar(text, widget.item.codigo_slim);
      },
      style: TextStyle(fontSize: 15.0),
    );
  }
  Future<http.Response> TYPE_actualizar(String type,String slim){
    return http.post(
        Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$slim&type=$type'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
  }
}

class MODELO extends StatefulWidget{
  slim_order item;

  MODELO({required this.item});

  @override
  State<StatefulWidget> createState() => _MODELO();
}

class _MODELO extends State<MODELO>{
  TextEditingController modelotxt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? Modelo = '';
    String? widgetmodelo = widget.item.Modelo;
    if(widgetmodelo != null){
      Modelo = widget.item.Modelo;
    }
    modelotxt.text= Modelo!;
    return TextField(
      controller: modelotxt,
      onSubmitted: (String? value){
        String text=modelotxt.text;
        print('Pedido:'+widget.item.codigo_slim+'Topic:MODELO'+' Texto:'+modelotxt.text);
        MODELO_actualizar(text, widget.item.codigo_slim);
      },
      style: TextStyle(fontSize: 15.0),
    );
  }
  Future<http.Response> MODELO_actualizar(String modelo,String slim){
    return http.post(
        Uri.parse('http://45.56.74.34:8890/container/producto/set?codigo=$slim&modelo=$modelo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
  }
}
class Confirmados_txt2 extends StatefulWidget {
  slim_order value;
  String user;
  folios folio;
  Confirmados_txt2( {Key? key,required this.value,required this.user, required this.folio}) : super(key: key);
  @override
  State<Confirmados_txt2> createState() => _Confirmados_txtState();
}

class _Confirmados_txtState extends State<Confirmados_txt2> {

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
  controller.text=widget.value.confimadas.toString();
    return TextField(
      controller: controller,
      onSubmitted: (String value){
        int pedido = int.parse(controller.text);
        try{
          Confirm_Folio(widget.folio.Folio, widget.value.codigo_slim,'', pedido, widget.user, '', '', '');
          UConfirm(widget.value.codigo_slim,'', 0, widget.user, '', '', '');
        } catch(error){
          print(error);
        }
      },
    );
  }
  Future<http.Response> Confirm_Folio(String folio,String codigo, String desc, int quantity,
      String user, String title, String variation, String id) {
    print('http://45.56.74.34:8890/container/set?container=$folio&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user');
    return http.post(
      Uri.parse(
        //'http://45.56.74.34:8890/container/set?container=SC22-3&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
          'http://45.56.74.34:8890/container/set?container=$folio&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
    );
  }
  Future<http.Response> UConfirm(String codigo, String desc, int quantity, String user, String title, String variation, String id) {
    return http.post(
      Uri.parse(
          'http://45.56.74.34:8890/container/set?container=&codigo=$codigo&descripcion=$desc&id=$id&title=$title&variation_id=$variation&quantity=$quantity&user_id=$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: _pedidojson,
  );
 }
}

class Imagen_existe extends StatefulWidget {
  String codSlim;
  List<imagen_exist> imagen =<imagen_exist>[];
  Imagen_existe({Key? key,required this.imagen,required this.codSlim}) : super(key: key);

  @override
  State<Imagen_existe> createState() => _Imagen_existeState();
}

class _Imagen_existeState extends State<Imagen_existe> {
  String hay_imagen='Agregar imagen';
  @override
  void initState() {
    setState(() {
      widget.imagen.where((element){
        var slim = element.Cod_Slim;
        return slim.contains(widget.codSlim);
      }).toList();
      if(widget.imagen.isNotEmpty){
        //print(widget.imagen[0].Cod_Slim+'-'+widget.imagen[0].image_exist);
        switch(widget.imagen[0].image_exist){
          case'SI':hay_imagen = 'Imagen Agregada'; break;
          case'NO':hay_imagen = 'No hay imagen'; break;
        }
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center,padding: EdgeInsets.all(5.0),
    child: Text(hay_imagen),);
  }
}

