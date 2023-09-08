import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:datatable/container.dart';
import 'package:datatable/sub_folios.dart';
import 'package:datatable/xls/container_layout.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'Modelo_contenedor/Slim_model.dart';
import 'Modelo_contenedor/slim_container.dart';
import 'option_menu.dart';

/*class Folios_Vista extends StatefulWidget {
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
}*/

class List_Folios extends StatefulWidget {
   String user;
   List_Folios({Key? key,required this.user}) : super(key: key);

  @override
  State<List_Folios> createState() => _List_FoliosState();
}

class _List_FoliosState extends State<List_Folios> with TickerProviderStateMixin {
  List<Folio_Container> sin_sub= <Folio_Container>[];
  List<Folio_Container> all_folio= <Folio_Container>[];
  List<Folio_Container> all_folios_searcher= <Folio_Container>[];
  List<Widget> ch_folio = <Widget>[];
  List<camino_china> listach = <camino_china>[];
  List<ProveedoresACCMX> provs = <ProveedoresACCMX>[];
  List<String>item =['*'];
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
        tabController = TabController(
          initialIndex: current.value,
          length: drawerItems.length,
          vsync: this,
        );
        tabController.addListener(tabChanged);
        customController.listen((value) {
          final index = drawerItems.indexOf(value);
          if (index != -1) {
            tabController.index = index;
            print(value);
            setState(() {
              valor_group = value.toString();
            });
          }
        });
      });
    });
     ProveedoresACCMXCon().ProveACC().then((valor){
       setState((){
         provs.addAll(valor);
         for(int x=0;x<provs.length;x++){
           item.add(provs[x].Nombre);
           print(item);
         }
       });
     });
    super.initState();
  }
  //TextEditingController controller= TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController controller_folio = TextEditingController();
  TextEditingController controller_referencia = TextEditingController();
  TextEditingController controller_dias = TextEditingController();
  TextEditingController controller_lead = TextEditingController();
  TextEditingController controller_control = TextEditingController();
  String? selectedValue = '*';
  //TextEditingController
  ValueNotifier<int> current = ValueNotifier(0);
  late TabController tabController;
  final customController = CustomGroupController(
    isMultipleSelection: false,
    initSelectedItem: "ACONT",
  );
  void tabChanged() {
    current.value = tabController.index;
  }
  String valor_group = 'ACONT';
  final List<String> drawerItems = [
    "ACONT",
    "RCONT",
    "REFMX",
    "ACCMX"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Menu(user: widget.user)), (Route<dynamic> route) => false);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Menu(user: widget.user)));
        }, icon: Icon(Icons.arrow_back)),
        title: Row(
          children: <Widget>[
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
          SizedBox(width: 20,),
          TextButton(
              onPressed: () async {
                showDialog(context: context, builder: (BuildContext context){
                  return Dialog_full();
                });
              }, child: Text('Control\nFulfillment',style: TextStyle(color: Colors.white),)),
          SizedBox(width: 20,),
          TextButton(
              onPressed: () async {
                showDialog(context: context, builder: (BuildContext context){
                  return Dialog_HCS();
                });
              }, child: Text('Control\nHCS',style: TextStyle(color: Colors.white),)),
          SizedBox(width: 20,),
          IconButton(onPressed: (){
            _scaffoldKey.currentState?.openEndDrawer();
          }, icon: Icon(Icons.menu))
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
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 25,),
            Container(decoration: BoxDecoration(color: Colors.black),
                child: Text('Crear folio',style: TextStyle(color: Colors.white,fontSize: 20),)),
            Row(
              children: [
                Expanded(flex:1,child: Text('Folio:',style: TextStyle(fontSize: 18),)),
                Expanded(flex: 3,child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(controller: controller_folio,),
                ))
              ],
            ),
            Container(decoration: BoxDecoration(color: Colors.black),
                child: Text('Referencia',style: TextStyle(color: Colors.white,fontSize: 20),)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(controller: controller_referencia,decoration: InputDecoration(hintText: 'Referencia'),),
            ),
            Container(decoration: BoxDecoration(color: Colors.black),
                child: Text('Tipo de Contenedor',style: TextStyle(color: Colors.white,fontSize: 20),)),
            ValueListenableBuilder(
                valueListenable: current,
                builder: (ctx,value,_){
                  return CustomGroupedCheckbox(
                      controller: customController,
                      itemBuilder: (ctx,index,isSelected,isDisabled){
                        return ListTile(
                          tileColor: value==index?Colors.blue:null,
                          title: Text(
                            drawerItems[index],
                            //style: T,
                          ),
                          leading:value==index?Icon(Icons.check_box):Icon(Icons.check_box_outline_blank_rounded),
                        );
                      },
                      itemExtent: 40,
                      values: drawerItems);
                }),
            Container(decoration: BoxDecoration(color: Colors.black),
                child: Text('Dias y Lead Time',style: TextStyle(color: Colors.white,fontSize: 20),)),
           Row(
              children: [
                Expanded(flex:1,child: Text('Dias:',style: TextStyle(fontSize: 18),)),
                Expanded(flex: 2,child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(controller: controller_dias,),
                )),
                Expanded(flex:1,child: Text('Lead Time:',style: TextStyle(fontSize: 18),)),
                Expanded(flex: 2,child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(controller: controller_lead,),
                )),
              ],
            ),
            Visibility(
              visible: valor_group=='REFMX'||valor_group=='ACCMX'?true:false,
              child: Container(decoration: BoxDecoration(color: Colors.black),
                  child: Text('Control de stock',style: TextStyle(color: Colors.white,fontSize: 20),)),
            ),
             Visibility(
                visible: valor_group=='REFMX'||valor_group=='ACCMX'?true:false,
              child: Row(
                children: [
                  Expanded(flex:1,child: Text('Control:',style: TextStyle(fontSize: 18),)),
                  Expanded(flex: 2,child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(controller: controller_control,),
                  )),
                ],
              ),
            ),
            Container(decoration: BoxDecoration(color: Colors.black),
                child: Text('Proveedores',style: TextStyle(color: Colors.white,fontSize: 20),)),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Agregar usuario',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: item
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 160,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.black,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.green,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 200,
                    padding: null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.black,
                    ),
                    elevation: 8,
                    offset: const Offset(-20, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(6),
                      thumbVisibility: MaterialStateProperty.all(true),
                    )),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () async {
              print(controller_folio.text+'-'
                  +controller_referencia.text+'-'
                  +controller_dias.text+'-'
                  +controller_lead.text+'-'
                  +ProveedoresbyID(selectedValue!, provs)+'-'+valor_group);
              await Create_Folios().ADDFolios(controller_folio.text, controller_referencia.text, DateTime.now().toIso8601String(),selectedValue=='*'?'*':ProveedoresbyID(selectedValue!, provs), tipo_CONT(valor_group),int.parse(controller_dias.text),int.parse(controller_lead.text),valor_group, 'Proceso');
              Accion_realizada('Folio creado');
              var request = http.Request('GET', Uri.parse('http://45.56.74.34:6660/container_atm?tipo=${tipo_CONT(valor_group)}&proveedor=${selectedValue=='*'?'0':ProveedoresbyID(selectedValue!, provs)}&container=${controller_folio.text}&codigo=${valor_group}&control=${controller_control.text}&dias=${int.parse(controller_dias.text)}&lead=${int.parse(controller_lead.text)}&user=${widget.user}'));
              http.StreamedResponse response = await request.send();
              if (response.statusCode == 200) {
                print(await response.stream.bytesToString());
              }
              else {
                print(response.reasonPhrase);
              }
            }, child: Text('Crear folio'))
          ],
        ),
      ),
    );
  }
  tipo_CONT(String selectedValue){
    String tipo = 'A';
    switch(selectedValue){
      case'ACONT':
        tipo='A';
        break;
      case'RCONT':
        tipo='R';
        break;
      case'REFMX':
        tipo='R';
        break;
      case'ACCMX':
        tipo='A';
        break;
    }
    return tipo;
  }
    Item_fol(Folio_Container item_folio){
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          if(item_folio.apartado=='Acc MX'){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AccMX_Screen(user:widget.user,item_folio: item_folio)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>GRID_Container(user: widget.user, folio: item_folio)));
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
             Text('Proveedor: '+ProveedorbyName(item_folio.proveedor, provs),style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
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
