// ignore: file_names
import 'package:firebase_database/firebase_database.dart';
import 'producto.dart';

class ProductoDAO {
  final DatabaseReference _productoRef =
      FirebaseDatabase.instance.ref().child('productos');

  void guardarProducto(Producto producto) {
    _productoRef.push().set(producto.toJson());
  }

  Query getProductos() => _productoRef;
}
