// ignore_for_file: override_on_non_overriding_member

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_control/data/producto.dart';
import 'package:stock_control/data/productoDAO.dart';
import 'package:stock_control/data/productoWidget.dart';

class VerProductosEscaneados extends StatefulWidget {
  VerProductosEscaneados({Key? key}) : super(key: key);
  final productoDAO = ProductoDAO();

  @override
  VerProductosEscaneadosState createState() => VerProductosEscaneadosState();
}

// ignore: non_constant_identifier_names
class VerProductosEscaneadosState extends State<VerProductosEscaneados> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Productos escaneados')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _getProductos(),
            ],
          ),
        ));
  }

  Widget _getProductos() {
    return Expanded(
        child: FirebaseAnimatedList(
      controller: _scrollController,
      query: widget.productoDAO.getProductos(),
      itemBuilder: (context, snapshot, animation, index) {
        final json = snapshot.value as Map<dynamic, dynamic>;
        final producto = Producto.fromJson(json);
        return ProductoWidget(producto.codigo, producto.cantidad);
      },
    ));
  }

  void _scrollHaciaAbajo() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
