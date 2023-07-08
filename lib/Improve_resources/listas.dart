import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../mkt_design_dash_main.dart';

List<PlutoColumn> Petercolumn = <PlutoColumn>[
  PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
  PlutoColumn(title: 'TAREA', field: 'TOPIC', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,
      renderer: (contst){
        return ContextTop(CoDSlim: contst.row.cells['CODIGO']!.value, topic: contst.cell.value,canal: contst.row.cells['CANAL']!.value,/*pub: contst.row.cells['PUB']!.value,*/);
      }),
  PlutoColumn(title: 'CREÓ', field: 'CREATEDBY', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO', field: 'TIPO', type:PlutoColumnType.select(
      <String>[
        'Refacciones',
        'Accesorios'
      ]
  ),enableContextMenu: true),
  PlutoColumn(title: 'CODIGO', field: 'CODIGO', type: PlutoColumnType.text(),enableEditingMode: false,width: 110),
  PlutoColumn(title: 'DESCRIPCION', field: 'COD_DSC', type: PlutoColumnType.text(),enableEditingMode: false,width: 200,
      renderer: (contxt){
        return Text(contxt.cell.value);
      }),
  PlutoColumn(title: 'WMS_STOCK', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO_PUB', field: 'TIPO_PUB', type: PlutoColumnType.select(
      <String>[
        'Clasica',
        'Premium'
      ]
  ),enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'CANAL', field: 'CANAL', type: PlutoColumnType.text(),enableEditingMode: false,width: 75),
  PlutoColumn(title: 'MARKETING', field: 'USER_MKT',type: PlutoColumnType.text(),enableEditingMode:false,width: 95),
  PlutoColumn(title: 'DISEÑO', field: 'USER_DGN', type: PlutoColumnType.text(),enableEditingMode:false,width: 95),
  PlutoColumn(title: 'COSTO NET', field: 'COST', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'PRECIO_ML', field: 'PRECIO_ML', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'PRECIO_AMZN', field: 'PRECIO_AMZN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'PRECIO_SHEIN', field: 'PRECIO_SHEIN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'NOTAS_ADICIONALES', field: 'DESC', type: PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'PRIORIDAD', field: 'PRIOR', type: PlutoColumnType.select(
    <String>[
      'ALTA',
      'MEDIA',
      'BAJA'
    ],
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'ALTA': colorsillo = Colors.red;break;
        case'MEDIA':colorsillo = Colors.yellow;break;
        case'BAJA':colorsillo = Colors.blue;break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  } ,enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'MKT STATUS', field: 'STATUS_MKT', type: PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'NOTA_MKT', field: 'NOTA_MKT', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'WIP_MKT', field: 'WIP_MKT', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'DISEÑO STATUS', field: 'STATUS_DGN', type: PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'NOTA_DISEÑO', field: 'NOTA_DGN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'WIP_DISEÑO', field: 'WIP_DGN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'STATUS_FINAL', field: 'STATUS_FINAL', type:PlutoColumnType.text(),
    renderer: (contxt){
      _change(){
        Color colorsillo = Colors.grey;
        switch(contxt.cell.value){
          case'Asignada': colorsillo = Colors.yellow;break;
          case'Completado':colorsillo = Colors.green;break;
          case'Realizar Cambios':colorsillo = Colors.orange;break;
          case'Trabajando en ello':colorsillo = Colors.blue;break;
          case'Para Revisar':colorsillo = Colors.purple;break;
          case 'No aplica':colorsillo = Colors.red; break;
        }
        return colorsillo;
      }
      return Container(
        color:_change(),
        child: Text(contxt.cell.value),
      );
    },enableEditingMode: false,
    width: 85,),
  PlutoColumn(title: 'WIP_FINAL', field: 'WIP_FINAL', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'CHECKED', field: 'CHECKED', type: PlutoColumnType.text(),enableEditingMode: false,enableRowChecked: false,width: 85,
      renderer: (conxt){
        String ischcked = '';
        switch(conxt.cell.value){
          case true: ischcked = 'Revisado!'; break;
          case false: ischcked = 'Por revisar!'; break;
        }
        return Container(
          color: conxt.cell.value?Colors.green:Colors.red,
          child: Text(ischcked,style: TextStyle(color: Colors.white),),
        );
      }),

  PlutoColumn(title: 'NOTAYS', field: 'NOTAYS', type: PlutoColumnType.text(),enableEditingMode: false,width: 95,hide: true),
  PlutoColumn(title: 'MELI', field: 'ML', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'AMZN', field: 'AMZN', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'SHEIN', field: 'SHEIN', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'REVISAR', field: 'A_CHECKED', type: PlutoColumnType.select(
      <String>['REVISADO','NO REVISADO']
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case 'REVISADO': colorsillo = Colors.green;break;
        case 'NO REVISADO': colorsillo = Colors.yellow;break;
      //default:colorsillo=Colors.grey; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell. value),
    );
  },enableContextMenu: true,width: 95,hide: false),
  PlutoColumn(title: 'REVISADOPOR', field: 'A_CHECKEDBY', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'FECHAyHORA_C', field: 'DT', type: PlutoColumnType.text(),enableEditingMode: false,width: 150,),
];

//--------------------Ale
List<PlutoColumn> Alecolumn = <PlutoColumn>[
  PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
  PlutoColumn(title: 'TAREA', field: 'TOPIC', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,
      renderer: (contst){
        return ContextTop(CoDSlim: contst.row.cells['CODIGO']!.value, topic: contst.cell.value,canal: contst.row.cells['CANAL']!.value,/*pub: contst.row.cells['PUB']!.value,*/);
      }),
  PlutoColumn(title: 'CREÓ', field: 'CREATEDBY', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO', field: 'TIPO', type:PlutoColumnType.select(
      <String>[
        'Refacciones',
        'Accesorios'
      ]
  ),enableContextMenu: true),
  PlutoColumn(title: 'CODIGO', field: 'CODIGO', type: PlutoColumnType.text(),enableEditingMode: false,width: 110),
  PlutoColumn(title: 'DESCRIPCION', field: 'COD_DSC', type: PlutoColumnType.text(),enableEditingMode: false,width: 200,
      renderer: (contxt){
        return Text(contxt.cell.value);
      }),
  PlutoColumn(title: 'WMS_STOCK', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO_PUB', field: 'TIPO_PUB', type: PlutoColumnType.select(
      <String>[
        'Clasica',
        'Premium'
      ]
  ),enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'CANAL', field: 'CANAL', type: PlutoColumnType.text(),enableEditingMode: false,width: 75),
  PlutoColumn(title: 'MARKETING', field: 'USER_MKT',type: PlutoColumnType.text(),enableEditingMode:false,width: 95),
  PlutoColumn(title: 'DISEÑO', field: 'USER_DGN', type: PlutoColumnType.text(),enableEditingMode:false,width: 95),
  PlutoColumn(title: 'C_NETO', field: 'COST', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'PRECIO_ML', field: 'PRECIO_ML', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'PRECIO_AMZN', field: 'PRECIO_AMZN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'PRECIO_SHEIN', field: 'PRECIO_SHEIN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'NOTAS_ADICIONALES', field: 'DESC', type: PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'PRIORIDAD', field: 'PRIOR', type: PlutoColumnType.select(
    <String>[
      'ALTA',
      'MEDIA',
      'BAJA'
    ],
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'ALTA': colorsillo = Colors.red;break;
        case'MEDIA':colorsillo = Colors.yellow;break;
        case'BAJA':colorsillo = Colors.blue;break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  } ,enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'MKT STATUS', field: 'STATUS_MKT', type: PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'WIP_MKT', field: 'WIP_MKT', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'NOTA_MKT', field: 'NOTA_MKT', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'STATUS_FINAL', field: 'STATUS_FINAL', type:PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableEditingMode: false,width: 85,),
  PlutoColumn(title: 'WIP_FINAL', field: 'WIP_FINAL', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'CHECKED', field: 'CHECKED', type: PlutoColumnType.text(),enableEditingMode: false,enableRowChecked: false,width: 85,
      renderer: (conxt){
        String ischcked = '';
        switch(conxt.cell.value){
          case true: ischcked = 'Revisado!'; break;
          case false: ischcked = 'Por revisar!'; break;
        }
        return Container(
          color: conxt.cell.value?Colors.green:Colors.red,
          child: Text(ischcked,style: TextStyle(color: Colors.white),),
        );
      }),


  PlutoColumn(title: 'DISEÑO STATUS', field: 'STATUS_DGN', type: PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'NOTA DISEÑO', field: 'NOTA_DGN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'WIP DISEÑO', field: 'WIP_DGN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'NOTAYS', field: 'NOTAYS', type: PlutoColumnType.text(),enableEditingMode: false,width: 95,hide: true),
  PlutoColumn(title: 'ML', field: 'ML', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'AMZN', field: 'AMZN', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'SHEIN', field: 'SHEIN', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'REVISAR', field: 'A_CHECKED', type: PlutoColumnType.select(
      <String>['REVISADO','NO REVISADO']
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case 'REVISADO': colorsillo = Colors.green;break;
        case 'NO REVISADO': colorsillo = Colors.yellow;break;
      //default:colorsillo=Colors.grey; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell. value),
    );
  },enableContextMenu: true,width: 95,hide: false),
  PlutoColumn(title: 'REVISADOPOR', field: 'A_CHECKEDBY', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'DT', field: 'DT', type: PlutoColumnType.text(),enableEditingMode: false,width: 150,),
];
//-------YAZZ
List<PlutoColumn> yazzcolumn = <PlutoColumn>[
  PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
  PlutoColumn(title: 'TAREA', field: 'TOPIC', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,
      renderer: (contst){
        return ContextTop(CoDSlim: contst.row.cells['CODIGO']!.value, topic: contst.cell.value,canal: contst.row.cells['CANAL']!.value,/*pub: contst.row.cells['PUB']!.value,*/);
      }),
  PlutoColumn(title: 'CREÓ', field: 'CREATEDBY', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO', field: 'TIPO', type:PlutoColumnType.select(
      <String>[
        'Refaccion',
        'Accesorio'
      ]
  ),enableContextMenu: true,
        renderer: (conxt){
         Color colorsito = Colors.black;
          if(conxt.cell.value.toString().contains('Refaccion')){
            colorsito = Colors.blue;
        }else{
            colorsito = Colors.pink;
          }
        return Container(
        color: colorsito,
        child: Text(conxt.cell.value,style: TextStyle(color: Colors.white),),
        );
        }),
  PlutoColumn(title: 'NOTAS', field: 'NOTAYS', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'CODIGO', field: 'CODIGO', type: PlutoColumnType.text(),enableEditingMode: false,width: 110),
  PlutoColumn(title: 'DESCRIPCION', field: 'COD_DSC', type: PlutoColumnType.text(),enableEditingMode: false,width: 200,
      renderer: (contxt){
        return Text(contxt.cell.value);
      }),
  PlutoColumn(title: 'WMS_TOCK', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO_PUB', field: 'TIPO_PUB', type: PlutoColumnType.select(
      <String>[
        'Clasica',
        'Premium'
      ]
  ),enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'CANAL', field: 'CANAL', type: PlutoColumnType.text(),enableEditingMode: false,width: 75),
  PlutoColumn(title: 'MARKETING', field: 'USER_MKT', type: PlutoColumnType.select(
      <String>[
        'MARKETING1',
        'Raul',
        'Xime',
        'Brenda',
        'MARKETING5',
        'Ariadna'
      ]
  ),enableContextMenu: true,width: 95),
  PlutoColumn(title: 'DISEÑO', field: 'USER_DGN', type: PlutoColumnType.select(
      <String>[
        'Viry',
        'Diana',
        'MARKETING8',
        'Yitzil',
        'Gerardo',
        'Yazmin'
      ]
  ),enableContextMenu: true,width: 95),
  PlutoColumn(title: 'PRECIO_ML', field: 'PRECIO_ML', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'PRECIO_AMZN', field: 'PRECIO_AMZN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'PRECIO_SHEIN', field: 'PRECIO_SHEIN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'NOTAS ADICIONALES', field: 'DESC', type: PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'PRIORIDAD', field: 'PRIOR', type: PlutoColumnType.select(
    <String>[
      'ALTA',
      'MEDIA',
      'BAJA'
    ],
  ),
    renderer: (contxt){
      _change(){
        Color colorsillo = Colors.grey;
        switch(contxt.cell.value){
          case'ALTA': colorsillo = Colors.red;break;
          case'MEDIA':colorsillo = Colors.yellow;break;
          case'BAJA':colorsillo = Colors.blue;break;
        }
        return colorsillo;
      }
      return Container(
        color:_change(),
        child: Text(contxt.cell.value),
      );
    },
    enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'MKT ESTADO', field: 'STATUS_MKT', type: PlutoColumnType.select(
      <String>[
        'Realizar Cambios','Completado','No aplica'
      ]
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'NOTA_MKT', field: 'NOTA_MKT', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'WIP_MKT', field: 'WIP_MKT', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'DG ESTADO', field: 'STATUS_DGN', type: PlutoColumnType.select(
      <String>[
        'Realizar Cambios','Completado','No aplica'
      ]
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'NOTA_DG', field: 'NOTA_DGN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'WIP_DG', field: 'WIP_DGN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'ESTADO FINAL', field: 'STATUS_FINAL', type:PlutoColumnType.select(
      <String>[
        'Realizar Cambios','Completado','No aplica'
      ]
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'WIP_FINAL', field: 'WIP_FINAL', type:PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'REVISION FINAL', field: 'CHECKED', type: PlutoColumnType.text(),enableEditingMode: false,enableRowChecked: false,width: 85,
      renderer: (conxt){
        String ischcked = '';
        switch(conxt.cell.value){
          case true: ischcked = 'Revisado!'; break;
          case false: ischcked = 'Por revisar!'; break;
        }
        return Container(
          color: conxt.cell.value?Colors.green:Colors.red,
          child: Text(ischcked,style: TextStyle(color: Colors.white),),
        );
      }),
  PlutoColumn(title: 'MELI', field: 'ML', type:PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'AMZ', field: 'AMZN', type:PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'SHEIN', field: 'SHEIN', type:PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'APROBADA', field: 'A_CHECKED', type: PlutoColumnType.text(),enableEditingMode:false,renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case 'REVISADO': colorsillo = Colors.green;break;
        case 'NO REVISADO': colorsillo = Colors.yellow;break;
      //default:colorsillo=Colors.grey; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },width: 95,hide: false),
  PlutoColumn(title: 'USUARIO', field: 'A_CHECKEDBY', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'FECHAyHORA_C', field: 'DT', type: PlutoColumnType.text(),enableEditingMode: false,width: 150,),
];

List<PlutoColumn> colums = <PlutoColumn>[
  PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
  PlutoColumn(title: 'TAREA', field: 'TOPIC', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,),
  PlutoColumn(title: 'CREÓ', field: 'CREATEDBY', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO', field: 'TIPO', type:PlutoColumnType.select(
      <String>[
        'Refaccion',
        'Accesorio'
      ]
  ),enableContextMenu: true,
      renderer: (conxt){
        Color colorsito = Colors.black;
        if(conxt.cell.value.toString().contains('Refaccion')){
          colorsito = Colors.blue;
        }else{
          colorsito = Colors.pink;
        }
        return Container(
          color: colorsito,
          child: Text(conxt.cell.value,style: TextStyle(color: Colors.white),),
        );
      }),
  PlutoColumn(title: 'NOTAS', field: 'NOTAYS', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'CODIGO', field: 'CODIGO', type: PlutoColumnType.text(),enableEditingMode: false,width: 110),
  PlutoColumn(title: 'DESCRIPCION', field: 'COD_DSC', type: PlutoColumnType.text(),enableEditingMode: false,width: 200,
      renderer: (contxt){
        return Text(contxt.cell.value);
      }),
  PlutoColumn(title: 'WMS_STOCK', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO_PUB', field: 'TIPO_PUB', type: PlutoColumnType.select(
      <String>[
        'Clasica',
        'Premium'
      ]
  ),enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'CANAL', field: 'CANAL', type: PlutoColumnType.text(),enableEditingMode: false,width: 75),
  PlutoColumn(title: 'MARKETING', field: 'USER_MKT', type: PlutoColumnType.select(
      <String>[
        'MARKETING1',
        'Raul',
        'Xime',
        'Brenda',
        'MARKETING5',
        'Ariadna',
        'SELENE',
        'Victor Moneda'
      ]
  ),enableContextMenu: true,width: 95),
  PlutoColumn(title: 'DISEÑO', field: 'USER_DGN', type: PlutoColumnType.select(
      <String>[
        'Viry',
        'Diana',
        'MARKETING8',
        'Yitzil',
        'Gerardo',
        'Yazmin'
      ]
  ),enableContextMenu: true,width: 95),
  PlutoColumn(title: 'C_NET', field: 'COST', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'PRECIO_ML', field: 'PRECIO_ML', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'PRECIO_AMZN', field: 'PRECIO_AMZN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'PRECIO_SHEIN', field: 'PRECIO_SHEIN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'NOTAS_ADICIONALES', field: 'DESC', type: PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'PRIORIDAD', field: 'PRIOR', type: PlutoColumnType.select(
    <String>[
      'ALTA',
      'MEDIA',
      'BAJA'
    ],
  ),
    renderer: (contxt){
      _change(){
        Color colorsillo = Colors.grey;
        switch(contxt.cell.value){
          case'ALTA': colorsillo = Colors.red;break;
          case'MEDIA':colorsillo = Colors.yellow;break;
          case'BAJA':colorsillo = Colors.blue;break;
        }
        return colorsillo;
      }
      return Container(
        color:_change(),
        child: Text(contxt.cell.value),
      );
    },
    enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'MKT ESTADO', field: 'STATUS_MKT', type: PlutoColumnType.select(
      <String>[
        'Realizar Cambios','Completado','No aplica'
      ]
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'NOTA_MKT', field: 'NOTA_MKT', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'WIP_MKT', field: 'WIP_MKT', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'DG ESTADO', field: 'STATUS_DGN', type: PlutoColumnType.select(
      <String>[
        'Realizar Cambios','Completado','No aplica'
      ]
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'NOTA_DG', field: 'NOTA_DGN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'WIP_DG', field: 'WIP_DGN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'STATUS_FINAL', field: 'STATUS_FINAL', type:PlutoColumnType.select(
      <String>[
        'Realizar Cambios','Completado','No aplica'
      ]
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'WIP_FINAL', field: 'WIP_FINAL', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'REVISION FINAL', field: 'CHECKED', type: PlutoColumnType.text(),enableEditingMode: false,enableRowChecked: false,width: 85,
      renderer: (conxt){
        String ischcked = '';
        switch(conxt.cell.value){
          case true: ischcked = 'Revisado!'; break;
          case false: ischcked = 'Por revisar!'; break;
        }
        return Container(
          color: conxt.cell.value?Colors.green:Colors.red,
          child: Text(ischcked,style: TextStyle(color: Colors.white),),
        );
      }),
  PlutoColumn(title: 'MELI', field: 'ML', type:PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'AMZ', field: 'AMZN', type:PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'SHEIN', field: 'SHEIN', type:PlutoColumnType.text(),enableEditingMode: true),
  PlutoColumn(title: 'APROBADA', field: 'A_CHECKED', type: PlutoColumnType.text(),enableEditingMode:false,renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case 'REVISADO': colorsillo = Colors.green;break;
        case 'NO REVISADO': colorsillo = Colors.yellow;break;
      //default:colorsillo=Colors.grey; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },width: 95,hide: false),
  PlutoColumn(title: 'USUARIO', field: 'A_CHECKEDBY', type:PlutoColumnType.text(),enableEditingMode: false),
  PlutoColumn(title: 'FECHAyHORA_C', field: 'DT', type: PlutoColumnType.text(),enableEditingMode: false,width: 150,)
];

List<PlutoColumn> colums_DGN = <PlutoColumn>[
  PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
  PlutoColumn(title: 'TAREA', field: 'TOPIC', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,),
  PlutoColumn(title: 'CREÓ', field: 'CREATEDBY', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO', field: 'TIPO', type: PlutoColumnType.text(),enableEditingMode: false,width: 95,
      renderer: (conxt){
        Color colorsito = Colors.black;
        if(conxt.cell.value.toString().contains('Refaccion')){
          colorsito = Colors.blue;
        }else{
          colorsito = Colors.pink;
        }
        return Container(
          color: colorsito,
          child: Text(conxt.cell.value,style: TextStyle(color: Colors.white),),
        );
      }
  ),
  PlutoColumn(title: 'CODIGO', field: 'CODIGO', type: PlutoColumnType.text(),enableEditingMode: false,width: 110),
  PlutoColumn(title: 'DESCRIPCION', field: 'COD_DSC', type: PlutoColumnType.text(),enableEditingMode: false,width: 200,
      renderer: (contxt){
        return Text(contxt.cell.value);
      }),
  PlutoColumn(title: 'WMS_STOCK', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO_PUB', field: 'TIPO_PUB', type: PlutoColumnType.text(),enableContextMenu: false,enableEditingMode: false,width: 85,),
  PlutoColumn(title: 'CANAL', field: 'CANAL', type: PlutoColumnType.text(),enableEditingMode: false,width: 75),
  PlutoColumn(title: 'MARKETING', field: 'USER_MKT', type: PlutoColumnType.text(),width: 95,enableEditingMode: false),
  PlutoColumn(title: 'DISEÑO', field: 'USER_DGN', type: PlutoColumnType.text(),width: 95,enableEditingMode: false),
  PlutoColumn(title: 'PRECIO_ML', field: 'PRECIO_ML', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'PRECIO_AMZN', field: 'PRECIO_AMZN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'PRECIO_SHEIN', field: 'PRECIO_SHEIN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'NOTAS ADICIONALES', field: 'DESC', type: PlutoColumnType.text(),enableEditingMode: false,),
  PlutoColumn(title: 'PRIORIDAD', field: 'PRIOR', type: PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'ALTA': colorsillo = Colors.red;break;
        case'MEDIA':colorsillo = Colors.yellow;break;
        case'BAJA':colorsillo = Colors.blue;break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableEditingMode: false,width: 85,),
  PlutoColumn(title: 'NOTA_MKT', field: 'NOTA_MKT', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'MKT ESTADO', field: 'STATUS_MKT', type: PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableEditingMode: false,width: 85,),
  PlutoColumn(title: 'WIP_MKT', field: 'WIP_MKTING', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'DG ESTADO', field: 'STATUS_DGN', type: PlutoColumnType.select(
      <String>['Trabajando en ello','Para Revisar']
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'NOTA_DG', field: 'NOTA_DGN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'WIP_DG', field: 'WIP_DGN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'ESTADO FINAL', field: 'STATUS_FINAL', type: PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableEditingMode: false,width: 85,),
  PlutoColumn(title: 'WIP_FINAl', field: 'WIP_FINAL', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'REVISION FINAL', field: 'CHECKED', type: PlutoColumnType.text(),enableEditingMode: false,enableRowChecked: false,width: 85,
      renderer: (conxt){
        String ischcked = '';
        switch(conxt.cell.value){
          case true: ischcked = 'Revisado!'; break;
          case false: ischcked = 'Por revisar!'; break;
        }
        return Container(
          color: conxt.cell.value?Colors.green:Colors.red,
          child: Text(ischcked,style: TextStyle(color: Colors.white),),
        );
      }),
  PlutoColumn(title: 'MELI', field: 'ML', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'AMZN', field: 'AMZN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'SHEIN', field: 'SHEIN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'FECHAyHORA_C', field: 'DT', type: PlutoColumnType.text(),enableEditingMode: false,width: 150,),
];

List<PlutoColumn> colums_MKT = <PlutoColumn>[
  PlutoColumn(title: 'ID', field: 'ID', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,hide: true),
  PlutoColumn(title: 'CREÓ', field: 'CREATEDBY', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TAREA', field: 'TOPIC', type: PlutoColumnType.text(),enableEditingMode: false,width: 75,),
  PlutoColumn(title: 'TIPO', field: 'TIPO', type: PlutoColumnType.text(),enableEditingMode: false,width: 95,
      renderer: (conxt){
        Color colorsito = Colors.black;
        if(conxt.cell.value.toString().contains('Refaccion')){
          colorsito = Colors.blue;
        }else{
          colorsito = Colors.pink;
        }
        return Container(
          color: colorsito,
          child: Text(conxt.cell.value,style: TextStyle(color: Colors.white),),
        );
      }
  ),
  PlutoColumn(title: 'CODIGO', field: 'CODIGO', type: PlutoColumnType.text(),enableEditingMode: false,width: 110),
  PlutoColumn(title: 'DESCRIPCION', field: 'COD_DSC', type: PlutoColumnType.text(),enableEditingMode: false,width: 200,
      renderer: (contxt){
        return Text(contxt.cell.value);
      }),
  PlutoColumn(title: 'WMS_STOCK', field: 'STOCK', type: PlutoColumnType.number(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'TIPO_PUB', field: 'TIPO_PUB', type: PlutoColumnType.text(),enableContextMenu: false,enableEditingMode: false,width: 85,),
  PlutoColumn(title: 'CANAL', field: 'CANAL', type: PlutoColumnType.text(),enableEditingMode: false,width: 75),
  PlutoColumn(title: 'MARKETING', field: 'USER_MKT', type: PlutoColumnType.text(),width: 95,enableEditingMode: false),
  PlutoColumn(title: 'DISEÑO', field: 'USER_DGN', type: PlutoColumnType.text(),width: 95,enableEditingMode: false),
  PlutoColumn(title: 'PRECIO_ML', field: 'PRECIO_ML', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'PRECIO_AMZN', field: 'PRECIO_AMZN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'PRECIO_SHEIN', field: 'PRECIO_SHEIN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'NOTAS ADICIONALES', field: 'DESC', type: PlutoColumnType.text(),enableEditingMode: false,),
  PlutoColumn(title: 'PRIORIDAD', field: 'PRIOR', type: PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'ALTA': colorsillo = Colors.red;break;
        case'MEDIA':colorsillo = Colors.yellow;break;
        case'BAJA':colorsillo = Colors.blue;break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableEditingMode: false,width: 85,),
  PlutoColumn(title: 'NOTA_MKT', field: 'NOTA_MKT', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'MKT ESTADO', field: 'STATUS_MKT', type: PlutoColumnType.select(
      <String>['Trabajando en ello','Para Revisar']
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'WIP_MKT', field: 'WIP_MKTING', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'NOTA_DG', field: 'NOTA_DGN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'DG ESTADO', field: 'STATUS_DGN', type: PlutoColumnType.text(),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableEditingMode: false,width: 85,),
  PlutoColumn(title: 'WIP_DG', field: 'WIP_DGN', type: PlutoColumnType.text(),enableEditingMode: false,width: 95),
  PlutoColumn(title: 'ESTADO FINAL', field: 'STATUS_FINAL', type: PlutoColumnType.select(
      <String>['Trabajando en ello','Para Revisar']
  ),renderer: (contxt){
    _change(){
      Color colorsillo = Colors.grey;
      switch(contxt.cell.value){
        case'Asignada': colorsillo = Colors.yellow;break;
        case'Completado':colorsillo = Colors.green;break;
        case'Realizar Cambios':colorsillo = Colors.orange;break;
        case'Trabajando en ello':colorsillo = Colors.blue;break;
        case'Para Revisar':colorsillo = Colors.purple;break;
        case 'No aplica':colorsillo = Colors.red; break;
      }
      return colorsillo;
    }
    return Container(
      color:_change(),
      child: Text(contxt.cell.value),
    );
  },enableContextMenu: true,width: 85,),
  PlutoColumn(title: 'WIP_FINAL', field: 'WIP_FINAL', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'REVISION FINAL', field: 'CHECKED', type: PlutoColumnType.text(),enableEditingMode: false,enableRowChecked: false,width: 85,
      renderer: (conxt){
        String ischcked = '';
        switch(conxt.cell.value){
          case true: ischcked = 'Revisado!'; break;
          case false: ischcked = 'Por revisar!'; break;
        }
        return Container(
          color: conxt.cell.value?Colors.green:Colors.red,
          child: Text(ischcked,style: TextStyle(color: Colors.white),),
        );
      }),
  PlutoColumn(title: 'MELI', field: 'ML', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'AMZ', field: 'AMZN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'SHEIN', field: 'SHEIN', type: PlutoColumnType.text(),enableEditingMode: true,width: 95),
  PlutoColumn(title: 'FECHAyHORA_C', field: 'DT', type: PlutoColumnType.text(),enableEditingMode: false,width: 150,),
];