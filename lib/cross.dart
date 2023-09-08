import 'package:datatable/Improve_resources/listas.dart';
import 'package:datatable/Modelo_traspaso/modelo_traspaso.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:url_launcher/url_launcher.dart';

import 'option_menu.dart';

class ListCross extends StatefulWidget {
  String user;
  ListCross({Key? key,required this.user}) : super(key: key);

  @override
  State<ListCross> createState() => _ListCrossState();
}

class _ListCrossState extends State<ListCross> {
  PersistentTabController _controller = PersistentTabController();

  void initState(){

  }
  @override
  Widget build(BuildContext context) {
    List<Widget> buildScreens() {
     return [
      Cross_AMZ(user: widget.user,),
      Cross_ML(user: widget.user,)
      ];
    }
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.stop),
          title: ("AMAZON\nPAUSED"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.umbrella_fill),
          title: ("ML\nPAUSED"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }
    _controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(context,
    controller: _controller,
    items: _navBarsItems(),
    screens: buildScreens(),
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
    navBarStyle: NavBarStyle.neumorphic,);
  }

}

class Cross_AMZ extends StatefulWidget {
  String user;
 Cross_AMZ({Key? key,required this.user}) : super(key: key);

  @override
  State<Cross_AMZ> createState() => _Cross_AMZState();
}

class _Cross_AMZState extends State<Cross_AMZ> {
  late final PlutoGridStateManager stateManager;
  List<cross_amazon> lista = <cross_amazon>[];
  List<PlutoRow> rows = <PlutoRow>[];
  List<PlutoColumn> colums = <PlutoColumn>[
    PlutoColumn(title: 'CODIGO', field: 'COD', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'TITULO', field: 'TIT', type: PlutoColumnType.text(),enableEditingMode: false,
        renderer: (contxt){
          return Text(contxt.cell.value);
        }),
    PlutoColumn(title: 'STOCK', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'IMG', field: 'IMG', type: PlutoColumnType.text(),enableEditingMode: false,
        renderer: (contxt){
          return Image.network(contxt.cell.value);
        }),
    PlutoColumn(title: 'QTY', field: 'QTY', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'PRICE', field: 'PRICE', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'ML', field: 'ML', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'AMZ', field: 'AMZ', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'SHEIN', field: 'SHEIN', type: PlutoColumnType.text(),enableEditingMode: false),
  ];
  PlutoRow item(cross_amazon item){
    return PlutoRow(
        cells:{
          'COD':PlutoCell(value: item.cODIGO),
          'ID':PlutoCell(value: item.iD),
          'TIT':PlutoCell(value: item.item),
          'STOCK':PlutoCell(value: item.sTOCKCEDIS),
          'IMG':PlutoCell(value: item.image),
          'QTY':PlutoCell(value: item.quantity),
          'PRICE':PlutoCell(value: item.price),
          'ML':PlutoCell(value: item.mL),
          'AMZ':PlutoCell(value: item.aMZ),
          'SHEIN':PlutoCell(value: item.sHEIN),
        }
    );
  }
  getData(){
    setState(() {
    rows.clear();
    lista.clear();
    });
    Paused().AMZ().then((value){
      setState(() {
        lista.addAll(value);
        lista.forEach((element) {
          setState(() {
            rows.add(item(element));
          });
        });
        _updatemanager();
      });
    });
  }
  @override
  void initState() {
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
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Menu(user: widget.user),), (route) => false,);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        actions: [
          IconButton(onPressed: (){
            getData();
          }, icon: Icon(Icons.refresh))
        ],
        title: Text('AMZ paused'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:lista.isNotEmpty?PlutoGrid(
          columns: colums,
          rows: rows,
          onLoaded: (PlutoGridOnLoadedEvent vnt){
            stateManager = vnt.stateManager;
            vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
            stateManager.setShowColumnFilter(true);
          },
          onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent vnt)async{
            print(vnt.row.cells["ID"]!.value);
            await _launchURL(vnt.row.cells["ID"]!.value);
          },
        ):Center(
          child: SpinKitRipple(
            color: Theme.of(context).primaryColor,
            size: 75,
          )
        ),
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
  _launchURL(asin) async {
    final Uri url = Uri.parse('https://sellercentral.amazon.com.mx/inventory/ref=xx_invmgr_dnav_xx?tbla_myitable=sort:%7B"sortOrder"%3A"DESCENDING"%2C"sortedColumnId"%3A"date"%7D;search:${asin};pagination:1;');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

class Cross_ML extends StatefulWidget {
  String user;
   Cross_ML({Key? key,required this.user}) : super(key: key);

  @override
  State<Cross_ML> createState() => _Cross_MLState();
}

class _Cross_MLState extends State<Cross_ML> {
  late final PlutoGridStateManager stateManager;
  List<ML_paused> lista = <ML_paused>[];
  List<PlutoRow> rows = <PlutoRow>[];
  List<PlutoColumn> colums = <PlutoColumn>[
    PlutoColumn(title: 'CODIGO', field: 'COD', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'TITULO', field: 'TIT', type: PlutoColumnType.text(),enableEditingMode: false,
        renderer: (contxt){
          return Text(contxt.cell.value);
        }),
    PlutoColumn(title: 'STATUS', field: 'STATUS', type: PlutoColumnType.text(),enableEditingMode: false,),
    PlutoColumn(title: 'STOCK', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'IMG', field: 'IMG', type: PlutoColumnType.text(),enableEditingMode: false,
        renderer: (contxt){
          return Image.network(contxt.cell.value);
        }),
    PlutoColumn(title: 'LOG', field: 'LOG', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'QTY', field: 'QTY', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'PRICE', field: 'PRICE', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'ML', field: 'ML', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'AMZ', field: 'AMZ', type: PlutoColumnType.number(),enableEditingMode: false),
    PlutoColumn(title: 'SHEIN', field: 'SHEIN', type: PlutoColumnType.number(),enableEditingMode: false),
  ];
  PlutoRow item(ML_paused item){
    return PlutoRow(
        cells:{
          'COD':PlutoCell(value: item.cODIGO),
          'ID':PlutoCell(value: item.iD),
          'TIT':PlutoCell(value: item.tITLE),
          'STATUS':PlutoCell(value: item.sTATUS),
          'STOCK':PlutoCell(value: item.sTOCKCEDIS),
          'IMG':PlutoCell(value: item.tHUMBNAIL),
          'QTY':PlutoCell(value: item.aVAILABLEQUANTITY),
          'LOG':PlutoCell(value: item.lOGISTICTYPE),
          'PRICE':PlutoCell(value: item.pRICE),
          'ML':PlutoCell(value: item.mL),
          'AMZ':PlutoCell(value: item.aMZ),
          'SHEIN':PlutoCell(value: item.sHEIN),
        }
    );
  }
  getData(){
    setState(() {
      lista.clear();
      rows.clear();
    });
    Paused().ML().then((value){
      setState(() {
        lista.addAll(value);
        lista.forEach((element) {
          setState(() {
            rows.add(item(element));
          });
        });
        _updatemanager();
      });
    });
  }
  @override
  void initState() {
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
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Menu(user: widget.user),), (route) => false,);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        actions: [
          IconButton(onPressed: (){
            getData();
          }, icon:Icon(Icons.refresh))
        ],
        title: Text('ML paused'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:lista.isNotEmpty?PlutoGrid(
          columns: colums,
          rows: rows,
          onLoaded: (PlutoGridOnLoadedEvent vnt){
            stateManager = vnt.stateManager;
            vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
            stateManager.setShowColumnFilter(true);
          },
          onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent vnt)async{
          print(vnt.row.cells["ID"]!.value);
          await _launchURL(vnt.row.cells["ID"]!.value);
         },
        ):Center(
          child: SpinKitSpinningLines(
          color: Theme.of(context).primaryColor,
        ),
      ),
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
  _launchURL(id) async {
    final Uri url = Uri.parse('https://www.mercadolibre.com.mx/publicaciones/${id}/modificar/omni');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}