/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_control/data/producto.dart';
import 'package:stock_control/data/productoDAO.dart';

class EnviarDatos extends StatefulWidget {
  EnviarDatos({Key? key}) : super(key: key);
  final productoDao = ProductoDAO();

  @override
  EnviarDatosState createState() => EnviarDatosState();
}

class EnviarDatosState extends State<EnviarDatos> {
  @override
  final TextEditingController _productoController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            IconButton(
              icon: Icon(_puedoEnviarDatos()
                  ? CupertinoIcons.arrow_2_circlepath_circle_fill
                  : CupertinoIcons.arrow_2_circlepath_circle),
              onPressed: () {
                _enviarDatos();
              },
            )
          ])),
    );
  }

  void _enviarDatos() {
    
  }

  bool _puedoEnviarDatos() => _productoController.text.length > 0;
}
 */