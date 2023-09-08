
import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:datatable/listaorders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'option_menu.dart';

class LoginTable extends StatelessWidget {
  const LoginTable({Key? key}) : super(key: key);
  static const String _title = 'Slim Company';

  @override
  Widget build(BuildContext context){
    Map<int, Color> colorCodes = {
      50: Color.fromRGBO(25, 26, 54, .1),
      100: Color.fromRGBO(25, 26, 54, .2),
      200: Color.fromRGBO(25, 26, 54, .3),
      300: Color.fromRGBO(25, 26, 54, .4),
      400: Color.fromRGBO(25, 26, 54, .5),
      500: Color.fromRGBO(25, 26, 54, .6),
      600: Color.fromRGBO(25, 26, 54, .7),
      700: Color.fromRGBO(25, 26, 54, .8),
      800: Color.fromRGBO(25, 26, 54, .9),
      900: Color.fromRGBO(25, 26, 54, 1),
    };// Green color code: FF93cd48MaterialColor customColor = MaterialColor(0xFF93cd48, colorCodes);
    return GetMaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
          textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
          primarySwatch:MaterialColor(0xFF4A148C, colorCodes),
      ),
      home: _LoginT(),
    );
  }
}

class _LoginT extends StatefulWidget{
  const _LoginT({Key? key}) :super(key: key);

  @override
  State<_LoginT> createState() => _LoginT_();
}

class _LoginT_ extends State<_LoginT>{
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var prefs;
shared_preferences() async {
  prefs = await SharedPreferences.getInstance();
  nameController.text=prefs.getString('Usuario');
  passwordController.text=prefs.getString('Contrasena');
}

@override
  initState(){
  super.initState();
  }
  @override
  Widget build(BuildContext context){
  shared_preferences();
    return Scaffold(
        //appBar: AppBar(title: Text('Slim Company')),
        body: Container(
            decoration: BoxDecoration(
              //image: DecorationImage(image: NetworkImage('https://marketplace.canva.com/EAE_LfKw720/1/0/1600w/canva-fondo-de-pantalla-degradado-rosa-y-azul-dibujo-constelaci%C3%B3n-ALs0nk1iKfU.jpg'),
              image: DecorationImage(image: AssetImage('assets/cover.png'),
                  fit: BoxFit.cover),
            ),
              child: Center(
                child: Container(
                  width: 500,
                  height: 500,
                  //color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment:  MainAxisAlignment.center,
                              children: <Widget>[
                                /*Container( // El contenedor de la imagen de la pantalla
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
                                    child: Image(
                                      image: NetworkImage('https://http2.mlstatic.com/storage/mshops-appearance-api/images/65/97892065/logo-2019043020294833300.png'),
                                      height: 140,
                                    )),*/
                                Text('¡Qué gusto verte de nuevo!',style: TextStyle(color: Colors.black,fontSize: 30),),
                                Text('Inicia sesión para comenzar',style: TextStyle(color: Colors.black,fontSize: 20)),
                                SizedBox(height: 40,),
                                Container(//El contenedor del cuadro de texto de Usuario
                                  padding: const EdgeInsets.all(10),
                                  child: TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Usuario',
                                    ),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                 // color: Colors.white,
                                ),
                                Container(// El contenedor del cuador de texto para el password
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: TextField(
                                    obscureText: true,
                                    controller: passwordController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Contraseña',
                                    ),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  //color: Colors.white,
                                ),
                                Container(//El boton con el cual inicia una peticion con los parametros agregados
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(32, 41, 79, 1),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    //padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                                    child: TextButton(
                                      child: const Text('Comenzar',
                                        style: TextStyle(
                                            height: 1,
                                            fontSize: 30,
                                            color: Colors.white
                                        ),),
                                      onPressed: () async {
                                        var url = Uri.parse('http://45.56.74.34:5558/usuarios/login/?name='+nameController.text+'&password='+passwordController.text);
                                        var response = await http.get(url);
                                        if(response.statusCode == 200){
                                          var jsonResponse = json.decode(response.body);
                                          Log log = new Log.fromJson(jsonResponse);
                                          if (log.status ==0){
                                            _showDialog(context);
                                          } else {
                                            print(log.data[0].USER_ID);
                                            String userid = log.data[0].USER_ID.toString();
                                            await prefs.setString('Usuario',nameController.text);
                                            await prefs.setString('Contrasena',passwordController.text);
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => new Menu(user: userid)));
                                          }
                                        }
                                      },
                                    )
                                ),
                              ],
                            ),
                          ),
                ),
                ),
              ),
        );
  }
}

class Log {//Clase Log para serializar la respuesta del servidor
  late String message;
  late int status;
  late List<Data> data;

  Log({required this.status, required this.message, required this.data});

  factory Log.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<Data> DataList = list.map((i) => Data.fromJson(i)).toList();
    return Log(
        status: parsedJson['status'],
        message: parsedJson['message'],
        data: DataList);
  }
}

class Data{//El array de la respuesta del servidor
  final String NOMBRE,TOKEN;
  final int USER_ID;

  Data({required this.NOMBRE, required this.TOKEN, required this.USER_ID});

  factory Data.fromJson(Map<String,dynamic> parsedJson){
    return Data(
        NOMBRE: parsedJson['NOMBRE'],
        TOKEN: parsedJson['TOKEN'],
        USER_ID: parsedJson['USER_ID']);
  }
}

void _showDialog(BuildContext context) {//El show dialog mostrado en cuento la sesion sea erronea
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Error !!!",style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
        content: new Text("Usuario o contraseña incorrectos",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),),
        actions: <Widget>[
          new TextButton(
            child: new Text("OK",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurple
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
