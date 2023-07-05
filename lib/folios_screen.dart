import 'package:datatable/container.dart';
import 'package:datatable/sub_folios.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sidebarx/sidebarx.dart';

import 'Modelo_contenedor/slim_container.dart';
import 'option_menu.dart';

class Folios_Vista extends StatefulWidget {
  String user;
  Folios_Vista({Key? key,required this.user}) : super(key: key);

  @override
  State<Folios_Vista> createState() => _Folios_ScreenState();
}

class _Folios_ScreenState extends State<Folios_Vista> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xFF000000))),
      home: List_Folios(user:widget.user),
    );
  }
}

class List_Folios extends StatefulWidget {
   String user;
   List_Folios({Key? key,required this.user}) : super(key: key);

  @override
  State<List_Folios> createState() => _List_FoliosState();
}

class _List_FoliosState extends State<List_Folios> {
  List<Folio_Container> sin_sub= <Folio_Container>[];
  List<Folio_Container> all_folio= <Folio_Container>[];
  List<Folio_Container> all_folios_searcher= <Folio_Container>[];
  List<Widget> ch_folio = <Widget>[];
  List<camino_china> listach = <camino_china>[];
  @override
     initState(){
     Selec_Folios().All_Folios().then((value) {
      setState(() {
        sin_sub.addAll(value);
        for(int x=0;x<sin_sub.length;x++){
          if(sin_sub[x].folio.contains('_')!=true){
            all_folio.add(sin_sub[x]);
          }
        }
        //print(all_folio[0].folio);
        all_folios_searcher=all_folio;
      });
    });
    super.initState();
  }
  TextEditingController controller= TextEditingController();
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Menu(user: widget.user)), (Route<dynamic> route) => false);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Menu(user: widget.user)));
        }, icon: Icon(Icons.arrow_back)),
        title: Row(
          children: <Widget>[
            SizedBox(width: 20,),
            SizedBox(width: 20,),
            Text('Folios'),
            SizedBox(width: 20,),
            Container(
              padding: EdgeInsets.all(5),
              width: 300,
              child: TextField(
                autofocus: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                // controller: controller,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                onChanged: (value){
                  value = value.toUpperCase();
                  setState(() {
                    all_folio= all_folios_searcher.where((element) {
                      var searcher = element.folio.toUpperCase();
                      return searcher.contains(value);
                    }).toList() ;
                  });
                },
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
            showDialog(context: context, builder: (BuildContext context){
              return DialogChina();
            });
          }, child: Text('Control\nCamino CH',style: TextStyle(color: Colors.white),)),
          TextButton(
              onPressed: () async {
                showDialog(context: context, builder: (BuildContext context){
                  return Dialog_full();
                });
              }, child: Text('Control\nFulfillment',style: TextStyle(color: Colors.white),)),
        ],
      ),
      body:  GridView.builder(
          addAutomaticKeepAlives: true,
          itemCount: all_folio.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 4,
              crossAxisSpacing: .9,
              mainAxisSpacing: 5
          ),
          itemBuilder: (context, int index) {
            return AnimationConfiguration.staggeredGrid(
                position: index,
                columnCount: 3,
                duration: const Duration(milliseconds: 250),
                child: SlideAnimation(
                    horizontalOffset: 100,
                    verticalOffset: 100,
                    child: Item_fol(all_folio[index])
                )
            );

          }
        ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
        showDialog(context: context, builder: (BuildContext context){
          return Alert_AddFolio(user: widget.user);
            });
          },
          elevation: 2,
          backgroundColor: Colors.black,
          child: Icon(Icons.add,size: 25,color: Colors.white,),
      )
    );
  }
    Item_fol(Folio_Container item_folio){
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          if(item_folio.apartado=='Acc MX'){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Sub_Folios(user:widget.user,item_folio: item_folio)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Container_MX(user: widget.user, folio: item_folio)));
          }
        },
        onLongPress: (){
          showDialog(context: context, builder: (BuildContext context){
            return AlrtUpdate(folio: item_folio.folio, dias: item_folio.dias, lead: item_folio.lead,);
          });
        },
      child: Neumorphic(
      padding: const EdgeInsets.all(8),
      style: NeumorphicStyle(
      shadowDarkColor: Colors.black,
      shadowLightColor: Colors.deepPurple,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      depth: 2,
      lightSource: LightSource.topLeft,
      intensity: 1,
      surfaceIntensity: 1,
      color:item_folio.fechaTermino=='NODATE'?Colors.orange:Colors.green),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
       ListTile(
         leading: Text(item_folio.folio,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
         subtitle: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(item_folio.referencia,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
             Text('Fecha inicio: '+item_folio.fechaCreacion.substring(0,10),style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
             Text('Proveedor: '+item_folio.proveedor,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
             Text('Confirmados: '+item_folio.productosConfirmados.toString(),style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
             Text('Apartado: '+item_folio.apartado,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold))
            ],
            ),
          ) ,
        ],
       ),
      ),
    )
    );
  }
}
