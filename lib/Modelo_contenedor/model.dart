import 'dart:convert';
import 'package:http/http.dart' as http;

class Variant{
  final String SKU,Marca,Color,Slim,Title,ID,Thumbnail,Status,Desc,Flex,Agotar;
  final String? Proveedor;
  final int Stock_F,Stock,VTA30,Cam,WMS,Disp,Soldq,Age,Stock_Ama,VariationID,Compras_Camino,UCaja;
  final int Stock_Shop,Stock_Pv1,Compras,Amazn_FBA,Amazn_Cross,WMS_Factor,Pedido_quantity,V30ML;
  final int? Stock_Sh;
  final num price,health;
  final bool is_variant;
  Variant({required this.ID,required this.SKU, required this.Marca,required this.Color, required this.VTA30,required this.Slim,required this.Title,required this.Cam,
    required this.Stock_F,required this.price,required this.Thumbnail,required this.Compras,
  required this.WMS,required this.Status,required this.health,required this.Desc,
  required this.Disp,required this.Soldq,required this.Age,required this.Flex,required this.Proveedor,required this.Stock,required this.Stock_Sh,
    required this.Stock_Ama,required this.Stock_Pv1,required this.Stock_Shop,required this.is_variant,required this.Amazn_FBA,required this.Amazn_Cross,
  required this.WMS_Factor,required this.VariationID,required this.Pedido_quantity,required this.Compras_Camino,required this.V30ML,required this.UCaja,
  required this.Agotar});

  factory Variant.from(Map<String, dynamic>json){
    return Variant(
        ID: json['ID'],
        SKU: json['SKU'],
        Marca: json['MARCA'],
        Color:json['COLOR'],
        VTA30: json['VTA_LAST30D'],
        Soldq: json['SOLD_QUANTITY'],
        Compras: json['COMPRAS_SOLD'],
        Age: json['AGE'],
        Slim: json['CODIGO_SLIM'],
        Title: json['TITLE'],
        Stock_F: json['STOCK_FULL'],
        Stock: json['STOCK'],
        Stock_Sh: json['SHOPEE_STOCK'],
        Stock_Shop: json['STOCK_SHOPEE'],
        Stock_Ama: json['STOCK_AMAZON'],
        Stock_Pv1: json['STOCK_PV1'],
        Cam: json['ENV_ENCAMINO'],
        price: json['PRICE'],
        Thumbnail: json['THUMBNAIL'],
        WMS: json['WMS_UNIDADES'],
        Status: json['STATUS'],
        health: json['HEALTH'],
        Desc: json['DESCRIPCION_CORTA'],
        Disp: json['AVAILABLE_QUANTITY'],
        Flex: json['SHIPPING_FLEX'],
        is_variant: json['IS_VARIANT'],
        Proveedor: json['PROVEEDORES'],
        Amazn_FBA: json['AMAZON_FBA'],
        Amazn_Cross: json['AMAZON_CROSSDOCK'],
        WMS_Factor: json['WMS_FACTOR'],
        VariationID: json['VARIATION_ID'],
        Pedido_quantity: json['QUANTITY'],
        Compras_Camino: json['COMPRA_EN_CAMINO'],
        V30ML: json['VTA30DML'],
        UCaja: json['UNIDADES_POR_CAJA'],
        Agotar: json['AGOTAR_DESCATALOGAR']
    );
  }
}

class folios {
 final String Folio,Referencia,Fecha_creacion,Proveedor,Tipo;
 final String? Status,Apartado,Fecha_cierre;
 final int Dias,Lead,items_conf;

 folios({required this.Folio,required this.Referencia,required this.Fecha_creacion,required this.Proveedor,
 required this.Tipo,required this.Dias,required this.Lead,required this.Apartado,required this.Fecha_cierre,
 required this.items_conf,required this.Status});

 factory folios.from(Map<String,dynamic>json){
        return folios(
            Folio:json['Folio'],
            Referencia:json['Referencia'],
            Fecha_creacion:json['Fecha_Creacion'],
            Proveedor:json['Proveedor'],
            Tipo:json['Tipo'],
            Dias:json['Dias'],
            Lead:json['Lead'],
            Apartado: json['Apartado'],
            Fecha_cierre: json['Fecha_Termino'],
            items_conf: json['Productos_Confirmados'],
            Status: json['Status'],
        );
 }
}

class Consul_folios{
  Future Folios()async{
    var url = Uri.parse('http://45.56.74.34:8890/pedido');
    var response = await http.get(url);
    List<folios> folios_ = <folios>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      int count = sJson.toString().length;
      String _sub = sJson.toString().substring(34, count-1);
      var Jsonv = json.decode(_sub);
      print(Jsonv);
      for (var noteJson in Jsonv) {
        folios_.add(folios.from(noteJson));
      }
      return folios_;
    }else
      throw Exception('NO se pudo');
  }
}

class Folios_ACCMX{
  final String Proveedor_Nombre;
  final String Usuario;
  final String id_proveedor;

  Folios_ACCMX({required this.Proveedor_Nombre,required this.Usuario,required this.id_proveedor});

}

class imagen_exist{
  String Cod_Slim,image_exist;

  imagen_exist({required this.Cod_Slim,required this.image_exist});
}



