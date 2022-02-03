// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock_control/sections/verProductosEscaneados.dart';

import 'sections/ingresoCajaPorUnidades.dart';
import 'sections/ingresoManual.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBwgcOmg0DpmMXtiAkKMLwkUnxQAdmAiko',
          authDomain: 'https://barcodemevir-default-rtdb.firebaseio.com/',
          databaseURL: 'https://barcodemevir-default-rtdb.firebaseio.com/',
          appId: '1:486602886759:android:f05071410030f07b304ec2',
          storageBucket: 'gs://barcodemevir.appspot.com',
          messagingSenderId: '486602886759',
          projectId: 'barcodemevir'));

  runApp(const MyApp());
}

final menu = [
  Menu(
    name: 'Ingreso manual',
    route: '/ingresoManual',
    // ignore: prefer_const_constructors
    builder: (context) => IngresoManual(),
  ),
  Menu(
    name: 'Ingreso cajas x unidades',
    route: '/ingreso_cajas_por_unidades',
    builder: (context) => IngresoCajaPorUnidades(),
  ),
  Menu(
      name: 'Ver productos escaneados',
      route: '/verProductosEscaneados',
      builder: (context) => VerProductosEscaneados())
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingreso de productos - control de stock',
      theme: ThemeData(primarySwatch: Colors.cyan),
      routes: Map.fromEntries(menu.map((e) => MapEntry(e.route, e.builder))),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('MENU PRINCIPAL',
              style: TextStyle(color: Colors.white))),
      body: Center(
        child: SizedBox(
          width: 800.0,
          height: 200.0,
          child: ListView(
            children: [...menu.map((d) => MenuTile(menu: d))],
          ),
        ),
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final Menu? menu;

  const MenuTile({this.menu, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, menu!.route);
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(1.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF03A9F4), Color(0xff64B6FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              menu!.name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
    /* ListTile(
      title: Text(menu!.name),
      onTap: () {
        Navigator.pushNamed(context, menu!.route);
      },
    ); */
  }
}

class Menu {
  final String name;
  final String route;
  final WidgetBuilder builder;

  const Menu({required this.name, required this.route, required this.builder});
}
