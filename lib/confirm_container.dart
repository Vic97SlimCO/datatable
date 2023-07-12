import 'package:datatable/container.dart';
import 'package:datatable/widgets_contenedor/widgets_confirmados.dart';
import 'package:datatable/widgets_contenedor/widgets_contenedor.dart';
import 'package:datatable/xls/container_layout.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'Modelo_contenedor/slim_container.dart';

/*class Confirmar_Con extends StatefulWidget {
  String user;
  Folio_Container folio;
  Confirmar_Con({Key? key,required this.user,required this.folio}) : super(key: key);

  @override
  State<Confirmar_Con> createState() => _Confirmar_ConState();
}

class _Confirmar_ConState extends State<Confirmar_Con> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xFF000000))),
      home: ScreenConfirmCont(user: widget.user,folio: widget.folio,),
    );
  }
}*/

class ScreenConfirmCont extends StatefulWidget {
  String type = '*';
  String sublinea = '*';
  String user;
  Folio_Container folio;
  ScreenConfirmCont({Key? key,required this.user,required this.folio}) : super(key: key);

  @override
  State<ScreenConfirmCont> createState() => _ScreenConfirmContState();
}

class _ScreenConfirmContState extends State<ScreenConfirmCont> {

  List<String> items = <String>[];
  List<Sublinea> sublinea2 = <Sublinea>[];
  List<Sublinea> sublinea2_get = <Sublinea>[];
  String? selectedValue='*';

  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }){
    if (stateManager.isEditing) return;
    stateManager.setEditing(true);
  }
  List <confirmadas_container> list_container = <confirmadas_container>[];
  List<confirmadas_container> list_container_searcher = <confirmadas_container>[];
  GET_headers(String apartado){
    bool isacc = true;
    bool iscont = true;
    bool isref = true;
    switch(apartado){
      case'Acc MX':setState(() {
        isacc=false;
      });break;
      case'Ref China':
        setState(() {
          isref=false;
        });break;
      case'Contenedor':
        setState(() {
          iscont=false;
        }); break;
    }
     List<PlutoColumn> headers = <PlutoColumn>[
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
        width: 200,
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
      //enableEditingMode: false
    ),
    PlutoColumn(
        width: 95,
        title: 'CANTIDAD',
        field: 'QUANTITY',
        type: PlutoColumnType.number(),
        enableEditingMode: true
    ),
    PlutoColumn(
        title: 'COLOR',
        field: 'COLOR',
        type: PlutoColumnType.text(),
        width: 100,
        enableEditingMode: true
    ),
    PlutoColumn(
        title: 'DESC-CH',
        field: 'DESC-CH',
        type: PlutoColumnType.text(),
        width: 150,
        enableEditingMode: true,
        hide: iscont
    ),
    PlutoColumn(
        title: 'INSTRUCCIONES',
        field: 'INSTRUCCIONES',
        type: PlutoColumnType.text(),
        width: 150,
        enableEditingMode: true,
        hide: iscont
    ),
    PlutoColumn(
        title: 'EXAMPLE',
        field: 'EXAMPLE',
        type: PlutoColumnType.text(),
        width: 150,
        enableEditingMode: true,
        hide: iscont
    ),
    PlutoColumn(
        title: 'DESC-MX',
        field: 'DESC-MX',
        type: PlutoColumnType.text(),
        width: 150,
        enableEditingMode: true,
        hide: isacc
    ),
    PlutoColumn(
        title: 'BRAND',
        field: 'BRAND',
        type: PlutoColumnType.text(),
        width: 125,
        enableEditingMode: true,
        hide: isref
    ),
    PlutoColumn(
        title: 'TYPE',
        field: 'TYPE',
        type: PlutoColumnType.text(),
        width: 85,
        enableEditingMode: true,
        hide: isref
    ),
    PlutoColumn(
        title: 'MODELO',
        field: 'MODELO',
        type: PlutoColumnType.text(),
        width: 100,
        enableEditingMode: true,
        hide: isref
    ),
    PlutoColumn(
        title: 'FRAME',
        field: 'FRAME',
        type: PlutoColumnType.text(),
        width: 75,
        enableEditingMode: true,
        hide: isref
    ),
    PlutoColumn(
        title: 'USER',
        field: 'USER',
        type: PlutoColumnType.text(),
        width: 150,
        enableEditingMode: false,
        hide: isref
    ),
    PlutoColumn(
        title: 'ADDIMAGE',
        field: 'ADDIMAGE',
        type: PlutoColumnType.text(),
        width: 150,
        enableEditingMode: false,
        renderer: (renderContext){
          return imagenCH(cod_slim: renderContext.cell.value.toString());
        },
        hide: iscont
    ),
    PlutoColumn(
        title: 'DELETE',
        field: 'DELETE',
        type: PlutoColumnType.text(),
        width: 65,
        enableEditingMode: false,
        renderer:  (rendercontext){
          return IconButton(onPressed: (){

          }, icon: Icon(Icons.delete_forever));
        },
    ),
  ];
    return headers;
  }


  late final PlutoGridStateManager stateManager;
  PlutoRow _buildRow(confirmadas_container data){
    return PlutoRow(
        cells: {
          'CODIGO':PlutoCell(value: data.cODIGO),
          'DESCRIPCION':PlutoCell(value: data.dESCRIPCION),
          'SKU':PlutoCell(value: data.sku),
          'IMAGEN':PlutoCell(value: data.iMAGEN),
          'QUANTITY':PlutoCell(value: data.qUANTITY),
          'COLOR':PlutoCell(value: data.cOLOR),
          'DESC-CH':PlutoCell(value: data.dESCCHINA),
          'INSTRUCCIONES':PlutoCell(value: data.iNSTRUCCIONES),
          'EXAMPLE':PlutoCell(value: data.eXAMPLE),
          'DESC-MX':PlutoCell(value: data.dESCMX),
          'BRAND':PlutoCell(value: data.bRAND),
          'TYPE':PlutoCell(value: data.tYPE),
          'MODELO':PlutoCell(value: data.mODELO),
          'FRAME':PlutoCell(value: data.fRAME),
          'USER':PlutoCell(value: data.uSUARIO),
          'ADDIMAGE':PlutoCell(value: data.cODIGO),
          'DELETE':PlutoCell(value: 'HI'),
        }
    );
  }
  List<PlutoRow> row_s = <PlutoRow>[];
  List<PlutoColumn> real = <PlutoColumn>[];
  @override
  void initState() {
    setState(() {
      real.addAll(GET_headers(widget.folio.apartado));
    });
    Slimsublinea().Subline().then((value){
      setState(() {
        sublinea2.addAll(value);
        sublinea2_get = sublinea2;
        sublinea2.forEach((element) {
          items.add(element.Nombre);
        });
      });
    });
    if(widget.folio.tipo=='R'){
      widget.type = 'R';
    }
    confirm_view().Slim_container(widget.folio.proveedor,widget.sublinea,widget.folio.folio,'',widget.type).then((value){
      setState((){
        list_container.addAll(value);
        list_container_searcher=list_container;
         list_container.forEach((element) {
          row_s.add(_buildRow(element));
          PlutoGridStateManager.initializeRowsAsync(real,row_s).then((value){
          stateManager.refColumns.addAll(real);
          stateManager.refRows.addAll(value);
          stateManager.setShowLoading(true);
        });
       });
      });
    });
    super.initState();
  }
  bool autoEditing = true;
  void toggleAutoEditing(bool flag) {
    setState(() {
      autoEditing = flag;
      stateManager.setAutoEditing(flag);
    });
  }
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>GRID_Container(user: widget.user, folio: widget.folio)), (Route<dynamic> route) => false);
        }, icon: Icon(Icons.arrow_back_ios)),
        title: Row(
          children: <Widget>[
            Text('FOLIO: ${widget.folio.folio}',style: TextStyle(fontSize: 18),),
            SizedBox(width: 20,),
            Text('DIAS:${widget.folio.dias} LEAD:${widget.folio.lead}',style: TextStyle(fontSize: 18)),
            SizedBox(width: 20,),
            Text('PROVEEDOR: ${widget.folio.proveedor}',style: TextStyle(fontSize: 18)),
            SizedBox(width: 20,),
            Visibility(
              visible: widget.folio.apartado=='Ref China'||widget.folio.apartado=='Ref MX',
              child: DropdownButtonHideUnderline(child: DropdownButton2(isExpanded: true, hint: Text('Select Item', style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),)).toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() async {
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
                        row_s.add(_buildRow(element));
                        PlutoGridStateManager.initializeRowsAsync(real, row_s).then((value){
                          stateManager.refColumns.addAll(real);
                          stateManager.refRows.addAll(value);
                          stateManager.setShowLoading(true);
                        });
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
          ],
        ),
        actions: <Widget>[
          TextButton(onPressed: () async {
             await Done_folio().finish(widget.folio.folio,'Listo');
          }, child: Text('Finalizar\nFolio',style: TextStyle(color: Colors.white),)),
          SizedBox(width: 25,),
          IconButton(onPressed: () async {
            List<confirmadas_container> lista = <confirmadas_container>[];
            Accion_realizada('Petición en curso');
            await confirm_view().Slim_container(widget.folio.proveedor,widget.sublinea,widget.folio.folio,'', widget.type).then((value){
              setState(() {
                lista.addAll(value);
                switch(widget.folio.apartado){
                  case 'Contenedor': container_layout().generateExcelContainer(lista,widget.folio, context);break;
                  case 'Ref China':container_layout().Excel_Refacciones(lista, context); break;
                  case 'Ref MX':container_layout().Excel_Refacciones(lista, context); break;
                  case 'Acc MX':container_layout().generateACCMX(lista,widget.folio.folio, context);break;
                }
                Accion_realizada('Excel generado');
              });
            });

          }, icon: Icon(Icons.save,color: Colors.white,))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: PlutoGrid(
          columns: real,
          rows: row_s,
          onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager.setShowColumnFilter(true);
          event.stateManager.setTextEditingController(controller);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            List<PlutoCell> item_s = event.row.cells.values.toList();
            String  column_ev = event.column.title.toString();
            item_s[0].value;
            switch(column_ev){
              case 'CANTIDAD':Confirmar(Cod_Slim: item_s[0].value, quantity: event.value, folio: widget.folio.folio, user: widget.user);break;
              case 'COLOR':Confirm_color(color: event.value.toString(), cod_slim: item_s[0].value); break;
              case 'DESC-CH':DSChina(dchina: event.value, cond_slim: item_s[0].value); break;
              case 'INSTRUCCIONES':Instruc(instruc: event.value, cond_slim: item_s[0].value); break;
              case 'EXAMPLE':Exmpl(exmple: event.value, cod_slim: item_s[0].value); break;
              case 'DESC-MX':DCMX(dcmx:event.value, cond_slim: item_s[0].value); break;
              case 'BRAND':Brand(brand: event.value, cond_slim: item_s[0].value); break;
              case 'TYPE':Type(type: event.value, cond_slim: item_s[0].value); break;
              case 'MODELO':Modelo(modelo: event.value, cond_slim: item_s[0].value); break;
              case 'FRAME':Frame(frame: event.value, cond_slim: item_s[0].value);break;
            }
            print(item_s[0].value+'-'+event.value.toString()+'-'+column_ev);
            //Confirmar(Cod_Slim: item_s[0].value, quantity: event.value, folio: widget.folio.folio, user: widget.user);
          },
          configuration: const PlutoGridConfiguration(),
        ),
      ),
    );
  }
}
