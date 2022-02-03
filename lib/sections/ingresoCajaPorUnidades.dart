// ignore_for_file: prefer_equal_for_default_values

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_control/data/producto.dart';
import 'package:stock_control/data/productoDAO.dart';
import 'package:scan/scan.dart';
import '../main.dart';

class IngresoCajaPorUnidades extends StatefulWidget {
  IngresoCajaPorUnidades({Key? key}) : super(key: key);
  final productoDAO = ProductoDAO();

  @override
  _IngresoCajaPorUnidades createState() => _IngresoCajaPorUnidades();
}

class _IngresoCajaPorUnidades extends State<IngresoCajaPorUnidades> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textControllerCodigo = TextEditingController();
  final TextEditingController _textControllerConteo = TextEditingController();
  final TextEditingController _textControllerCajas = TextEditingController();
  var _scanResult = '';
  ScanController controller = ScanController();

  String codigoProducto = '';
  late int conteo = 0;
  late int cajas = 0;
  late bool control = false;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ingreso cajas x unidades',
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
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...[
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: /* Text(
                            _scanResult,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ) */
                            TextFormField(
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
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          enabled: _checkFieldCantidadUnidades(),
                          keyboardType: TextInputType.number,
                          controller: _textControllerConteo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Ingrese cantidad de unidades por caja',
                            labelText: 'Cantidad de unidades por caja',
                          ),
                          onChanged: (value) {
                            conteo = int.parse(value);
                          },
                          onFieldSubmitted: (value) => setState(() {
                            control = true;
                          }),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            enabled: control,
                            keyboardType: TextInputType.number,
                            controller: _textControllerCajas,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              hintText: 'Ingrese cantidad de  cajas',
                              labelText: 'Cantidad de cajas',
                            ),
                            onChanged: (value) {
                              cajas = int.parse(value);
                            },
                          )),
                      IconButton(
                        iconSize: 24.0,
                        icon: Icon(_puedoEnviarDatos2()
                            ? CupertinoIcons.upload_circle
                            : CupertinoIcons.arrow_right_circle),
                        onPressed: () {
                          _enviarDatos2();
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22.0))),
          child: const Icon(
            Icons.qr_code_2,
            color: Colors.cyan,
          )),
    );
  }

  bool _checkFieldCantidadUnidades() => _scanResult.isNotEmpty;

  bool _puedoEnviarDatos2() =>
      _textControllerConteo.text.isNotEmpty &&
      _textControllerCajas.text.isNotEmpty;

  void _enviarDatos2() {
    if (_puedoEnviarDatos2()) {
      final producto = Producto(_scanResult, conteo * cajas);
      widget.productoDAO.guardarProducto(producto);
      _textControllerConteo.clear();
      _textControllerCajas.clear();
      _textControllerCodigo.clear();
      _scanResult = '';
      conteo = 0;
      control = false;
      setState(() {});
      _showMyDialog();
    }
  }

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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Desea continuar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Desea continuar agregando por unidad?')
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
