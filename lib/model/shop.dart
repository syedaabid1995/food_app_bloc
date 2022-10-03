class ShopData {
  List<ShopItem>? shopitems;

  ShopData({this.shopitems});

  void addProduct(ShopItem p) {
    shopitems!.add(p);
  }

  void removeProduct(ShopItem p) {
    shopitems!.add(p);
  }
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
