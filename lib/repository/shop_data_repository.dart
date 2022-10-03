
import '../model/shop.dart';


// A static data to display list items
class ShopDataProvider {
  Future<ShopData> getShopItems() async {
    List<ShopItem> shopItems = [
      ShopItem(
        imageUrl:
            "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?cs=srgb&dl=pexels-ella-olsson-1640777.jpg&fm=jpg",
        price: 22,
        maxQuantity: 0,
        title: 'The Mixed Green Salad',
          addedQuantity: 0,

          thumbnail:
            'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?cs=srgb&dl=pexels-ella-olsson-1640777.jpg&fm=jpg',
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore ."
      ),
      ShopItem(
        imageUrl:
            "https://media.gettyimages.com/photos/authentic-indian-food-picture-id639389404?s=612x612",
        price: 50,
        maxQuantity: 0,
        addedQuantity: 0,

        title: 'Butter chicken',
        description: "A Spicy one, you'll eat your fingers",

        thumbnail:
            'https://media.gettyimages.com/photos/authentic-indian-food-picture-id639389404?s=612x612',
      ),
      ShopItem(
        imageUrl:
            "https://t3.ftcdn.net/jpg/03/62/02/26/360_F_362022640_fZ6UM0JycJlFDdBiR1pYlNddKfdGvYwR.jpg",
        price: 80.12,
        maxQuantity: 0,
        title: 'Idly',
          addedQuantity: 0,

          thumbnail:
            'https://t3.ftcdn.net/jpg/03/62/02/26/360_F_362022640_fZ6UM0JycJlFDdBiR1pYlNddKfdGvYwR.jpg',
      ),
      ShopItem(
        imageUrl:
            "https://img.freepik.com/free-photo/top-view-pepperoni-pizza-with-mushroom-sausages-bell-pepper-olive-corn-black-wooden_141793-2158.jpg?w=2000",
        price: 30.12,
        maxQuantity: 0,
        title: 'Pizza',
          addedQuantity: 0,

          thumbnail:
            'https://img.freepik.com/free-photo/top-view-pepperoni-pizza-with-mushroom-sausages-bell-pepper-olive-corn-black-wooden_141793-2158.jpg?w=2000',
          description: "Buy 1 get 1 free"
      ),
      ShopItem(
        imageUrl:
            "https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8YnVyZ2VyfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        price: 40.12,
        addedQuantity: 0,

        maxQuantity: 0,
        title: 'Burger',
        thumbnail:
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8YnVyZ2VyfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
      ),
    ];
    return ShopData(shopItems: shopItems);
  }

}
