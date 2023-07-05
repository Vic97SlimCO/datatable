import 'package:datatable/Modelo_traspaso/modelo_traspaso.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'option_menu.dart';

class Cross_AMZN extends StatefulWidget {
  String user;
   Cross_AMZN({Key? key, required this.user}) : super(key: key);

  @override
  State<Cross_AMZN> createState() => _Cross_AMZNState();
}

class _Cross_AMZNState extends State<Cross_AMZN> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: ListCross(user: widget.user),
    );
  }
}

class ListCross extends StatefulWidget {
  String user;
  ListCross({Key? key,required this.user}) : super(key: key);

  @override
  State<ListCross> createState() => _ListCrossState();
}

class _ListCrossState extends State<ListCross> {
  List<cross_amazon> amazon_list = <cross_amazon>[];
  List<cross_amazon> amazon_list_searcher = <cross_amazon>[];
  bool Ascending = true;

  void initState(){
    list_amazon().CROSS().then((value){
      setState(() {
        amazon_list.addAll(value);
        amazon_list_searcher = amazon_list;
        //print(amazon_list);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Menu(user: widget.user)));
            },
            icon: Icon(Icons.arrow_back)),
        title: Row(
          children: <Widget>[
            FittedBox(child:
            Text('Amazon-Cross'),),
            SizedBox(width: 45,),
            FittedBox(child: Text('Registros: '+amazon_list.length.toString()),),
            SizedBox(width: 45,),
            TextButton(onPressed: (){
              setState((){
                if(Ascending == false){
                  Ascending=true;
                  amazon_list.sort((A,B)=>
                      A.aMZV30D.compareTo(B.aMZV30D));
                }else{
                  Ascending=false;
                  amazon_list.sort((A,B)=>
                      B.aMZV30D.compareTo(A.aMZV30D));
                }
              });
            }, child: Text('Ordenar\npor\nventas',style: TextStyle(color:Colors.white),)),
            SizedBox(width: 45,),
            Container(
              padding: EdgeInsets.all(5),
              width: 300,
              child: TextField(
                  cursorColor: Colors.white,
                 // controller: controller,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                onChanged: (value){
                    value = value.toUpperCase();
                    setState(() {
                      amazon_list= amazon_list_searcher.where((element) {
                        String sku =  element.sKU??"N";
                        var searcher = element.dESCRIPCIONCORTA.toUpperCase()+element.cODIGOSLIM.toUpperCase()+sku.toUpperCase()+element.aSIN.toUpperCase();
                        return searcher.contains(value);
                      }).toList() ;
                    });
                },
              ),
            )
          ],
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                amazon_list.clear();
                list_amazon().CROSS().then((value){
                  setState(() {
                    amazon_list.addAll(value);
                    amazon_list_searcher = amazon_list;
                    //print(amazon_list);
                  });
                });
              }, icon: Icon(Icons.refresh))
        ]
        ),
      body: GridView.builder(
          itemCount: amazon_list.length,
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 2.0,crossAxisSpacing: 15,mainAxisSpacing: 15),
          itemBuilder: (context,index){
            return _Item(amazon_list[index]);
          }),
    );
  }
  _Item(cross_amazon item){
    return Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
        child: Neumorphic(
          padding: const EdgeInsets.all(8),
          style: NeumorphicStyle(
            shadowDarkColor: Colors.black,
            shadowLightColor: Colors.deepPurple,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: 2,
            lightSource: LightSource.topLeft,
            //color: getColor(folios_item.Apartado.toString()),
            color: Colors.orange,
            intensity: 1,
            surfaceIntensity: 1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: GestureDetector(
                  onTap:(){
                    Clipboard.setData(ClipboardData(text: item.cODIGOSLIM));
                  } ,
                  child: Text('Cod_Slim:'+item.cODIGOSLIM,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color:Colors.black
                    ),),
                ),
                leading: Image.network(item.imagen??'https://st.depositphotos.com/1987177/3470/v/950/depositphotos_34700099-stock-illustration-no-photo-available-or-missing.jpg'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Clipboard.setData(ClipboardData(text: item.aSIN));
                      },
                      child: Text('ASIN: '+item.aSIN,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),
                    ),
                    Text('DESC Corta: '+item.dESCRIPCIONCORTA,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('WMS Existencia: '+item.wMSUNIDADES.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('AMAZON 30V: '+item.aMZV30D.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('Status: '+item.status.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('Precio: '+item.precio.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    Text('ML_30V: '+item.vTA30ML.toString(),
                      style: TextStyle(
                        fontSize:18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                  ],
                ),
              )
            ],
          ),
        ),
    ),
    );
  }
}
