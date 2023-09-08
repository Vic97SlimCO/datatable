import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:datatable/traspaso.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'Improve_resources/impro_res.dart';
import 'option_menu.dart';

class improve_points extends StatefulWidget {
  String user;
   improve_points({Key? key,required this.user}) : super(key: key);

  @override
  State<improve_points> createState() => _improve_pointsState();
}

class _improve_pointsState extends State<improve_points> {
  PersistentTabController _controller = PersistentTabController();
  allowedto(){
    bool allowed = false;
    if(widget.user=='100'||
        widget.user=='101'||
        widget.user=='103'||
        widget.user=='121'||
        widget.user=='118'||
        widget.user=='102'||
        widget.user=='33'||
        widget.user=='29'){
      allowed = true;
    }
    return allowed;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        infractions(user:widget.user),
        allowedto()==true?MLMvtasScreen(user: widget.user):Center(child: CircularProgressIndicator(),),
        improve_items(user:widget.user),
        allowedto()==true?ASINvtas(user: widget.user,):Center(child: CircularProgressIndicator(),),
        allowedto()==true?SKCvtas(user: widget.user,):Center(child: CircularProgressIndicator(),),
        allowedto()==true?Co_fondeadas(user: widget.user,):Center(child: CircularProgressIndicator(),)
      ];
    }
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.map_pin_ellipse),
          title: ("Infractions"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
       allowedto()==true?PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.arrow_branch),
          title: ("Ventas x MLM"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ):PersistentBottomNavBarItem(
         icon: Icon(CupertinoIcons.arrow_branch),
         title: ("Sin permiso para ver"),
         activeColorPrimary: CupertinoColors.black,
         inactiveColorPrimary: CupertinoColors.systemGrey,
       ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.arrow_3_trianglepath),
          title: ("Mejora items"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
       allowedto()==true?PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.arrow_merge),
          title: ("Ventas x ASIN"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ):PersistentBottomNavBarItem(
         icon: Icon(CupertinoIcons.arrow_merge),
         title: ("Sin permiso para ver"),
         activeColorPrimary: CupertinoColors.black,
         inactiveColorPrimary: CupertinoColors.systemGrey,
       ),
        allowedto()==true?PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.rectangle_compress_vertical),
          title: ("Ventas x SKC"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ):PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.sort_down),
          title: ("Sin permiso para ver"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        allowedto()==true?PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.rectangle_3_offgrid_fill),
          title: ("Co-fondeadas"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ):PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.sort_down),
          title: ("Sin permiso para ver"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }
   _controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(context,
        controller: _controller,
        items: _navBarsItems(),
        screens: _buildScreens(),
        confineInSafeArea: true,
        decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }

}

class infractions extends StatefulWidget {
  String user;
  infractions({Key? key,required this.user}) : super(key: key);

  @override
  State<infractions> createState() => _infractionsState();
}

class _infractionsState extends State<infractions> {
  List<infraction_map> infrac = <infraction_map>[];
  List<String> items = ['Diseño','Reclamos','Propiedad','Categoria','Desenfoque'];
  String? selectedValue='Diseño';
  List<DateTime?> _calendar_value = [DateTime.now()];
  List<variation_item> variantes =<variation_item>[];
  List<main_item> public_list =<main_item>[];
  List<String> imagenes = <String>[];

@override
  void initState() {
    get_infra().indice_req('diseño',DateTime.now().subtract(Duration(days: 3)).toString().substring(0,10)).then((value){
      setState(() {
        infrac.addAll(value);
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: Menu(user: widget.user),
          withNavBar: false);
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Menu(user: widget.user),), (route) => false,);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Row(
          children: [
            Text('Infracciones'),
            SizedBox(width: 20,),
            Text('Topic:'),
            SizedBox(width: 20,),
            DropdownButtonHideUnderline(
              child: DropdownButton2(isExpanded: true, hint: Text('Select Item', style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
              items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),)).toList(),
              value: selectedValue,
              onChanged: (value) {
                infrac.clear();
                setState(() {
                  infrac.clear();
                  selectedValue = value as String;
                  get_infra().indice_req(selectedValue!.toLowerCase(),_calendar_value[0].toString().substring(0,10)).then((value){
                    setState(() {
                      infrac.addAll(value);
                      if(infrac.length>0){
                        toast_impro('CONSULTA EXITOSA', true,Duration(seconds: 2));
                      }else{
                        toast_impro('SIN RESULTADOS', false,Duration(seconds: 2));
                      }
                    });
                  });
                });
              },
              buttonStyleData: const ButtonStyleData(
                height: 40,
                width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(color: Colors.black)
              ),
            ),
            ),
            SizedBox(width: 20,),
            TextButton(onPressed: () async {
              await showDialog(context: context,builder: (BuildContext context){
                return Card(
                    elevation: 10,
                    margin: EdgeInsets.fromLTRB(50,
                    200,50,
                    200),
                child: Container(
                color: Colors.white,
                child: _calendar(),
                ),);
                });
            }, child: Text('Fecha-Creacion',style: TextStyle(color:Colors.white),))
          ],
        ),),
      body: Row(
        children:[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:infrac.length>0?GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                  ),
                  itemCount: infrac.length,
                  itemBuilder: (BuildContext context,index){
                    return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 3,
                        child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                                child: GestureDetector(
                                  onLongPress: () async {
                                  await get_infra().checked_infractions(infrac[index].id!, infrac[index].itemId!, infrac[index].dt!,infrac[index].topic!,widget.user,DateTime.now().toIso8601String() );
                                  },
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(text: infrac[index].itemId!));
                                  },
                                  onDoubleTap: () async {
                                    public_list.clear();
                                   variantes.clear();
                                   imagenes.clear();
                                  await get_impro_data().infra_main(infrac[index].itemId!).then((value){
                                     setState(() {
                                       public_list.addAll(value);
                                     String imagenes1 =public_list[0].iMAGES!.substring(1,public_list[0].iMAGES!.length-1);
                                      print(imagenes1);
                                       imagenes = imagenes1.split(",");
                                     });
                                   });
                                  await get_impro_data().infra_var(infrac[index].itemId!).then((value){
                                     setState(() {
                                       variantes.addAll(value);
                                     });
                                   });
                                  },
                                  child: Neumorphic(
                                    padding: const EdgeInsets.all(8),
                                    style: NeumorphicStyle(
                                        shape: NeumorphicShape.concave,
                                        shadowDarkColor: Colors.black,
                                        shadowLightColor: Colors.white24,
                                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                        depth: 5,
                                        lightSource: LightSource.topLeft,
                                        intensity: .85,
                                        surfaceIntensity: .85,
                                        color:infrac[index].checked=='NO'?Colors.orange:Colors.green),
                                    child: ListTile(
                                      title: Text(infrac[index].itemId!),
                                      subtitle: Text(infrac[index].reason!),
                                    ),
                                  ),
                                )))
                    );
                  }):Center(child: Container(width:150,height:150,child: CircularProgressIndicator())),
            ),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(
                  padding: EdgeInsets.all(8),
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 10,
                    intensity: 0.75,
                    surfaceIntensity: 0.7,
                    lightSource: LightSource.topLeft,
                    color: Colors.white30
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:[
                        GestureDetector(
                            onDoubleTap: (){
                          launchuURL(public_list[0].iD!);
                            },
                            child: Text(public_list.length==0?'MLM':public_list[0].iD!,style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                        Text(public_list.length==0?'Tittle':public_list[0].tITLE!,style: TextStyle(fontSize: 20),),
                        //Image.network(public_list.length==0?'':public_list[0].iMAGES!,width: 200,height: 200,),+
                        CarouselSlider(
                          items: imagenes.map((e) => ClipRRect(
                            borderRadius: BorderRadius.circular(19),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Image.network(e,
                                width: 160,height: 250,fit: BoxFit.contain,)
                              ],
                            ),
                          )).toList(),
                          options: CarouselOptions(
                            height: 250,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            enableInfiniteScroll: true
                          ),),
                        Text(public_list.length==0?'Price':'PRECIO: '+public_list[0].pRICE.toString(),style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'Status':'STATUS: '+public_list[0].sTATUS!,style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'DT':'FECHA CREACION: '+public_list[0].dATECREATED!.substring(0,10),style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'LUPDATE':'ULTIMA ACTUALIZACION: '+public_list[0].lASTUPDATED!.substring(0,10),style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'HEALTH':'HEALTH: '+(public_list[0].hEALTH!*100).toStringAsFixed(0),style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'LOGISTIC':'LOGISTTC TYPE: '+public_list[0].lOGISTICTYPE!,style: TextStyle(fontSize: 19),),
                   Neumorphic(
                      padding: EdgeInsets.all(8),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                          depth: 10,
                          intensity: 0.75,
                          surfaceIntensity: 0.7,
                          lightSource: LightSource.topLeft,
                          color: Colors.white38
                      ),
                     child: Container(
                          height: 20,
                         width: 600,
                         alignment: Alignment.center,
                         child: Text('VARIANTES')),
                   ),
                        Container(
                          width: 500,
                          height: 250,
                          child: ListView.builder(
                              itemCount: variantes.length,
                              itemBuilder: (BuildContext context,index){
                                return ListTile(
                                  leading: Image.network(variantes[index].tHUMBNAIL!),
                                  title: Text('SKU: '+variantes[index].sKU!),
                                  subtitle: Column(
                                    textDirection: TextDirection.ltr,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('CODIGO: '+variantes[index].cODIGO!),
                                      Text('QUANTITY: '+variantes[index].aVAILABLEQUANTITY.toString()),
                                    ],
                                  ),
                                );
                              }),
                        )
                      ] ),
                ),
              ),
          )
        ]
      ),
    );
  }
  CalendarDatePicker2WithActionButtons _calendar(){
    return CalendarDatePicker2WithActionButtons(
      value: _calendar_value,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarViewMode: DatePickerMode.day,
        closeDialogOnOkTapped: true,
        closeDialogOnCancelTapped: true,
        firstDayOfWeek: 1,
        calendarType: CalendarDatePicker2Type.single,
        selectedDayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        selectedDayHighlightColor: Colors.black,
        centerAlignModePicker: true,
        customModePickerIcon: SizedBox(),
      ),
      onValueChanged: (dates) =>setState(() {
        _calendar_value= dates;

      }),
      onOkTapped: (){
        setState(() {
          infrac.clear();
          get_infra().indice_req(selectedValue!.toLowerCase(),_calendar_value[0].toString().substring(0,10)).then((value){
            setState(() {
              infrac.addAll(value);
              if(infrac.length>0){
                toast_impro('CONSULTA EXITOSA', true,Duration(seconds: 2));
              }else{
                toast_impro('SIN RESULTADOS', false,Duration(seconds: 2));
              }
            });
          });
        });
      },
      onCancelTapped: (){
        setState(() {
          infrac.clear();
          get_infra().indice_req(selectedValue!.toLowerCase(),_calendar_value[0].toString().substring(0,10)).then((value){
            setState(() {
              infrac.addAll(value);
              if(infrac.length>0){
                toast_impro('CONSULTA EXITOSA', true,Duration(seconds: 2));
              }else{
                toast_impro('SIN RESULTADOS', false,Duration(seconds: 2));
              }
            });
          });
        });
      },
    );
  }
}

class MLMvtasScreen extends StatefulWidget {
  String user;
  MLMvtasScreen({Key? key,required this.user}) : super(key: key);

  @override
  State<MLMvtasScreen> createState() => _MLMvtasScreenState();
}

class _MLMvtasScreenState extends State<MLMvtasScreen> {
  final _status = ["Ambas", "Accesorios", "Refacciones"];
  String _verticalGroupValue = "Ambas";
  int tipo = 0;
  List<DateTime?> _calendar_value = [DateTime.now()];
  List<MLMvtas> lista = <MLMvtas>[];
  List<MLMvtas> lista_searcher = <MLMvtas>[];
  List<MLMvtasatrb> atrb = <MLMvtasatrb>[];
  List<main_item> publicacion = <main_item>[];
  late final PlutoGridStateManager stateManager;
  List<PlutoRow> row_s = <PlutoRow>[];
  String initdt = DateTime.now().toString().substring(0,10);
  String finaldt = DateTime.now().toString().substring(0,10);
  get_data(){
  row_s.clear();
  lista.clear();
  lista_searcher;
    MLMvtasclass().getMLMlist(initdt,finaldt).then((value){
      setState(() {
        lista.addAll(value);
        lista_searcher = lista;
        lista.forEach((element) {
          row_s.add(item_rows(element));
        });
        PlutoGridStateManager.initializeRowsAsync(columns,row_s).then((value){
          stateManager.refColumns.addAll(columns);
          stateManager.refRows.addAll(value);
          stateManager.setShowLoading(false);
        });
      });
    });
  }
  void _defaultExportGridAsCSVFakeExcel() async {
    String title = "MLM_sales_report";
    var exportCSV = pluto_grid_export.PlutoGridExport.exportCSV(stateManager);
    var exported = const Utf8Encoder().convert(
        '\u{FEFF}$exportCSV');
    await FileSaver.instance.saveFile(name:"$title.xls", bytes:exported, ext:".xls");
  }
  @override
  void initState() {
    get_data();
    super.initState();
  }

   List<PlutoColumn> columns =<PlutoColumn>[
     PlutoColumn(title: 'CODIGO', field: 'CODIGO', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
     PlutoColumn(title: 'TIPO', field: 'TIPO', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
     PlutoColumn(title: 'IMAGE', field: 'IMAGE', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,
     renderer: (renderContext){
       return Image.network(renderContext.cell.value);
     },),
      PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 100),
      PlutoColumn(title: 'TITULO', field: 'TITLE', type: PlutoColumnType.text(),enableEditingMode: false,),
      PlutoColumn(title: 'LOGISTICA', field: 'LOGISTIC', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
      PlutoColumn(title: 'STATUS', field: 'STATUS', type: PlutoColumnType.text(),enableEditingMode: false,width: 75),
     PlutoColumn(title: 'STOCK', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false,width: 70),
      PlutoColumn(title: 'PRICE', field: 'PRICE', type: PlutoColumnType.number(),enableEditingMode: false,width: 70),
      PlutoColumn(title: 'VENTAS', field: 'VENTAS', type: PlutoColumnType.number(),enableEditingMode: false,width: 85),
     PlutoColumn(title: 'VENTAS', field: 'VENTAS_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false,width: 85),
     PlutoColumn(title: 'COMISION', field: 'COMISION', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
     PlutoColumn(title: 'COMISION_TOTAL', field: 'COMISION_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false,width: 100),
     PlutoColumn(title: 'COSTO', field: 'COSTO', type: PlutoColumnType.number(),enableEditingMode: false,width: 70),
     PlutoColumn(title: 'COSTO_TOTAL', field: 'COSTO_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
     PlutoColumn(title: 'UTILIDAD', field: 'UTILIDAD', type: PlutoColumnType.number(),enableEditingMode: false,width: 95,
     footerRenderer: (context){
       return PlutoAggregateColumnFooter(
           rendererContext: context,
           type:  PlutoAggregateColumnType.sum,
           alignment: Alignment.center,
           format: '#,###',
            titleSpanBuilder: (text){
             return[
               const TextSpan(
                 text: 'Utilidad total',
                 style: TextStyle(color: Colors.black)
               ),
               const TextSpan(text: ' : '),
               TextSpan(text: text)
             ];
            },
       );
     }),
   ];

   PlutoRow item_rows(MLMvtas item){
     return PlutoRow(
         cells: {
           'CODIGO':PlutoCell(value: item.cODIGO),
           'TIPO':PlutoCell(value: item.sUBLINEA2==0?'Accesorio':'Refaccion'),
           'ID':PlutoCell(value: item.iD),
           'TITLE':PlutoCell(value: item.tITULO),
           'LOGISTIC':PlutoCell(value: item.lOGISTICA),
           'IMAGE':PlutoCell(value: item.iMAGE),
           'STATUS':PlutoCell(value: item.sTATUS),
           'STOCK':PlutoCell(value: item.sTOCKCEDIS),
           'VENTAS':PlutoCell(value: item.vENTAS),
           'PRICE':PlutoCell(value: item.uNITPRICE),
           'VENTAS_TOTAL':PlutoCell(value: item.ventas_total),
           'COMISION':PlutoCell(value: item.sALEFEE),
           'COMISION_TOTAL':PlutoCell(value: item.comision_total),
           'COSTO':PlutoCell(value: item.cOSTOULTIMO),
           'COSTO_TOTAL':PlutoCell(value: item.costo_total),
           'UTILIDAD':PlutoCell(value: item.utilidad),
         });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading:IconButton(onPressed: (){
    PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: Menu(user: widget.user),
    withNavBar: false);
    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Menu(user: widget.user),), (route) => false,);
    }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
      title: Row(children: [
        Text('VENTAS POR PUBLICACION'),
        SizedBox(width: 20,),
        TextButton(onPressed: ()async{
        await showDialog(context: context, builder: (BuildContext context){
          return Card(
            margin: EdgeInsets.fromLTRB(50,
                200,50,
                200),
            elevation: 10,
            child: Container(
              color: Colors.white,
              child: _calendar(),
            ),
          );
        });
        }, child: Text('Rango de ventas',style: TextStyle(color: Colors.white),)),
        SizedBox(width: 20,),
        Text(initdt+'-'),
        Text(finaldt),
        SizedBox(width: 30,),
        Container(
          width: 350,
          child: RadioGroup<String>.builder(
            direction: Axis.horizontal,
            groupValue: _verticalGroupValue,
            textStyle: TextStyle(fontSize: 12),
            onChanged: (value) => setState(() {
              _verticalGroupValue = value ?? '';
              switch(_verticalGroupValue){
                case 'Accesorios':
                  //tipo = 'A';
                  row_s.clear();
                  setState(() {
                    lista=lista_searcher.where((element){
                      var searcher = element.sUBLINEA2;
                      return searcher==0;
                    }).toList();
                    lista.forEach((element) {
                      row_s.add(item_rows(element));
                    });
                    PlutoGridStateManager.initializeRowsAsync(columns,row_s).then((value){
                      stateManager.refColumns.addAll(columns);
                      stateManager.refRows.addAll(value);
                      stateManager.setShowLoading(false);
                    });
                  });

                  break;
                case 'Refacciones':
                  row_s.clear();
                  setState(() {
                    lista=lista_searcher.where((element){
                      var searcher = element.sUBLINEA2;
                      return searcher!>=200;
                    }).toList();
                    lista.forEach((element) {
                      row_s.add(item_rows(element));
                    });
                    PlutoGridStateManager.initializeRowsAsync(columns,row_s).then((value){
                      stateManager.refColumns.addAll(columns);
                      stateManager.refRows.addAll(value);
                      stateManager.setShowLoading(false);
                    });
                  });

                  break;
                case 'Ambas':
                  row_s.clear();
                  setState(() {
                    lista=lista_searcher.where((element){
                      var searcher = element.sUBLINEA2;
                      return searcher!>=0;
                    }).toList();
                    lista.forEach((element) {
                      row_s.add(item_rows(element));
                    });
                    PlutoGridStateManager.initializeRowsAsync(columns,row_s).then((value){
                      stateManager.refColumns.addAll(columns);
                      stateManager.refRows.addAll(value);
                      stateManager.setShowLoading(false);
                    });
                  });
                  break;
              }

            }),
            items: _status,
            itemBuilder: (item) => RadioButtonBuilder(
              item,
            ),
            activeColor: Colors.white,
            //fillColor: Colors.purple,
          ),
        ),
        SizedBox(width: 20,),
        TextButton(onPressed: (){
          _defaultExportGridAsCSVFakeExcel();
        }, child: Text('Export XLS',style: TextStyle(color: Colors.white),))
      ],),),
      body: Row(
        children: [
          Expanded(
            child: 
            Padding(
              padding: EdgeInsets.all(8),
             child:lista.isNotEmpty?PlutoGrid(
                 onLoaded:(PlutoGridOnLoadedEvent event) {
                   stateManager = event.stateManager;
                   stateManager.setShowColumnFilter(true);
                 },
                 configuration: PlutoGridConfiguration(),
                 columns: columns,
                 rows: row_s,
                 onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) async{
                   atrb.clear();
                   List<PlutoCell> eventRow = event.row.cells.values.toList();
                   //print(eventRow[0].value.toString()+'-'+event.cell.value);
                   MLMvtasclass().getMLMatrb(eventRow[1].value.toString(),initdt, finaldt).then((value){
                     setState(() {
                       atrb.addAll(value);
                     });
                   });
                 },
             ):Center(child: Container(width:200,height:200,child: CircularProgressIndicator())),
            ),
            flex: 2,),
         atrb.isNotEmpty?Expanded(child: Padding(padding: EdgeInsets.all(8),
            child: Neumorphic(
              padding: EdgeInsets.all(8),
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 10,
                intensity: 0.75,
                surfaceIntensity: 0.75,
                lightSource: LightSource.topLeft,
                color: Colors.white24
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Neumorphic(
                    padding: EdgeInsets.all(8),
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                      depth: 10,
                      intensity: 0.75,
                      surfaceIntensity: 0.75,
                      lightSource: LightSource.topLeft,
                      color: Colors.black12
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Text(atrb.length==0?'':atrb[0].iD!,style: TextStyle(fontSize: 25),),
                        ),
                        Text(atrb.length==0?'':atrb[0].tITLE!,style: TextStyle(fontSize: 18),softWrap: true,),
                        Text(atrb.length==0?'':'PRICE: '+atrb[0].pRICE.toString(),style: TextStyle(fontSize: 15),),
                        Text(atrb.length==0?'':'DT CREATED: '+atrb[0].dATECREATED.toString().substring(0,10),style: TextStyle(fontSize: 15),),
                        Text(atrb.length==0?'':'LT UPDATE: '+atrb[0].lASTUPDATED.toString().substring(0,10),style: TextStyle(fontSize: 15),),
                        Text(atrb.length==0?'':'LOGISTICA: '+atrb[0].lOGISTICTYPE!,style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                   Container(
                     width: 500,
                     child: ListView.builder(
                       padding: EdgeInsets.all(8),
                       shrinkWrap: true,
                          itemCount: atrb.length,
                          itemBuilder: (BuildContext context,index){
                        return Column(
                          children: [
                            Row(
                              children:[
                                Expanded(child: Image.network(atrb[index].pICTUREURL!),flex: 1,),
                                Expanded(child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(atrb[index].cODIGO!),
                                    Text(atrb[index].sKU!),
                                    Text('VENTAS: '+atrb[index].vENTAS.toString()),
                                    Text('WMS: '+atrb[index].sTOCKCEDIS.toString()),
                                    Text('DISPONIBLE MELI: '+atrb[index].aVAILABLEQUANTITY.toString())
                                  ],
                                ),flex: 6,)
                                ]
                            ),
                            Neumorphic(
                              child: Container(width: 450,height: 3),
                            )
                          ],
                        );
                      }),
                   ),
                ],
              ),
            ),
          ),flex: 1,):Container()
        ],
      ),
    );
  }
  CalendarDatePicker2WithActionButtons _calendar(){
    return CalendarDatePicker2WithActionButtons(
      value: _calendar_value,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarViewMode: DatePickerMode.day,
        closeDialogOnOkTapped: true,
        closeDialogOnCancelTapped: true,
        firstDayOfWeek: 1,
        calendarType: CalendarDatePicker2Type.range,
        selectedDayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        selectedDayHighlightColor: Colors.black,
        centerAlignModePicker: true,
        customModePickerIcon: SizedBox(),
      ),
      onValueChanged: (dates) =>setState(() {
        _calendar_value= dates;
      }),
      onOkTapped: (){
        if(_calendar_value.length==1){
          initdt = _calendar_value[0].toString().substring(0,10);
          finaldt =_calendar_value[0].toString().substring(0,10);
        }else{
          initdt = _calendar_value[0].toString().substring(0,10);
          finaldt =_calendar_value[1].toString().substring(0,10);
        }
        setState(() {
          lista.clear();
          lista_searcher.clear();
          row_s.clear();
          MLMvtasclass().getMLMlist(initdt,finaldt).then((value){
            setState(() {
              lista.addAll(value);
              lista_searcher = lista;
              lista.forEach((element) {
                row_s.add(item_rows(element));
              });
              PlutoGridStateManager.initializeRowsAsync(columns,row_s).then((value){
                stateManager.refColumns.addAll(columns);
                stateManager.refRows.addAll(value);
                stateManager.setShowLoading(false);
              });
            });
          });
        });
      },
      onCancelTapped: (){
        initdt = DateTime.now().toString().substring(0,10);
        finaldt =DateTime.now().toString().substring(0,10);
        setState(() {
          lista.clear();
          lista_searcher.clear();
          row_s.clear();
          MLMvtasclass().getMLMlist(initdt, finaldt).then((value){
          setState(() {
            lista.addAll(value);
            lista_searcher = lista;
            lista.forEach((element) {
            row_s.add(item_rows(element));
            });
            PlutoGridStateManager.initializeRowsAsync(columns,row_s).then((value){
              stateManager.refColumns.addAll(columns);
              stateManager.refRows.addAll(value);
              stateManager.setShowLoading(false);
          });
        });
    });
      },
    );
  });
 }
}

class improve_items extends StatefulWidget {
  String user;
   improve_items({Key? key,required this.user}) : super(key: key);

  @override
  State<improve_items> createState() => _improve_itemsState();
}

class _improve_itemsState extends State<improve_items> {
  List<variation_item> variantes =<variation_item>[];
  List<main_item> public_list =<main_item>[];
  List<String> imagenes = <String>[];
  List<imp_items> im_items = <imp_items>[];
  List<imp_items> im_items_filter = <imp_items>[];
  List<String> items = ['Health Disminuido','Bajo Revision','Ficha Tecnica Incompleta','Precio Fuera de Rango','Sin Codigo Universal'];
  String? selectedValue='Health Disminuido';
TextEditingController controller =TextEditingController();
  void get_imp(String value){
    String topic='unhealthy';
    switch(value){
      case'Health Disminuido':topic='unhealthy';break;
      case'Bajo Revision':topic='pending';break;
      case'Ficha Tecnica Incompleta':topic='specs';break;
      case'Precio Fuera de Rango':topic='outrange';break;
      case'Sin Codigo Universal':topic='universal_code';break;
    }
    items_improve_services().getMLMlist(topic).then((value){
      setState(() {
        im_items.addAll(value);
        im_items_filter  = im_items;
      });
    });
  }
@override
  void initState() {
    get_imp('Health Disminuido');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: Menu(user: widget.user),
              withNavBar: false);
        }, icon:Icon(Icons.arrow_back_ios_new_outlined)),
        title: Row(
          children: [
            Text('Infracciones'),
            SizedBox(width: 20,),
            Text('Topic:'),
            SizedBox(width: 20,),
            DropdownButtonHideUnderline(
              child: DropdownButton2(isExpanded: true, hint: Text('Select Item', style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),)).toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    im_items_filter.clear();
                    im_items.clear();
                    selectedValue = value as String;
                    //---Peticion
                    get_imp(selectedValue!);
                  });
                },
                buttonStyleData: const ButtonStyleData(
                  height: 40,
                  width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(color: Colors.black)
                ),
              ),
            ),
            SizedBox(width: 20,),
            Container(
              padding: EdgeInsets.all(8),
              //color: Colors.white,
              width: 180,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                    hintText: 'BUSCAR ...',
                    hintStyle: TextStyle(color: Colors.white)),
              controller: controller,
              style: TextStyle(color: Colors.white),
              onChanged: (val){
                setState(() {
                  im_items = im_items_filter.where((element){
                    var finder = element.iD!.toLowerCase()+element.tITLE!.toLowerCase();
                    return finder.contains(val.toLowerCase());
                  }).toList();
                });
              },
            ),
            )
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                child:im_items.isNotEmpty?GridView.builder(
                  itemCount: im_items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10
                    ),
                  itemBuilder: (BuildContext context,index){
                      return AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 3,
                          child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                  child: GestureDetector(
                                   child: Neumorphic(
                                      padding: const EdgeInsets.all(8),
                                      style: NeumorphicStyle(
                                          //shape: NeumorphicShape.values,
                                          shadowDarkColor: Colors.black,
                                          shadowLightColor: Colors.white24,
                                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                          depth: -20,
                                          lightSource: LightSource.topLeft,
                                          intensity: 1,
                                          surfaceIntensity: 1,
                                          color:Colors.yellow),
                                      child: ListTile(
                                        title: Text(im_items[index].iD!),
                                        subtitle: Text(im_items[index].tITLE!,style: TextStyle(color: Colors.black),),
                                      ),
                                    ),
                                    onDoubleTap: () async {
                                      public_list.clear();
                                      variantes.clear();
                                      imagenes.clear();
                                      await get_impro_data().infra_main(im_items[index].iD!).then((value){
                                        setState(() {
                                          public_list.addAll(value);
                                          String imagenes1 =public_list[0].iMAGES!.substring(1,public_list[0].iMAGES!.length-1);
                                          print(imagenes1);
                                          imagenes = imagenes1.split(",");
                                        });
                                      });
                                      await get_impro_data().infra_var(im_items[index].iD!).then((value){
                                        setState(() {
                                          variantes.addAll(value);
                                        });
                                      });
                                    },
                                  )
                              )
                          )
                      );
                  },
                ):Center(child: CircularProgressIndicator(),),
              )
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(
                  padding: EdgeInsets.all(8),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                      depth: 10,
                      intensity: 0.75,
                      surfaceIntensity: 0.7,
                      lightSource: LightSource.topLeft,
                      color: Colors.white30
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:[
                        GestureDetector(
                            onDoubleTap: (){
                              launchuURL(public_list[0].iD!);
                            },
                            child: Text(public_list.length==0?'MLM':public_list[0].iD!,style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                        Text(public_list.length==0?'Title':public_list[0].tITLE!,style: TextStyle(fontSize: 20),),
                        //Image.network(public_list.length==0?'':public_list[0].iMAGES!,width: 200,height: 200,),+
                        CarouselSlider(
                          items: imagenes.map((e) => ClipRRect(
                            borderRadius: BorderRadius.circular(19),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Image.network(e,
                                  width: 160,height: 250,fit: BoxFit.contain,)
                              ],
                            ),
                          )).toList(),
                          options: CarouselOptions(
                              height: 250,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              enableInfiniteScroll: true
                          ),),
                        Text(public_list.length==0?'Price':'PRECIO: '+public_list[0].pRICE.toString(),style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'Status':'STATUS: '+public_list[0].sTATUS!,style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'DT':'FECHA CREACION: '+public_list[0].dATECREATED!.substring(0,10),style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'LUPDATE':'ULTIMA ACTUALIZACION: '+public_list[0].lASTUPDATED!.substring(0,10),style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'HEALTH':'HEALTH: '+(public_list[0].hEALTH!*100).toStringAsFixed(0),style: TextStyle(fontSize: 19),),
                        Text(public_list.length==0?'LOGISTIC':'LOGISTTC TYPE: '+public_list[0].lOGISTICTYPE!,style: TextStyle(fontSize: 19),),
                        Neumorphic(
                          padding: EdgeInsets.all(8),
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                              depth: 10,
                              intensity: 0.75,
                              surfaceIntensity: 0.7,
                              lightSource: LightSource.topLeft,
                              color: Colors.white38
                          ),
                          child: Container(
                              height: 20,
                              width: 600,
                              alignment: Alignment.center,
                              child: Text('VARIANTES')),
                        ),
                        Container(
                          width: 500,
                          height: 250,
                          child: ListView.builder(
                              itemCount: variantes.length,
                              itemBuilder: (BuildContext context,index){
                                return ListTile(
                                  leading: Image.network(variantes[index].tHUMBNAIL!),
                                  title: Text('SKU: '+variantes[index].sKU!),
                                  subtitle: Column(
                                    textDirection: TextDirection.ltr,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('CODIGO: '+variantes[index].cODIGO!),
                                      Text('QUANTITY: '+variantes[index].aVAILABLEQUANTITY.toString()),
                                    ],
                                  ),
                                );
                              }),
                        )
                      ] ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ASINvtas extends StatefulWidget {
  String user;
   ASINvtas({Key? key,required this.user}) : super(key: key);

  @override
  State<ASINvtas> createState() => _ASINvtasState();
}

class _ASINvtasState extends State<ASINvtas> {
 String initdt = DateTime.now().toString().substring(0,10);
 String finaldt =DateTime.now().toString().substring(0,10);
  List<DateTime?> _calendar_value = [DateTime.now()];

  List<PlutoColumn> columns =<PlutoColumn>[
    PlutoColumn(title: 'ASIN', field: 'ASIN', type: PlutoColumnType.text(),enableEditingMode: false,width: 85),
    PlutoColumn(title: 'TIPO', field: 'TIPO', type: PlutoColumnType.text(),enableEditingMode: false,width: 85),
    PlutoColumn(title: 'TITLE', field: 'TITLE', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'SKU', field: 'SKU', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'IMAGE', field: 'IMAGE', type: PlutoColumnType.text(),enableEditingMode: false,width: 85,
      renderer: (renderContext){
        return Image.network(renderContext.cell.value);
      },),
    PlutoColumn(title: 'STATUS', field: 'STATUS', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
    PlutoColumn(title: 'STOCk_CEDIS', field: 'STOCK', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'PRICE', field: 'PRICE', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'VENTAS', field: 'VENTAS', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'VENTAS_TOTAL', field: 'VENTAS_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'COMISION', field: 'COMISION', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'COMISION_TOTAL', field: 'COMISION_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'SHIPPING', field: 'SHIPPING', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'SHIPPING_TOTAL', field: 'SHIPPING_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'COSTO', field: 'COSTO', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'COSTO_TOTAL', field: 'COSTO_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'UTILIDAD', field: 'UTILIDAD', type: PlutoColumnType.number(),enableEditingMode: false,
    footerRenderer: (context){
      return PlutoAggregateColumnFooter(
          rendererContext: context,
          type: PlutoAggregateColumnType.sum,
          alignment: Alignment.center,
          format: '#,###',
          titleSpanBuilder: (text){
            return[
              const TextSpan(
                text: 'Utilidad Total',
                style: TextStyle(color: Colors.black)
              ),
              const TextSpan(text: ' : '),
              TextSpan(text: text)
            ];
          },
      );
    }),
  ];

  PlutoRow item_rows(ASIN_SALES item){
    return PlutoRow(
        cells: {
          'ASIN':PlutoCell(value: item.asin),
          'TIPO':PlutoCell(value: item.sublinea),
          'TITLE':PlutoCell(value: item.item),
          'SKU':PlutoCell(value: item.sku),
          'IMAGE':PlutoCell(value: item.image),
          'STATUS':PlutoCell(value: item.sTATUS),
          'VENTAS':PlutoCell(value: item.vTAS),
          'PRICE':PlutoCell(value: item.price),
          'VENTAS_TOTAL':PlutoCell(value:item.price!*num.parse(item.vTAS.toString())),
          'COMISION':PlutoCell(value: item.cOMISION),
          'COMISION_TOTAL':PlutoCell(value: item.cOMISION!*num.parse(item.vTAS.toString())),
          'SHIPPING':PlutoCell(value: item.sHIPPINGFEE),
          'SHIPPING_TOTAL':PlutoCell(value: item.sHIPPINGFEE!*num.parse(item.vTAS.toString())),
          'COSTO_TOTAL':PlutoCell(value: item.cOSTOPUBLICACION!*num.parse(item.vTAS.toString())),
          'COSTO':PlutoCell(value: item.cOSTOPUBLICACION),
          'UTILIDAD':PlutoCell(value: (item.price!*num.parse(item.vTAS.toString()))-((item.cOMISION!*num.parse(item.vTAS.toString())+(item.sHIPPINGFEE!*num.parse(item.vTAS.toString()))+(item.cOSTOPUBLICACION!*num.parse(item.vTAS.toString()))))),
          'STOCK':PlutoCell(value: item.stock)
        });
  }
 late final PlutoGridStateManager stateManager;
  List<PlutoRow> row_s = <PlutoRow>[];
  List<ASIN_SALES> asins = <ASIN_SALES>[];
  listgette(){
    vtas_byasin().getASINlist(initdt,finaldt).then((value){
      setState(() {
        asins.addAll(value);
        asins.forEach((element) {row_s.add(item_rows(element));});
        PlutoGridStateManager.initializeRowsAsync(columns,row_s).then((value){
          stateManager.refColumns.addAll(columns);
          stateManager.refRows.addAll(value);
          stateManager.setShowLoading(false);
        });
      });
      //updateManager();
    });
  }
 void _defaultExportGridAsCSVFakeExcel() async {
    String title = "Amazon_sales_report";
    var exportCSV = pluto_grid_export.PlutoGridExport.exportCSV(stateManager);
    var exported = const Utf8Encoder().convert(
        '\u{FEFF}$exportCSV');
    await FileSaver.instance.saveFile(name:"$title.xls", bytes:exported, ext:".xls");
 }

  @override
  void initState() {
    listgette();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: Menu(user: widget.user),
              withNavBar: false);
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Menu(user: widget.user),), (route) => false,);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Row(
          children: [
            TextButton(onPressed: ()async{
              await showDialog(context: context, builder: (BuildContext context){
                return Center(
                  child: Container(
                      height:450,
                      width: 500,
                      child:Card(child: _calendar())),
                );
              });
            }, child: Text('Rango de ventas',style: TextStyle(color: Colors.white),)),
            SizedBox(width: 20,),
            Column(children: [
              Text(initdt),
              Text(finaldt)
            ],),
            SizedBox(width: 20,),
            TextButton(onPressed: ()async{
              _defaultExportGridAsCSVFakeExcel();
            }, child: Text('Exportar XLS',style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            //flex: 2,
              child: PlutoGrid(
                  onLoaded: (PlutoGridOnLoadedEvent vnt){
                    stateManager = vnt.stateManager;
                    vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                    stateManager.setShowColumnFilter(true);
                  },
                  configuration: const PlutoGridConfiguration(localeText: PlutoGridLocaleText.spanish()),
                  columns: columns,
                  rows:row_s)),
          /*Expanded(
            flex: 1,
              child: Container())*/
        ],
      ),
    );
  }

 CalendarDatePicker2WithActionButtons _calendar(){
   return CalendarDatePicker2WithActionButtons(
       value: _calendar_value,
       config: CalendarDatePicker2WithActionButtonsConfig(
         calendarViewMode: DatePickerMode.day,
         closeDialogOnOkTapped: true,
         closeDialogOnCancelTapped: true,
         firstDayOfWeek: 1,
         calendarType: CalendarDatePicker2Type.range,
         selectedDayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
         selectedDayHighlightColor: Colors.black,
         centerAlignModePicker: true,
         customModePickerIcon: SizedBox(),
       ),
       onValueChanged: (dates) =>setState(() {
         _calendar_value= dates;
       }),
       onOkTapped: (){
         if(_calendar_value.length==1){
           initdt = _calendar_value[0].toString().substring(0,10);
           finaldt =_calendar_value[0].toString().substring(0,10);
         }else{
           initdt = _calendar_value[0].toString().substring(0,10);
           finaldt =_calendar_value[1].toString().substring(0,10);
         }
         setState(() {
           asins.clear();
           row_s.clear();
           listgette();
         });
       },
       onCancelTapped: (){
         initdt = DateTime.now().toString().substring(0,10);
         finaldt =DateTime.now().toString().substring(0,10);
         setState(() {
           asins.clear();
           row_s.clear();
           listgette();
         },
         );
       });
 }
}

class SKCvtas extends StatefulWidget {
  String user;
  SKCvtas({Key? key,required this.user}) : super(key: key);

  @override
  State<SKCvtas> createState() => _SKCvtasState();
}

class _SKCvtasState extends State<SKCvtas> {
  List<skc_sales> lista =<skc_sales>[];
  String initdt = DateTime.now().toString().substring(0,10);
  String finaldt =DateTime.now().toString().substring(0,10);
  List<DateTime?> _calendar_value = [DateTime.now()];
  late final PlutoGridStateManager stateManager;
  List<PlutoRow> row_s = <PlutoRow>[];
  List<PlutoColumn> columns =<PlutoColumn>[
    PlutoColumn(title: 'CODIGO', field: 'CODIGO', type: PlutoColumnType.text(),enableEditingMode: false,width: 85),
    PlutoColumn(title: 'TIPO', field: 'TIPO', type: PlutoColumnType.text(),enableEditingMode: false,width: 85),
    PlutoColumn(title: 'TITLE', field: 'NAME', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'SPU', field: 'SPU', type: PlutoColumnType.text(),enableEditingMode: false,hide: true),
    PlutoColumn(title: 'SKC', field: 'SKC', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'SKU', field: 'SKU', type: PlutoColumnType.text(),enableEditingMode: false,width: 85,hide: true),
    PlutoColumn(title: 'INVENTARIO', field: 'QUANTITY', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
    PlutoColumn(title: 'STOCK_CEDIS', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'PRICE', field: 'PRICE', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'VENTAS', field: 'VENTAS', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'VENTAS_TOTAL', field: 'VENTAS_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'COMISION', field: 'COMISION', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'COMISION_TOTAL', field: 'COMISION_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'COSTO', field: 'COSTO_ULTIMO', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'COSTO_TOTAL', field: 'COSTO_TOTAL', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'UTILIDAD', field: 'UTILIDAD', type: PlutoColumnType.number(),enableEditingMode: false,
        footerRenderer: (context){
          return PlutoAggregateColumnFooter(
            rendererContext: context,
            type: PlutoAggregateColumnType.sum,
            alignment: Alignment.center,
            format: '#,###',
            titleSpanBuilder: (text){
              return[
                const TextSpan(
                    text: 'Utilidad Total',
                    style: TextStyle(color: Colors.black)
                ),
                const TextSpan(text: ' : '),
                TextSpan(text: text)
              ];
            },
          );
        }),
  ];
  PlutoRow item_rows(skc_sales item){
    return PlutoRow(
        cells: {
          'CODIGO':PlutoCell(value: item.cODIGO),
          'TIPO':PlutoCell(value: item.sublinea),
          'SPU':PlutoCell(value: item.sPU),
          'SKC':PlutoCell(value: item.sKC),
          'SKU':PlutoCell(value: item.sKU),
          'NAME':PlutoCell(value: item.nAME),
          'QUANTITY':PlutoCell(value: item.qUANTITY),
          'STOCK':PlutoCell(value: item.sTOCKCEDIS),
          'VENTAS':PlutoCell(value:item.vTAS),
          'PRICE':PlutoCell(value: item.pRICE),
          'VENTAS_TOTAL':PlutoCell(value:item.vtas_totales),
          'COMISION':PlutoCell(value: item.cOMISION),
          'COMISION_TOTAL':PlutoCell(value: item.comision_total),
          'COSTO_ULTIMO':PlutoCell(value: item.cOSTOULTIMO),
          'COSTO_TOTAL':PlutoCell(value: item.costo_total),
          'UTILIDAD':PlutoCell(value: item.vtas_totales!-(item.comision_total!+item.costo_total!))
          //'UTILIDAD':PlutoCell(value: (item.price!*num.parse(item.vTAS.toString()))-((item.cOMISION!*num.parse(item.vTAS.toString())+(item.sHIPPINGFEE!*num.parse(item.vTAS.toString()))+(item.cOSTOPUBLICACION!*num.parse(item.vTAS.toString()))))),
        });
  }
  getdata(){
    lista.clear();
    row_s.clear();
    get_skcdata().getSKClist(initdt, finaldt).then((value){
      setState(() {
        lista.addAll(value);
        lista.forEach((element) {row_s.add(item_rows(element));});
        PlutoGridStateManager.initializeRowsAsync(columns,row_s).then((value){
          stateManager.refColumns.addAll(columns);
          stateManager.refRows.addAll(value);
          stateManager.setShowLoading(false);
        });
      });
    });
  }
  void _defaultExportGridAsCSVFakeExcel() async {
    String title = "SHEIN_sales_report";
    var exportCSV = pluto_grid_export.PlutoGridExport.exportCSV(stateManager);
    var exported = const Utf8Encoder().convert(
        '\u{FEFF}$exportCSV');
    await FileSaver.instance.saveFile(name:"$title.xls", bytes:exported, ext:".xls");
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){
        PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: Menu(user: widget.user),
            withNavBar: false);
        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Menu(user: widget.user),), (route) => false,);
      }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Row(
          children: [
            TextButton(onPressed: ()async{
              await showDialog(context: context, builder: (BuildContext context){
                return Center(
                  child: Container(
                      height:450,
                      width: 500,
                      child:Card(child: _calendar())),
                );
              });
            }, child: Text('Rango de ventas',style: TextStyle(color: Colors.white),)),
            SizedBox(width: 20,),
            Column(children: [
              Text(initdt),
              Text(finaldt)
            ],),
            SizedBox(width: 20,),
            TextButton(onPressed: ()async{
              _defaultExportGridAsCSVFakeExcel();
            }, child: Text('Exportar XLS',style: TextStyle(color: Colors.white),))
          ],
        ),),
      body: Row(
        children: [
        Expanded(child:
        PlutoGrid(
          onLoaded: (PlutoGridOnLoadedEvent vnt){
            stateManager = vnt.stateManager;
            vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
            stateManager.setShowColumnFilter(true);
          },
            columns: columns,
            rows: row_s,
            configuration: const PlutoGridConfiguration(localeText: PlutoGridLocaleText.spanish()),
        ),
        ),
       ],
      ),
    );
  }
  CalendarDatePicker2WithActionButtons _calendar(){
    return CalendarDatePicker2WithActionButtons(
        value: _calendar_value,
        config: CalendarDatePicker2WithActionButtonsConfig(
          calendarViewMode: DatePickerMode.day,
          closeDialogOnOkTapped: true,
          closeDialogOnCancelTapped: true,
          firstDayOfWeek: 1,
          calendarType: CalendarDatePicker2Type.range,
          selectedDayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          selectedDayHighlightColor: Colors.black,
          centerAlignModePicker: true,
          customModePickerIcon: SizedBox(),
        ),
        onValueChanged: (dates) =>setState(() {
          _calendar_value= dates;
        }),
        onOkTapped: (){
          if(_calendar_value.length==1){
            initdt = _calendar_value[0].toString().substring(0,10);
            finaldt =_calendar_value[0].toString().substring(0,10);
          }else{
            initdt = _calendar_value[0].toString().substring(0,10);
            finaldt =_calendar_value[1].toString().substring(0,10);
          }
          setState(() {
            getdata();
          });
        },
        onCancelTapped: (){
          initdt = DateTime.now().toString().substring(0,10);
          finaldt =DateTime.now().toString().substring(0,10);
          setState(() {
            getdata();
          },
          );
        });
  }
}

class Co_fondeadas extends StatefulWidget {
  String user;
  Co_fondeadas({Key? key,required this.user}) : super(key: key);

  @override
  State<Co_fondeadas> createState() => _Co_fondeadasState();
}

class _Co_fondeadasState extends State<Co_fondeadas> {
  String campaing = '';
  String finaldt = DateTime.now().toString().substring(0,10);
  String initdt = DateTime.now().subtract(Duration(days: 30)).toString().substring(0,10);
  List<user_offers> offer_usr = <user_offers>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late final PlutoGridStateManager stateManager;
  List<MLMvtasatrb> atrb = <MLMvtasatrb>[];
 List<PlutoRow> rows = <PlutoRow>[];
 List<items_offer> publicaciones = <items_offer>[];
  List<PlutoColumn> colums = <PlutoColumn>[
  PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'STATUS', field: 'STATUS', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'PRICE', field: 'PRICE', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'ORIGINAL', field: 'ORIGINAL', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'OFFER', field: 'OFFER', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'MELI', field: 'MELI', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'SELLER', field: 'SELLER', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'START', field: 'START', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'END', field: 'END', type: PlutoColumnType.text(),enableEditingMode: false),
  ];
  List<offers_items> ofertas = <offers_items>[];
 PlutoRow item(items_offer item){
   return PlutoRow(
       cells:{
         'ID':PlutoCell(value: item.id),
         'STATUS':PlutoCell(value: item.status),
         'PRICE':PlutoCell(value: item.price),
         'ORIGINAL':PlutoCell(value: item.originalPrice),
         'OFFER':PlutoCell(value: item.offerId),
         'MELI':PlutoCell(value: item.meliPercentage),
         'SELLER':PlutoCell(value: item.sellerPercentage),
         'START':PlutoCell(value: item.startDate),
         'END':PlutoCell(value: item.endDate),
       }
   );
 }
 void getitems(String id,String type){
   setState(() {
     publicaciones.clear();
     rows.clear();
   });
   get_offers().getitemsOffer(id, type).then((value){
     setState(() {
       publicaciones.addAll(value);
       publicaciones.forEach((element) {
         setState(() {
           rows.add(item(element));
         });
       });
       _updatemanager();
     });

   });
 }

   getItemspromo(String id){
   get_offers().getOffersitems(id).then((value) =>{
     setState((){
       ofertas.addAll(value);
     })
   });
 }


  @override
  void initState() {
    get_offers().getOffersUSR().then((value) => {
      setState((){
        offer_usr.addAll(value);
      })
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: Menu(user: widget.user),
              withNavBar: false);
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Menu(user: widget.user),), (route) => false,);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Row(
          children: [
            Text(campaing),
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            _scaffoldKey.currentState?.openEndDrawer();
          }, icon: Icon(Icons.menu))
        ],
      ),
      endDrawer: Drawer(
        child:offer_usr.isNotEmpty?ListView.builder(
          itemCount: offer_usr.length,
          itemBuilder: (BuildContext context, int index) {
           return ListTile(
             onTap: ()async{
              atrb.clear();
              ofertas.clear();
              getitems(offer_usr[index].id!, offer_usr[index].type!);
              setState(() {
                campaing = '${offer_usr[index].id!}-${offer_usr[index].name!}';
              });
             },
             title: Text(offer_usr.length==0?'':'${offer_usr[index].id!}-${offer_usr[index].type!}'),
             subtitle: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Text(offer_usr.length==0?'':offer_usr[index].name!),
                 Text(offer_usr.length==0?'':offer_usr[index].status!)
               ],
             ),

           );
          },
        )
            :Center(
              child: SpinKitRotatingCircle(
          itemBuilder: (BuildContext context,int index){
              return DecoratedBox(
                  decoration: BoxDecoration(
                   color: Colors.green
                  )
              );
          },
        ),
            ),
      ),
    body: Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child:publicaciones.isNotEmpty? PlutoGrid(
              columns: colums,
              rows: rows,
              onLoaded: (PlutoGridOnLoadedEvent vnt){
              stateManager = vnt.stateManager;
              vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
              stateManager.setShowColumnFilter(true);
              },
              onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent vnt)async{
                print(vnt.row.cells["ID"]!.value);
                atrb.clear();
                ofertas.clear();
               await MLMvtasclass().getMLMatrb(vnt.row.cells["ID"]!.value,initdt, finaldt).then((value){
                  setState(() {
                    atrb.addAll(value);
                  });
                });

               await getItemspromo(vnt.row.cells["ID"]!.value);
              },
            ):Center(
              child: SpinKitCubeGrid(
                itemBuilder: (BuildContext context,int index){
                  return DecoratedBox(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor
                      )
                  );
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: ofertas.isNotEmpty,
          child: Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Expanded(
                    child: Container(
                      child: ListView.builder(
                          itemCount: ofertas.length,
                          itemBuilder: (BuildContext context,int index){
                            return ListTile(
                              title: Text(ofertas[index].id.toString()),
                              subtitle: Column(
                                children: [
                                  Text('Tipo: '+ofertas[index].type.toString()),
                                  Text('Estado: '+ofertas[index].status.toString()),
                                  Text('Nombre: '+ofertas[index].name.toString()),
                                  Text('Meli percent: '+ofertas[index].meliPercent.toString()),
                                  Text('Seller percent: '+ofertas[index].sellerPercent.toString())
                                ],
                              ),
                            );
                          }),
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Neumorphic(
                      padding: EdgeInsets.all(8),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                          depth: 10,
                          intensity: 0.75,
                          surfaceIntensity: 0.75,
                          lightSource: LightSource.topLeft,
                          color: Colors.white24
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex:2,
                            child: Neumorphic(
                              padding: EdgeInsets.all(8),
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                  depth: 10,
                                  intensity: 0.75,
                                  surfaceIntensity: 0.75,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.black12
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Text(atrb.length==0?'':atrb[0].iD!,style: TextStyle(fontSize: 25),),
                                  ),
                                  Text(atrb.length==0?'':atrb[0].tITLE!,style: TextStyle(fontSize: 18),softWrap: true,),
                                  Text(atrb.length==0?'':'PRICE: '+atrb[0].pRICE.toString(),style: TextStyle(fontSize: 15),),
                                  Text(atrb.length==0?'':'DT CREATED: '+atrb[0].dATECREATED.toString().substring(0,10),style: TextStyle(fontSize: 15),),
                                  Text(atrb.length==0?'':'LT UPDATE: '+atrb[0].lASTUPDATED.toString().substring(0,10),style: TextStyle(fontSize: 15),),
                                  Text(atrb.length==0?'':'LOGISTICA: '+atrb[0].lOGISTICTYPE!,style: TextStyle(fontSize: 15),),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: ListView.builder(
                                  padding: EdgeInsets.all(8),
                                  shrinkWrap: true,
                                  itemCount: atrb.length,
                                  itemBuilder: (BuildContext context,index){
                                       return Row(
                                            children:[
                                              Expanded(child: Image.network(atrb[index].pICTUREURL!),flex: 1,),
                                              Expanded(child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(atrb[index].cODIGO!),
                                                  Text(atrb[index].sKU!),
                                                  Text('VENTAS: '+atrb[index].vENTAS.toString()),
                                                  Text('WMS: '+atrb[index].sTOCKCEDIS.toString()),
                                                  Text('DISPONIBLE MELI: '+atrb[index].aVAILABLEQUANTITY.toString())
                                                ],
                                              ),flex: 6,)
                                            ]
                                        );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    )
                )
              ],
            ),
          )),
        )
      ],
    ),
    );
  }
  _updatemanager(){
    print(colums.length.toString()+'-'+rows.length.toString());
    setState(() {
      PlutoGridStateManager.initializeRowsAsync(colums,rows).then((value){
        stateManager.refColumns.addAll(colums);
        stateManager.refRows.addAll(value);
        stateManager.setShowLoading(true);
        stateManager.setShowColumnFilter(true);
      });
    });
  }
}




