import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/UI/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/shop.dart';
import '../shop/bloc/shop_bloc.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<ShopBloc>(context);
    bloc.add(ShopPageInitializedEvent());
    initSharedPreferences();
    super.initState();
  }
  bool loadingData = true;

  // To add data into cart
  List<ShopItem> _cartItems = [];

  // To display all products
  List<ShopItem> shopItems = [];

  // To store value into the internal memory
  SharedPreferences? sharedPreferences;

  // initializing sharedPreferences
  void initSharedPreferences()async {

    sharedPreferences = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {

        // listening states
        if (state is ShopInitial) {
          loadingData = true;
        }
        else if (state is ShopPageLoadedState) {
          shopItems = state.shopData!.shopItems!;
          loadingData = false;
        }
        if (state is ItemAddedCartState) {

          // compare and add items to the cart
          // if item is there just increasing addedQuantity
          // while the quantity in ShopItem is for maxQuantity in DB.

          if(!_cartItems.contains(state.cartItems)){
            state.cartItems.addedQuantity++;
            _cartItems.add(state.cartItems);
          }
          else{
            _cartItems.forEach((element) {
              if(element.title == state.cartItems.title){
                element.addedQuantity++;
              }
            });


          }
          // after adding it to cart
          // save the list into sharedPreferences
          var encodedString = jsonEncode(_cartItems).toString();
          sharedPreferences!.setString("cartData", encodedString);
          loadingData = false;
        }
        if (state is ItemDeletingCartState) {
          // compare and delete items from the cart
          if(_cartItems.contains(state.cartItems)){
            print(_cartItems.length);
            _cartItems.forEach((element) {
              if(element.title == state.cartItems.title){
                element.addedQuantity--;
                if(element.addedQuantity==0){
                  _cartItems.remove(element);
                }
              }

            });

          }
          // after deleting it to cart
          // save the list into sharedPreferences
          var encodedString = jsonEncode(_cartItems).toString();
          sharedPreferences!.setString("cartData", encodedString);
          loadingData = false;
        }
      },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {

          // UI Part here

          return SafeArea(
            child: Scaffold(
              body: loadingData
                  ? Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ))
                  : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height*.84,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Salads  & many more",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: shopItems.length,
                            separatorBuilder: (context,index){
                              return Divider(height: 2,thickness: 2,);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: 4),

                                  leading: Image.network(shopItems[index].thumbnail!),
                                  title: Text(shopItems[index].title!,style: TextStyle(fontWeight: FontWeight.bold),),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 50,
                                        child: Text(shopItems[index].description ?? "", style: TextStyle(fontSize: 12),),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("\$ ${shopItems[index].price.toString()}", style: TextStyle(color: Colors.green),),
                                          Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.green),
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: (shopItems[index].addedQuantity==0)
                                                ?
                                            Center(child: InkWell(
                                                onTap: (){
                                                  bloc.add(ItemAddedCartEvent(shopItems[index]));

                                                },
                                                child: Text("ADD",style: TextStyle(color: Colors.green),)))
                                                :
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(child: Icon(Icons.remove,),onTap: (){
                                                  bloc.add(ItemDeleteCartEvent(shopItems[index]));
                                                },),
                                                Text("${shopItems[index].addedQuantity ?? 0}"),
                                                InkWell(child: Icon(Icons.add,color: Colors.green),onTap: (){
                                                  bloc.add(ItemAddedCartEvent(shopItems[index]));

                                                },),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),


                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*.1,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shopping_cart_outlined,color: Colors.grey,),
                            Text(" ${_cartItems.length.toString()} Items")
                          ],
                        ),
                        ElevatedButton(onPressed: (){


                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                      value: BlocProvider.of<ShopBloc>(context),
                                      child: ShoppingCartPage(_cartItems))));

                        }, child: Text("Place order",
                          style: TextStyle(color: Colors.white),),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.green),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    )
                                )
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
