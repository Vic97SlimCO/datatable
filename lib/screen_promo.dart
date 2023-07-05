import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:datatable/Promotion_resources/promo_res.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';

import 'Modelo_contenedor/slim_container.dart';
import 'option_menu.dart';

class stfulpromo extends StatefulWidget {
  String user;
   stfulpromo({Key? key,required this.user}) : super(key: key);

  @override
  State<stfulpromo> createState() => _stfulpromoState();
}

class _stfulpromoState extends State<stfulpromo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'screen',
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xFF000000))),
      home: Promotion_screen(user: widget.user,),
    );
  }
}

class Promotion_screen extends StatefulWidget {
  String user;
  Promotion_screen({Key? key,required this.user}) : super(key: key);

  @override
  State<Promotion_screen> createState() => _Promotion_screenState();
}

class _Promotion_screenState extends State<Promotion_screen> {
  String texto = '*';
  List<promo_list> list_promo = <promo_list>[];
  List<promo_list> list_promo_searcher = <promo_list>[];
  TextEditingController controller = TextEditingController();
  TextEditingController controller_desc = TextEditingController();
  TextEditingController controller_ganancia = TextEditingController();
  TextEditingController controller_ventas = TextEditingController();
  String dt_init = '*';
  String dt_final ='*';
  List<Sublinea> sublinea2 = <Sublinea>[];
  List<Sublinea> sublinea2_get = <Sublinea>[];
  List<String> items = <String>[];
  List<String> items_ventas = ['Mayor a','Menor a','Igual a'];
  String? selectedValue='*';
  String? selectedValue_v='Mayor a';
  String sublinea ='*';
  String init_date = '*';
  String final_date = '*';
  num descuento = 0;
  num ganancia = 0;
  String _verticalGroupValue = "Ambas";
  List<DateTime?> _calendar_value = [DateTime.now()];
  final _status = ["Ambas", "Accesorios", "Refacciones"];
  String tipo = '*';
  @override
  void initState() {
    controller_ventas.text =0.toString();
    DateTime hoy = DateTime.now();
    DateTime final_dt = hoy.subtract(Duration(days: 30));
    init_date = hoy.toString().substring(0,10);
    final_date = final_dt.toString().substring(0,10);
    Slimsublinea().Subline().then((value){
      setState(() {
        sublinea2.addAll(value);
        sublinea2_get = sublinea2;
        sublinea2.forEach((element) {
          items.add(element.Nombre);
        });
      });
    });
    promo_class().Promotion_Data('*', dt_init,dt_final,sublinea,init_date,final_date,tipo).then((value){
      setState(() {
        list_promo.addAll(value);
        list_promo_searcher = list_promo;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthCount = (MediaQuery.of(context).size.width ~/ 500).toInt();
    final minCount = 2;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leading: Row(
          children: <Widget>[
            IconButton(onPressed: () {Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Menu(user: widget.user),), (route) => false,); },icon: Icon(Icons.arrow_back_ios),),
          ]
        ),
        title: Row(
          children: <Widget>[
            Expanded(child: Text('PROMOTIONS',style: TextStyle(fontSize: 15),)),
            SizedBox(width: 5,),
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.all(Radius.circular(40))),
                  hintText: 'Buscar...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  )
                ),
                onChanged: (value){

                },
                onSubmitted: (value){
                  setState(() {
                    list_promo.clear();
                    list_promo_searcher.clear();
                    if(controller.text.isNotEmpty){
                      texto = controller.text;
                    }else{
                      texto = '*';
                    }
                  });
                  promo_class().Promotion_Data(texto,dt_init, dt_final,sublinea,'','',tipo).then((value){
                    setState(() {
                      list_promo.addAll(value);
                      list_promo_searcher = list_promo;
                    });
                  });
                },
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: TextButton(onPressed:() async {
                await showDialog(context: context, builder: (BuildContext context){
                  return Card(
                    elevation: 10,
                    margin: EdgeInsets.fromLTRB(50,
                        200,50,
                        200),
                    child: Container(

                      //padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      color: Colors.white,
                      //width: 500,
                      //height: 500,
                      child: _calendar()
                    ),
                  );
                });
              }, child: Text('DATE-CREATED',style: TextStyle(color: Colors.white),)),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: DropdownButtonHideUnderline(child: DropdownButton2(isExpanded: true, hint: Text('Select Item', style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),)).toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState((){
                    selectedValue = value as String;
                    sublinea2 =sublinea2_get.where((element){
                      var searcher = element.Nombre;
                      return searcher.contains(selectedValue.toString());
                    }).toList();
                    int sublineaID =sublinea2[0].ID;
                    setState(() {
                      if(sublineaID==0){
                        sublinea = '*';
                      }else{
                        sublinea =sublineaID.toString();
                      }
                      setState(() {
                        list_promo.clear();
                        list_promo_searcher.clear();
                      });
                      promo_class().Promotion_Data(texto,dt_init, dt_final,sublinea,'','',tipo).then((value){
                        setState(() {
                          list_promo.addAll(value);
                          list_promo_searcher = list_promo;
                        });
                      });
                    });
                  });
                },
                buttonStyleData: const ButtonStyleData(
                  height: 40,
                  width: 100,
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
            SizedBox(width: 5,),
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
                    tipo = 'A';
                      break;
                    case 'Refacciones':
                    tipo = 'R';
                      break;
                    case 'Ambas':
                    tipo = '*';
                      break;
                  }

                list_promo.clear();
                list_promo_searcher.clear();
        promo_class().Promotion_Data(texto,dt_init, dt_final,sublinea,'','',tipo).then((value){
        setState(() {
          list_promo.addAll(value);
          list_promo_searcher = list_promo;
        });
      });
                }),
                items: _status,
                itemBuilder: (item) => RadioButtonBuilder(
                  item,
                ),
                activeColor: Colors.white,
                //fillColor: Colors.purple,
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: TextField(
                controller: controller_desc,
                autofocus: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.all(Radius.circular(40))),
                    hintText: 'Aplicar Descuento%',
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    )
                ),
                onChanged: (value){
                  if(value.isEmpty){
                    setState(() {
                      descuento =0;
                    });
                  }
                },
                onSubmitted: (value){
                  setState(() {
                    descuento = num.parse(controller_desc.text.trim());
                  });
                },
              ),
            ),

            Expanded(
              child: TextField(
                controller: controller_ganancia,
                autofocus: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.all(Radius.circular(40))),
                    hintText: 'Aplicar indice de ganancia',
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    )
                ),
                onChanged: (value){
                  if(value.isEmpty){
                    setState(() {
                      ganancia =0;
                    });
                  }
                },
                onSubmitted: (value){
                  setState(() {
                    ganancia = num.parse(controller_ganancia.text.trim());
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child:
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: Text('Control de\nVentas',style: TextStyle(fontSize: 10,height: 0),)),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              barrierLabel: 'Control de ventas',
                              isExpanded: true,
                              hint: Text('Control de ventas', style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold),),
                              items: items_ventas.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),)).toList(),
                              value: selectedValue_v,
                              onChanged: (value) {
                                setState((){
                                  selectedValue_v = value as String;
                                  switch(selectedValue_v){
                                    case 'Mayor a':list_promo =list_promo_searcher.where((element){
                                      var searcher = element.v30D;
                                      return searcher>num.parse(controller_ventas.text.trim());
                                    }).toList(); break;
                                    case 'Menor a': list_promo =list_promo_searcher.where((element){
                                      var searcher = element.v30D;
                                      return searcher<num.parse(controller_ventas.text.trim());
                                    }).toList();break;
                                    case 'Igual a': list_promo =list_promo_searcher.where((element){
                                      var searcher = element.v30D;
                                      return searcher==num.parse(controller_ventas.text.trim());
                                    }).toList();break;
                                  }
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 50,
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
                        Expanded(
                          child: TextField(
                            controller: controller_ventas,
                            autofocus: true,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.all(Radius.circular(40))),
                                hintText: 'Ventas',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                )
                            ),
                            onChanged: (value){

                            },
                            onSubmitted: (value){
                              setState(() {
                                switch(selectedValue_v){
                                  case 'Mayor a':list_promo =list_promo_searcher.where((element){
                                    var searcher = element.v30D;
                                    return searcher>num.parse(controller_ventas.text.trim());
                                  }).toList(); break;
                                  case 'Menor a': list_promo =list_promo_searcher.where((element){
                                    var searcher = element.v30D;
                                    return searcher<num.parse(controller_ventas.text.trim());
                                  }).toList();break;
                                  case 'Igual a': list_promo  =list_promo_searcher.where((element){
                                    var searcher = element.v30D;
                                    return searcher==num.parse(controller_ventas.text.trim());
                                  }).toList();break;
                                }
                                //descuento = num.parse(controller_desc.text.trim());
                              });
                            },
                          ),
                        ),
                      ],
                ),
            ),
            Expanded(child: TextButton(
              onPressed: (){
              list_promo.forEach((element) {
                //num desc = element.pRICE-((element.pRICE/100)*descuento);
                num gain = element.pRICE-((element.pRICE/100)*descuento)-element.ML_FEE-element.shipping_cost - (element.COSTO_ULTIMO*element.fACTOR);
                if(element.pROMO =='NO'&&gain>ganancia){
                 String fec_promoinit = DateTime.now().toString().substring(0,10);
                 String fec_prmofinal = DateTime.now().add(Duration(days: 20)).toString().substring(0,10);
                    print(element.iD+' PRECIO:'+element.pRICE.toString()+' Ganancia:'+gain.toString()+' Indice de ganancia:'+ganancia.toString());
                    controlo_promo().ADD_PROMO(element.iD, descuento,fec_promoinit,fec_prmofinal);
                 }
                Promo_toast('Peticion Realizada');
              });
              },
              child: Text(
                'Add Promocion',
                style: TextStyle(color: Colors.white),
              ),
            )
            )
          ],
        ),
      ),
      body:list_promo.isNotEmpty ? GridView.builder(
          addAutomaticKeepAlives: true,
          itemCount: list_promo.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: max(widthCount, minCount),
          childAspectRatio: 5,
          crossAxisSpacing: 9,
          mainAxisSpacing: 5
        ),
        itemBuilder: (context, int index){
          return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: max(widthCount, minCount),
              duration: const Duration(milliseconds: 200),
              child: SlideAnimation(
                  horizontalOffset: 50,
                  verticalOffset: 50,
                  child: List_item(list_promo[index])
              )
          );
        },
      ):Center(child: Container(
        width: 200,
        height: 200,
          child: CircularProgressIndicator()))
    );
  }
  List_item(promo_list publicacion){
   num desc = publicacion.pRICE-((publicacion.pRICE/100)*descuento);
   num gain = publicacion.pRICE-((publicacion.pRICE/100)*descuento)-publicacion.ML_FEE-publicacion.shipping_cost - (publicacion.COSTO_ULTIMO*publicacion.fACTOR);
   String fec_promoinit = '';
   String fec_prmofinal = '';
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        child: Neumorphic(
         padding: const EdgeInsets.all(8),
         style: NeumorphicStyle(
             shadowDarkColor: Colors.black,
             shadowLightColor: Colors.indigo,
             boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
             depth: 2,
             lightSource: LightSource.topLeft,
             intensity: 1,
             surfaceIntensity: 1,
             color:getColor(publicacion.pROMO=='SI',gain.isLowerThan(ganancia))),
             //gain.isLowerThan(ganancia)?Colors.red:Colors.black),
          child: ListTile(
             leading:  Image.network(publicacion.tHUMBNAIL),
             title: Text(publicacion.iD,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
             subtitle:  Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(publicacion.tITLE,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                   Text('VENTAS: '+publicacion.v30D.toString()+' AGE: '+publicacion.age.toString(),style: TextStyle(color: Colors.white)),
                   Text('PRECIO: '+publicacion.pRICE.toString()+' PRECIO EN DESCUENTO: '+desc.toStringAsFixed(2)+' COSTO: '+publicacion.COSTO_ULTIMO.toStringAsFixed(2),style: TextStyle(color: Colors.white)),
                 ],
             ),
          )
        ),
        onLongPress: (){
          controlo_promo().DELETE_PROMO(publicacion.iD).then((value){
            Promo_toast('Promocion eliminada en '+publicacion.iD);
          }).onError((error, stackTrace){
            Promo_toast('Error en eliminar promocion en '+publicacion.iD);
          });
        },
          onTap:(){
            Pasteboard.writeText(publicacion.iD);
            Promo_toast('${publicacion.iD} copiado');
          },
        onDoubleTap: () async {
          fec_promoinit = DateTime.now().toString().substring(0,10);
          fec_prmofinal = DateTime.now().add(Duration(days: 20)).toString().substring(0,10);
          print(fec_promoinit + fec_prmofinal);
          await showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              insetPadding: EdgeInsets.fromLTRB(50,
                                       200,50,
                                       200),
              actions: [
                TextButton(onPressed: (){
                  List<promoML> respuesta = <promoML>[];
                  controlo_promo().DELETE_PROMO(publicacion.iD);
                  controlo_promo().ADD_PROMO(publicacion.iD, descuento, fec_promoinit,fec_prmofinal).then((value){
                    setState(() {
                      respuesta.addAll(value);
                      Promo_toast(respuesta[0].message.toString());
                    });
                  });
                }, child: Text('Generar promocion'))
              ],
              content:
                  Card(
                      elevation: 10,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Container(
                        padding: EdgeInsets.all(35),
                        child: Column(
                          children: <Widget>[
                            GestureDetector
                              (child: Text(publicacion.iD),onTap:(){
                              Pasteboard.writeText(publicacion.iD);
                              Promo_toast('${publicacion.iD} copiado');
                            },),
                            Text(publicacion.tITLE),
                            Text('FECHA DE CREACION: '+ publicacion.dATECREATED.substring(0,10)),
                            Text('LOGISTICA: '+publicacion.lOGISTICTYPE),
                            Text('STOCK: '+publicacion.sTOCKCEDIS.toString()),
                            Text('FACTOR: '+publicacion.fACTOR.toString()+' VENTAS30D: '+publicacion.v30D.toString()),
                            Text('PRICE: '+publicacion.pRICE.toString()),
                            Text('DISCOUNT PRICE: '+desc.toStringAsFixed(2)),
                            Text('COSTO ULTIMO:'+(publicacion.COSTO_ULTIMO*publicacion.fACTOR).toStringAsFixed(2)),
                            Text('COMISION:'+publicacion.ML_FEE.toString()+' ENVIO: '+publicacion.shipping_cost.toStringAsFixed(2)),
                            Text('GANANCIA: '+(gain).toStringAsFixed(2)),
                            TextButton(onPressed: () async {
                                List<DateTime?> _singleDatePickerValueWithDefaultValue = [
                                  DateTime.now(),
                                ];
                                 showDialog(context: context, builder: (BuildContext context){
                                    return Card(
                                      elevation: 10,
                                      margin: EdgeInsets.fromLTRB(800, 300, 800,300),
                                      child: Container(
                                        child: CalendarDatePicker2WithActionButtons(
                                         config: CalendarDatePicker2WithActionButtonsConfig(
                                           firstDayOfWeek: 1,
                                           calendarType: CalendarDatePicker2Type.range,
                                           selectedDayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                           selectedDayHighlightColor: Colors.purple[800],
                                           centerAlignModePicker: true,
                                           customModePickerIcon: SizedBox(),
                                         ),
                                         value: _singleDatePickerValueWithDefaultValue,
                                         onValueChanged: (dates) =>setState(() {
                                           _singleDatePickerValueWithDefaultValue = dates;
                                         }),
                                         onOkTapped: (){
                                              print(_singleDatePickerValueWithDefaultValue);
                                              if(_singleDatePickerValueWithDefaultValue.length>1){
                                                DateTime first = _singleDatePickerValueWithDefaultValue[0]!;
                                                DateTime second = _singleDatePickerValueWithDefaultValue[1]!;
                                                int rango = second.difference(first).inDays;
                                                if(rango>21){
                                                  print('El rango es mayor a 21 dias rango '+rango.toString()+' dias.');
                                                  Promo_toast('El rango es mayor a 21 dias');
                                                }else{
                                                  print('Rango permitido :'+rango.toString());
                                                  setState(() {
                                                   fec_promoinit = first.toString().substring(0,10);
                                                   fec_prmofinal = second.toString().substring(0,10);
                                                   print('Fecha inicial '+fec_promoinit +'-Fecha final '+fec_prmofinal);
                                                   Promo_toast('Rango permitido');
                                                  });
                                                }
                                              }else{
                                                Promo_toast('Selecciona un rango de fecha valido');
                                              }
                                          },
                                          onCancelTapped: (){
                                           setState(() {
                                             fec_promoinit = DateTime.now().toString().substring(0,10);
                                             fec_prmofinal = DateTime.now().add(Duration(days: 20)).toString().substring(0,10);
                                           });
                                            print(fec_promoinit + fec_prmofinal);
                                          },
                                      ),
                                    ),
                                  );
                                });
                              }, child: Text('Fecha de la promocion'))
                          ],
                        ),
                      ),
                    ),
              );
          },);
        },
      ),
    );
  }
  getColor(bool promo,bool colo_gain){
    Color color_promo;
    if(promo == true){
      color_promo = Colors.green;
    }else{
      if(colo_gain ==true){
        color_promo= Colors.red;
      }else{
        color_promo= Colors.black;
      }
    }
   return color_promo;
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
        print(_calendar_value);
        if(_calendar_value.length>1){
          DateTime first = _calendar_value[0]!;
          DateTime second = _calendar_value[1]!;
          setState(() {
            list_promo.clear();
            list_promo_searcher.clear();
            dt_init=first.toString().substring(0,10);
            dt_final=second.toString().substring(0,10);
          });
          promo_class().Promotion_Data(texto,dt_init, dt_final,sublinea,'','',tipo).then((value){
            setState(() {
              list_promo.addAll(value);
              list_promo_searcher = list_promo;
            });
          });
        }
      },
      onCancelTapped: (){
        dt_init = '*';
        dt_final ='*';
        setState(() {
          list_promo.clear();
          list_promo_searcher.clear();
        });
        promo_class().Promotion_Data(texto,dt_init, dt_final,sublinea,'','',tipo).then((value){
          setState(() {
            list_promo.addAll(value);
            list_promo_searcher = list_promo;
          });
        });
      },
    );
  }
}


