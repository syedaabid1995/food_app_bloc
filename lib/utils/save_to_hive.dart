import 'dart:convert';
import 'package:hive/hive.dart';

import '../model/login/login_response.dart';


class HiveKeys {
  HiveKeys._();

  static const String userBox = 'myBox';
  static const String userDetails = 'loginDetails';
  static const String cartDetails = 'cartDetails';
  static const String recentOrders = 'recentOrders';

}

class HiveData {
  final Box _userBox;
  LoginResponse? get getLoginDetails => _userBox.get(HiveKeys.userDetails);
  List<dynamic> get getCartDetails => _userBox.get(HiveKeys.cartDetails) ?? [];
  List<dynamic> get getRecentOrders => _userBox.get(HiveKeys.recentOrders) ?? [];

  HiveData(this._userBox);

  void setLoginDetails(LoginResponse loginResponse) {
    print(jsonEncode(loginResponse));
    _userBox.put(HiveKeys.userDetails, loginResponse);
  }
  void setCartDetails(List<dynamic> cartItems) {
    _userBox.put(HiveKeys.cartDetails, cartItems);
  }
  void setRecentOrders(List<dynamic> recentOrders) {
    _userBox.put(HiveKeys.recentOrders, recentOrders);
  }

  void clearAll() {
    _userBox.clear();
  }
}
