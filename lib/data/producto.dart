import 'package:flutter/material.dart';

class Producto {
  late String codigo = '';
  late int cantidad;

  Producto(this.codigo, this.cantidad);

  Producto.fromJson(Map<dynamic, dynamic> json)
      : codigo = json['codigo'] as String,
        cantidad = json['cantidad'] as int;

  Map<dynamic, dynamic> toJson() =>
      {'codigo': codigo.toString(), 'cantidad': cantidad};
}
