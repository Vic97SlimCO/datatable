import 'dart:convert';

import 'package:datatable/folios.dart';
import 'package:datatable/indices.dart';
import 'package:datatable/mkt_design_dash_main.dart';
import 'package:datatable/screen_promo.dart';
import 'package:datatable/traspaso.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:transition/transition.dart' as trans;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'cross.dart';
import 'devoluciones.dart';
import 'folios_screen.dart';
import 'improve.dart';
import 'lista_multiple.dart';
import 'main.dart';

/*class menu_opciones extends StatelessWidget{
  String user;
  menu_opciones({Key? key, required this.user}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Lista Orden',
      theme:  ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xFF000000))
      ),
      home: Menu(user: user,),
    );
  }
}*/

class Menu extends StatefulWidget{
  String user;
  Menu({Key? key,required this.user}):super(key: key);
  @override
  State<StatefulWidget> createState() => _Menu();
}

class _Menu extends State<Menu>{


  @override
  Widget build(BuildContext context) {

     Widget _btn_contenedor = Padding(padding:EdgeInsets.all(8),
     child: GestureDetector(
       onTap: (){
         setState(() {
           Navigator.push(context,trans.Transition(child:Folio(user:widget.user),transitionEffect: trans.TransitionEffect.FADE));
         });
       },
       child:Container(
         padding: EdgeInsets.all(20),
         height: 400,
         width: 400,
          child:Neumorphic(
            style: NeumorphicStyle(
              shadowLightColor: Colors.white24,
              shadowDarkColor: Colors.black,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              depth: 8,
              lightSource: LightSource.topLeft,
              //color: Colors.white
            ),
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Align(alignment: Alignment.center,
                  child:Image.asset('assets/orden.jpg'),),
                Align(alignment: Alignment.bottomCenter,
                  child: NeumorphicText('Contenedor',
                    curve: Neumorphic.DEFAULT_CURVE,
                    style: NeumorphicStyle(
                      intensity: 16,
                      shadowLightColor: Colors.white,
                      shadowDarkColor: Colors.white,
                      depth: 4,
                      color: Colors.black,
                    ),
                    textStyle: NeumorphicTextStyle(fontSize: 30,
                        fontWeight: FontWeight.bold),),)
              ],
            ),
          )
       ),
     ),);
     Widget _btn_traspaso = Padding(
       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           setState(() {
             Navigator.push(context, trans.Transition(child:inicio(user: widget.user),transitionEffect: trans.TransitionEffect.BOTTOM_TO_TOP));
           });
         },
         child:Container(
           padding: EdgeInsets.all(20),
           width: 400,
           height: 400,
           child:Neumorphic(
             style: NeumorphicStyle(
               shadowLightColor: Colors.white24,
               shadowDarkColor: Colors.black,
               shape: NeumorphicShape.concave,
               boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
               depth: 8,
               lightSource: LightSource.topLeft,
               //color: Colors.white
             ),
             child: Stack(
               fit: StackFit.loose,
               children: <Widget>[
                 Align(alignment: Alignment.center,
                   child: Image.network('https://cf.shopee.com.mx/file/c0adccdd29fb3f20249c91056e12bb61'),),
                 Align(alignment: Alignment.bottomCenter,
                   child: NeumorphicText('Amazon, Mercado Libre',
                     curve: Neumorphic.DEFAULT_CURVE,
                     style: NeumorphicStyle(
                       intensity: 16,
                       shadowLightColor: Colors.white,
                       shadowDarkColor: Colors.white,
                       depth: 4,
                       color: Colors.black,
                     ),
                     textStyle: NeumorphicTextStyle(fontSize: 30,
                         fontWeight: FontWeight.bold),),)
               ],
             ),
           ),
         ),
       ),
     );
     Widget _btn_multi = Padding(
       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           Navigator.push(context, trans.Transition(child:multi_list(user: widget.user),transitionEffect: trans.TransitionEffect.LEFT_TO_RIGHT));
         },
         child:Container(
           padding: EdgeInsets.all(20),
           width: 400,
           height: 400,
           child: Neumorphic(
             style: NeumorphicStyle(
               shadowLightColor: Colors.white,
               shadowDarkColor: Colors.white,
               shape: NeumorphicShape.concave,
               boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
               depth: 4,
               lightSource: LightSource.topLeft,
               //color: Colors.white
             ),
             child: Stack(
               fit: StackFit.loose,
               children: <Widget>[
                 Align(alignment: Alignment.center,
                 child: Image.network('https://http2.mlstatic.com/storage/mshops-appearance-api/images/65/97892065/logo-2019043020294833300.png'),),
                 Align(alignment: Alignment.bottomCenter,
                 child: NeumorphicText('Codigo Slim',
                 curve: Neumorphic.DEFAULT_CURVE,
                 style: NeumorphicStyle(
                   intensity: 16,
                   lightSource: LightSource.top,
                   shadowDarkColor: Colors.black,
                   shadowLightColor: Colors.white24,
                   depth: 4,
                   color: Colors.black,
                 ),
                 textStyle: NeumorphicTextStyle(fontSize: 30,
                 fontWeight: FontWeight.bold),),)
               ],
             ),
           )
         ),
       ),
     );

     Widget _btn_cross = Padding(
       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           Navigator.push(context,trans.Transition(child:ListCross(user: widget.user),transitionEffect: trans.TransitionEffect.BOTTOM_TO_TOP));
         },
         child:Container(
             padding: EdgeInsets.all(20),
             width: 400,
             height: 400,
             child:Neumorphic(
               style: NeumorphicStyle(
                 shadowLightColor: Colors.white,
                 shadowDarkColor: Colors.white,
                 shape: NeumorphicShape.concave,
                 boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                 depth: 4,
                 lightSource: LightSource.topLeft,
               ),
               child:Stack(
                 fit: StackFit.loose,
                 children: <Widget>[
                   Align(alignment: Alignment.center,
                     child: Image.network('https://cdn.redstagfulfillment.com/wp-content/uploads/RedStag_Dec18-110-1024x680.jpg'),),
                   Align(
                     alignment:Alignment.bottomCenter,
                     child: NeumorphicText('AMAZON CROSS',
                       curve: Neumorphic.DEFAULT_CURVE,
                       style: NeumorphicStyle(
                         intensity: 16,
                         lightSource: LightSource.top,
                         shadowLightColor: Colors.white24,
                         shadowDarkColor: Colors.black,
                         depth: 4,
                         color: Colors.black,
                       ),
                       textStyle: NeumorphicTextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
             )
         ),
       ),);
     Widget _btn_cont = Padding(

       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           Navigator.push(context,trans.Transition(child:List_Folios(user: widget.user),transitionEffect: trans.TransitionEffect.RIGHT_TO_LEFT));
         },
         child:Container(
             padding: EdgeInsets.all(20),
             width: 400,
             height: 400,
             child:Neumorphic(
               style: NeumorphicStyle(
                 shadowLightColor: Colors.white,
                 shadowDarkColor: Colors.white,
                 shape: NeumorphicShape.concave,
                 boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                 depth: 4,
                 lightSource: LightSource.topLeft,
               ),
               child:Stack(
                 fit: StackFit.loose,
                 children: <Widget>[
                   Align(alignment: Alignment.center,
                     child: Image.asset('assets/orden.jpg'),),
                   Align(
                     alignment:Alignment.bottomCenter,
                     child: NeumorphicText('Container',
                       curve: Neumorphic.DEFAULT_CURVE,
                       style: NeumorphicStyle(
                         intensity: 16,
                         lightSource: LightSource.top,
                         shadowLightColor: Colors.white,
                         shadowDarkColor: Colors.white,
                         depth: 4,
                         color: Colors.black,
                       ),
                       textStyle: NeumorphicTextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
             )
         ),
       ),);
     Widget _btn_promo = Padding(

       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           Navigator.push(context,trans.Transition(child:Promotion_screen(user: widget.user),transitionEffect: trans.TransitionEffect.TOP_TO_BOTTOM));
         },
         child:Container(
             padding: EdgeInsets.all(20),
             width: 400,
             height: 400,
             child:Neumorphic(
               style: NeumorphicStyle(
                 shadowLightColor: Colors.white,
                 shadowDarkColor: Colors.white,
                 shape: NeumorphicShape.concave,
                 boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                 depth: 4,
                 lightSource: LightSource.topLeft,
               ),
               child:Stack(
                 fit: StackFit.loose,
                 children: <Widget>[
                   Align(alignment: Alignment.center,
                     child: Image.network('https://altaglatam.com/wp-content/uploads/2014/10/promociones.jpg'),),
                   Align(
                     alignment:Alignment.bottomCenter,
                     child: NeumorphicText('PROMOCIONES',
                       curve: Neumorphic.DEFAULT_CURVE,
                       style: NeumorphicStyle(
                         intensity: 16,
                         lightSource: LightSource.top,
                         shadowLightColor: Colors.white,
                         shadowDarkColor: Colors.white,
                         depth: 4,
                         color: Colors.black,
                       ),
                       textStyle: NeumorphicTextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
             )
         ),
       ),);
     Widget _btn_indice = Padding(
       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           Navigator.push(context,trans.Transition(child:Mainindice(user: widget.user,),transitionEffect: trans.TransitionEffect.SCALE));
         },
         child:Container(
             padding: EdgeInsets.all(20),
             width: 400,
             height: 400,
             child:Neumorphic(
               style: NeumorphicStyle(
                 shadowLightColor: Colors.white,
                 shadowDarkColor: Colors.white,
                 shape: NeumorphicShape.concave,
                 boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                 depth: 4,
                 lightSource: LightSource.topLeft,
               ),
               child:Stack(
                 fit: StackFit.loose,
                 children: <Widget>[
                   Align(alignment: Alignment.center,
                     child: Image.network('https://images.template.net/83408/free-sales-growth-vector-9ig9l.jpg'),),
                   Align(
                     alignment:Alignment.bottomCenter,
                     child: NeumorphicText('INDICES',
                       curve: Neumorphic.DEFAULT_CURVE,
                       style: NeumorphicStyle(
                         intensity: 16,
                         lightSource: LightSource.top,
                         shadowLightColor: Colors.white,
                         shadowDarkColor: Colors.white,
                         depth: 4,
                         color: Colors.black,
                       ),
                       textStyle: NeumorphicTextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
             )
         ),
       ),);
     Widget _btn_improve = Padding(
       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>improve_points(user: widget.user)), (Route<dynamic> route) => false);
           //Navigator.push(context,trans.Transition(child:improve_points(user: widget.user,),transitionEffect: trans.TransitionEffect.SCALE));
         },
         child:Container(
             padding: EdgeInsets.all(20),
             width: 400,
             height: 400,
             child:Neumorphic(
               style: NeumorphicStyle(
                 shadowLightColor: Colors.white,
                 shadowDarkColor: Colors.white,
                 shape: NeumorphicShape.concave,
                 boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                 depth: 4,
                 lightSource: LightSource.topLeft,
               ),
               child:Stack(
                 fit: StackFit.loose,
                 children: <Widget>[
                   Align(alignment: Alignment.center,
                     child: Image.network('https://www.eviciti.com.mx/2019/wp-content/uploads/2021/03/imagen-blog-web39.jpg'),),
                   Align(
                     alignment:Alignment.bottomCenter,
                     child: NeumorphicText('PUNTOS A\nMEJORAR',
                       curve: Neumorphic.DEFAULT_CURVE,
                       style: NeumorphicStyle(
                         intensity: 16,
                         lightSource: LightSource.top,
                         shadowLightColor: Colors.white,
                         shadowDarkColor: Colors.white,
                         depth: 4,
                         color: Colors.black,
                       ),
                       textStyle: NeumorphicTextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
             )
         ),
       ),);
     Widget _btn_design_tareas = Padding(
       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Dash_main(user: widget.user)), (Route<dynamic> route) => false);
           //Navigator.push(context,trans.Transition(child:improve_points(user: widget.user,),transitionEffect: trans.TransitionEffect.SCALE));
         },
         child:Container(
             padding: EdgeInsets.all(20),
             width: 400,
             height: 400,
             child:Neumorphic(
               style: NeumorphicStyle(
                 shadowLightColor: Colors.white,
                 shadowDarkColor: Colors.white,
                 shape: NeumorphicShape.concave,
                 boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                 depth: 4,
                 lightSource: LightSource.topLeft,
               ),
               child:Stack(
                 fit: StackFit.loose,
                 children: <Widget>[
                   Align(alignment: Alignment.center,
                     child: Image.network('https://static.vecteezy.com/system/resources/previews/006/549/765/original/to-do-list-hand-drawn-doodle-icon-free-vector.jpg'),),
                   Align(
                     alignment:Alignment.bottomCenter,
                     child: NeumorphicText('TAREAS\nDISEÑO-MKT',
                       curve: Neumorphic.DEFAULT_CURVE,
                       style: NeumorphicStyle(
                         intensity: 16,
                         lightSource: LightSource.top,
                         shadowLightColor: Colors.white,
                         shadowDarkColor: Colors.white,
                         depth: 4,
                         color: Colors.black,
                       ),
                       textStyle: NeumorphicTextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
             )
         ),
       ),);
     Widget _btn_design_tareas_users = Padding(
       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>users_dsgn_tasks(user: widget.user)), (Route<dynamic> route) => false);
           //Navigator.push(context,trans.Transition(child:improve_points(user: widget.user,),transitionEffect: trans.TransitionEffect.SCALE));
         },
         child:Container(
             padding: EdgeInsets.all(20),
             width: 400,
             height: 400,
             child:Neumorphic(
               style: NeumorphicStyle(
                 shadowLightColor: Colors.white,
                 shadowDarkColor: Colors.white,
                 shape: NeumorphicShape.concave,
                 boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                 depth: 4,
                 lightSource: LightSource.topLeft,
               ),
               child:Stack(
                 fit: StackFit.loose,
                 children: <Widget>[
                   Align(alignment: Alignment.center,
                     child: Image.network('https://static.vecteezy.com/system/resources/previews/006/549/765/original/to-do-list-hand-drawn-doodle-icon-free-vector.jpg'),),
                   Align(
                     alignment:Alignment.bottomCenter,
                     child: NeumorphicText('TAREAS\nDISEÑO-MKT',
                       curve: Neumorphic.DEFAULT_CURVE,
                       style: NeumorphicStyle(
                         intensity: 16,
                         lightSource: LightSource.top,
                         shadowLightColor: Colors.white,
                         shadowDarkColor: Colors.white,
                         depth: 4,
                         color: Colors.black,
                       ),
                       textStyle: NeumorphicTextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
             )
         ),
       ),);
     Widget _btn_design_tareas_returns = Padding(
       padding:EdgeInsets.all(8.0),
       child: GestureDetector(
         onTap: (){
           //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>User_mktdsgn(user: widget.user)), (Route<dynamic> route) => false);
           //Navigator.push(context,trans.Transition(child:improve_points(user: widget.user,),transitionEffect: trans.TransitionEffect.SCALE));
           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Devoluciones_main(user: widget.user)), (Route<dynamic> route) => false);
         },
         child:Container(
             padding: EdgeInsets.all(20),
             width: 400,
             height: 400,
             child:Neumorphic(
               style: NeumorphicStyle(
                 shadowLightColor: Colors.white,
                 shadowDarkColor: Colors.white,
                 shape: NeumorphicShape.concave,
                 boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                 depth: 4,
                 lightSource: LightSource.topLeft,
               ),
               child:Stack(
                 fit: StackFit.loose,
                 children: <Widget>[
                   Align(alignment: Alignment.center,
                     child: Image.network('https://copackerplus.com/wp-content/uploads/2022/10/devolucion-300x300.png'),),
                   Align(
                     alignment:Alignment.bottomCenter,
                     child: NeumorphicText('TAREAS\nDEVOLUCIONES',
                       curve: Neumorphic.DEFAULT_CURVE,
                       style: NeumorphicStyle(
                         intensity: 16,
                         lightSource: LightSource.top,
                         shadowLightColor: Colors.white,
                         shadowDarkColor: Colors.white,
                         depth: 4,
                         color: Colors.black,
                       ),
                       textStyle: NeumorphicTextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
             )
         ),
       ),);
     List<Widget> _botones =[
       Visibility(child: _btn_cross,visible: allow_container(),),
       Visibility(child: _btn_cont,visible: allow_container(),),
       Visibility(child: _btn_promo,visible:promo_allow()),
       Visibility(child: _btn_indice,visible: allow_indices(),),
       Visibility(child: _btn_improve,visible: allow_improve(),),
       Visibility(child: _btn_design_tareas,visible: allow_d_task(),),
       Visibility(child: _btn_design_tareas_users,visible: allow_u_task(),),
       Visibility(child: _btn_design_tareas_returns,visible: is_allowedreturns(),)
     ];
     return Scaffold(
       appBar: AppBar(
         title: Row(
           children: [
             Text('Menu Slim'),
             SizedBox(width: 20,),
             Visibility(
               child: TextButton(
                   onPressed: () async {
                     var response =await http.get(Uri.parse('http://45.56.74.34:6660/MLtok'));
                      //http.StreamedResponse response = await request.send();
                     if (response.statusCode == 200) {
                       //print(await response.stream.bytesToString());
                       String sJson =response.body.toString();
                       var Json = json.decode(sJson);
                       print(Json[0]["token"].toString().trim());
                         await Clipboard.setData(ClipboardData(text:Json[0]["token"].toString().trim()));
                         // copied successfully
                     }
                     else {
                     print(response.reasonPhrase);
                     }
             }, child: Text('GET TOKEN',style: TextStyle(color: Colors.white),)),
               visible:is_allowedTKN(),)
           ],
         ),
         actions: <Widget>[
           IconButton(onPressed: () async {
             await openFile(is_allowedreturns()?'//192.168.10.110/Public/DEVOLUCIONES/SlimDataSetup.exe':'//192.168.10.109/Public/PROGRA/VICTOR/SlimData/SlimDataSetup.exe');
           }, icon: Icon(Icons.download))
         ],
       ),
       body: SingleChildScrollView(
        child: Center(
         child: Container(
           color: Colors.black,
           child: Wrap(
             children: _botones,
           ),
         )
       ),
     )
     );
  }
    Future<void> openFile(String file) async {
      final Uri uri = Uri.file(file);
      print(uri);
      if (!File(uri.toFilePath()).existsSync()) {
        throw '$uri does not exist!';
      }
      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
    }
  allow_container(){
    bool allow = false;
    switch(widget.user){
      case'33':setState(() {
        allow=true;
      });
      break;
      case'19':setState(() {
        allow=true;
      });
      break;
      case'16':setState(() {
        allow=true;
      });
      break;
      case'102':setState(() {
        allow=true;
      });
      break;
      case'100':setState(() {
        allow=true;
      });
      break;
      case'103':setState(() {
        allow=true;
      });
      break;
      case'121':setState(() {
        allow=true;
      });
      break;
      case'118':setState(() {
        allow=true;
      });
      break;
      case'17':setState(() {
        allow=true;
      });
      break;
      case'29':setState(() {
        allow=true;
      });
      break;
      case'1057':setState(() {
        allow=true;
      });
      break;
      case'101':setState(() {
        allow=true;
      });
      break;
      case'36':setState(() {
        allow=true;
      });
      break;
      case'118':setState(() {
        allow=true;
      });
      break;
    }
    return allow;
  }
  allow_indices(){
    bool allow = false;
    switch(widget.user){
      case'33':setState(() {
        allow=true;
      });
      break;
      case'102':setState(() {
        allow=true;
      });
      break;
      case'100':setState(() {
        allow=true;
      });
      break;
      case'103':setState(() {
        allow=true;
      });
      break;
      case'121':setState(() {
        allow=true;
      });
      break;
      case'17':setState(() {
        allow=true;
      });
      break;
      case'1057':setState(() {
        allow=true;
      });
      break;
      case'101':setState(() {
        allow=true;
      });
      break;
      case'118':setState(() {
        allow=true;
      });
      break;
    }
    return allow;
  }
  promo_allow(){
    bool allow = false;
    switch(widget.user){
      case'33':setState(() {
        allow=true;
      });
      break;
      case'102':setState(() {
        allow=true;
      });
      break;
      case'100':setState(() {
        allow=true;
      });
      break;
      case'103':setState(() {
        allow=true;
      });
      break;
      case'121':setState(() {
        allow=true;
      });
      break;
      case'17':setState(() {
        allow=true;
      });
      break;
      case'1057':setState(() {
        allow=true;
      });
      break;
      case'101':setState(() {
        allow=true;
      });
      break;
      case'118':setState(() {
        allow=true;
      });
      break;
    }
    return allow;
  }
  allow_improve(){
    bool allow = false;
    switch(widget.user){
      case'33':setState(() {
        allow=true;
      });
      break;
      case'19':setState(() {
        allow=true;
      });
      break;
      case'16':setState(() {
        allow=true;
      });
      break;
      case'102':setState(() {
        allow=true;
      });
      break;
      case'100':setState(() {
        allow=true;
      });
      break;
      case'103':setState(() {
        allow=true;
      });
      break;
      case'121':setState(() {
        allow=true;
      });
      break;
      case'118':setState(() {
        allow=true;
      });
      break;
      case'17':setState(() {
        allow=true;
      });
      break;
      case'29':setState(() {
        allow=true;
      });
      break;
      case'1057':setState(() {
        allow=true;
      });
      break;
      case'101':setState(() {
        allow=true;
      });
      break;
      case'212':setState(() {
        allow=true;
      });
      break;
      case'213':setState(() {
        allow=true;
      });
      break;
      case'214':setState(() {
        allow=true;
      });
      break;
      case'216':setState(() {
        allow=true;
      });
      break;
      case'217':setState(() {
        allow=true;
      });
      break;
      case'218':setState(() {
        allow=true;
      });
      break;
      case'219':setState(() {
        allow=true;
      });
      break;
      case'220':setState(() {
        allow=true;
      });
      break;
      case'221':setState(() {
        allow=true;
      });
      break;
      case'200':setState(() {
        allow=true;
      });
      break;
      case'118':setState(() {
        allow=true;
      });
      break;
    }
    return allow;
  }

  allow_d_task(){
    bool allow = false;
    switch(widget.user){
      //-------REF
      case'29':setState(() {
        allow=true;
      });
      break;
      case'33':setState(() {
        allow=true;
      });break;
      case'31':setState(() {
        allow=true;
      });break;
      //------ACC
      case'101':setState(() {
        allow=true;
      });
      break;
      case'17':setState(() {
        allow=true;
      });
      break;
      case'14':setState(() {
        allow=true;
      });
      break;
      case'16':setState(() {
        allow=true;
      });
      break;
      case'38':setState(() {
        allow=true;
      });
      break;
      case'3':setState(() {
        allow=true;
      });
      break;
      case'20':setState(() {
        allow=true;
      });
      break;
      //------MASTER
      case'100':setState(() {
        allow=true;
      });
      break;
      case'103':setState(() {
        allow=true;
      });
      break;
      case'121':setState(() {
        allow=true;
      });
      break;
      //------JAZZ
      case'200':setState(() {
        allow=true;
      });
      break;
      //------Prueba
      case'1057':setState(() {
        allow=true;
      });
      break;
      case'1008':setState(() {
        allow=true;
      });
      break;
      case'118':setState(() {
        allow=true;
      });
      break;
    }
    return allow;
  }
  allow_u_task(){
    bool allow = false;
    switch(widget.user){
      case'212':setState(() {
        allow=true;
      });
      break;
      case'213':setState(() {
        allow=true;
      });
      break;
      case'214':setState(() {
        allow=true;
      });
      break;
      case'216':setState(() {
        allow=true;
      });
      break;
      case'217':setState(() {
        allow=true;
      });
      break;
      case'218':setState(() {
        allow=true;
      });
      break;
      case'219':setState(() {
        allow=true;
      });
      break;
      case'220':setState(() {
        allow=true;
      });
      break;
      case'221':setState(() {
        allow=true;
      });
      break;
    }
    return allow;
  }
  is_allowedTKN(){
    bool value = false;
    if(widget.user=='101'||widget.user=='103'||widget.user=='33'||widget.user=='101'||widget.user=='121'||widget.user=='1057'){
      value = true;
    }
    return value;
  }
  is_allowedreturns(){
    bool value = false;
    if(widget.user=='121'
    ||widget.user=='113'
    ||widget.user=='123'
    ||widget.user=='116'
    ||widget.user=='103'
    ||widget.user=='100'){
      value = true;
    }
    return value;
  }
}