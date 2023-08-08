import 'package:datatable/Modelo_MLmensajes/msn_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'Improve_resources/impro_res.dart';
import 'option_menu.dart';

class ML_messages extends StatefulWidget {
  String user;
   ML_messages({Key? key,required this.user}) : super(key: key);

  @override
  State<ML_messages> createState() => _ML_messagesState();
}

class _ML_messagesState extends State<ML_messages> {
  List<ML_MSG> mensajes = <ML_MSG>[];
  List<PlutoRow> row_s = <PlutoRow>[];
  List<MLMvtasatrb> atrb = <MLMvtasatrb>[];
  String initdt = DateTime.now().toString().substring(0,10);
  String finaldt = DateTime.now().subtract(Duration(days: 30)).toString().substring(0,10);
  late final PlutoGridStateManager stateManager;
  PlutoRow item_rows(ML_MSG msg){
    return PlutoRow(
        cells: {
          'ID':PlutoCell(value: msg.iD),
          'DT':PlutoCell(value: msg.dATECREATED),
          'IMAGEN':PlutoCell(value: msg.iMAGEN),
          'STATUS':PlutoCell(value: msg.sTATUS),
          'MENSAJE':PlutoCell(value: msg.pOSTDELIVEREDMESSAGE),
          'SOLD':PlutoCell(value:msg.sOLD),
          'PRICE':PlutoCell(value: msg.pRICE),
        });
  }

  List<PlutoColumn> colums = <PlutoColumn>[
    PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 115,hide: false),
    PlutoColumn(title: 'IMAGEN', field: 'IMAGEN', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,
        renderer: (contxt){
          return Image.network(contxt.cell.value);
        }),
    PlutoColumn(title: 'MENSAJE', field: 'MENSAJE', type:PlutoColumnType.text(),enableEditingMode: true,width: 600,
      renderer: (contxt){
      return Text(contxt.cell.value);
      }),
    PlutoColumn(title: 'STATUS', field: 'STATUS', type:PlutoColumnType.text(),enableEditingMode: false,width: 75),
    PlutoColumn(title: 'DT', field: 'DT', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
    PlutoColumn(title: 'SOLD', field: 'SOLD', type: PlutoColumnType.text(),enableEditingMode: false,width: 75),
    PlutoColumn(title: 'PRICE', field: 'PRICE', type: PlutoColumnType.text(),enableEditingMode: false,width: 100,),
  ];

  void get_data(){
    setState(() {
      row_s.clear();
      mensajes.clear();
    });
    MSG_ML().MensajesML().then((value) =>{
      setState((){
        mensajes.addAll(value);
        mensajes.forEach((element) {
        row_s.add(item_rows(element));
        });
        _updatemanager();
      })
    });
  }

  @override
  void initState() {
    get_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Menu(user: widget.user)), (Route<dynamic> route) => false);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text('ML Mensajes'),
        actions: [
          IconButton(onPressed: (){
            get_data();
          }, icon: Icon(Icons.refresh)),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: PlutoGrid(
              columns: colums,
              rows: row_s,
              onLoaded: (PlutoGridOnLoadedEvent vnt){
                stateManager = vnt.stateManager;
                vnt.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                stateManager.setShowColumnFilter(true);
              },
              onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) async{
                atrb.clear();
                MLMvtasclass().getMLMatrb(event.row.cells["ID"]!.value,initdt, finaldt).then((value){
                  setState(() {
                    atrb.addAll(value);
                  });
                });
              },
              onChanged: (PlutoGridOnChangedEvent event) async {
              switch(event.column.field) {
                case'MENSAJE':
                  await MSG_ML().Add_msg(event.row.cells["ID"]!.value,event.value);
                  break;
                }
              },
              configuration: const PlutoGridConfiguration(localeText:PlutoGridLocaleText.spanish()),
            ),
          ),
          ),
      Visibility(
        visible: atrb.isNotEmpty?true:false,
        child: Expanded(child: Padding(padding: EdgeInsets.all(8),
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
                  height: 300,
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
        ),flex: 1,),
      )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
       onPressed: (){
        _showAlertDialog();
      },child: Icon(Icons.add,),),
    );
  }
  _updatemanager(){
    setState(() {
      PlutoGridStateManager.initializeRowsAsync(colums, row_s).then((value){
        stateManager.refColumns.addAll(colums);
        stateManager.refRows.addAll(value);
        stateManager.setShowLoading(true);
      });
    });
  }
  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, //
      builder: (BuildContext context) {
        TextEditingController id_controller = TextEditingController();
        TextEditingController msg_controller = TextEditingController();
        return AlertDialog(
          title:  Text('Agregar mensaje'),
          content: SingleChildScrollView(
            child: Container(
              width: 250,
              height: 150,
              child: Column(
                children:  <Widget>[
                  Text('ID Publicacion'),
                  TextField(controller: id_controller,),
                  SizedBox(height: 10,),
                  Text('Mensaje'),
                  TextField(controller: msg_controller,)
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Agregar'),
              onPressed: () async {
               await MSG_ML().Add_msg(id_controller.text,msg_controller.text);
                get_data();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
