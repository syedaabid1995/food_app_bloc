import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc/app.dart';
import 'package:my_bloc/shop/bloc/shop_bloc.dart';

import 'UI/product_page.dart';

void main() {
  runApp(MyApp());
}
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(),
//       home: BlocProvider(
//         create: (context) => ShopBloc(),
//         child: ProductPage(),
//       ),
//     );
//   }
// }
