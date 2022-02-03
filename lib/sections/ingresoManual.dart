import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:scan/scan.dart';
import 'package:stock_control/data/producto.dart';
import 'package:stock_control/data/productoDAO.dart';

import '../main.dart';

class IngresoManual extends StatefulWidget {
  IngresoManual({Key? key}) : super(key: key);
  // ignore: non_constant_identifier_names
  final productoDAO = ProductoDAO();

  @override
  _IngresoManualState createState() => _IngresoManualState();
}

class _IngresoManualState extends State<IngresoManual> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textControllerCodigo = TextEditingController();
  final TextEditingController _textControllerConteo = TextEditingController();
  String codigoProducto = '';
  late int conteo;
  var _scanResult = '';
  late bool control = false;

  ScanController controller = ScanController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ingreso Manual',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
                child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...[
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          readOnly: true,
                          controller: _textControllerCodigo,
                          decoration: const InputDecoration(
                              filled: true,
                              labelText: 'Tap para escanear un código'),
                          onTap: () => _showBarcodeScanner(),
                          onChanged: (_scanResult) => {
                            setState(() {
                              _scanResult;
                            }),
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          enabled: _checkFieldCantidadUnidades(),
                          controller: _textControllerConteo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Ingrese cantidad',
                            labelText: 'Cantidad contada',
                          ),
                          onChanged: (value) {
                            conteo = int.parse(value);
                          },
                        ),
                      ),
                      IconButton(
                        iconSize: 24.0,
                        icon: Icon(_puedoEnviarDatos()
                            ? CupertinoIcons.upload_circle
                            : CupertinoIcons.arrow_right_circle),
                        onPressed: () {
                          _enviarDatos();
                        },
                      ),
                    ]
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _showBarcodeScanner,
          tooltip: 'Escanear codigo de barras',
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22.0))),
          child: Icon(
            Icons.qr_code_2,
            color: Colors.cyan,
          )),
    );
  }

  void _enviarDatos() {
    if (_puedoEnviarDatos()) {
      final producto = Producto(_scanResult, conteo);
      widget.productoDAO.guardarProducto(producto);
      _textControllerConteo.clear();
      _textControllerCodigo.clear();
      _scanResult = '';
      conteo = 0;
      control = false;
      setState(() {});
      _continuarEscaneando();
    }
  }

  bool _puedoEnviarDatos() =>
      _textControllerCodigo.text.isNotEmpty &&
      _textControllerConteo.text.isNotEmpty;

  bool _checkFieldCantidadUnidades() => _scanResult.isNotEmpty;

  _showBarcodeScanner() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Scaffold(
                appBar: _buildBarcodeScannerAppBar(),
                body: _buildBarcodeScannerBody(),
              ));
        });
      },
    );
  }

  AppBar _buildBarcodeScannerAppBar() {
    return AppBar(
      bottom: PreferredSize(
        child: Container(color: Colors.cyan, height: 4.0),
        preferredSize: const Size.fromHeight(4.0),
      ),
      title: const Text('Scan Your Barcode'),
      elevation: 0.0,
      backgroundColor: const Color(0xFF333333),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Center(
            child: Icon(
          Icons.cancel,
          color: Colors.white,
        )),
      ),
      actions: [
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
                onTap: () => controller.toggleTorchMode(),
                child: const Icon(Icons.flashlight_on))),
      ],
    );
  }

  Widget _buildBarcodeScannerBody() {
    return SizedBox(
      height: 400,
      child: ScanView(
        controller: controller,
        scanAreaScale: .7,
        scanLineColor: Colors.cyan,
        onCapture: (data) {
          setState(() {
            _scanResult = data;
            _textControllerCodigo.text = data;
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  Future<void> _continuarEscaneando() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Desea continuar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Desea continuar agregando productos cajas x cantidad?')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Si'),
              onPressed: () {
                Navigator.of(context).pop();
                _showBarcodeScanner();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                main();
              },
            ),
          ],
        );
      },
    );
  }
}
