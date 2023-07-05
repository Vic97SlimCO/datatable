import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:datatable/indice_resources/indice_res.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'option_menu.dart';

class Screen_indices extends StatefulWidget {
  String user;
   Screen_indices({Key? key,required this.user}) : super(key: key);

  @override
  State<Screen_indices> createState() => _Screen_indicesState();
}

class _Screen_indicesState extends State<Screen_indices> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(primaryColor: Colors.purple),
     theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white)),
      home: Mainindice(user: widget.user),
    );
  }
}

class Mainindice extends StatefulWidget {
  String user;
  Mainindice({Key? key,required this.user}) : super(key: key);

  @override
  State<Mainindice> createState() => _MainindiceState();
}

class _MainindiceState extends State<Mainindice> {
  List<DateTime?> _calendar_value = [DateTime.now()];
  String initdt =DateTime.now().subtract(Duration(days: 31)).toString().substring(0,10);
  String finaldt = DateTime.now().toString().substring(0,10);
  late final PlutoGridStateManager stateManager;
  late final PlutoGridStateManager stateManager2;
  List<PlutoRow> row_s = <PlutoRow>[];
  List<PlutoRow> row_z = <PlutoRow>[];
  List<indices_model> list_indices= <indices_model>[];
  List<LineChartBarData> BARS = <LineChartBarData>[];
  List<FlSpot> spots1 = <FlSpot>[];
  List<FlSpot> spots2 = <FlSpot>[];
  int max_value = 0;

  num value_acc_uni = 0;
  num value_ref_uni = 0;
  num value_acc_tot = 0;
  num value_ref_tot = 0;
  List<FLEX> lista = <FLEX>[];
  List<FLEX> lista2 = <FLEX>[];

  void get_sales(String fecha){
    lista.clear();
    row_s.clear();
    FlexFull().getFlex(fecha,fecha).then((value){
      setState(() {
        lista.addAll(value);
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

  void get_sales2(String fecha){
    lista2.clear();
    row_z.clear();
    FlexFull().getFlex(fecha,fecha).then((value){
      setState(() {
        lista2.addAll(value);
        lista2.forEach((element) {
          row_z.add(item_rows(element));
        });
        PlutoGridStateManager.initializeRowsAsync(columns,row_z).then((value){
          stateManager2.refColumns.addAll(columns);
          stateManager2.refRows.addAll(value);
          stateManager2.setShowLoading(false);
        });
      });
    });
  }
  //Double
  @override
  void initState() {
    get_data();
    get_sales(DateTime.now().toString().substring(0,10));
    get_sales2(DateTime.now().subtract(Duration(days: 31)).toString().substring(0,10));
    super.initState();
  }

  List<PlutoColumn> columns =<PlutoColumn>[
    PlutoColumn(title: 'CODIGO', field: 'COD', type: PlutoColumnType.text(),enableEditingMode: false,width: 100),
    PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 150),
    PlutoColumn(title: 'TITULO', field: 'TITLE', type: PlutoColumnType.text(),enableEditingMode: false),
    PlutoColumn(title: 'STATUS', field: 'STATUS', type: PlutoColumnType.text(),enableEditingMode: false,width: 85),
    PlutoColumn(title: 'ES FULL?', field: 'ISFULL', type: PlutoColumnType.text(),enableEditingMode: false,width:85),
    PlutoColumn(title: 'ES FLEX?', field: 'ISFLEX', type: PlutoColumnType.text(),enableEditingMode: false,width: 85),
    PlutoColumn(title: 'VTAS TOTALES', field: 'TOTALES',
        type: PlutoColumnType.number(),
        enableEditingMode: false,
        width: 85,
      footerRenderer: (rendererContext){
        return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            alignment: Alignment.center,
            format: '#,###',
            titleSpanBuilder: (text){
              return [
                const TextSpan(
                  text: 'Sum',
                  style: TextStyle(color: Colors.red)
                ),
                const TextSpan(text: ' : '),
                TextSpan(text: text)
              ];
            },
        );
      }
    ),
    PlutoColumn(title: 'CROSS', field: 'CROSS', type: PlutoColumnType.number(),enableEditingMode: false,width: 85),
    PlutoColumn(title: 'FULL', field: 'FULL', type: PlutoColumnType.text(),enableEditingMode: false,width: 85),
    PlutoColumn(title: 'FLEX', field: 'FLEX', type: PlutoColumnType.text(),enableEditingMode: false,width: 85)
  ];

  PlutoRow item_rows(FLEX item){
    return PlutoRow(
        cells: {
          'COD':PlutoCell(value: item.cODIGO),
          'ID':PlutoCell(value: item.iD),
          'TITLE':PlutoCell(value: item.tITLE),
          'STATUS':PlutoCell(value: item.sTATUS),
          'CROSS':PlutoCell(value: item.vENTASCROSS),
          'TOTALES':PlutoCell(value: item.vENTASTOTALES),
          'FULL':PlutoCell(value: item.vENTASFLEX),
          'FLEX':PlutoCell(value: item.vENTASFULL),
          'ISFULL':PlutoCell(value: item.fULL),
          'ISFLEX':PlutoCell(value: item.fLEX)
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(children: [
            ListTile(
              onTap: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Menu(user: widget.user),), (route) => false,);
              },
              horizontalTitleGap: 0.0,
              leading: Icon(Icons.arrow_back_ios_new_outlined),
              title: Text('Menu Principal'),
            ),
            DrawerHeader(child: Image.network('https://pbs.twimg.com/profile_images/1411539185974972416/-s4R89At_400x400.jpg')),
            ListTile(
              onTap: (){
                list_indices.clear();
                max_value = 0;
                spots1.clear();
                spots2.clear();
                BARS.clear();
                get_indices().indice_req(initdt,finaldt).then((value){
                  setState(() {
                    list_indices.addAll(value);
                    for(int x=0;x<list_indices.length;x++){
                      if(max_value.isLowerThan(list_indices[x].vtasTotales!)){max_value=list_indices[x].vtasTotales!;}
                      spots1.add(FlSpot(x.toDouble(), list_indices[x].vtasTotalesRef!.toDouble()));
                      spots2.add(FlSpot(x.toDouble(), list_indices[x].vtasTotalesAcc!.toDouble()));
                    }
                    BARS.add(
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.yellow,
                          barWidth: 8,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                          spots: spots1,
                        ));
                    BARS.add(
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 8,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                          spots: spots2,
                        )
                    );
                  });
                });},
              horizontalTitleGap: 0.0,
              leading: Icon(Icons.menu),
              title: Text('Ventas Totales'),
            ),
            ListTile(
              onTap: (){
                list_indices.clear();
                max_value = 0;
                spots1.clear();
                spots2.clear();
                BARS.clear();
                get_indices().indice_req(initdt,finaldt).then((value){
                  setState(() {
                    list_indices.addAll(value);
                    for(int x=0;x<list_indices.length;x++){
                      if(max_value.isLowerThan(list_indices[x].vtasTotales!)){max_value=list_indices[x].vtasTotales!;}
                      spots1.add(FlSpot(x.toDouble(), list_indices[x].vtasTotalesRefCross!.toDouble()));
                      spots2.add(FlSpot(x.toDouble(), list_indices[x].vtasTotalesAccCross!.toDouble()));
                    }
                    BARS.add(
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.yellow,
                          barWidth: 8,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                          spots: spots1,
                        ));
                    BARS.add(
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 8,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                          spots: spots2,
                        )
                    );
                  });
                });
              },
              horizontalTitleGap: 0.0,
              leading: Icon(Icons.open_in_full),
              title: Text('Ventas en CROSS'),
            ),
            ListTile(
              onTap: (){
                list_indices.clear();
                max_value = 0;
                spots1.clear();
                spots2.clear();
                BARS.clear();
                get_indices().indice_req(initdt,finaldt).then((value){
                  setState(() {
                    list_indices.addAll(value);
                    for(int x=0;x<list_indices.length;x++){
                      if(max_value.isLowerThan(list_indices[x].vtasTotales!)){max_value=list_indices[x].vtasTotales!;}
                      spots1.add(FlSpot(x.toDouble(), list_indices[x].vtasTotalesRefFull!.toDouble()));
                      spots2.add(FlSpot(x.toDouble(), list_indices[x].vtasTotalesAccFull!.toDouble()));
                    }
                    BARS.add(
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.yellow,
                          barWidth: 8,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                          spots: spots1,
                        ));
                    BARS.add(
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 8,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                          spots: spots2,
                        )
                    );
                  });
                });
              },
              horizontalTitleGap: 0.0,
              leading: Icon(Icons.align_horizontal_right_rounded),
              title: Text('Ventas en Full'),
            )
          ],),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Container(
                            height: 500,
                            color: Colors.white,
                            child:  LineChart(
                                  LineChartData(
                                    lineTouchData: LineTouchData(
                                        handleBuiltInTouches: true,
                                        touchTooltipData: LineTouchTooltipData(
                                            tooltipBgColor: Colors.blueGrey.withOpacity(0.8)
                                        )
                                    ),
                                    titlesData: FlTitlesData(
                                      //topTitles: ,
                                      /* leftTitles: AxisTitles(sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 50,
                                            interval: 1,
                                            getTitlesWidget: leftTitleWidgets
                                          )),*/
                                        bottomTitles:
                                        AxisTitles(
                                            sideTitles:
                                            SideTitles(
                                                showTitles: true,
                                                reservedSize: 50,
                                                interval: 1,
                                                getTitlesWidget:bottomTitleWidgets
                                            ))
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black.withOpacity(0.2)
                                        ),
                                        left: const BorderSide(color: Colors.transparent),
                                        right: const BorderSide(color: Colors.transparent),
                                        top: const BorderSide(color: Colors.transparent),
                                      ),
                                    ),
                                    lineBarsData:
                                    BARS,
                                    gridData: FlGridData(
                                      show: true,
                                    ),
                                    minX: 0,
                                    maxX: list_indices.length-1.toDouble(),
                                    maxY: max_value.toDouble(),
                                    minY: 0,
                                  )
                              ),
                          )),
                      SizedBox(width: 20,),
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: 500,
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade300,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Column(
                              children: [
                                Text('Unidades vendidas',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                SizedBox(
                                  height: 200,
                                  child: PieChart(
                                      PieChartData(
                                          sections: [
                                            PieChartSectionData(value: value_acc_uni.toDouble(),title: 'Accesorios ${(value_acc_uni/((value_acc_uni+value_ref_uni)/100)).toStringAsFixed(2)}%\n'+value_acc_uni.toString(),color: Colors.orange),
                                            PieChartSectionData(value: value_ref_uni.toDouble(),title: 'Refacciones ${(value_ref_uni/((value_acc_uni+value_ref_uni)/100)).toStringAsFixed(2)}%\n'+value_ref_uni.toString(),color: Colors.blueGrey)
                                          ]
                                      )
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Text('Ventas totales',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                SizedBox(
                                  height: 200,
                                  child: PieChart(
                                      PieChartData(
                                          sections: [
                                            PieChartSectionData(value: value_acc_tot.toDouble(),title: 'Accesorios ${(value_acc_tot/((value_ref_tot+value_acc_tot)/100)).toStringAsFixed(2)}%\n'+value_acc_tot.toString(),color: Colors.indigo),
                                            PieChartSectionData(value: value_ref_tot.toDouble(),title: 'Refacciones ${(value_ref_tot/((value_ref_tot+value_acc_tot)/100)).toStringAsFixed(2)}%\n'+value_ref_tot.toString(),color: Colors.pink)
                                          ]
                                      )
                                  ),
                                )
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [
                          Expanded(
                            child: Container(
                              height: 450,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child:lista.isNotEmpty?PlutoGrid(
                                    onLoaded:(PlutoGridOnLoadedEvent event) {
                                      stateManager = event.stateManager;
                                      event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                                      stateManager.setShowColumnFilter(true);
                                    },
                                    configuration: const PlutoGridConfiguration(localeText: PlutoGridLocaleText.spanish()),
                                    columns: columns,
                                    rows: row_s,
                                  ):Center(child: Container(width:200,height:200,child: CircularProgressIndicator())),
                                ),
                            ),
                          ),
                      Expanded(
                          child: Container(
                            height: 450,
                            child: Padding(
                                padding: EdgeInsets.all(8),
                                child: lista2.isNotEmpty?PlutoGrid(
                                  onLoaded:(PlutoGridOnLoadedEvent event) {
                                    stateManager2 = event.stateManager;
                                    event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                                    stateManager2.setShowColumnFilter(true);
                                  },
                                  configuration: const PlutoGridConfiguration(localeText: PlutoGridLocaleText.spanish()),
                                  columns: columns,
                                  rows: row_z,
                                ):Center(child: Container(width:200,height:200,child: CircularProgressIndicator())),
                            ),
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          )
      ),
      appBar: AppBar(
        title:Row(
          children: [
            Text('INDICES'),
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
          ],
        )

      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space:1,
      child: FittedBox(child: TextButton(child: Text(''+list_indices[value.toInt()].iD!.substring(5,10),style: TextStyle(color: Colors.black,fontSize: 12),),
        onPressed: (){
          getdatapie(list_indices[value.toInt()].iD!,DateTime.parse(list_indices[value.toInt()].fecha!));
        }),)
    );
  }
      getdatapie(String id,DateTime fec){
        List<indices_model> indice_pie = <indices_model>[];
        get_indices().indice_req(id,id).then((value){
          setState(() {
            indice_pie.addAll(value);
            value_acc_uni = indice_pie[0].vtasUnidadesAcc!.toDouble();
            value_ref_uni = indice_pie[0].vtasUnidadesRef!.toDouble();
            value_acc_tot = indice_pie[0].vtasTotalesAcc!.toDouble();
            value_ref_tot = indice_pie[0].vtasTotalesRef!.toDouble();
        });
      });
        get_sales(id);
        get_sales2(fec.subtract(Duration(days: 1)).toString().substring(0,10));
   }

  get_data(){
    get_indices().indice_req(initdt,finaldt).then((value){
      setState(() {
        list_indices.addAll(value);
        value_acc_uni = list_indices[0].vtasUnidadesAcc!.toDouble();
        value_ref_uni = list_indices[0].vtasUnidadesRef!.toDouble();
        value_acc_tot = list_indices[0].vtasTotalesAcc!.toDouble();
        value_ref_tot = list_indices[0].vtasTotalesRef!.toDouble();
        for(int x=0;x<list_indices.length;x++){
          if(max_value.isLowerThan(list_indices[x].vtasTotales!)){max_value=list_indices[x].vtasTotales!;}
          spots1.add(FlSpot(x.toDouble(), list_indices[x].vtasTotalesRef!.toDouble()));
          spots2.add(FlSpot(x.toDouble(), list_indices[x].vtasTotalesAcc!.toDouble()));
        }
        BARS.add(
            LineChartBarData(
              isCurved: true,
              color: Colors.yellow,
              barWidth: 8,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              spots: spots1,
            ));
        BARS.add(
            LineChartBarData(
              isCurved: true,
              color: Colors.blue,
              barWidth: 8,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              spots: spots2,
            )
        );
      });
    });
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
            list_indices.clear();
            max_value = 0;
            spots1.clear();
            spots2.clear();
            BARS.clear();
            get_data();
            get_sales(initdt);
            get_sales2(finaldt);
          });
        },
        onCancelTapped: (){
          initdt = DateTime.now().toString().substring(0,10);
          finaldt =DateTime.now().toString().substring(0,10);
          list_indices.clear();
          max_value = 0;
          spots1.clear();
          spots2.clear();
          BARS.clear();
          get_data();
          get_sales(initdt);
          get_sales2(finaldt);
        });

  }
}
