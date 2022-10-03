class ShopData {
  List<ShopItem>? shopItems;
  ShopData({this.shopItems});
}

class ShopItem {
  String? imageUrl;
  String? thumbnail;
  String? title;
  double? price;
  int? maxQuantity;
  int addedQuantity = 0;
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
