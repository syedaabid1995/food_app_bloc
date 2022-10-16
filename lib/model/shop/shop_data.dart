import 'package:food_app/model/shop/shop.dart';
import 'package:hive/hive.dart';
part 'shop_data.g.dart';

@HiveType(typeId: 3)

class ShopData {
  @HiveField(0)
  List<ShopItem>? shopItems;

  ShopData({this.shopItems});
}