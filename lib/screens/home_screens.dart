import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_formulario/screens/screens.dart';
import 'package:validacion_formulario/services/services.dart';
import 'package:validacion_formulario/widgets/widgets.dart';

import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (productsService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(title: Text('Productos'), actions: [
        IconButton(
            icon: Icon(Icons.login_outlined),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            }),
      ]),
      body: ListView.builder(
          //cantidad a mostrar
          itemCount: productsService.products.length,
          itemBuilder: (BuildContext context, index) => GestureDetector(
              onTap: () {
                productsService.selectedProduct =
                    productsService.products[index].copy();
                Navigator.pushNamed(context, 'product');
              },
              child: ProductCard(
                //productos a mostrar
                product: productsService.products[index],
              ))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          productsService.selectedProduct =
              new Product(available: true, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
