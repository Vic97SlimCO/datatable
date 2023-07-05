import 'package:datatable/Modelo_contenedor/Slim_model.dart';
import 'package:datatable/container.dart';
import 'package:datatable/folios_screen.dart';
import 'package:datatable/xls/container_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'Modelo_contenedor/slim_container.dart';


class Sub_Folios extends StatefulWidget {
  String user;
  Folio_Container item_folio;
  Sub_Folios({Key? key,required this.user,required this.item_folio}) : super(key: key);

  @override
  State<Sub_Folios> createState() => _Sub_FoliosState();
}

class _Sub_FoliosState extends State<Sub_Folios> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xFF000000))),
      home: AccMX_Screen(user: widget.user,item_folio: widget.item_folio,),
    );
  }
}

class AccMX_Screen extends StatefulWidget {
  Folio_Container item_folio;
  String user;
  AccMX_Screen({Key? key,required this.user,required this.item_folio}) : super(key: key);

  @override
  State<AccMX_Screen> createState() => _AccMX_ScreenState(item_folio:item_folio);
}

class _AccMX_ScreenState extends State<AccMX_Screen> {
  List<ProveedoresACCMX> ACCMX_GET = <ProveedoresACCMX>[];
  List<ProveedoresACCMX> ACCMX_provider = <ProveedoresACCMX>[];
  Folio_Container item_folio;
  _AccMX_ScreenState({required this.item_folio});
  List<Folio_Container> subfolios = <Folio_Container>[];

  @override
  void initState() {
    Selec_SUB().All_Folios(item_folio.folio).then((value){
      setState(() {
        subfolios.addAll(value);
      });
    }).then((value) async {
     await ProveedoresACCMXCon().ProveACC().then((valor){
        setState(() {
          ACCMX_provider.addAll(valor);
          for(int x=0;x<subfolios.length;x++){
            for(int y=0;y<ACCMX_provider.length;y++){
              if(subfolios[x].proveedor.contains(ACCMX_provider[y].ID)){
                  ACCMX_GET.add(ACCMX_provider[y]);
                  ACCMX_provider.remove(ACCMX_provider[y]);
              }
            }
          }
        });
      });
    });
    super.initState();
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Folios_Vista(user: widget.user)), (route) => false);
        }, icon: Icon(Icons.arrow_back)),
        actions: <Widget>[
          IconButton(onPressed: (){
            setState(() {
              ACCMX_provider.clear();
              ACCMX_GET.clear();
              subfolios.clear();
            });
            Selec_SUB().All_Folios(item_folio.folio).then((value){
              setState(() {
                subfolios.addAll(value);
              });
            }).then((value) async {
              await ProveedoresACCMXCon().ProveACC().then((valor){
                setState(() {
                  ACCMX_provider.addAll(valor);
                  for(int x=0;x<subfolios.length;x++){
                    for(int y=0;y<ACCMX_provider.length;y++){
                      if(subfolios[x].proveedor.contains(ACCMX_provider[y].ID)){
                        ACCMX_provider.remove(ACCMX_provider[y]);
                      }
                    }
                  }
                });
              });
            });
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
              Expanded(
                flex:ACCMX_provider.length>12?2:3,
                child: ListView.builder(
                  itemCount: subfolios.length,
                  itemBuilder: (BuildContext context,index){
                   return AnimationConfiguration.staggeredList(
                     position: index,
                     duration:const Duration(milliseconds: 225),
                     child: SlideAnimation(
                       verticalOffset: 50.0,
                       child: FadeInAnimation(
                         child: GestureDetector(
                             onTap: (){
                               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Container_MX(user: widget.user, folio: subfolios[index])), (route) => false);
                             },
                              onDoubleTap: ()async{
                                List<confirmadas_container> lista = <confirmadas_container>[];
                                Accion_realizada('Peticion en curso');
                              await confirm_view().Slim_container(subfolios[index].proveedor,'*',subfolios[index].folio,'','*').then((value){
                                setState(() {
                                   lista.addAll(value);
                                   container_layout().generateACCMX(lista,subfolios[index].folio, context);
                                   Accion_realizada('Excel generado');
                                });
                              });
                            },
                             child: Card(
                               color: subfolios[index].status=='Listo'?Colors.green:Colors.orange,
                               shape: RoundedRectangleBorder(
                                   side: BorderSide(color: Colors.black),
                                   borderRadius: BorderRadius.all(Radius.circular(12))
                               ),
                               child: Row(
                                 mainAxisSize: MainAxisSize.max,
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   //Container(padding: EdgeInsets.all(12.0),child: Text(subfolios[index].folio,style: TextStyle(fontSize: 25),),),
                                   Container(padding: EdgeInsets.all(12.0),child: Text(ProveedorbyName(subfolios[index].proveedor,ACCMX_GET),style: TextStyle(fontSize: 25),),),
                                   Container(padding: EdgeInsets.all(12.0),child: Text(subfolios[index].referencia,style:TextStyle(fontSize: 25)),),
                                   Container(padding: EdgeInsets.all(12.0),child: Text('Status: '+subfolios[index].status,style: TextStyle(fontSize: 25),),),
                                   Container(padding: EdgeInsets.all(12.0),child: Text('Productos Confirmados: '+subfolios[index].productosConfirmados.toString(),style: TextStyle(fontSize: 25),),),
                                 ],
                               ),
                             ),
                           ),
                       ),
                     ),
                   );
                  }
            ),
              ),
          Visibility(
            visible: ACCMX_provider.length==0?false:true,
            child: Expanded(
                child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                ),
                itemCount: ACCMX_provider.length,
                itemBuilder: (BuildContext context,index){
                  return AnimationConfiguration.staggeredGrid(
                      position: index,
                      columnCount: 4,
                      duration: const Duration(milliseconds: 225),
                      child: SlideAnimation(
                        horizontalOffset: 100.0,
                        child: GestureDetector(
                          child: Card(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(12))),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(padding: EdgeInsets.all(12.0),child: Text(ACCMX_provider[index].Nombre,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),),
                              ],
                            ),
                          ),
                          onLongPress: (){
                            String persona = '';
                            print(ACCMX_provider[index].ID.toString());
                            if(ACCMX_provider[index].ID=='017'||ACCMX_provider[index].ID=='012'||ACCMX_provider[index].ID=='044'||ACCMX_provider[index].ID=='046'
                                ||ACCMX_provider[index].ID=='014'||ACCMX_provider[index].ID=='053'||ACCMX_provider[index].ID=='008'){
                              persona = 'Giovanni';
                            }else if(ACCMX_provider[index].ID=='055'||ACCMX_provider[index].ID=='054'||ACCMX_provider[index].ID=='028'||ACCMX_provider[index].ID=='019'
                                ||ACCMX_provider[index].ID=='002'||ACCMX_provider[index].ID=='001'||ACCMX_provider[index].ID=='004'||ACCMX_provider[index].ID=='006'){
                              persona = 'Jair';
                            }else if(ACCMX_provider[index].ID=='005'||ACCMX_provider[index].ID=='016'||ACCMX_provider[index].ID=='043'||ACCMX_provider[index].ID=='003'
                                ||ACCMX_provider[index].ID=='009'||ACCMX_provider[index].ID=='010'||ACCMX_provider[index].ID=='035'){
                              persona = 'Jorge';
                            }
                            showDialog(context: context, builder:(BuildContext context){
                              return AccMXAlrt(item_prov: ACCMX_provider[index], folio: widget.item_folio,user: widget.user,persona: persona);
                            });
                          },
                        ),
                      )
                  );
                    }
                )
            ),
          )
        ],
      ),
    );
  }
}
