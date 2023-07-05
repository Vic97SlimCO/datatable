import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'Modelo_contenedor/Slim_model.dart';
import 'Modelo_contenedor/model.dart';

class Listos extends StatefulWidget {
  const Listos({Key? key}) : super(key: key);

  @override
  State<Listos> createState() => _ListosState();
}

class _ListosState extends State<Listos> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Listos_screen(),
    );
  }
}

class Listos_screen extends StatefulWidget {

  Listos_screen({Key? key}) : super(key: key);

  @override
  State<Listos_screen> createState() => _Listos_screenState();
}

class _Listos_screenState extends State<Listos_screen> {
  List<folios> folios_list=<folios>[];
  List<folios> folios_apartado =<folios>[];

  List<Proveedores> provider_list = <Proveedores>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: folios_list.length,
          itemBuilder: (context,index){
            return GestureDetector(
              child: Card(
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(padding:EdgeInsets.all(12.0),child: Text('Folio: '+folios_list[index].Folio),),
                    Container(padding:EdgeInsets.all(12.0),child: Text('Status: '+folios_list[index].Status!),),
                    Container(padding:EdgeInsets.all(12.0),child: Text('Proveedor: '+folios_list[index].Proveedor),),
                    Container(padding:EdgeInsets.all(12.0),child: Text('Productos Confirmados: '+folios_list[index].items_conf.toString()),),
                    Container(padding:EdgeInsets.all(12.0),child: Text('Fecha de finalizacion: '+folios_list[index].Fecha_cierre!),)
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}

