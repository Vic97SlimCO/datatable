import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:core';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:datatable/design_mkt/design_res.dart';
import 'package:datatable/option_menu.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'Improve_resources/listas.dart';


/*class Dsgn_Mkt extends StatefulWidget {
  String user;
   Dsgn_Mkt({Key? key,required this.user}) : super(key: key);

  @override
  State<Dsgn_Mkt> createState() => _Dsgn_MktState();
}

class _Dsgn_MktState extends State<Dsgn_Mkt> {
  //String user;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xFF000000))),
      home: Dash_main(user:widget.user),
    );
  }
}*/

class Dash_main extends StatefulWidget {
  String user;
  Dash_main({Key? key,required this.user}) : super(key: key);
  @override
  State<Dash_main> createState() => _Dash_mainState();
}

class _Dash_mainState extends State<Dash_main> with TickerProviderStateMixin{
  List<DateTime?> _calendar_value = [DateTime.now()];
  String initdt = '2023-06-19';
  String finaldt = DateTime.now().toString().substring(0,10);
  String? selectedValue = '*';
  String? selectedValue2 = '*';
  String? selectedValue3 = '*';
  TextEditingController cod_slim =TextEditingController();
  TextEditingController ML_pub = TextEditingController();
  TextEditingController Amzn_pub = TextEditingController();
  TextEditingController Shein_pub = TextEditingController();
  String ischecked = 'false';
  bool valor_checked = false;
   List<String> items = [
    '*',
    'MARKETING1',
    'Raul',
    'Xime',
    'Brenda',
    'MARKETING5',
    'Ariadna',
    'SELENE',
    'Victor Moneda'
  ];
  List<String> items2 = [
    '*',
    'Viry',
    'Diana',
    'Angel',
    'Yitzil',
    'Gerardo',
    'Yazmin'
  ];
  final List<String> items3 = [
    '*',
    'Levantar Caso',
    'Ajustar Titulo',
    'Mercado Envios',
    'EasyShip',
    'Video',
    'ADS',
    'Manual',
    'Revision',
    'Eliminar',
    'Extra'
  ];
  List<String> users_grid = <String>[];
  late final PlutoGridStateManager stateManager;
  List<tareas_dsgn> tasks=<tareas_dsgn>[];
  List<users_dsgn> usuarios = <users_dsgn>[];

  PlutoRow item_rowsRA(tareas_dsgn task){
    return PlutoRow(
        cells: {
          'ID':PlutoCell(value: task.id),
          'TOPIC':PlutoCell(value: task.topic),
          'DT':PlutoCell(value: task.dateCreated?.substring(0,19)),
          'CODIGO':PlutoCell(value: task.codigoSlim),
          'COD_DSC':PlutoCell(value: task.codDesc),
          'CANAL':PlutoCell(value: task.canal),
          'CHECKED':PlutoCell(value: task.checked),
          'USER_MKT':PlutoCell(value: task.uSERMKT),
          'STATUS_MKT':PlutoCell(value: task.statusMkt),
          'NOTA_MKT':PlutoCell(value: task.notaMkt),
          'WIP_MKT':PlutoCell(value: task.wipMkt),
          'USER_DGN':PlutoCell(value: task.uSERDGN),
          'STATUS_DGN':PlutoCell(value: task.statusDgn),
          'NOTA_DGN':PlutoCell(value: task.notaDgn),
          'WIP_DGN':PlutoCell(value: task.wipDgn),
          'DESC':PlutoCell(value: task.description),
          'COST':PlutoCell(value: task.cOSTOULTIMO),
          'PRECIO_ML':PlutoCell(value: task.pRECIOPUB),
          'PRECIO_AMZN':PlutoCell(value: task.precio_AMZN),
          'PRECIO_SHEIN':PlutoCell(value: task.precio_SHEIN),
          'PRIOR':PlutoCell(value: task.pRIORITY),
          'STOCK':PlutoCell(value: task.sTOCK),
          'CREATEDBY':PlutoCell(value: task.cREATEDBY),
          'TIPO_PUB':PlutoCell(value: task.tipoPublicacion),
          'PROVS':PlutoCell(value: task.nOTAYS),
          'A_CHECKED':PlutoCell(value: task.aREACHECKED),
          'A_CHECKEDBY':PlutoCell(value: task.aREACNAME),
          'TIPO':PlutoCell(value: task.tipo),
          'ML':PlutoCell(value: task.ML),
          'AMZN':PlutoCell(value: task.AMZN),
          'SHEIN':PlutoCell(value: task.SHEIN),
          'STATUS_FINAL':PlutoCell(value: task.status_final),
          'WIP_FINAL':PlutoCell(value: task.wip_final),
          'V30AMZ':PlutoCell(value: task.V30AMZ),
          'V30ML':PlutoCell(value: task.V30ML),
          'V30SHEIN':PlutoCell(value: task.V30SHEIN),
        });
  }
  PlutoRow item_rows(tareas_dsgn task){
    return PlutoRow(
        cells: {
          'ID':PlutoCell(value: task.id),
          'TOPIC':PlutoCell(value: task.topic),
          'DT':PlutoCell(value: task.dateCreated?.substring(0,19)),
          'CODIGO':PlutoCell(value: task.codigoSlim),
          'COD_DSC':PlutoCell(value: task.codDesc),
          'CANAL':PlutoCell(value: task.canal),
          'CHECKED':PlutoCell(value: task.checked),
          'USER_MKT':PlutoCell(value: task.uSERMKT),
          'STATUS_MKT':PlutoCell(value: task.statusMkt),
          'NOTA_MKT':PlutoCell(value: task.notaMkt),
          'WIP_MKT':PlutoCell(value: task.wipMkt),
          'USER_DGN':PlutoCell(value: task.uSERDGN),
          'STATUS_DGN':PlutoCell(value: task.statusDgn),
          'NOTA_DGN':PlutoCell(value: task.notaDgn),
          'WIP_DGN':PlutoCell(value: task.wipDgn),
          'DESC':PlutoCell(value: task.description),
          'COST':PlutoCell(value: task.cOSTOULTIMO),
          'PRECIO_ML':PlutoCell(value: task.pRECIOPUB),
          'PRECIO_AMZN':PlutoCell(value: task.precio_AMZN),
          'PRECIO_SHEIN':PlutoCell(value: task.precio_SHEIN),
          'PRIOR':PlutoCell(value: task.pRIORITY),
          'STOCK':PlutoCell(value: task.sTOCK),
          'CREATEDBY':PlutoCell(value: task.cREATEDBY),
          'TIPO_PUB':PlutoCell(value: task.tipoPublicacion),
          'PROVS':PlutoCell(value: task.nOTAYS),
          'A_CHECKED':PlutoCell(value: task.aREACHECKED),
          'A_CHECKEDBY':PlutoCell(value: task.aREACNAME),
          'TIPO':PlutoCell(value: task.tipo),
          'ML':PlutoCell(value: task.ML),
          'AMZN':PlutoCell(value: task.AMZN),
          'SHEIN':PlutoCell(value: task.SHEIN),
          'STATUS_FINAL':PlutoCell(value: task.status_final),
          'WIP_FINAL':PlutoCell(value: task.wip_final),
          'V30AMZ':PlutoCell(value: task.V30AMZ),
          'V30ML':PlutoCell(value: task.V30ML),
          'V30SHEIN':PlutoCell(value: task.V30SHEIN),
    });
  }
  PlutoRow item_rowsYazz(tareas_dsgn task){
    return PlutoRow(
        cells: {
          'ID':PlutoCell(value: task.id),
          'TOPIC':PlutoCell(value: task.topic),
          'DT':PlutoCell(value: task.dateCreated?.substring(0,19)),
          'CODIGO':PlutoCell(value: task.codigoSlim),
          'COD_DSC':PlutoCell(value: task.codDesc),
          'CANAL':PlutoCell(value: task.canal),
          'CHECKED':PlutoCell(value: task.checked),
          'USER_MKT':PlutoCell(value: task.uSERMKT),
          'STATUS_MKT':PlutoCell(value: task.statusMkt),
          'NOTA_MKT':PlutoCell(value: task.notaMkt),
          'WIP_MKT':PlutoCell(value: task.wipMkt),
          'USER_DGN':PlutoCell(value: task.uSERDGN),
          'STATUS_DGN':PlutoCell(value: task.statusDgn),
          'NOTA_DGN':PlutoCell(value: task.notaDgn),
          'WIP_DGN':PlutoCell(value: task.wipDgn),
          'DESC':PlutoCell(value: task.description),
          'PRECIO_ML':PlutoCell(value: task.pRECIOPUB),
          'PRECIO_AMZN':PlutoCell(value: task.precio_AMZN),
          'PRECIO_SHEIN':PlutoCell(value: task.precio_SHEIN),
          'PRIOR':PlutoCell(value: task.pRIORITY),
          'STOCK':PlutoCell(value: task.sTOCK),
          'CREATEDBY':PlutoCell(value: task.cREATEDBY),
          'TIPO_PUB':PlutoCell(value: task.tipoPublicacion),
          'PROVS':PlutoCell(value: task.nOTAYS),
          'A_CHECKED':PlutoCell(value: task.aREACHECKED),
          'A_CHECKEDBY':PlutoCell(value: task.aREACNAME),
          'TIPO':PlutoCell(value: task.tipo),
          'ML':PlutoCell(value: task.ML),
          'AMZN':PlutoCell(value: task.AMZN),
          'SHEIN':PlutoCell(value: task.SHEIN),
          'STATUS_FINAL':PlutoCell(value: task.status_final),
          'WIP_FINAL':PlutoCell(value: task.wip_final),
          'V30AMZ':PlutoCell(value: task.V30AMZ),
          'V30ML':PlutoCell(value: task.V30ML),
          'V30SHEIN':PlutoCell(value: task.V30SHEIN),
        });
  }

  void handleSelected() async {
    String value = '';
    for (var element in stateManager.currentSelectingRows) {
      final cellValue = element.cells.entries.first.value.value.toString();
      print(element.cells["ID"]!.value);
      designmkt_class().update_tasks('CHECKED',true,element.cells["ID"]!.value);
      value += 'first cell value of row: $cellValue\n';
    }
    stateManager.removeRows(stateManager.currentSelectingRows);
    if (value.isEmpty) {
      value = 'No rows are selected.';
    }
    print(value);
  }
  void handleRemoveSelectedRowsButton() {
    for (var element in stateManager!.currentSelectingRows) {
      designmkt_class().delete_tasks(element.cells["ID"]!.value);
    }
    stateManager.removeRows(stateManager.currentSelectingRows);
  }
  void handleReturnRows(){
    for (var element in stateManager!.currentSelectingRows) {
      designmkt_class().update_tasks('CHECKED',false,element.cells["ID"]!.value);
    }
    stateManager.removeRows(stateManager.currentSelectingRows);
  }
  List<PlutoRow> row_s = <PlutoRow>[];
  void tabChanged() {
    current.value = tabController.index;
  }
  String valor_group = 'Nuevo';

  void getdata(String idt,String fdt,String Ischecked,String finder){
    designmkt_class().gettask(idt,fdt,Ischecked,widget.user,finder).then((value) {
      setState(() {
        tasks.addAll(value);
        tasks.forEach((element) {
          if( widget.user=='17'||
              widget.user=='14'||widget.user=='3'||
              widget.user=='16'||widget.user=='20'||
              widget.user=='101'|| widget.user=='38'||
              widget.user=='1057'||widget.user=='33'||
              widget.user=='29'||widget.user=='31'
          ){
            row_s.add(item_rowsRA(element));
          }
          if(widget.user=='200'){
            row_s.add(item_rowsYazz(element));
          }
          if(widget.user=='103'||widget.user=='121'||widget.user=='100') {
            row_s.add(item_rows(element));
          }
        });
        _updatemanager();
      });
    });
  }

  late Timer timers;
  @override
  void initState() {
    print(widget.user);
    if(
    widget.user=='17'||
    widget.user=='14'||widget.user=='3'||
    widget.user=='16'||widget.user=='20'||
    widget.user=='101'|| widget.user=='38'||
    widget.user=='1057'
    ){
      setState(() {
        colums=Petercolumn;
        items = ['*','SELENE'];
        items2 = ['*','Yazmin'];
      });
    }
    if(widget.user=='33'||widget.user=='29'||widget.user=='31'){
      setState(() {
        colums = Alecolumn;
        items = ['*','SELENE'];
        items2 = ['*','Yazmin'];
      });
    }

    if(widget.user=='200'){
      setState(() {
        colums=yazzcolumn;
      });
    }

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
        //print(value);
        setState(() {
          valor_group = value.toString();
        });
      }
    });
    Users_mkt().getUSRS().then((value){
      setState(() {
        usuarios.addAll(value);
        filterlist = usuarios;
      });
    });
    getdata(initdt,finaldt, ischecked,'*');
    //----------
    timers = new Timer.periodic(
        Duration(minutes: 5),
            (timer) {
              row_s.clear();
              tasks.clear();
              getdata(initdt,finaldt,ischecked,'*');
            });

  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final customController = CustomGroupController(
    isMultipleSelection: false,
    initSelectedItem: "Nuevo",
  );
  final List<String> drawerItems = [
    "Nuevo",
    "Republicar",
    "Mejora",
    "Portada",
    "Rehacer",
    "Publicar",
    "Adicional",
    "Variante"
  ];
  ValueNotifier<int> current = ValueNotifier(0);
  late TabController tabController;

  bool val_NL =false;
  bool val_AMZ = false;
  bool val_SHEIN = false;
  bool val_switcher = false;
  /*bool pros_dis = false;
  bool pros_mkt = false;*/
  List<users_dsgn> filterlist = <users_dsgn>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 25,),
            Container(
              decoration: BoxDecoration(color: Colors.black),
                child: Text('Agregar tarea',style: TextStyle(color: Colors.white),)),
            Row(children: [
              Expanded(child: Text('CODIGO')),
              Expanded(child:
              TextField(
                controller: cod_slim,
                onSubmitted: (val) async {
                  List<tareas_dsgn> tasks_exist=<tareas_dsgn>[];
                 await designmkt_class().gettask('*','*','both',widget.user,val).then((value) {
                  setState(() {
                    tasks_exist.addAll(value);
                  });
                  });
                  await showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      content:Container(
                            height:400,
                            width: 400,
                            color: Colors.white,
                            child:tasks_exist.length>0?
                            ListView.builder(
                                  itemCount: tasks_exist.length,
                                  itemBuilder: (BuildContext context,index){
                                    return ListTile(
                                      tileColor: Colors.grey,
                                      focusColor: Colors.blue,
                                      title: Text(tasks_exist[index].topic!),
                                      subtitle: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Created by: '+tasks_exist[index].cREATEDBY!),
                                          Text('Usuario Asignado: '+tasks_exist[index].uSERMKT!),
                                          Text('Fecha: '+tasks_exist[index].dateCreated!),
                                        ],
                                      ),
                                    );
                                  }):Center(child: Container(child: Text('No hay tareas con los criterios de busqueda'),color: Colors.white,),),
                        )
                      );
                  });
                },
              ),flex: 2,)
            ],),
            SizedBox(height: 10,),
            ValueListenableBuilder(
              valueListenable: current,
              builder: (ctx,value, _){
                return CustomGroupedCheckbox<String>(
                  controller: customController,
                  itemBuilder: (ctx, index, isSelected, isDisabled) {
                    return ListTile(
                      tileColor: value == index ? Colors.green : null,
                      title: Text(
                        drawerItems[index],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      leading:value==index ? Icon(Icons.check_box):Icon(Icons.check_box_outline_blank_rounded),
                    );
                  },
                  itemExtent: 40,
                  values: drawerItems,
                );
              },
            ),
            Visibility(
              child: Container(
                child: Text('Sublinea',style: TextStyle(
                    color: Colors.white),),
                color: Colors.black,),
              visible: valor_group=='Nuevo',),
            Visibility(child:
            Row(
              //mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Accesorio'),
                Switch(
                  inactiveTrackColor: Colors.black,
                 inactiveThumbColor: Colors.green,
                 activeColor: Colors.black,
                 activeTrackColor: Colors.green,
                 value: val_switcher,
                 onChanged: (val){
                   setState(() {
                     val_switcher = val;
                   });
                }),
                Text('Refaccion'),
              ],
            ),visible: valor_group=='Nuevo',),
            Visibility(child: Container(child: Text('Casos',
              style: TextStyle(color: Colors.white),),color: Colors.black,),visible: valor_group=='Adicional',),
            Visibility(
              child: DropdownButtonHideUnderline(
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
                          'Agregar Tarea Adicional',
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
                  items: items3
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
                  value: selectedValue3,
                  onChanged: (value) {
                    setState(() {
                      selectedValue3 = value as String;
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
              visible: valor_group=='Adicional',
            ),
            Visibility(child: Container(child: Text('Marketplaces',style: TextStyle(color: Colors.white),),color: Colors.black,),visible: valor_group!='Nuevo',),
            Visibility(
              child: CheckboxListTile(value: val_NL,
                  title: Text('Mercado Libre'),
                  subtitle: Visibility(child: TextField(controller: ML_pub,),visible: switcher_publicaciones(valor_group!)),
                  onChanged: (bool? val){
                  setState(() {
                    val_NL = val!;
                  });
                }),
              visible: valor_group!='Nuevo',
            ),
            Visibility(
              child: CheckboxListTile(value: val_AMZ,
                  title: Text('Amazon'),
                  subtitle: Visibility(child: TextField(controller: Amzn_pub,),visible: switcher_publicaciones(valor_group!)),
                  onChanged: (bool? val){
                    setState(() {
                      val_AMZ = val!;
                    });
                  }),
              visible: valor_group!='Nuevo',
            ),
            Visibility(
              child: CheckboxListTile(value: val_SHEIN,
                  title: Text('Shein'),
                  subtitle: Visibility(child: TextField(controller: Shein_pub,),visible: switcher_publicaciones(valor_group!)),
                  onChanged: (bool? val){
                setState(() {
                  val_SHEIN = val!;
                });
                  }),
              visible: valor_group!='Nuevo',
            ),
            Container(child: Text('Marketing',style: TextStyle(color: Colors.white),),color: Colors.black,),
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
                items: items
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
            Container(child: Text('Diseño',style: TextStyle(color: Colors.white),),color: Colors.black,),
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
                items: items2
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
                value: selectedValue2,
                onChanged: (value) {
                  setState(() {
                    selectedValue2 = value as String;
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
            TextButton(onPressed: (){
             topic_task(valor_group);
              setState(() {
                selectedValue = '*';
                selectedValue2 = '*';
              });
              _scaffoldKey.currentState?.closeEndDrawer();
            }, child: Text('Crear tarea'))
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Menu(user: widget.user)), (Route<dynamic> route) => false);
          setState(() {
            timers.cancel();
          });
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Row(
          children: [
            Text('TAREAS DISEÑO'),
            SizedBox(width: 20,),
            Visibility(
              child: TextButton(onPressed: (){
                handleSelected();
              }, child: Text('Revisar\nTareas',style: TextStyle(color: Colors.white),), ),
              visible: _switcherpermisionschecked(),
            ),
            SizedBox(width: 20,),
            Visibility(
              child: TextButton(onPressed: (){
                handleRemoveSelectedRowsButton();
              }, child: Text('Eliminar\nTareas',style: TextStyle(color: Colors.white),), ),
              visible: _switcherpermisonsdelete(),
            ),
            SizedBox(width: 20,),
            TextButton(onPressed: ()async{
              await showDialog(context: context, builder: (BuildContext context){
                return Center(
                    child: Container(
                      height:450,
                      width: 500,
                        child:Card(child: _calendar())),
                  );
              });
            }, child: Text('Filtrar\nPor Fecha',style: TextStyle(color: Colors.white),)),
            Column(children: [
              Text(initdt,style: TextStyle(fontSize: 12),),
              Text(finaldt,style: TextStyle(fontSize: 12),),
            ],),
            SizedBox(width: 20,),
            Column(children: [
              Text('Revisados',style: TextStyle(fontSize: 12),),
              Checkbox(value: valor_checked,
                  fillColor: MaterialStateProperty.all(Colors.white),
                  checkColor: Colors.black,
                  onChanged: (bool? val){
                    setState(() {
                      valor_checked = val!;
                      if(valor_checked ==false){
                        ischecked = 'false';
                      }else{
                        ischecked = 'true';
                      }
                    });
                    row_s.clear();
                    tasks.clear();
                    getdata(initdt,finaldt,ischecked,'*');
                  })
            ],),
            SizedBox(width: 20,),
            Visibility(
              visible: valor_checked,
                child:TextButton(
               onPressed: (){
                handleReturnRows();
            },
            child: Text('Retornar\nTarea',style: TextStyle(color: Colors.white),))),
          ],
        ),
        actions: [
  IconButton(onPressed: (){
    _scaffoldKey.currentState?.openEndDrawer();
  }, icon: Icon(Icons.menu))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: PlutoGrid(
                    columns: colums,
                    rows: row_s,
                  onChanged: (PlutoGridOnChangedEvent event) {
                    switch(event.column.field) {
                      case'USER_MKT':
                        designmkt_class().update_tasks('USER_MKT',getuser(event.value),event.row.cells["ID"]!.value);
                        break;
                      case'USER_DGN':
                        designmkt_class().update_tasks('USER_DGN',getuser(event.value),event.row.cells["ID"]!.value);
                        break;
                      case'DESC':
                        print(event.value);
                        designmkt_class().update_tasks('DESC',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'ML':
                        print(event.value);
                        designmkt_class().update_tasks('ML',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'AMZN':
                        print(event.value);
                        designmkt_class().update_tasks('AMZN',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'SHEIN':
                        print(event.value);
                        designmkt_class().update_tasks('SHEIN',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'PRECIO_ML' :
                        print(event.value);
                        designmkt_class().update_tasks('PRECIO_ML',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'TIPO_PUB':
                        print(event.value);
                        designmkt_class().update_tasks('TIPO_PUB',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'STATUS_DGN':
                        print(event.value);
                        designmkt_class().update_tasks('STATUS_DGN',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'STATUS_MKT':
                        print(event.value);
                        designmkt_class().update_tasks('STATUS_MKT',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'STATUS_FINAL':
                        print(event.value);
                        designmkt_class().update_tasks('STATUS_FINAL',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'PRIOR':
                        print(event.value);
                        designmkt_class().update_tasks('PRIOR',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'PROVS':
                        print(event.value);
                        designmkt_class().update_tasks('NOTAYS',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'A_CHECKED':
                        print(event.value);
                        designmkt_class().update_tasks('A_CHECKED',event.value=='REVISADO'?true:false,event.row.cells["ID"]!.value);
                        designmkt_class().update_tasks('AC_CHECKED',widget.user,event.row.cells["ID"]!.value);
                        break;
                      case'TIPO':
                        print(event.value);
                        designmkt_class().update_tasks('TIPO',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'PRECIO_ML':
                        print(event.value);
                        designmkt_class().update_tasks('PRECIO_ML',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'PRECIO_AMZN':
                        print(event.value);
                        designmkt_class().update_tasks('PRECIO_AMZN',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'PRECIO_SHEIN':
                        print(event.value);
                        designmkt_class().update_tasks('PRECIO_SHEIN',event.value,event.row.cells["ID"]!.value);
                        break;
                    }
                  },
                  onSelected: (PlutoGridOnSelectedEvent vnt){

                  },
                  onLoaded: (PlutoGridOnLoadedEvent vnt){
                      stateManager = vnt.stateManager;
                      vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                      stateManager.setShowColumnFilter(true);
                  },
                  configuration: const PlutoGridConfiguration(localeText:PlutoGridLocaleText.spanish()),

                )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            row_s.clear();
            tasks.clear();
            getdata(initdt, finaldt,ischecked,'*');
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.refresh,color: Colors.white,)),
    );
  }

  getuser(String name){
    int user_id=0;
    usuarios = filterlist.where((element){
      var searcher = element.name;
      return searcher==name;
    }).toList();
    user_id = usuarios[0].id!;
    print(user_id);
    return user_id;
  }

  topic_task(String topic){
    switch(topic){
      case 'Nuevo':
        users_due(topic,'*','*','*','*',val_switcher==false?'Accesorios':'Refacciones');
        //users_due('*','Nuevo','*');
        break;
      case 'Adicional':
        List<String> mktplaces=[];
        String ML = '*';
        String AMZN = '*';
        String SHEIN = '*';
       if(selectedValue3 !='*'){
         if(val_NL ==true){
           ML = ML_pub.text;
           mktplaces.add('Mercado Libre');
           //users_due(ML_pub.text,selectedValue3!,'Mercado Libre');
         }
         if(val_AMZ==true){
           AMZN = Amzn_pub.text;
           //users_due(Amzn_pub.text,selectedValue3!,'Amazon');
           mktplaces.add('Amazon');
         }
         if(val_SHEIN==true){
           SHEIN = Shein_pub.text;
           //users_due(Shein_pub.text,selectedValue3!,'SHEIN');
           mktplaces.add('SHEIN');
         }
         /*if(val_NL ==false&&val_AMZ==false&&val_SHEIN==false){
           //users_due('*',selectedValue3!,'*');
         }*/
         users_due(selectedValue3!,mktplaces.isEmpty?'':mktplaces.toString(), ML, AMZN, SHEIN,'*');
       }
        break;
      default:
        List<String> mktplaces=[];
        String ML = '*';
        String AMZN = '*';
        String SHEIN = '*';
        if(val_NL ==true){
          ML = ML_pub.text;
          mktplaces.add('Mercado Libre');
          //users_due(ML_pub.text,selectedValue3!,'Mercado Libre');
        }
        if(val_AMZ==true){
          AMZN = Amzn_pub.text;
          //users_due(Amzn_pub.text,selectedValue3!,'Amazon');
          mktplaces.add('Amazon');
        }
        if(val_SHEIN==true){
          SHEIN = Shein_pub.text;
          //users_due(Shein_pub.text,selectedValue3!,'SHEIN');
          mktplaces.add('SHEIN');
        }
        /*if(val_NL ==false&&val_AMZ==false&&val_SHEIN==false){
           //users_due('*',selectedValue3!,'*');
         }*/
        users_due(topic,mktplaces.isEmpty?'':mktplaces.toString(), ML, AMZN, SHEIN,'*');
      break;
    }
  }


  users_due(String top,String canal,String ML,String AMZN,String SHEIN,String tipo){
    if(selectedValue != '*'||selectedValue2 != '*'){
      add_new_TSK(selectedValue2=='*'?0:getuser(selectedValue2!),selectedValue=='*'?0:getuser(selectedValue!),top,canal,widget.user,ML,AMZN,SHEIN,tipo);
    }
    /*if(selectedValue != '*'){
      add_new_TSK(getuser(selectedValue!),pub,top,'Marketing',canal,widget.user,top=='Nuevo'?switcher_news('Marketing'):top);
    }
    if(selectedValue2 != '*'){
      add_new_TSK(getuser(selectedValue2!),pub,top,'Diseño',canal,widget.user,top=='Nuevo'?switcher_news('Diseño'):top);
    }*/
  }

  add_new_TSK(int USER_DGN,int USER_MKT,String TOPIC,String CANAL,String user,String ML,String AMZN,String SHEIN,String tipo) async {
     var url = Uri.parse('http://45.56.74.34:6660/addDSGNMKT?TOPIC=${TOPIC}&CODIGO=${cod_slim.text}&USER_DGN=${USER_DGN}&USER_MKT=${USER_MKT}&CANAL=${CANAL}&CREATEDBY=${user}&ML=${ML}&AMZN=${AMZN}&SHEIN=${SHEIN}&TIPO=${tipo}');
     var response = await http.post(url);
    if (response.statusCode == 200) {
      toast_dsgn('Tarea Creada', true);
    }
    else {
      toast_dsgn('ERROR AR CREAR TAREA', false);
    }
  }

  /*switcher_news(String DEPTO){
    String them_topic='';
      if(DEPTO == 'Diseño'){
        if(pros_dis ==true){
          them_topic='Fotos,Investigacion,Diseño';
        }
      }else{
        if(pros_mkt ==true){
          them_topic='Branding,Imagenes,Descripcion';
        }
      }
      return them_topic;
  }*/


  delete_tasks(int id_task)async{
    var request = http.Request('GET', Uri.parse('http://45.56.74.34:6660/deleteTSKS?ID=${id_task}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  switcher_publicaciones(String topic){
    bool value= false;
    if(topic =='Portada'||topic=='Mejora'||topic=='Adicional'||topic=='Variante'){
      value = true;
    }
    return value;
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
            row_s.clear();
            tasks.clear();
            getdata(initdt,finaldt,ischecked,'*');
          });
        },
        onCancelTapped: (){
          initdt = DateTime.now().toString().substring(0,10);
          finaldt =DateTime.now().toString().substring(0,10);
          setState(() {
            row_s.clear();
            tasks.clear();
            getdata(initdt,finaldt,ischecked,'*');
          },
          );
        });
  }
 _updatemanager(){
   print(colums.length.toString()+'-'+row_s.length.toString());
    setState(() {
      PlutoGridStateManager.initializeRowsAsync(colums,row_s).then((value){
        stateManager.refColumns.addAll(colums);
        stateManager.refRows.addAll(value);
        stateManager.setShowLoading(true);
      });
    });
  }
  _switcherpermisionschecked(){
    bool value=false;
    if(
    widget.user=='103'||
        widget.user=='121'||widget.user=='100'||
        widget.user=='200'
    ){
      setState(() {
        value = true;
      });
    }
    return value;
  }
  _switcherpermisonsdelete(){
    bool value=false;
    if(
    widget.user=='103'||
    widget.user=='121'||widget.user=='100'||
    widget.user=='200'
    ){
      setState(() {
        value = true;
      });
    }
    return value;
 }


}


class ContextTop extends StatefulWidget{
  String CoDSlim;
  String topic;
  String canal;
  ContextTop({Key? key,required this.CoDSlim,required this.topic,required this.canal});

  @override
  State<ContextTop> createState() => _ContextTop();
}

class _ContextTop extends State<ContextTop>{

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(1.0),
      child: ContextMenuArea(
          child:Text(widget.topic),
          builder: (context)=>[
            ListTile(
              title: Text('Areas'),
              onTap: (){
                Dialog(context);
              },
            ),
            ListTile(
              title: Text('Visualizar Publicacion'),
              onTap: (){
                switch(widget.canal){
                  case'SHEIN':

                    break;
                  case'Mercado Libre':
                    //_launchURL('https://articulo.mercadolibre.com.mx/MLM-${widget.pub.substring(3,widget.pub.length)}');
                    break;
                  case'Amazon':
                   // _launchURL('https://www.amazon.com.mx/dp/${widget.pub}');
                    break;
                }
              },
            ),
          ]
      ),
    );
  }
  void Dialog(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return Dta_table(CoDSlim: widget.CoDSlim,);
        });
  }
  _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se puede abrir $url';
    }
  }


}

class Dta_table extends StatefulWidget {
  String CoDSlim;
   Dta_table({Key? key,required this.CoDSlim}) : super(key: key);

  @override
  State<Dta_table> createState() => _Dta_tableState(CoDSlim: CoDSlim);
}

class _Dta_tableState extends State<Dta_table> {
  String CoDSlim;

  _Dta_tableState({required this.CoDSlim});

  List<areas_stock> stock=<areas_stock>[];
  void initState() {
    Stock_getter().getStock(CoDSlim).then((value){
      setState(() {
        stock.addAll(value);
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
        title: Text('Mercado Libre'),
        content:
        DataTable(columns: [
          DataColumn(label: Text('Cod Slim')),
          DataColumn(label: Text('STOCK')),
          DataColumn(label: Text('ML')),
          DataColumn(label: Text('AMZN')),
          DataColumn(label: Text('SHEIN')),
          //DataColumn(label: Text('DISEÑO')),
        ], rows: stock.map((pub) =>
            DataRow(cells: [
              DataCell(SelectableText(pub.cODIGO!)),
              DataCell(Text(pub.sTOCK.toString())),
              DataCell(Text(pub.mL.toString())),
              DataCell(Text(pub.aMZN.toString())),
              DataCell(Text(pub.sHEIN.toString())),
              //DataCell(Text(pub.dISEO.toString())),
            ])
        ).toList(),
        )
    );
  }
}

/*class User_mktdsgn extends StatefulWidget {
  String user;
  User_mktdsgn({required this.user,Key? key}) : super(key: key);

  @override
  State<User_mktdsgn> createState() => _User_mktdsgnState();
}

class _User_mktdsgnState extends State<User_mktdsgn> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xFF000000))),
        home: users_dsgn_tasks(user:widget.user),
    );
  }
}*/

class users_dsgn_tasks extends StatefulWidget {
  String user;
   users_dsgn_tasks({required this.user,Key? key}) : super(key: key);

  @override
  State<users_dsgn_tasks> createState() => _users_dsgnState();
}

class _users_dsgnState extends State<users_dsgn_tasks> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<users_task> tasks = <users_task>[];
  List<PlutoRow> row_s = <PlutoRow>[];
  List<DateTime?> _calendar_value = [DateTime.now()];
  String initdt = '2023-06-19';
  String finaldt = DateTime.now().toString().substring(0,10);
  String ischecked = 'false';
  bool valor_checked = false;
  List<users_dsgn> usuarios = <users_dsgn>[];
  List<users_dsgn> filterlist = <users_dsgn>[];
  late final PlutoGridStateManager stateManager;
  late Timer timers;
  String? selectedValue = '*';
  String? selectedValue2 = '*';
  String? selectedValue3 = '*';
  TextEditingController cod_slim =TextEditingController();
  TextEditingController ML_pub = TextEditingController();
  TextEditingController Amzn_pub = TextEditingController();
  TextEditingController Shein_pub = TextEditingController();
  bool val_switcher = false;
  final customController = CustomGroupController(
    isMultipleSelection: false,
    initSelectedItem: "Nuevo",
  );
  final List<String> drawerItems = [
    "Nuevo",
    "Republicar",
    "Mejora",
    "Portada",
    "Rehacer",
    "Publicar",
    "Adicional",
    "Variante"
  ];
  List<String> items = [
    '*',
    'MARKETING1',
    'Raul',
    'Xime',
    'Brenda',
    'MARKETING5',
    'Ariadna',
    'SELENE'
  ];
  List<String> items2 = [
    '*',
    'Viry',
    'Diana',
    'Angel',
    'Yitzil',
    'Gerardo',
    'Yazmin'
  ];
  final List<String> items3 = [
    '*',
    'Levantar Caso',
    'Ajustar Titulo',
    'Mercado Envios',
    'EasyShip',
    'Video',
    'ADS',
    'Manual',
    'Revision',
    'Eliminar',
    'Extra'
  ];
  ValueNotifier<int> current = ValueNotifier(0);
  late TabController tabController;
  bool val_NL =false;
  bool val_AMZ = false;
  bool val_SHEIN = false;
  bool pros_dis = false;
  bool pros_mkt = false;

  @override
  PlutoRow item_rowsDGN(users_task task){
    return PlutoRow(
        cells: {
          'ID':PlutoCell(value: task.id),
          'TOPIC':PlutoCell(value: task.topic),
          'DT':PlutoCell(value: task.dateCreated?.substring(0,19)),
          'PROVS':PlutoCell(value: task.proveedor),
          'CODIGO':PlutoCell(value: task.codigoSlim),
          'COD_DSC':PlutoCell(value: task.codDesc),
          'CANAL':PlutoCell(value: task.canal),
          'CHECKED':PlutoCell(value: task.checked),
          'USER_DGN':PlutoCell(value: task.userDiseO),
          'USER_MKT':PlutoCell(value: task.userMarketing),
          'DESC':PlutoCell(value: task.description),
          'PRECIO_ML':PlutoCell(value: task.pRECIOPUB),
          'PRECIO_AMZN':PlutoCell(value: task.precio_AMZN),
          'PRECIO_SHEIN':PlutoCell(value: task.precio_SHEIN),
          'STOCK':PlutoCell(value: task.sTOCK),
          'CREATEDBY':PlutoCell(value: task.cREATEDBY),
          'TIPO_PUB':PlutoCell(value: task.tipoPublicacion),
          'PRIOR':PlutoCell(value: task.pRIORITY),
          'STATUS_DGN':PlutoCell(value: task.statusDgn),
          'STATUS_MKT':PlutoCell(value: task.statusMkt),
          'STATUS_FINAL':PlutoCell(value: task.statusFinal),
          'NOTA_DGN':PlutoCell(value: task.notaDgn),
          'NOTA_MKT':PlutoCell(value: task.notaMkt),
          'WIP_DGN':PlutoCell(value: task.wipDgn),
          'WIP_MKTING':PlutoCell(value: task.wipMkt),
          'WIP_FINAL':PlutoCell(value: task.wipFinal),
          'TIPO':PlutoCell(value: task.tipo),
          'ML':PlutoCell(value: task.mL),
          'AMZN':PlutoCell(value: task.aMZN),
          'SHEIN':PlutoCell(value: task.sHEIN),
        });
  }
  //------------
  PlutoRow item_rowsMKT(users_task task){
    return PlutoRow(
        cells: {
          'ID':PlutoCell(value: task.id),
          'TOPIC':PlutoCell(value: task.topic),
          'DT':PlutoCell(value: task.dateCreated?.substring(0,19)),
          'PROVS':PlutoCell(value: task.proveedor),
          'CODIGO':PlutoCell(value: task.codigoSlim),
          'COD_DSC':PlutoCell(value: task.codDesc),
          'CANAL':PlutoCell(value: task.canal),
          'CHECKED':PlutoCell(value: task.checked),
          'USER_DGN':PlutoCell(value: task.userDiseO),
          'USER_MKT':PlutoCell(value: task.userMarketing),
          'DESC':PlutoCell(value: task.description),
          'PRECIO_ML':PlutoCell(value: task.pRECIOPUB),
          'PRECIO_AMZN':PlutoCell(value: task.precio_AMZN),
          'PRECIO_SHEIN':PlutoCell(value: task.precio_SHEIN),
          'STOCK':PlutoCell(value: task.sTOCK),
          'CREATEDBY':PlutoCell(value: task.cREATEDBY),
          'TIPO_PUB':PlutoCell(value: task.tipoPublicacion),
          'PRIOR':PlutoCell(value: task.pRIORITY),
          'STATUS_DGN':PlutoCell(value: task.statusDgn),
          'STATUS_MKT':PlutoCell(value: task.statusMkt),
          'STATUS_FINAL':PlutoCell(value: task.statusFinal),
          'NOTA_DGN':PlutoCell(value: task.notaDgn),
          'NOTA_MKT':PlutoCell(value: task.notaMkt),
          'WIP_DGN':PlutoCell(value: task.wipDgn),
          'WIP_MKTING':PlutoCell(value: task.wipMkt),
          'WIP_FINAL':PlutoCell(value: task.wipFinal),
          'TIPO':PlutoCell(value: task.tipo),
          'ML':PlutoCell(value: task.mL),
          'AMZN':PlutoCell(value: task.aMZN),
          'SHEIN':PlutoCell(value: task.sHEIN),
        });
  }


  void getdata(String USER,String INIT,String CHECKED,String FINAL){
    users_dsgn_tsk().getdata(USER, CHECKED, INIT,FINAL).then((value){
      setState(() {
        tasks.addAll(value);
        tasks.forEach((element) {
          if(widget.user=='212'||widget.user=='213'||widget.user=='214'||widget.user=='221'){
            row_s.add(item_rowsMKT(element));
          }else{
            row_s.add(item_rowsDGN(element));
          }
        });
        _updatemanager();
      });
    });
  }

  void handleRemoveSelectedRowsButton() {
    for (var element in stateManager!.currentSelectingRows) {
      //event.row.cells["ID"]!.value
      designmkt_class().update_tasks('STATUS','Completado',element.cells["ID"]!.value);
    }
    stateManager.removeRows(stateManager.currentSelectingRows);
  }

  @override
  void initState() {
    if(widget.user=='212'||widget.user=='213'||widget.user=='214'||widget.user=='221'){
      setState(() {
        colums_DGN = colums_MKT;
      });
    }
    Users_mkt().getUSRS().then((value){
      setState(() {
        usuarios.addAll(value);
        filterlist = usuarios;
      });
    });
    getdata(widget.user,initdt,ischecked, finaldt);
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
    super.initState();
    timers = new Timer.periodic(
        Duration(minutes: 5),
            (timer) {
          row_s.clear();
          tasks.clear();
          getdata(widget.user,initdt,ischecked,finaldt);
        });
    switch(widget.user){
      case'212':setState(() {
        items = ['*','Raul'];
      });break;
      case'213':setState(() {
        items = ['*','Xime'];
      });break;
      case'214':setState(() {
        items = ['*','Brenda'];
      });break;
      case'221':setState(() {
        items = ['*','Ariadna'];
      });break;
    }
  }
  void tabChanged() {
    current.value = tabController.index;
  }
  String valor_group = 'Nuevo';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Menu(user: widget.user)), (Route<dynamic> route) => false);
          setState(() {
            timers.cancel();
          });
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        actions: [
          Visibility(
            visible: allow2create(),
            child: IconButton(onPressed: (){
              _scaffoldKey.currentState?.openEndDrawer();
            }, icon: Icon(Icons.menu)),
          )
        ],
        title: Row(
          children: [
            Text('TAREAS DISEÑO-MKT'),
            SizedBox(width: 20,),
            /*TextButton(onPressed: (){
                handleRemoveSelectedRowsButton();
              }, child: Text('Completar\nTareas',style: TextStyle(color: Colors.white),), ),
            SizedBox(width: 20,),*/
            TextButton(onPressed: ()async{
              await showDialog(context: context, builder: (BuildContext context){
                return Center(
                  child: Container(
                      height:450,
                      width: 500,
                      child:Card(child: _calendar())),
                );
              });
            }, child: Text('Filtrar\nPor Fecha',style: TextStyle(color: Colors.white),)),
            Column(children: [
              Text(initdt,style: TextStyle(fontSize: 12),),
              Text(finaldt,style: TextStyle(fontSize: 12),),
            ],),
            SizedBox(width: 20,),
            Column(
              children: [
              Text('Revisados',style: TextStyle(fontSize: 12),),
              Checkbox(value: valor_checked,
                  fillColor: MaterialStateProperty.all(Colors.white),
                  checkColor: Colors.black,
                  onChanged: (bool? val){
                    setState(() {
                      valor_checked = val!;
                      if(valor_checked ==false){
                        ischecked = 'false';
                      }else{
                        ischecked = 'true';
                      }
                    });
                    row_s.clear();
                    tasks.clear();
                    getdata(widget.user,initdt,ischecked,finaldt);
                  })
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: PlutoGrid(
                  columns: colums_DGN,
                  rows: row_s,
                  onChanged: (PlutoGridOnChangedEvent event) {
                    //event.row.cells["ID"]!.value;
                    switch(event.column.field) {
                      case'USER_MKT':
                        designmkt_class().update_tasks('USER_MKT',getuser(event.value),event.row.cells["ID"]!.value);
                        break;
                      case'USER_DGN':
                        designmkt_class().update_tasks('USER_DGN',getuser(event.value),event.row.cells["ID"]!.value);
                        break;
                      case'DESC':
                        print(event.value);
                        designmkt_class().update_tasks('DESC',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'ML':
                        print(event.value);
                        designmkt_class().update_tasks('ML',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'AMZN':
                        print(event.value);
                        designmkt_class().update_tasks('AMZN',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'SHEIN':
                        print(event.value);
                        designmkt_class().update_tasks('SHEIN',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'PRECIO_P' :
                        print(event.value);
                        designmkt_class().update_tasks('PRECIO_P',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'TIPO_PUB':
                        print(event.value);
                        designmkt_class().update_tasks('TIPO_PUB',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'STATUS_DGN':
                        print(event.value);
                        designmkt_class().update_tasks('STATUS_DGN',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'STATUS_MKT':
                        print(event.value);
                        designmkt_class().update_tasks('STATUS_MKT',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'STATUS_FINAL':
                        print(event.value);
                        designmkt_class().update_tasks('STATUS_FINAL',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'PRIOR':
                        print(event.value);
                        designmkt_class().update_tasks('PRIOR',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'PROVS':
                        print(event.value);
                        designmkt_class().update_tasks('NOTAYS',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'A_CHECKED':
                        print(event.value);
                        designmkt_class().update_tasks('A_CHECKED',event.value=='REVISADO'?true:false,event.row.cells["ID"]!.value);
                        designmkt_class().update_tasks('AC_CHECKED',widget.user,event.row.cells["ID"]!.value);
                        break;
                      case'TIPO':
                        print(event.value);
                        designmkt_class().update_tasks('TIPO',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'WIP_DGN':
                        print(event.value);
                        designmkt_class().update_tasks('WIP_DGN',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'WIP_MKTING':
                        print(event.value);
                        designmkt_class().update_tasks('WIP_MKTING',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'WIP_FINAL':
                        print(event.value);
                        designmkt_class().update_tasks('WIP_FINAL',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'NOTA_MKT':
                        print(event.value);
                        designmkt_class().update_tasks('NOTA_MKT',event.value,event.row.cells["ID"]!.value);
                        break;
                      case'NOTA_DGN':
                        print(event.value);
                        designmkt_class().update_tasks('NOTA_DGN',event.value,event.row.cells["ID"]!.value);
                        break;

                    }
                  },
                  onSelected: (PlutoGridOnSelectedEvent vnt){

                  },
                  onLoaded: (PlutoGridOnLoadedEvent vnt){
                    stateManager = vnt.stateManager;
                    vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                    stateManager.setShowColumnFilter(true);
                  },
                  configuration: const PlutoGridConfiguration(localeText:PlutoGridLocaleText.spanish()),
                )
            ),
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
            onPressed: (){
              row_s.clear();
              tasks.clear();
              getdata(widget.user,initdt,ischecked, finaldt);
            },
            backgroundColor: Colors.black,
            child: Icon(Icons.refresh,color: Colors.white,)),
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 25,),
            Container(
                decoration: BoxDecoration(color: Colors.black),
                child: Text('Agregar tarea',style: TextStyle(color: Colors.white),)),
            Row(children: [
              Expanded(child: Text('CODIGO')),
              Expanded(child:
              TextField(
                controller: cod_slim,
                onSubmitted: (val) async {
                  List<tareas_dsgn> tasks_exist=<tareas_dsgn>[];
                  await designmkt_class().gettask('*','*','both',widget.user,val).then((value) {
                    setState(() {
                      tasks_exist.addAll(value);
                    });
                  });
                  await showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                        content:Container(
                          height:400,
                          width: 400,
                          color: Colors.white,
                          child:tasks_exist.length>0?
                          ListView.builder(
                              itemCount: tasks_exist.length,
                              itemBuilder: (BuildContext context,index){
                                return ListTile(
                                  tileColor: Colors.grey,
                                  focusColor: Colors.blue,
                                  title: Text(tasks_exist[index].topic!),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Created by: '+tasks_exist[index].cREATEDBY!),
                                      Text('Usuario Asignado: '+tasks_exist[index].uSERMKT!),
                                      Text('Fecha: '+tasks_exist[index].dateCreated!),
                                    ],
                                  ),
                                );
                              }):Center(child: Container(child: Text('No hay tareas con los criterios de busqueda'),color: Colors.white,),),
                        )
                    );
                  });
                },
              ),flex: 2,)
            ],),
            SizedBox(height: 10,),
            ValueListenableBuilder(
              valueListenable: current,
              builder: (ctx,value, _){
                return CustomGroupedCheckbox<String>(
                  controller: customController,
                  itemBuilder: (ctx, index, isSelected, isDisabled) {
                    return ListTile(
                      tileColor: value == index ? Colors.green : null,
                      title: Text(
                        drawerItems[index],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      leading:value==index ? Icon(Icons.check_box):Icon(Icons.check_box_outline_blank_rounded),
                    );
                  },
                  itemExtent: 40,
                  values: drawerItems,
                );
              },
            ),
            Visibility(
              child: Container(
                child: Text('Sublinea',style: TextStyle(
                    color: Colors.white),),
                color: Colors.black,),
              visible: valor_group=='Nuevo',),
            Visibility(child:
            Row(
              //mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Accesorio'),
                Switch(
                    inactiveTrackColor: Colors.black,
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.black,
                    activeTrackColor: Colors.green,
                    value: val_switcher,
                    onChanged: (val){
                      setState(() {
                        val_switcher = val;
                      });
                    }),
                Text('Refaccion'),
              ],
            ),visible: valor_group=='Nuevo',),
            Visibility(child: Container(child: Text('Casos',
              style: TextStyle(color: Colors.white),),color: Colors.black,),visible: valor_group=='Adicional',),
            Visibility(
              child: DropdownButtonHideUnderline(
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
                          'Agregar Tarea Adicional',
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
                  items: items3
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
                  value: selectedValue3,
                  onChanged: (value) {
                    setState(() {
                      selectedValue3 = value as String;
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
              visible: valor_group=='Adicional',
            ),
            Visibility(child: Container(child: Text('Marketplaces',style: TextStyle(color: Colors.white),),color: Colors.black,),visible: valor_group!='Nuevo',),
            Visibility(
              child: CheckboxListTile(value: val_NL,
                  title: Text('Mercado Libre'),
                  subtitle: Visibility(child: TextField(controller: ML_pub,),visible: switcher_publicaciones(valor_group!)),
                  onChanged: (bool? val){
                    setState(() {
                      val_NL = val!;
                    });
                  }),
              visible: valor_group!='Nuevo',
            ),
            Visibility(
              child: CheckboxListTile(value: val_AMZ,
                  title: Text('Amazon'),
                  subtitle: Visibility(child: TextField(controller: Amzn_pub,),visible: switcher_publicaciones(valor_group!)),
                  onChanged: (bool? val){
                    setState(() {
                      val_AMZ = val!;
                    });
                  }),
              visible: valor_group!='Nuevo',
            ),
            Visibility(
              child: CheckboxListTile(value: val_SHEIN,
                  title: Text('Shein'),
                  subtitle: Visibility(child: TextField(controller: Shein_pub,),visible: switcher_publicaciones(valor_group!)),
                  onChanged: (bool? val){
                    setState(() {
                      val_SHEIN = val!;
                    });
                  }),
              visible: valor_group!='Nuevo',
            ),
            Container(
              child: Text('Marketing',style: TextStyle(color: Colors.white),),color: Colors.black,),
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
                items: items
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
            Visibility(child: Container(child: Text('Diseño',style: TextStyle(color: Colors.white),),color: Colors.black,),visible: false,),
            Visibility(
              visible: false,
              child: DropdownButtonHideUnderline(
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
                  items: items2
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
                  value: selectedValue2,
                  onChanged: (value) {
                    setState(() {
                      selectedValue2 = value as String;
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
            ),
            TextButton(onPressed: (){
              topic_task(valor_group);
              setState(() {
                selectedValue = '*';
                selectedValue2 = '*';
              });
              _scaffoldKey.currentState?.closeEndDrawer();
            }, child: Text('Crear tarea'))
          ],
        ),
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
            row_s.clear();
            tasks.clear();
            getdata(widget.user,initdt,ischecked,finaldt);
          });
        },
        onCancelTapped: (){
          initdt = DateTime.now().toString().substring(0,10);
          finaldt =DateTime.now().toString().substring(0,10);
          setState(() {
            row_s.clear();
            tasks.clear();
            getdata(widget.user,initdt,ischecked,finaldt);
          },
          );
        });
  }
  getuser(String name){
    int user_id=0;
    usuarios = filterlist.where((element){
      var searcher = element.name;
      return searcher==name;
    }).toList();
    user_id = usuarios[0].id!;
    print(user_id);
    return user_id;
  }
  _updatemanager(){
    setState(() {
      PlutoGridStateManager.initializeRowsAsync(colums_DGN, row_s).then((value){
        stateManager.refColumns.addAll(colums_DGN);
        stateManager.refRows.addAll(value);
        stateManager.setShowLoading(true);
      });
    });
  }
  switcher_publicaciones(String topic){
    bool value= false;
    if(topic =='Portada'||topic=='Mejora'||topic=='Adicional'||topic=='Variante'){
      value = true;
    }
    return value;
  }

  topic_task(String topic){
    switch(topic){
      case 'Nuevo':
        users_due(topic,'*','*','*','*',val_switcher==false?'Accesorios':'Refacciones');
        //users_due('*','Nuevo','*');
        break;
      case 'Adicional':
        List<String> mktplaces=[];
        String ML = '*';
        String AMZN = '*';
        String SHEIN = '*';
        if(selectedValue3 !='*'){
          if(val_NL ==true){
            ML = ML_pub.text;
            mktplaces.add('Mercado Libre');
            //users_due(ML_pub.text,selectedValue3!,'Mercado Libre');
          }
          if(val_AMZ==true){
            AMZN = Amzn_pub.text;
            //users_due(Amzn_pub.text,selectedValue3!,'Amazon');
            mktplaces.add('Amazon');
          }
          if(val_SHEIN==true){
            SHEIN = Shein_pub.text;
            //users_due(Shein_pub.text,selectedValue3!,'SHEIN');
            mktplaces.add('SHEIN');
          }
          /*if(val_NL ==false&&val_AMZ==false&&val_SHEIN==false){
           //users_due('*',selectedValue3!,'*');
         }*/
          users_due(selectedValue3!,mktplaces.isEmpty?'':mktplaces.toString(), ML, AMZN, SHEIN,'*');
        }
        break;
      default:
        List<String> mktplaces=[];
        String ML = '*';
        String AMZN = '*';
        String SHEIN = '*';
        if(val_NL ==true){
          ML = ML_pub.text;
          mktplaces.add('Mercado Libre');
          //users_due(ML_pub.text,selectedValue3!,'Mercado Libre');
        }
        if(val_AMZ==true){
          AMZN = Amzn_pub.text;
          //users_due(Amzn_pub.text,selectedValue3!,'Amazon');
          mktplaces.add('Amazon');
        }
        if(val_SHEIN==true){
          SHEIN = Shein_pub.text;
          //users_due(Shein_pub.text,selectedValue3!,'SHEIN');
          mktplaces.add('SHEIN');
        }
        /*if(val_NL ==false&&val_AMZ==false&&val_SHEIN==false){
           //users_due('*',selectedValue3!,'*');
         }*/
        users_due(topic,mktplaces.isEmpty?'':mktplaces.toString(), ML, AMZN, SHEIN,'*');
        break;
    }
  }


  users_due(String top,String canal,String ML,String AMZN,String SHEIN,String tipo){
    if(selectedValue != '*'||selectedValue2 != '*'){
      add_new_TSK(selectedValue2=='*'?0:getuser(selectedValue2!),selectedValue=='*'?0:getuser(selectedValue!),top,canal,widget.user,ML,AMZN,SHEIN,tipo);
    }
    /*if(selectedValue != '*'){
      add_new_TSK(getuser(selectedValue!),pub,top,'Marketing',canal,widget.user,top=='Nuevo'?switcher_news('Marketing'):top);
    }
    if(selectedValue2 != '*'){
      add_new_TSK(getuser(selectedValue2!),pub,top,'Diseño',canal,widget.user,top=='Nuevo'?switcher_news('Diseño'):top);
    }*/
  }

  add_new_TSK(int USER_DGN,int USER_MKT,String TOPIC,String CANAL,String user,String ML,String AMZN,String SHEIN,String tipo) async {
    var url = Uri.parse('http://45.56.74.34:6660/addDSGNMKT?TOPIC=${TOPIC}&CODIGO=${cod_slim.text}&USER_DGN=${USER_DGN}&USER_MKT=${USER_MKT}&CANAL=${CANAL}&CREATEDBY=${user}&ML=${ML}&AMZN=${AMZN}&SHEIN=${SHEIN}&TIPO=${tipo}');
    var response = await http.post(url);
    if (response.statusCode == 200) {
      toast_dsgn('Tarea Creada', true);
    }
    else {
      toast_dsgn('ERROR AR CREAR TAREA', false);
    }
  }

  allow2create(){
    bool permission = false;
    if(widget.user=='213'||widget.user=='212'||widget.user=='214'||widget.user=='221'){
      permission = true;
    }
    return permission;
  }
}


