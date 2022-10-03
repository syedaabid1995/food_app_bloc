import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc/UI/cart.dart';
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
  List<ShopItem> _cartItems = [];
  List<ShopItem> shopItems = [];
  SharedPreferences? sharedPreferences;

  void initSharedPreferences()async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is ShopInitial) {
          loadingData = true;
        }
        else if (state is ShopPageLoadedState) {
          shopItems = state.shopData!.shopitems!;
          // _cartItems = state.cartData!.shopitems!;
          loadingData = false;
        }
        if (state is ItemAddedCartState) {
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


          var encodedString = jsonEncode(_cartItems).toString();
          sharedPreferences!.setString("cartData", encodedString);

          loadingData = false;
        }
        if (state is ItemDeletingCartState) {
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



          var encodedString = jsonEncode(_cartItems).toString();
          sharedPreferences!.setString("cartData", encodedString);
          loadingData = false;
        }
      },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
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

                                  // trailing: Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Container(
                                  //       height: 20,
                                  //       width: 60,
                                  //     ),
                                  //     Container(
                                  //       height: 30,
                                  //       width: 70,
                                  //       decoration: BoxDecoration(
                                  //           border: Border.all(color: Colors.green),
                                  //           borderRadius: BorderRadius.all(Radius.circular(10))
                                  //       ),
                                  //       child: (shopItems[index].addedQuantity==0)
                                  //           ?
                                  //       Center(child: InkWell(
                                  //           onTap: (){
                                  //             bloc.add(ItemAddedCartEvent(shopItems[index]));
                                  //
                                  //           },
                                  //           child: Text("ADD",style: TextStyle(color: Colors.green),)))
                                  //           :
                                  //       Row(
                                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //         children: [
                                  //           InkWell(child: Icon(Icons.remove,),onTap: (){
                                  //             bloc.add(ItemDeleteCartEvent(shopItems[index]));
                                  //           },),
                                  //           Text("${shopItems[index].addedQuantity ?? 0}"),
                                  //           InkWell(child: Icon(Icons.add,color: Colors.green),onTap: (){
                                  //             bloc.add(ItemAddedCartEvent(shopItems[index]));
                                  //
                                  //           },),
                                  //
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),

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
