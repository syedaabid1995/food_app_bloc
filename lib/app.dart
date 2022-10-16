import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/UI/auth/login.dart';
import 'package:food_app/UI/home/bottom_navigation.dart';
import 'package:food_app/bloc/login/login_bloc.dart';
import 'package:food_app/bloc/shop/shop_bloc.dart';
import 'package:food_app/constants/colors.dart';
import 'package:food_app/repository/user_repository.dart';
import 'package:food_app/utils/save_to_hive.dart';
import 'package:hive/hive.dart';
import 'model/login/login_response.dart';

class MyApp extends StatefulWidget{
  final Box userBox;
  MyApp(this.userBox);
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    LoginResponse? loginResponse = HiveData(widget.userBox).getLoginDetails;

    // Added multi-bloc provider
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopBloc>(
          create: (BuildContext context) => ShopBloc(),),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(RealUserRepo()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: appPrimaryColor,primarySwatch: appPrimaryColor),

        home: (loginResponse ==null || loginResponse.isSuccess==false)?LoginScreen(): HomeScreen(),
      ),
    );

  }
}