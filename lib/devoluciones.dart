import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:datatable/Modelo_dev/dev_model.dart';
import 'package:datatable/option_menu.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:url_launcher/url_launcher.dart';


class Devoluciones_main extends StatefulWidget {
  String user;
   Devoluciones_main({Key? key,required this.user}) : super(key: key);

  @override
  State<Devoluciones_main> createState() => _Devoluciones_mainState();
}

class _Devoluciones_mainState extends State<Devoluciones_main> {
  PersistentTabController _controller = PersistentTabController();
  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        Screen_dev(user: widget.user),
        llegada_screen(user: widget.user)
      ];
    }
    List<PersistentBottomNavBarItem> _navBarsItems(){
      return [
        PersistentBottomNavBarItem(
        icon:  Icon(CupertinoIcons.arrow_2_circlepath_circle_fill),
          title: ("Reclamos"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          textStyle: TextStyle(fontSize: 20)
        ),
        PersistentBottomNavBarItem(
          icon:  Icon(CupertinoIcons.arrow_2_circlepath_circle_fill),
          title: ("Llegada"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }
    _controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(context,
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


class Screen_dev extends StatefulWidget {
  String user;
  Screen_dev({Key? key,required this.user}) : super(key: key);

  @override
  State<Screen_dev> createState() => Screen_devState();
}

class Screen_devState extends State<Screen_dev> {
  late final PlutoGridStateManager stateManager;
  List<DateTime?> _calendar_value = [DateTime.now()];
  List<String> folios = <String>['*'];
  List<String> estados = <String>['PENDIENTES','REVISADOS','TODAS'];
  int estados_id = 1;
  String? selectedValue = '*';
  String? selectedValue1 = 'PENDIENTES';
  List<PlutoColumn> columns = <PlutoColumn>[];
  bool ischecked = false;
  List<PlutoColumn> columnas(){
    ismaster(){
      bool master = false;
      if(widget.user=='116'||widget.user=='121'){
        master = true;
      }
      return master;
    }
    return <PlutoColumn>[
      PlutoColumn(title: 'CODIGO', field: 'CODIGO', type: PlutoColumnType.text(),enableEditingMode: false,width: 100,hide: false),
      PlutoColumn(title: 'DESC', field: 'DESC', type: PlutoColumnType.text(),enableEditingMode: false,width: 175,hide: false,
      renderer: (contxt){
        return Container(
          child: Text(contxt.cell.value),
        );
      }),
      PlutoColumn(title: 'PM', field: 'PM', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'VARIANTE', field: 'VAR_ID', type: PlutoColumnType.number(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'CANTIDAD', field: 'SHIPQTY', type: PlutoColumnType.text(),enableEditingMode: false,width: 60,hide: false),
      PlutoColumn(title: 'AREA', field: 'AREA', type: PlutoColumnType.text(),enableEditingMode: false,width: 125,hide: false,
      renderer: (txt){
        return Container(
          color: txt.cell.value=='ACCESORIOS'?Colors.blue:Colors.pink,
          child: Text(txt.cell.value),
        );
      }),
      PlutoColumn(title: 'UNIDAD', field: 'UNIDAD', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'FOLIO', field: 'FOLIO', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'DIA', field: 'DIA', type: PlutoColumnType.number(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'MES', field: 'MES', type: PlutoColumnType.number(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'ANI', field: 'ANI', type: PlutoColumnType.number(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'FECHA_HORA', field: 'FEC_HORA', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'FECHA', field: 'FECHA', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'HORA', field: 'HORA', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: false),
      PlutoColumn(title: 'GUIA', field: 'TRACK', type: PlutoColumnType.text(),enableEditingMode: false,width: 200,hide: false),
      PlutoColumn(title: 'PUBLICACION', field: 'PUB', type: PlutoColumnType.text(),enableEditingMode: false,width: 150,hide: false),
      PlutoColumn(title: 'PAQUETERIA', field: 'PAQ', type: PlutoColumnType.text(),enableEditingMode: false,width: 200,hide: false),
      PlutoColumn(title: 'PRODUCTO', field: 'PROD', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'DESC_PROD', field: 'DSC_PROD', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'NOTAS', field: 'OBVS', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'NICKNAME', field: 'NICK', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'NOMBRE', field: 'NAME', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'ORDEN', field: 'VTA', type: PlutoColumnType.number(),enableEditingMode: false,width: 125,hide: false),
      PlutoColumn(title: 'REVISÓ', field: 'CHECKEDBY', type: PlutoColumnType.text(),enableEditingMode: false,width: 85,hide: false),
      PlutoColumn(title: 'ESTADO', field: 'STATUS', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: false,
      renderer: (txt){
        Color colosillo = Colors.white;
        switch(txt.cell.value??''){
          case'RI-NF':
           colosillo = Colors.red;
              break;
          case'RI-FN':
          colosillo = Colors.green;
            break;
        }
        return Container(
          color: colosillo,
          child: Text(txt.cell.value??'',style: TextStyle(fontWeight: FontWeight.bold)),
        );
      }),
      PlutoColumn(title: 'ORDEN_FECHA', field: 'ORDER_DT', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'DEV_LLEGADA', field: 'ARRIVED', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: ismaster()),
      PlutoColumn(title: 'POR REVISAR', field: 'ISCHECKED', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'USUARIO', field: 'USER', type: PlutoColumnType.number(),enableEditingMode: false,width: 75,hide: true),
      PlutoColumn(title: 'LINK_REVISADO', field: 'LINK_C', type: PlutoColumnType.text(),enableEditingMode: true,width: 150,hide: false),
      PlutoColumn(title: 'EXCLUSION_REMBOLSO', field: 'EXCLU', type: PlutoColumnType.text(),enableEditingMode: true,width: 150,hide: false),
      PlutoColumn(title: 'NOTAS', field: 'NOTAS', type: PlutoColumnType.text(),enableEditingMode: true,width: 150,hide: false),
      PlutoColumn(title: 'RESOLUCION', field: 'RESOLU', type: PlutoColumnType.text(),enableEditingMode: false,width: 230,hide: false,
          renderer: (txt){
            Color colorsillo = Colors.white;
            switch(txt.cell.value??''){
              case'Devolución finalizada con reembolso al comprador':
                colorsillo = Colors.red;
                break;
              case'Devolución finalizada. Te dimos el dinero.':
                colorsillo = Colors.green;
                break;
            }
            return Container(
              color: colorsillo,
              child: Text(txt.cell.value??'SIN RESOLUCION',style: TextStyle(fontWeight: FontWeight.bold),),
            );
          }),
      PlutoColumn(title: 'REPUTACION', field: 'REPU', type: PlutoColumnType.text(),enableEditingMode: false,width: 150,hide: false),
      PlutoColumn(title: 'MONTO', field: 'MONTO', type: PlutoColumnType.text(),enableEditingMode: false,width: 150,hide: false),
      /*PlutoColumn(title: 'POR REVISAR', field: 'CHECKED',
        type: PlutoColumnType.select(
      <String>[
        'REVISADO!','POR REVISAR'
        ],
      ),
        renderer:(txt){
        _change(){
          Color colorsillo = Colors.grey;
          switch(txt.cell.value){
            case'REVISADO!':colorsillo = Colors.green;break;
            case'POR REVISAR':colorsillo = Colors.red; break;
          }
          return colorsillo;
          }
         return Container(
           color: _change(),
           child: Text(txt.cell.value),
         );
        }
        , enableContextMenu: true,width: 150,hide: false,)*/
    ];
  }
  List<dev_model> lista = <dev_model>[];
  List<dev_model> lista_filter = <dev_model>[];
  String initdt = DateTime.now().toString().substring(0,10);
  String finaldt = DateTime.now().toString().substring(0,10);
  List<PlutoRow> row_s = <PlutoRow>[];
  late TabController tabController;
  PlutoRow item_rows(dev_model item){
    return PlutoRow(
        cells: {
          'CODIGO':PlutoCell(value: item.cODIGOSLIM),
          'DESC':PlutoCell(value: item.dESCRIPCIONCORTA),
          'PM':PlutoCell(value: item.pERMALINK),
          'VAR_ID':PlutoCell(value: item.vARIATIONID),
          'SHIPQTY':PlutoCell(value: item.sHIPPINGQUANTITY),
          'AREA':PlutoCell(value: item.aREA),
          'UNIDAD':PlutoCell(value: item.uNIDAD),
          'FOLIO':PlutoCell(value: item.fOLIO),
          'ID':PlutoCell(value: item.iD),
          'DIA':PlutoCell(value: item.dIA),
          'MES':PlutoCell(value: item.mES),
          'ANI':PlutoCell(value: item.aNI),
          'FEC_HORA':PlutoCell(value: item.fECHAHORA),
          'FECHA':PlutoCell(value: item.fECHA),
          'HORA':PlutoCell(value: item.hORA),
          'TRACK':PlutoCell(value: item.tRACKINGNUMBER),
          'PUB':PlutoCell(value: item.pUBLICACION),
          'PAQ':PlutoCell(value: item.pAQUETERIA),
          'PROD':PlutoCell(value: item.pRODUCTO),
          'DSC_PROD':PlutoCell(value: item.dESCRIPCIONDELPRODUCTO),
          'OBVS':PlutoCell(value: item.oBSERVACIONES),
          'NICK':PlutoCell(value: item.nICKNAME),
          'NAME':PlutoCell(value: item.nOMBRE),
          'VTA':PlutoCell(value: item.vENTA),
          'CHECKEDBY':PlutoCell(value: item.rEVISO),
          'STATUS':PlutoCell(value: item.sTATUS),
          'ORDER_DT':PlutoCell(value: item.oRDERDATECREATED),
          'ARRIVED':PlutoCell(value: item.lLEGADADEVOLUCION),
          'ISCHECKED':PlutoCell(value: item.pORREVISAR),
          'USER':PlutoCell(value: item.uSERID),
          'LINK_C':PlutoCell(value: item.link_checked),
          'EXCLU':PlutoCell(value: item.exclusion_rembolso),
          'NOTAS':PlutoCell(value: item.notas),
          'RESOLU':PlutoCell(value: item.resolucion),
          'REPU':PlutoCell(value: item.reputation),
          'MONTO':PlutoCell(value: item.money_rturn),
          //'CHECKED':PlutoCell(value: item.por_revisar==false?'POR REVISAR':'REVISADO!')
        });
  }
  updateManager(){
    setState(() {
      PlutoGridStateManager.initializeRowsAsync(columns, row_s).then((value){
        stateManager.refColumns.addAll(columns);
        stateManager.refRows.addAll(value);
        stateManager.setShowLoading(true);
      });
    });
  }
  Future<void> handleRemoveSelectedRowsButton() async {
    for (var element in stateManager!.currentSelectingRows) {
      //event.row.cells["ID"]!.value
      //designmkt_class().update_tasks('STATUS','Completado',element.cells["ID"]!.value);
      await dev_getter().is_CHECKED(element.cells["ID"]!.value.toString(),element.cells["VTA"]!.value.toString(),true);
    }
    stateManager.removeRows(stateManager.currentSelectingRows);
  }
  _launchURL(String venta) async {
    var url = 'https://www.mercadolibre.com.mx/ventas/${venta}/detalle';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se puede abrir $url';
    }
  }

  getData(){
    if(folios.length>1){
      setState(() {
        selectedValue = '*';
        folios.removeRange(1, folios.length);
      });
    }
    row_s.clear();
    lista.clear();
    lista_filter.clear();
    dev_getter().dv_list(initdt,estados_id,widget.user,ischecked).then((value){
      setState(() {
        lista.addAll(value);
        lista_filter= lista;

        lista.forEach((element) {
          if(folios.contains(element.fOLIO)){}else{
            folios.add(element.fOLIO!);
          }
          row_s.add(item_rows(element));
        });
        updateManager();
      });
    });
  }
@override
  void initState() {
    setState(() {
      columns = columnas();
    });
    getData();
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
        }, icon: Icon(Icons.arrow_back)),
        title: Row(
          children: <Widget>[
            Text('DEVOLUCIONES'),
            SizedBox(width: 20,),
            TextButton(onPressed: ()async{
              await showDialog(context: context, builder: (BuildContext context){
                return Center(
                  child: Container(
                    height:450,
                    width: 500,
                    child: Card(child: _calendar()),
                  ),
                );
              });
            }, child: Text('FECHA',style: TextStyle(color: Colors.white),)),
            SizedBox(width: 10,),
            Text(initdt,style: TextStyle(fontSize: 15),),
            SizedBox(width: 10,),
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
                items: folios
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
                    if(selectedValue=='*'){
                      row_s.clear();
                      lista = lista_filter;
                      lista.forEach((element) {
                        row_s.add(item_rows(element));
                      });
                      updateManager();
                    }else{
                      row_s.clear();
                      lista = lista_filter.where((element){
                        var finder = element.fOLIO;
                        return finder ==selectedValue!;
                      }).toList();
                      lista.forEach((element) {
                        row_s.add(item_rows(element));
                      });
                      updateManager();
                    }
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
                items: estados
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
                value: selectedValue1,
                onChanged: (value) {
                  setState(() {
                    selectedValue1 = value as String;
                    switch(selectedValue1){
                      case'TODAS':
                        setState(() {
                          estados_id = 0;
                        });
                        break;
                      case'PENDIENTES':
                        setState(() {
                          estados_id = 1;
                        });
                        break;
                      case'REVISADOS':
                        setState(() {
                          estados_id = 2;
                        });
                        break;
                    }
                    getData();
                    updateManager();
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
            SizedBox(width: 20,),
            Visibility(
              visible: widget.user=='116'||widget.user=='121'||widget.user=='103'||widget.user=='100'?true:false,
              child: Column(
                children: [
                  Text('Todos',style: TextStyle(fontSize: 12),),
                  Checkbox(
                      value: ischecked,
                      onChanged: (bool? change){
                        setState(() {
                          ischecked=change!;
                          getData();
                          updateManager();
                        });
                      }
                  ),
                ],
              ),
            ),
            SizedBox(width: 20,),
            ElevatedButton(onPressed:(){
              handleRemoveSelectedRowsButton();
            }, child: Text('Completar'))
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlutoGrid(
                        columns: columns,
                        rows: row_s,
                      onLoaded: (PlutoGridOnLoadedEvent vnt){
                        stateManager = vnt.stateManager;
                        vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                        stateManager.setShowColumnFilter(true);
                      },
                      onChanged:(PlutoGridOnChangedEvent event) async {
                       print(event.column.field+'-'+event.value);
                       switch(event.column.field){
                         case'LINK_C':
                        await dev_getter().ADD_link(event.row.cells["ID"]!.value,event.row.cells["VTA"]!.value.toString(),'&url='+(event.value).toString());
                        /*await getData();
                        await updateManager();*/
                         break;
                         case'RESOLU':
                           break;
                         case'NOTAS':
                           await dev_getter().ADD_link(event.row.cells["ID"]!.value,event.row.cells["VTA"]!.value.toString(),'&notas='+(Uri.encodeComponent(event.value)).toString());
                           break;
                         case'EXCLU':
                           await dev_getter().ADD_link(event.row.cells["ID"]!.value,event.row.cells["VTA"]!.value.toString(),'&exclusion='+(event.value).toString());
                           break;
                         /*case'CHECKED':
                           await dev_getter().ADD_link(event.row.cells["ID"]!.value,event.row.cells["VTA"]!.value.toString(),'&checked='+event.value=='POR REVISAR'?'false':'true');
                           break;*/
                       }
                      },
                      configuration: const PlutoGridConfiguration(localeText:PlutoGridLocaleText.spanish()),
                      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event){
                        print(event.row.cells["VTA"]!.value.toString());
                        _launchURL(event.row.cells["VTA"]!.value.toString());
                      },
                    ),
                  )
              ),
            ],
          ),),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){
            getData();
            updateManager();
          },child: Icon(Icons.refresh,color: Colors.white,),),
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
          initdt = _calendar_value[0].toString().substring(0,10);
        });
          getData();
          updateManager();
      },
      onCancelTapped: (){
        setState(() {
          initdt = _calendar_value[0].toString().substring(0,10);
        });
      },
    );
  }
}

class llegada_screen extends StatefulWidget {
  String user;
  llegada_screen({Key? key,required this.user}) : super(key: key);

  @override
  State<llegada_screen> createState() => _llegada_screenState();
}

class _llegada_screenState extends State<llegada_screen> {
  List<PlutoColumn> columns = <PlutoColumn>[];
  List<tareas_count> tareas_a = <tareas_count>[];
  List<PlutoRow> row_s = <PlutoRow>[];
  List<llegaran> lista = <llegaran>[];
  List<String> estados = <String>['TODAS','PENDIENTES','REVISADOS'];
  String? selectedValue1 = 'TODAS';
  int estados_id = 0;
  late final PlutoGridStateManager stateManager;
  List<PlutoColumn> columnas(){
    return <PlutoColumn>[
      PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 100,hide: false),
      PlutoColumn(title: 'TITULO', field: 'TITLE', type: PlutoColumnType.text(),enableEditingMode: false,width: 175,hide: false,),
      PlutoColumn(title: 'ITEM', field: 'ITEM', type: PlutoColumnType.text(),enableEditingMode: false,width: 175,hide: false),
      PlutoColumn(title: 'USER', field: 'USER', type: PlutoColumnType.text(),enableEditingMode: false,width: 175,hide: false),
      PlutoColumn(title: 'LAST_UPDATE', field: 'LAST', type: PlutoColumnType.text(),enableEditingMode: false,width: 175,hide: false),
      PlutoColumn(title: 'LLEGADA', field: 'LLEGADA', type: PlutoColumnType.text(),enableEditingMode: false,width: 160,hide: false),
      PlutoColumn(title: 'POR REVISAR', field: 'CHECKED', type: PlutoColumnType.text(),enableEditingMode: false,width: 125,hide: false,),
      PlutoColumn(title: 'REVISADO', field: 'REVISADO', type: PlutoColumnType.text(),enableEditingMode: false,width: 175,hide: false),
      PlutoColumn(title: 'FECHA_REVISADO', field: 'FEC_REV', type: PlutoColumnType.text(),enableEditingMode: false,width: 175,hide: false),
      PlutoColumn(title: 'ESTADO', field: 'ESTADO', type: PlutoColumnType.text(),enableEditingMode: false,width: 175,hide: false),
      PlutoColumn(title: 'ENTRADA', field: 'ENTRADA', type: PlutoColumnType.text(),enableEditingMode: false,width: 175,hide: false),
    ];
  }
  PlutoRow item_rows(llegaran task){
    return PlutoRow(
        cells: {
          'ID':PlutoCell(value: task.oRDERID),
          'TITLE':PlutoCell(value: task.tITLE),
          'ITEM':PlutoCell(value: task.iTEMID),
          'USER':PlutoCell(value: task.user),
          'LAST':PlutoCell(value: task.lASTUPDATED),
          'LLEGADA':PlutoCell(value: task.lLEGADADEVOLUCION),
          'CHECKED':PlutoCell(value: task.pORREVISAR),
          'REVISADO':PlutoCell(value: task.rEVISADO),
          'FEC_REV':PlutoCell(value: task.dATEDREVISADO),
          'ESTADO':PlutoCell(value: task.eSTADO),
          'ENTRADA':PlutoCell(value: task.fECHAENTRADACEDIS),
        });
  }

void get_arrived_data(){
    setState(() {
      row_s.clear();
      lista.clear();
    });
    llegaran_class().dv_list(estados_id,widget.user).then((value) => {
    setState(() {
    lista.addAll(value);
    lista.forEach((element) {
      setState(() {
        row_s.add(item_rows(element));
          });
        });
    updateManager();
    get_asigned();
      })
    });
}

void get_asigned(){
    setState(() {
      tareas_a.clear();
    });
    tareas_class().tareas_counter().then((value) => {
    setState(() {
    tareas_a.addAll(value);
    })
    });
}

  updateManager(){
    setState(() {
      PlutoGridStateManager.initializeRowsAsync(columns, row_s).then((value){
        stateManager.refColumns.addAll(columns);
        stateManager.refRows.addAll(value);
        stateManager.setShowLoading(true);
      });
    });
  }

  Future<void> handleRemoveSelectedRowsButton() async {
    for (var element in stateManager!.currentSelectingRows) {
      await tareas_class().is_CHECKED(element.cells["ID"]!.value.toString(),true);
    }
    stateManager.removeRows(stateManager.currentSelectingRows);
  }

@override
  void initState() {
    setState(() {
      columns= columnas();
      get_arrived_data();
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
        }, icon: Icon(Icons.arrow_back)),
        title: Row(
          children: [
            Text('Llegada'),
            SizedBox(width: 20,),
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
                items: estados
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
                value: selectedValue1,
                onChanged: (value) {
                  setState(() {
                    selectedValue1 = value as String;
                    switch(selectedValue1){
                      case'TODAS':
                        setState(() {
                          estados_id = 0;
                        });
                        break;
                      case'PENDIENTES':
                        setState(() {
                          estados_id = 1;
                        });
                        break;
                      case'REVISADOS':
                        setState(() {
                          estados_id = 2;
                        });
                        break;
                    }
                    get_arrived_data();
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
            SizedBox(width: 20,),
            ElevatedButton(onPressed: (){
              tareas_class().sincornizar();
              get_arrived_data();
            }, child: Text('Sincronizar')),
            SizedBox(width: 20,),
            ElevatedButton(onPressed: (){
              handleRemoveSelectedRowsButton();
            }, child: Text('Completar')),
            SizedBox(width: 20,),
            Visibility(
              visible: widget.user=='123'?false:true,
              child: Column(children: [
               Text(tareas_a.length>0?tareas_a[0].nICKNAME!:'',style: TextStyle(color: Colors.white),),
                Text(tareas_a.length>0?tareas_a[0].aSIGNADAS.toString()!:'',style: TextStyle(color: Colors.white)),
              ],),
            ),
            SizedBox(width: 20,),
            Visibility(
              visible: widget.user=='113'?false:true,
              child: Column(children: [
                Text(tareas_a.length>0?tareas_a[1].nICKNAME!:'',style: TextStyle(color: Colors.white)),
                Text(tareas_a.length>0?tareas_a[1].aSIGNADAS.toString()!:'',style: TextStyle(color: Colors.white)),
              ],),
            ),
            SizedBox(width: 20,),
            Visibility(
              visible: true,
              child: Column(children: [
                Text(tareas_a.length>0?tareas_a[2].nICKNAME!:'',style: TextStyle(color: Colors.white)),
                Text(tareas_a.length>0?tareas_a[2].aSIGNADAS.toString()!:'',style: TextStyle(color: Colors.white)),
              ],),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PlutoGrid(
                        columns: columns,
                        rows:row_s,
                        configuration: const PlutoGridConfiguration(localeText:PlutoGridLocaleText.spanish()),
                        onLoaded: (PlutoGridOnLoadedEvent vnt){
                          stateManager = vnt.stateManager;
                          vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                          stateManager.setShowColumnFilter(true);
                        },
                        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event){
                          print(event.row.cells["ID"]!.value.toString());
                          _launchURL(event.row.cells["ID"]!.value.toString());
                        },
                      ),
                    )
                ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
      get_arrived_data();
    },child: Icon(Icons.refresh,color: Colors.white,),),
    );
  }
  _launchURL(String venta) async {
    var url = 'https://www.mercadolibre.com.mx/ventas/${venta}/detalle';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se puede abrir $url';
    }
  }
}
