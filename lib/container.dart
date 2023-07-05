import 'dart:async';
import 'dart:convert';
import 'package:datatable/Improve_resources/impro_res.dart';
import 'package:datatable/Modelo_traspaso/modelo_traspaso.dart';
import 'package:datatable/confirm_container.dart';
import 'package:datatable/folios_screen.dart';
import 'package:datatable/sub_folios.dart';
import 'package:datatable/widgets_contenedor/widgets_contenedor.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:pluto_grid/pluto_grid.dart';
import 'Modelo_contenedor/model.dart';
import 'Modelo_contenedor/slim_container.dart';
import 'acc_mx.dart';
import 'folios.dart';
import 'option_menu.dart';
import 'package:flutter/services.dart';

class Container_MX extends StatelessWidget {
  String user;
  Folio_Container folio;
   Container_MX({Key? key,required this.user,required this.folio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Container_GRID',
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xFF000000))),
      home: GRID_Container(user:user,folio:folio),
    );
  }
}

class GRID_Container extends StatefulWidget {
  String user;
  Folio_Container folio;
   GRID_Container({Key? key,required this.user,required this.folio}) : super(key: key);

  @override
  State<GRID_Container> createState() => _GRID_ContainerState();
}

class _GRID_ContainerState extends State<GRID_Container> {
  /*String user;
  _GRID_ContainerState({required this.user});*/

  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }){
    if (stateManager.isEditing) return;
    stateManager.setEditing(true);
  }
  List<container_data> list_container = <container_data>[];
  List<container_data> list_container_searcher = <container_data>[];
  List<String> items = <String>[];
  List<Sublinea> sublinea2 = <Sublinea>[];
  List<Sublinea> sublinea2_get = <Sublinea>[];
  String? selectedValue='*';
  bool isRef = false;
  String ubi_slim = '';
  bool agotar=false;
  int control_stock =15;
TextEditingController control_stck = TextEditingController();
    final List<PlutoColumn> headers = <PlutoColumn>[
      PlutoColumn(
          title: 'CODIGO_SLIM',
          field: 'CODIGO',
          type: PlutoColumnType.text(),
          width: 125,
          enableEditingMode: false,
          renderer: (rendererContext){
            return ContextSlim(CoDSlim: rendererContext.cell.value, SKU: '');
          }
      ),
      PlutoColumn(
          title: 'DESC',
          field: 'DESCRIPCION',
          type: PlutoColumnType.text(),
          width: 250,
          enableEditingMode: false

      ),
      PlutoColumn(
          title: 'SKU',
          field: 'SKU',
          type: PlutoColumnType.text(),
          width: 250,
          enableEditingMode: false

      ),
      PlutoColumn(
          title: 'IMAGEN',
          field: 'IMAGEN',
          type: PlutoColumnType.text(),
          width: 75,
          renderer: (renderContext){
            return Image.network(renderContext.cell.value);
          },
          enableEditingMode: false
      ),
      PlutoColumn(
          backgroundColor: Colors.green,
          title: 'MLV30',
          field: 'VTA30_NATURALES',
          width: 100,
          type: PlutoColumnType.number(),
          enableEditingMode: false,
         renderer: (renderContext){
            return Container(color: Colors.lightGreen,child: Text(renderContext.cell.value.toString()),);
          }
      ),
      PlutoColumn(
          title: 'MLV30HIS',
          field: 'VTA30_HISTORICAS',
          width: 100,
          type: PlutoColumnType.number(),
          enableEditingMode: false
      ),
      PlutoColumn(
          title: 'SOLDML',
          field: 'SOLDML',
          width: 100,
          type: PlutoColumnType.number(),
          enableEditingMode: false
      ),
      PlutoColumn(
          title: 'AMZV30',
          field: 'AMAZON30D',
          width: 110,
          type: PlutoColumnType.number(),
          enableEditingMode: false
      ),
      PlutoColumn(
          width: 110,
          title: 'AMZN_SOLD',
          field: 'AMAZON_SOLD',
          type: PlutoColumnType.number(),
          enableEditingMode: false
      ),
      PlutoColumn(
          width: 100,
          title: 'FULL',
          field: 'FULL',
          type: PlutoColumnType.number(),
          enableEditingMode: false
      ),
      PlutoColumn(
          width: 100,
          title: 'FBA',
          field: 'FBA',
          type: PlutoColumnType.number(),
          enableEditingMode: false
      ),
      PlutoColumn(
          backgroundColor: Colors.deepOrange,
          width: 100,
          title: 'WMS',
          field: 'STOCK_CEDIS',
          type: PlutoColumnType.number(),
          enableEditingMode: false,
          renderer: (renderContext){
            return Container(color: Colors.orange,child: Text(renderContext.cell.value.toString()),);
          }
      ),
      PlutoColumn(
          backgroundColor: Colors.yellow,
          width: 100,
          title: 'CH-MX',
          field: 'COMPRA_CAMINO',
          type: PlutoColumnType.number(),
          enableEditingMode: false,
          renderer: (renderContext){
            return Container(color: Colors.yellow,child: Text(renderContext.cell.value.toString()),);
          }
      ),
      PlutoColumn(
          backgroundColor: Colors.blue,
          width: 125,
          title: 'CAM',
          field: 'FULL_ENVIOS',
          type: PlutoColumnType.number(),
          enableEditingMode: false,
          renderer: (renderContext){
            return Container(color: Colors.lightBlue,child: Text(renderContext.cell.value.toString()),);
          }
      ),
      PlutoColumn(
          title: 'TRANSFER',
          field: 'TRANSFER',
          type: PlutoColumnType.number(),
          enableEditingMode: false
      ),
      PlutoColumn(
          width: 110,
          title: 'U.BOX',
          field: 'CAJA',
          type: PlutoColumnType.number(),
          enableEditingMode: false
      ),
      PlutoColumn(
          width: 110,
          title: 'SUGERIDO',
          field: 'SUGERIDO',
          type: PlutoColumnType.number(),
          enableEditingMode: false
      ),
      PlutoColumn(
          width: 125,
          title: 'ORDENAR',
          field: 'QUANTITY',
          type: PlutoColumnType.number(),
          enableEditingMode: true
        /*renderer: (renderContext){

      }*/
      ),
      PlutoColumn(
          width: 125,
          title: 'PEDIDAS',
          field: 'PEDIDAS',
          type: PlutoColumnType.number(),
          enableEditingMode: false,
          hide: true,
      ),

      PlutoColumn(
          width: 100,
          title: 'ORDENAR',
          field: 'ORDENAR',
          type: PlutoColumnType.number(),
          enableEditingMode: true,
          hide: true,
          /*renderer: (renderContext){
            
           //return Confirmar(user: user, folio: folio, cod_slim: renderContext.row.cells[0]?.value.toString());
          }*/
      ),
      PlutoColumn(
        width: 100,
        title: 'UBICACIONES',
        field: 'UBICACIONES',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        hide: true,
      ),
      PlutoColumn(
        width: 100,
        title: 'AGOTAR',
        field: 'AGOTAR',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        hide: false,
      ),
    ];
    //return headers;
  //}

  late final PlutoGridStateManager stateManager;
  PlutoRow _buldRow(container_data data,int DIAS,int LEAD,Folio_Container folio,int control_stock){
    int pedido_sugerido = 0;
    if(folio.apartado=='Ref MX'){
    double vta_diaria =(data.vTA30NATURALES/30)+(data.aMAZON30D/30);
    double stock_real =(data.fULL+data.fULLENVIOS+data.fBA+data.cOMPRACAMINO+data.transfer+data.sTOCKCEDIS)/vta_diaria;
    if(vta_diaria != 0.0){
      if(stock_real>=control_stock){
        pedido_sugerido =0;
      }else{
        num dias_falt= (DIAS+LEAD)-stock_real;
        pedido_sugerido=  sugested((vta_diaria*dias_falt).toInt());
      }
    }else{
      pedido_sugerido = 0;
    }
    }
    if(folio.apartado=='Ref China'){
     if(data.vTA30HISTORICAS!=0){
       double vta_diaria =(data.vTA30HISTORICAS/30)+(data.aMAZON30D/30);
       double stock_real =(data.fULL+data.fULLENVIOS+data.fBA+data.cOMPRACAMINO+data.transfer+data.sTOCKCEDIS)/vta_diaria;
       if(stock_real<=15){stock_real = 0;}
       double dias_falt= (DIAS+LEAD)-stock_real;
       if(vta_diaria >=2.5){
         pedido_sugerido = (dias_falt*vta_diaria).toInt()+(vta_diaria*15).toInt();
         print(pedido_sugerido.toInt().toString());
       pedido_sugerido=  sugested(pedido_sugerido);
       }else{
       pedido_sugerido = sugested(pedido_sugerido);
       }
     }
    }
    if(folio.apartado == 'Contenedor'){
      if(data.vTA30HISTORICAS!=0){
        double vta_diaria =(data.vTA30HISTORICAS/30)+(data.aMAZON30D/30);
        double stock_real =(data.fULL+data.fULLENVIOS+data.fBA+data.cOMPRACAMINO+data.transfer+data.sTOCKCEDIS)/vta_diaria;
        if(stock_real<=15){stock_real=0;}
        double dias_falt = (DIAS+LEAD)-stock_real;
        if(vta_diaria >=2.5){
          pedido_sugerido = (dias_falt*vta_diaria).toInt()+(vta_diaria*15).toInt();
          pedido_sugerido=  sugested(pedido_sugerido);
        }else{
          pedido_sugerido = sugested(pedido_sugerido);
        }
      }
    //pedido_sugerido=  (((data.vTA30HISTORICAS/30)+(data.aMAZON30D/30))*(DIAS+LEAD)).toInt()-(data.sTOCKCEDIS+data.fULL+data.fULLENVIOS+data.fBA+data.cOMPRACAMINO+data.transfer).toInt();
    }
    if(folio.apartado =='Acc MX'){
    pedido_sugerido=  (((data.vTA30HISTORICAS/30)+(data.aMAZON30D/30))*(DIAS+LEAD)).toInt()-(data.sTOCKCEDIS+data.fULL+data.fULLENVIOS+data.fBA+data.transfer).toInt();
    }
    return PlutoRow(
        cells: {
          'CODIGO':PlutoCell(value: data.cODIGO),
          'DESCRIPCION':PlutoCell(value: data.dESCRIPCION),
          'SKU':PlutoCell(value: data.sKU),
          'IMAGEN':PlutoCell(value: data.iMAGEN),
          'VTA30_NATURALES':PlutoCell(value: data.vTA30NATURALES),
          'VTA30_HISTORICAS':PlutoCell(value: data.vTA30HISTORICAS),
          'SOLDML':PlutoCell(value: data.sold),
          'AMAZON30D':PlutoCell(value: data.aMAZON30D),
          'AMAZON_SOLD':PlutoCell(value: data.aMAZONSOLD),
          'FULL':PlutoCell(value: data.fULL),
          'FBA':PlutoCell(value: data.fBA),
          'STOCK_CEDIS':PlutoCell(value: data.sTOCKCEDIS),
          'COMPRA_CAMINO':PlutoCell(value: data.cOMPRACAMINO),
          'FULL_ENVIOS':PlutoCell(value: data.fULLENVIOS),
          'CAJA':PlutoCell(value: data.unidades_caja),
          'SUGERIDO':PlutoCell(value:int.parse(pedido_sugerido.toString())),
          'QUANTITY':PlutoCell(value:data.qUANTITY),
          'ORDENAR':PlutoCell(value: data.qUANTITY),
          'PEDIDAS':PlutoCell(value: data.pEDIDAS),
          'TRANSFER':PlutoCell(value: data.transfer),
          'UBICACIONES':PlutoCell(value: data.ubicaciones),
          'AGOTAR':PlutoCell(value: data.agotar)
        }
    );
  }
List<PlutoRow> row_s = <PlutoRow>[];
@override
  void initState() {
  control_stck.text = control_stock.toString();
  Slimsublinea().Subline().then((value){
    setState(() {
      sublinea2.addAll(value);
      sublinea2_get = sublinea2;
      sublinea2.forEach((element) {
        items.add(element.Nombre);
      });
    });
  });
  String type='*';
  String sublinea ='*';
  if(widget.folio.tipo=='R'){
    type='R';
  }
  container_class().Slim_container(widget.folio.proveedor,sublinea,widget.folio.folio,'',type).then((value) {
    setState(() {
      list_container.addAll(value);
      list_container_searcher = list_container;
      list_container.forEach((element) {
        row_s.add(_buldRow(element,widget.folio.dias,widget.folio.lead,widget.folio,control_stock));
      });
      PlutoGridStateManager.initializeRowsAsync(headers, row_s).then((value){
        stateManager.refColumns.addAll(headers);
        stateManager.refRows.addAll(value);
        stateManager.setShowLoading(true);
      });
    });
    });
  }
  bool autoEditing = true;
  void toggleAutoEditing(bool flag) {
    setState(() {
      autoEditing = flag;
      stateManager.setAutoEditing(flag);
    });
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: <Widget>[
            IconButton(onPressed: (){
              if(widget.folio.apartado=='Acc MX'){
                List<String> acc_mxfolio = widget.folio.folio.split('_');
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Sub_Folios(user: widget.user, item_folio: Folio_Container(folio: acc_mxfolio[0], referencia: widget.folio.referencia, fechaCreacion: widget.folio.fechaCreacion,
                    proveedor: widget.folio.proveedor, tipo: widget.folio.tipo, dias: widget.folio.dias, lead: widget.folio.lead, fechaTermino: widget.folio.fechaTermino, productosConfirmados: widget.folio.productosConfirmados,
                    apartado: widget.folio.apartado, status: widget.folio.apartado))), (Route<dynamic> route) => false);
              }else{Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Folios_Vista(user: widget.user)), (Route<dynamic> route) => false);}
            }, icon: Icon(Icons.arrow_back_ios)),
          ],
        ),
        title: Row(
          children: [
            Text('FOLIO: ${widget.folio.folio}',style: TextStyle(fontSize: 18),),
            SizedBox(width: 20,),
            Text('DIAS:${widget.folio.dias} LEAD:${widget.folio.lead}',style: TextStyle(fontSize: 18)),
            SizedBox(width: 20,),
            Text('PROVEEDOR: ${widget.folio.proveedor}',style: TextStyle(fontSize: 18)),
            SizedBox(width: 20,),
            Visibility(
              visible: sublinea(widget.folio.apartado),
              child: DropdownButtonHideUnderline(child: DropdownButton2(isExpanded: true, hint: Text('Select Item', style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),)).toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as String;
                      sublinea2 =sublinea2_get.where((element){
                          var searcher = element.Nombre;
                          return searcher.contains(selectedValue.toString());
                      }).toList();
                      int sublinea =sublinea2[0].ID;
                      print(sublinea.toString());
                      row_s.clear();
                        setState(() {
                          if(sublinea == 0){
                            list_container = list_container_searcher.where((element){
                              var sub_searcher = element.sUBLINEA2ID;
                              return sub_searcher.isGreaterThan(sublinea);
                            }).toList();
                          }else{
                            list_container = list_container_searcher.where((element){
                              var sub_searcher = element.sUBLINEA2ID;
                              return sub_searcher.isEqual(sublinea);
                            }).toList();
                          }
                          list_container.forEach((element) {
                            row_s.add(_buldRow(element,widget.folio.dias,widget.folio.lead,widget.folio,control_stock));
                          });
                          PlutoGridStateManager.initializeRowsAsync(headers, row_s).then((value){
                            stateManager.refColumns.addAll(headers);
                            stateManager.refRows.addAll(value);
                            stateManager.setShowLoading(true);
                          });
                        });
                     // });
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
            ),
            SizedBox(width: 20,),
            /*Text('AGOTAR:'),
            Checkbox(
                value: agotar,
                fillColor: MaterialStateProperty.all(Color(0xFF5D5F6E)),
                onChanged: (bool? value){
                    setState(() {
                      agotar = value!;
                      String agot = ' ';
                      if(agotar==true){agot = 'X';}
                      row_s.clear();
                      list_container = list_container_searcher.where((element){
                      var agot_searcher = element.agotar;
                      return agot_searcher.contains(agot);
                      }).toList();
                      list_container.forEach((element) {
                      row_s.add(_buldRow(element,widget.folio.dias,widget.folio.lead,widget.folio,control_stock));
                      });
                      PlutoGridStateManager.initializeRowsAsync(headers, row_s).then((value){
                        stateManager.refColumns.addAll(headers);
                        stateManager.refRows.addAll(value);
                        stateManager.setShowLoading(true);
                      });
               });
            }),*/
            SizedBox(width: 20,),
           Visibility(
               visible: sublinea(widget.folio.apartado),
               child: Container(
                 width: 150,
                 height: 20,
                 child: TextField(
                   decoration: InputDecoration(hintText: 'Control Stock',hintStyle: TextStyle(color: Colors.white)),
                   style: TextStyle(color: Colors.white),
                  controller: control_stck,
                   onSubmitted: (value){
                    setState(() {
                      control_stock=int.parse(control_stck.text);
                      row_s.clear();
                      list_container.forEach((element) {
                        row_s.add(_buldRow(element,widget.folio.dias,widget.folio.lead,widget.folio,control_stock));
                      });
                      PlutoGridStateManager.initializeRowsAsync(headers, row_s).then((value){
                        stateManager.refColumns.addAll(headers);
                        stateManager.refRows.addAll(value);
                        stateManager.setShowLoading(true);
                      });
                    });
                   },
                 ),
               ))
          ],
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              TextButton(onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Confirmar_Con(user: widget.user, folio: widget.folio)), (Route<dynamic> route) => false);
              }, child: Text('CONFIRMADOS',style: TextStyle(fontSize: 18,color: Colors.white),)),
              TextButton(onPressed: (){
                list_container.forEach((element) {
                  setState(()  {
                    if(element.qUANTITY==0){
                      print(element.cODIGO);
                      confirm_sugested(element, widget.folio.dias,widget.folio.lead,widget.folio, control_stock);
                    }
                  });
                });
              }, child: Text('CONFIRM ALL',style: TextStyle(fontSize: 18,color: Colors.white),)),
              SizedBox(width: 25,),
              IconButton(onPressed: () async {
                String type='*';
                String sublinea ='*';
                if(widget.folio.tipo=='R'){
                  type='R';
                }
                list_container.clear();
                list_container_searcher.clear();
                row_s.clear();
               await container_class().Slim_container(widget.folio.proveedor,sublinea,widget.folio.folio,'',type).then((value) {
                  setState(() {
                    list_container.addAll(value);
                    list_container.forEach((element) {
                      row_s.add(_buldRow(element,widget.folio.dias,widget.folio.lead,widget.folio,control_stock));
                    });
                    PlutoGridStateManager.initializeRowsAsync(headers, row_s).then((value){
                      stateManager.refColumns.addAll(headers);
                      stateManager.refRows.addAll(value);
                      stateManager.setShowLoading(false);
                    });
                  });
                });
              }, icon: Icon(Icons.refresh))
            ],
          )
        ],
      ),
      body:list_container.isEmpty?
      Container(child: Center(child: LinearProgressIndicator()))
    :Column(
      children: [
        Expanded(
          flex: 49,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: PlutoGrid(
              columns: headers,
              rows: row_s,
              onLoaded: (PlutoGridOnLoadedEvent event) {
                stateManager = event.stateManager;
                stateManager.setShowColumnFilter(true);
                event.stateManager.setTextEditingController(controller);
              },
              onChanged: (PlutoGridOnChangedEvent event) {
                print(event);
                List<PlutoCell> item_s = event.row.cells.values.toList();
                item_s[0].value;
                print(item_s[0].value+'-'+event.value.toString());
                Confirmar(Cod_Slim: item_s[0].value, quantity: event.value, folio: widget.folio.folio, user: widget.user);
              },
              onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) async {
                List<PlutoCell> item_s = event.row.cells.values.toList();
                await Clipboard.setData(ClipboardData(text: item_s[0].value.toString()));
                print(item_s[20].value);
                setState(() {
                  ubi_slim = ubicaciones(item_s[0].value, item_s[20].value);
                });
              },
              configuration:  PlutoGridConfiguration(
               localeText:PlutoGridLocaleText.spanish(),
                  columnFilter: PlutoGridColumnFilterConfig(
                    filters: const[
                      ...FilterHelper.defaultFilters,
                      ClassYouImplemented()
                    ],
                    resolveDefaultColumnFilter: (column,resolver){
                      if (column.field == 'text') {
                        return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                      } else if (column.field == 'QUANTITY') {
                        return resolver<PlutoFilterTypeGreaterThan>()
                        as PlutoFilterType;
                      } else if (column.field == 'SUGERIDO') {
                        return resolver<PlutoFilterTypeGreaterThanOrEqualTo>()
                        as PlutoFilterType;
                      }else if (column.field == 'date') {
                        return resolver<PlutoFilterTypeLessThan>() as PlutoFilterType;
                      } else if (column.field == 'select') {
                        return resolver<ClassYouImplemented>() as PlutoFilterType;
                      }
                      return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                    },
                  ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Text(ubi_slim),
            ],
          ),
        )
      ],
      )
    );
  }
  sublinea(String apartado){
    bool issub= false;
    if(apartado=='Ref MX'||apartado=='Ref China'){
      issub = true;
    }
    return issub;
  }
  ubicaciones(String cod ,String ubicaciones){
    return cod+' Ubicaciones: '+ubicaciones;
  }
  sugested(int pedido){
    switch (pedido.toInt().toString()[pedido.toInt().toString().length-1]){
      case '9': pedido=pedido+1;break;
      case '8': pedido=pedido+2;break;
      case '7': pedido=pedido-2;break;
      case '6': pedido=pedido-1;break;
      case '4': pedido=pedido+1;break;
      case '3': pedido=pedido+2;break;
      case '2': pedido=pedido-2;break;
      case '1': pedido=pedido-1;break;
    }
    return pedido.toInt();
  }

  confirm_sugested(container_data data,int DIAS,int LEAD,Folio_Container folio,int control_stock){
    toast_impro('Confirmando Productos', true);
    int pedido_sugerido = 0;
    if(folio.apartado=='Ref MX'){
      double vta_diaria =(data.vTA30NATURALES/30)+(data.aMAZON30D/30);
      double stock_real =(data.fULL+data.fULLENVIOS+data.fBA+data.cOMPRACAMINO+data.transfer+data.sTOCKCEDIS)/vta_diaria;
      if(vta_diaria != 0.0){
        if(stock_real>=control_stock){
          pedido_sugerido =0;
        }else{
          num dias_falt= (DIAS+LEAD)-stock_real;
          pedido_sugerido=  sugested((vta_diaria*dias_falt).toInt());
          Confirmar(Cod_Slim: data.cODIGO, quantity: pedido_sugerido, folio: widget.folio.folio, user: widget.user);
        }
      }else{
        pedido_sugerido = 0;
      }
    }
    if(folio.apartado=='Ref China'){
      if(data.vTA30HISTORICAS!=0){
        double vta_diaria =(data.vTA30HISTORICAS/30)+(data.aMAZON30D/30);
        double stock_real =(data.fULL+data.fULLENVIOS+data.fBA+data.cOMPRACAMINO+data.transfer+data.sTOCKCEDIS)/vta_diaria;
        if(stock_real<=15){stock_real = 0;}
        double dias_falt= (DIAS+LEAD)-stock_real;
        if(vta_diaria >=2.5){
          pedido_sugerido = (dias_falt*vta_diaria).toInt()+(vta_diaria*15).toInt();
          print(pedido_sugerido.toInt().toString());
          pedido_sugerido=  sugested(pedido_sugerido);
          Confirmar(Cod_Slim: data.cODIGO, quantity: pedido_sugerido, folio: widget.folio.folio, user: widget.user);
        }else{
          pedido_sugerido = sugested(pedido_sugerido);
          Confirmar(Cod_Slim: data.cODIGO, quantity: pedido_sugerido, folio: widget.folio.folio, user: widget.user);
        }
      }
    }
    if(folio.apartado == 'Contenedor'){
      pedido_sugerido=  (((data.vTA30HISTORICAS/30)+(data.aMAZON30D/30))*(DIAS+LEAD)).toInt()-(data.sTOCKCEDIS+data.fULL+data.fULLENVIOS+data.fBA+data.cOMPRACAMINO+data.transfer).toInt();
      Confirmar(Cod_Slim: data.cODIGO, quantity: pedido_sugerido, folio: widget.folio.folio, user: widget.user);
    }
    if(folio.apartado =='Acc MX'){
      pedido_sugerido=  (((data.vTA30HISTORICAS/30)+(data.aMAZON30D/30))*(DIAS+LEAD)).toInt()-(data.sTOCKCEDIS+data.fULL+data.fULLENVIOS+data.fBA+data.transfer).toInt();
      Confirmar(Cod_Slim: data.cODIGO, quantity: pedido_sugerido, folio: widget.folio.folio, user: widget.user);
    }
    toast_impro('Elementos Confimados', true);
  }
}

class ClassYouImplemented implements PlutoFilterType {
  @override
  String get title => 'Custom contains';

  @override
  get compare => ({
    required String? base,
    required String? search,
    required PlutoColumn? column,
  }) {
    var keys = search!.split(',').map((e) => e.toUpperCase()).toList();

    return keys.contains(base!.toUpperCase());
  };

  const ClassYouImplemented();
}