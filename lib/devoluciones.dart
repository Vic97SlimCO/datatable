import 'package:datatable/Modelo_dev/dev_model.dart';
import 'package:datatable/option_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Dev extends StatelessWidget {
  String user;
  Dev({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Devoluciones search',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      home: Finder_dev(user: user),
    );
  }
}

class Finder_dev extends StatefulWidget {
  String user;
  Finder_dev({Key? key,required this.user}) : super(key: key);

  @override
  State<Finder_dev> createState() => _Finder_devState();
}

class _Finder_devState extends State<Finder_dev> {
  List<DEV> dev_list = <DEV>[];

  @override
  Widget build(BuildContext context) {
    TextEditingController txtcontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>Menu(user: widget.user)));
        }, icon: Icon(Icons.arrow_back)),
        title: Row(
          children: <Widget>[
            Container(
              width: 350,
              child: TextField(
                style: TextStyle(color: Colors.white,fontSize: 25),
                controller: txtcontroller,
                onSubmitted: (value){
                  dev_list.clear();
                  dev_searcher().dv_searcher(txtcontroller.text).then((value){
                    setState(() {
                      dev_list.addAll(value);
                    });
                  });
                },
              ),
            )
          ],
        ),
      ),
      body:dev_list.isNotEmpty ? DataTable(
          columns: const <DataColumn>[
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('PACK_ID')),
              DataColumn(label: Text('TITULO')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('SKU')),
              DataColumn(label: Text('SHIPPING')),
              DataColumn(label: Text('DATE_CREATED')),
              DataColumn(label: Text('DATE_CLOSED')),
          ],
          rows: List.generate(dev_list.length, (index){
          return DataRow(cells:[
            DataCell(Container(child: GestureDetector(child: Text(dev_list[index].iD!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),onTap:(){
              Clipboard.setData(ClipboardData(text:dev_list[index].iD!));
            } ,),)),
            DataCell(Container(child: GestureDetector(child: Text(dev_list[index].pACKID!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),onTap:(){
              Clipboard.setData(ClipboardData(text:dev_list[index].pACKID!));
            },),)),
            DataCell(Container(child: Text(dev_list[index].tITLE!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),)),
            DataCell(Container(child: Text(dev_list[index].sTATUS!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),)),
            DataCell(Container(child: Text(dev_list[index].sKU!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),)),
            DataCell(Container(child: Text(dev_list[index].sHIPPING!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),)),
            DataCell(Container(child: Text(dev_list[index].dATECREATED!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),)),
            DataCell(Container(child: Text(dev_list[index].dATECLOSED!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),)),
          ]);
        }),
    ):Center(
        child: Container(
          child: Image.network('https://i.pinimg.com/originals/49/e5/8d/49e58d5922019b8ec4642a2e2b9291c2.png'),
        ),
      ),
    );
  }
}

