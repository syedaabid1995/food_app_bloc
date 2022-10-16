
import 'package:hive/hive.dart';
part 'shop.g.dart';

@HiveType(typeId: 4)
class ShopItem {

  @HiveField(0)
  String? imageUrl;

  @HiveField(1)
  String? thumbnail;

  @HiveField(2)
  String? title;

  @HiveField(3)
  double? price;

  @HiveField(4)
  int? maxQuantity;

  @HiveField(5)
  int addedQuantity = 0;

  @HiveField(6)
  String? description;

  ShopItem(
      {this.imageUrl, this.thumbnail, this.price, this.maxQuantity, this.title, this.description,required this.addedQuantity});

  Map<String,dynamic> toJson(){
    return {
      "imageUrl":this.imageUrl,
      "thumbnail":this.thumbnail,
      "price":this.price,
      "quantity":this.maxQuantity,
      "title":this.title,
      "description":this.description,
      "addedQuantity":  this.addedQuantity
    };
  }
}
