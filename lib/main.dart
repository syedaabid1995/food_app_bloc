import 'package:flutter/material.dart';
import 'package:food_app/model/shop/shop.dart';
import 'package:food_app/model/shop/shop_data.dart';
import 'package:food_app/utils/save_to_hive.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'model/login/login_response.dart';
import 'model/login/user_details.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDir = await getApplicationDocumentsDirectory();



  /// getting directory of this app

  /// To build adapter files use this command
  ///
  /// "flutter packages pub run build_runner build"
  /// To Store Data in Internal memory using Hive
  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(LoginResponseAdapter())
    ..registerAdapter(UserDetailsAdapter())
    ..registerAdapter(ShopDataAdapter())
    ..registerAdapter(ShopItemAdapter())
  ;

  Box? _userBox;
  _userBox = await Hive.openBox(HiveKeys.userBox);

  runApp(MyApp(_userBox));
}

