
import 'dart:convert';
import 'package:http/http.dart' as http;

class Slim_model{
  String Slim,Desc_corta;
  int WMS,VTA30ML,Full,Compra_Camino,Quantity,UCaja;
  List<String> Thumb;

  Slim_model({required this.Slim,required this.Desc_corta,
    required this.WMS, required this.VTA30ML,required this.Full,
    required this.Compra_Camino,required this.Quantity,required this.UCaja
  ,required this.Thumb});

  factory Slim_model.from(Map<String,dynamic> json){
    var list = json['THUMBNAIL'] as List;
    List<String> THUMBS = list.cast<String>();
    return Slim_model(Slim: json['CODIGO_SLIM'],
        Desc_corta: json['DESCRIPCION_CORTA'],
        WMS: json['WMS_UNIDADES'],
        VTA30ML: json['VTA30DML'],
        Full: json['STOCK_FULL'],
        Compra_Camino: json['COMPRA_EN_CAMINO'],
        Quantity: json['QUANTITY'],
        UCaja: json['UNIDADES_POR_CAJA'],
        Thumb: THUMBS
    );
  }
}

class slim_order{
String codigo_slim,SKU,Desc,Agotar,Thumbnail,proveedores,desc_mx;
String? Color,DChina,Example,Inst,Type,Brand,Frame,Modelo,folio,usuario;
int full,cedis,sugerido,v30nat,v30hist,caja,amzn30v,amznsold,
    confimadas,stock_total,pedir,sublinea2,camino_china,pedidas;
num stockMeses,costo_ultimo;
//num? costo_ultimo;
slim_order({required this.codigo_slim,
  required this.folio,
  required this.SKU,
  required this.Desc,
  required this.Color,
  required this.Agotar,
  required this.Thumbnail,
  required this.costo_ultimo,
  required this.full,
  required this.cedis,
  required this.sugerido,
  required this.v30nat,
  required this.v30hist,
  required this.caja,
  required this.confimadas,
  required this.DChina,
  required this.Example,
  required this.Inst,
  required this.stock_total,
  required this.stockMeses,
  required this.pedir,
  required this.sublinea2,
  required this.Brand,
  required this.Frame,
  required this.Modelo,
  required this.Type,
  required this.proveedores,
  required this.camino_china,
  required this.pedidas,
  required this.usuario,
  required this.amzn30v,
  required this.desc_mx,
  required this.amznsold
});

  factory slim_order.from(Map<String,dynamic> json){
    return slim_order(
        folio: json['Folio'],
        codigo_slim:json['CODIGO'],
        SKU: json['SKU'],
        Desc: json['DESCRIPCION'],
        Color: json['COLOR'],
        Agotar: json['AGOTAR_DESCATALOGAR'],
        Thumbnail: json['THUMBNAIL'],
        costo_ultimo: json['COSTO_ULTIMO_PROVEEDOR'],
        full: json['FULFILLMENT'],
        cedis: json['STOCK_CEDIS'],
        sugerido: json['PEDIDO_SUGERIDO'],
        v30nat: json['VTA30Dnaturales'],
        v30hist: json['VTA30Dhistorica'],
        caja: json['UNIDADES_POR_CAJA'],
        confimadas: json['UNIDADES_CONFIRMADAS'],
        DChina: json['DESCRIPCION_CHINA'],
        Example: json['URL_EXAMPLE'],
        Inst: json['INSTRUCCIONES_USO'],
        stock_total: json['STOCK_CEDIS']+json['FULFILLMENT'],
        stockMeses: (json['STOCK_CEDIS']+json['FULFILLMENT'])/json['VTA30Dhistorica'],
        pedir: (json['VTA30Dhistorica']*3)-(json['STOCK_CEDIS']+json['FULFILLMENT']),
        sublinea2: json['SUBLINEA2'],
        Brand: json['BRAND'],
        Frame: json['FRAME'],
        Modelo: json['MODELO'],
        Type: json['TYPE'],
        proveedores: json['PROVEEDORES'],
        camino_china: json['COMPRA_EN_CAMINO'],
        pedidas: json['UNIDADES_PEDIDAS'],
        usuario: json['USUARIO'],
        amzn30v: json['AMZV30D'],
        desc_mx: json['DESCRIPCION_MX'],
        amznsold: json['AMAZON_SOLD']
        );
  }

}

class Proveedores{
  final String Nombre;
  final int ID;

  Proveedores({required this.Nombre,required this.ID});

  factory Proveedores.from(Map<String, dynamic>json){
    return Proveedores(
        Nombre: json['NOMBRE'],
        ID: json['ID']);
  }
}

class Consul_Provider{
    Future Prove() async{
    var url = Uri.parse('http://45.56.74.34:5558/proveedores/list');
    var response = await http.get(url);
    List<Proveedores> proveedores = <Proveedores>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(36, count-1);
      var Jsonv = json.decode(_sub);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        proveedores.add(Proveedores.from(noteJson));
      }
      return proveedores;
    }else
      throw Exception('NO se pudo');
  }
}
class Pv{
  final String Cod_Slim,Desc_corta;
  final int Cantidad;
  final num total;

  Pv({required this.Cod_Slim,required this.Desc_corta,required this.Cantidad,required this.total});

  factory Pv.from(Map<String, dynamic>json){
    return Pv(
        Cod_Slim: json['CODIGO'],
        Desc_corta: json['DESCRIPCION'],
        Cantidad: json['CANTIDAD'],
        total: json['TOTAL']
    );
  }
}

class PvStock{
  final String? Cod_Slim;
  final int Stock;

  PvStock({required this.Cod_Slim,required this.Stock});

  factory PvStock.from(Map<String, dynamic>json){
    return PvStock(
        Cod_Slim: json['CODIGO'],
        Stock: json['FISICO_DISPONIBLE']
    );
  }
}

class Orden_class{
  Future Orden(String folio,String PR,String title, bool? choice,String Dias,String lead,String sublinea2,String tipo)async{
    String PRR = '&proveedor=$PR';
    String Con = '';
    if(choice==false){
        Con='';
    }
    if(choice==true){
        Con='&confirmados=yes';
    }
    var url = Uri.parse('http://45.56.74.34:8890/container/condensado?folio=$folio&title=$title&dias=$Dias&leadtime=$lead'+PRR+'&sublinea2=$sublinea2&tipo=$tipo'+Con);
    print(url);
    var response = await http.get(url);
    List<slim_order> publicaciones = <slim_order>[];
    if(response.statusCode == 200){
      String sJson = response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      for (var noteJson in Jsonv) {
        publicaciones.add(slim_order.from(noteJson));
      }
      return publicaciones;
    }else throw Exception('NO se pudo');
  }
}

