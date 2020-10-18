
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/common/theme.dart';
import 'package:provider_shopper/models/cart.dart';
import 'package:provider_shopper/models/catalog.dart';
import 'package:provider_shopper/screens/cart.dart';
import 'package:provider_shopper/screens/catalog.dart';
import 'package:provider_shopper/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MultiProvider(
      providers: [
          Provider(create: (context) => CatalogModel()),
          //CartModel-the changeNotifierprovider depends on catalogmodel in updating so it takes it as a proxyprpovider
          ChangeNotifierProxyProvider<CatalogModel, CartModel>(
              create: (context) => CartModel(),
              update: (context, catalog, cart) {
                  cart.catalog = catalog;
                  return cart;
              },
           ),
        ],
      child: MaterialApp(
        title: 'Provider Demo',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => MyLogin(),
          '/catalog': (context) => MyCatalog(),
          '/cart': (context) => MyCart(),
        },
      ),
    );
  }
}
