import 'dart:convert';
import 'package:http/http.dart' as http;
class Slim{
  String cod_slim,meli,title,sku,thumbnail,flex,asin,desc,status,es_full
  ,inventory_id,color,date_created;
  int av_quantity,av_quantity_ori,stockfull,vta30ML,
      stock,wmsunidades,shopee_stock,stockamazon,vta30MLH,en_camino,AMAZON_SOLD,
  amzncross,amznfba,vta30amzn,ofertado_shopee,variation_id,amazon30_hist,wms_amazon;
  num price,costo_publicacion,comision,comision_porcentaje,amazon_precio;

  Slim({
    required this.cod_slim,
    required this.desc,
    required this.meli,
    required this.title,
    required this.sku,
    required this.thumbnail,
    required this.flex,
    required this.color,
    required this.av_quantity,
    required this.av_quantity_ori,
    required this.stockfull,
    required this.vta30ML,
    required this.stock,
    required this.wmsunidades,
    required this.shopee_stock,
    required this.stockamazon,
    required this.vta30MLH,
    required this.asin,
    required this.amzncross,
    required this.amznfba,
    required this.vta30amzn,
    required this.price,
    required this.costo_publicacion,
    required this.ofertado_shopee,
    required this.status,
    required this.es_full,
    required this.comision,
    required this.comision_porcentaje,
    required this.inventory_id,
    required this.variation_id,
    required this.date_created,
    required this.amazon30_hist,
    required this.amazon_precio,
    required this.en_camino,
    required this.wms_amazon,
    required this.AMAZON_SOLD
  });


  factory Slim.from(Map<String,dynamic>json){
    return Slim(
      cod_slim: json['CODIGO_SLIM'],
      desc: json['DESCRIPCION_CORTA'],
      meli: json['ID'],
      title: json['TITLE'],
      sku: json['SKU'],
      color: json['COLOR'],
      thumbnail: json['THUMBNAIL'],
      flex: json['SHIPPING_FLEX'],
      av_quantity: json['AVAILABLE_QUANTITY'],
      av_quantity_ori: json['AVAILABLE_QUANTITY_ORI'],
      stockfull: json['STOCK_FULL'],
      vta30ML: json['VTA_LAST30D'],
      stock: json['STOCK'],
      wmsunidades: json['WMS_UNIDADES'],
      shopee_stock: json['STOCK_SHOPEE'],
      ofertado_shopee: json['SHOPEE_STOCK'],
      stockamazon: json['STOCK_AMAZON'],
      vta30MLH: json['VTA30D'],
      asin: json['ASIN'],
      amzncross: json['AMAZON_CROSSDOCK'],
      amznfba: json['AMAZON_FBA'],
      vta30amzn: json['AMZV30D'],
      price: json['PRICE'],
      costo_publicacion: json['COSTO_PUBLICACION'],
      status: json['STATUS'],
      es_full: json['FULFILLMENT'],
      comision: json['SALE_FEE_AMOUNT'],
      comision_porcentaje: json['SALE_FEE_AMOUNT']/(json['PRICE']/100),
      inventory_id: json['INVENTORY_ID'],
      variation_id: json['VARIATION_ID'],
      date_created: json['DATE_CREATED'],
      amazon30_hist: json['AMAZON_SOLD'],
      amazon_precio: json['AMAZON_PRECIO'],
      en_camino: json['ENV_ENCAMINO'],
      wms_amazon: json['WMS_AMAZON'],
      AMAZON_SOLD: json['AMAZON_SOLD']
    );
  }

}


class areas_stock {
  String cod_slim,desc,linea_desc;
  int cross,acc_racks,acc_mz,ref_mz,amz,shp,rev,
      //emp_dan,
      merma,tec_gar;
      //,diseno

  areas_stock({required this.cod_slim,required this.desc,required this.linea_desc,required this.cross,
    required this.acc_racks,required this.acc_mz,required this.ref_mz,required this.amz,required this.shp,required this.rev,
    //required this.emp_dan,
    required this.merma,required this.tec_gar});
    //required this.diseno
  //

  factory areas_stock.from(Map<String,dynamic>json){
    return areas_stock(
        cod_slim: json['CODIGO'],
        desc: json['DESCRIPCION'],
        linea_desc: json['LINEA_DESCRIPCION'],
        cross: json['CROSSDOCK'],
        acc_racks: json['ACC_RACKS'],
        acc_mz: json['ACC_MZ'],
        ref_mz: json['REF_MZ'],
        amz: json['AMZ'],
        shp: json['SHP'],
        rev: json['REV'],
        merma: json['MERMA'],
        tec_gar: json['TEC_GAR'],

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

class historial{
  String fecha,compra_ID,Proveedor,SKU;
  int cantidad,ventas;
  num costo,total,iva;

  historial({required this.fecha,required this.compra_ID,
    required this.Proveedor,required this.SKU,required this.cantidad,
 required this.iva,required this.ventas,required this.costo,required this.total});

  factory historial.from(Map<String,dynamic>json){
    return historial(
        fecha: json['DATE_RECEIPT'],
        compra_ID: json['COMPRA_ID'],
        Proveedor: json['NOMBRE'],
        SKU: json['SKU'],
        cantidad: json['UNITS'],
        iva: json['FACTOR_IVA'],
        ventas: json['VENTAS'],
        costo: json['COST'],
        total: json['COST']*json['UNITS']);
  }
}

class ubicaciones_stock{
  String codigo_slim,descripcion,ubicaciones;

  ubicaciones_stock({required this.codigo_slim,required this.descripcion,required this.ubicaciones});
  factory ubicaciones_stock.from(Map<String, dynamic>json){
    return ubicaciones_stock(
        codigo_slim: json['CODIGO'],
        descripcion: json['DESCRIPCION'],
        ubicaciones: json['UBICACIONES']);
  }

}

class productos{
  String cod_slim,canales,descripcion,ubicaciones;
  int Stock,sub2;

  productos({required this.cod_slim,required this.canales,required this.descripcion,
    required this.Stock,required this.sub2,required this.ubicaciones});

  factory productos.from(Map<String, dynamic>json){
    return productos(
        cod_slim: json['CODIGO'],
        descripcion: json['DESCRIPCION'],
        Stock: json['STOCK_CEDIS'],
        sub2: json['SUBLINEA2_ID'],
        ubicaciones:json['UBICACIONES'],
        canales: json['CANALES']);
  }
}

class cross_amazon {
  String cODIGOSLIM;
  String dESCRIPCIONCORTA;
  int wMSUNIDADES;
  int vTA30ML;
  String? sKU;
  int aMZV30D;
  //String aMAZONSOLD;
  String aSIN;
  //int aMAZONCROSSDOCK;
  num precio;
  String? imagen;
  //int aMAZONFBA;
  String status;

  cross_amazon({
    required this.cODIGOSLIM,
    required this.dESCRIPCIONCORTA,
    required this.wMSUNIDADES,
    required this.vTA30ML,
    required this.sKU,
    required this.aMZV30D,
    //required this.aMAZONSOLD,
    required this.aSIN,
    //required this.aMAZONCROSSDOCK,
    required this.precio,
    required this.imagen,
    //required this.aMAZONFBA,
    required this.status});

  factory cross_amazon.from(Map<String,dynamic>json){
    return cross_amazon(
    cODIGOSLIM : json['CODIGO_SLIM'],
    dESCRIPCIONCORTA : json['DESCRIPCION_CORTA'],
    wMSUNIDADES : json['WMS_UNIDADES'],
    vTA30ML : json['VTA30ML'],
    sKU : json['SKU'],
    aMZV30D : json['AMZV30D'],
    //aMAZONSOLD : json['AMAZON_SOLD'],
    aSIN : json['ASIN'],
    //aMAZONCROSSDOCK : json['AMAZON_CROSSDOCK'],
    precio: json['PRECIO_AMZ'],
    imagen: json['IMAGEN'],
    //aMAZONFBA : json['AMAZON_FBA'],
    status: json['Status']
    );
  }
}

class list_amazon{
  Future CROSS() async{
    var url = Uri.parse('http://45.56.74.34:6660/cross');
    var response = await http.get(url);
    List<cross_amazon> lista_amazon = <cross_amazon>[];
    if(response.statusCode ==200){
      String sJson =response.body.toString();
      var Jsonv = json.decode(sJson);
      //print(Jsonv);
      for (var noteJson in Jsonv) {
        lista_amazon.add(cross_amazon.from(noteJson));
      }
      return lista_amazon;
    }else
      throw Exception('NO se pudo');
  }
}
