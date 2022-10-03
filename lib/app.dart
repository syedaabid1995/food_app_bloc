import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc/shop/bloc/shop_bloc.dart';

import 'UI/product_page.dart';

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _MyAppState();
  }

}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopBloc>(
          create: (BuildContext context) => ShopBloc(),
        ),

      ],
      child: MaterialApp(
        home: ProductPage(),
      ),
    );

  }
}