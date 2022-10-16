import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/UI/auth/login.dart';
import 'package:food_app/UI/recent_orders.dart';
import 'package:food_app/constants/colors.dart';
import 'package:food_app/utils/navigation.dart';
import 'package:food_app/utils/save_to_hive.dart';
import 'package:hive/hive.dart';

import '../../bloc/shop/shop_bloc.dart';
import '../cart.dart';
import '../product_page.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }

}

class _HomeScreenState extends State<HomeScreen>{
  int index = 0;
  List<Widget> _widgetOptions = [
    ProductPage(),
    ShoppingCartPage(),
    RecentOrders(),
  ];
  List<dynamic>? cart =[];

  @override
  void initState() {
    initBox();
    super.initState();

  }
  Box? _userBox;
  initBox()async{
    _userBox = await Hive.openBox(HiveKeys.userBox);
    cart = HiveData(_userBox!).getCartDetails;
    // HiveData(_userBox!).clearAll();
  }
  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000, 80, 0, 0),
      items: [
        PopupMenuItem(
          value: 1,
          child: TextButton(onPressed: (){}, child: Text("Profile", style: TextStyle(color: Colors.black)),),
        ),
        PopupMenuItem(
          value: 2,
          child: TextButton(onPressed: (){
            HiveData(_userBox!).clearAll();
            Navigate().navigateAndRemoveUntil(context, LoginScreen());
          }, child: Text("Logout", style: TextStyle(color: Colors.black),),),
        ),
      ],
      elevation: 8.0,
    ).then((value){
      if(value!=null)
        print(value);
    });
  }
  @override
  Widget build(BuildContext context) {

    return BlocListener<ShopBloc, ShopState>(
        listener: (context, state) async{
          if (state is ItemAddedCartState) {

            print("here add");
            // compare and add items to the cart
            // if item is there just increasing addedQuantity
            // while the quantity in ShopItem is for maxQuantity in DB.


            if(!cart!.contains(state.cartItems)){
              state.cartItems.addedQuantity++;
              cart!.add(state.cartItems);
            }
            else{
              cart!.forEach((element) {
                if(element.title == state.cartItems.title){
                  element.addedQuantity++;
                }
              });
            }
            HiveData(_userBox!).setCartDetails(cart?? []);
            // after adding it to cart
            // save the list into sharedPreferences
          }
          if (state is ItemDeletingCartState) {

            // compare and delete items from the cart
            // loadingData = false;

            if(cart!.contains(state.cartItems)){

              cart!.forEach((element) {
                if(element.title == state.cartItems.title){
                  element.addedQuantity--;
                  if(element.addedQuantity==0){
                    cart!.remove(element);
                  }
                }
              });
              print("here delete");
              HiveData(_userBox!).setCartDetails(cart!);

            }
          }
          if(state is PlaceOrderState){
            setState(() {
              cart = HiveData(_userBox!).getCartDetails;
              index = 2;
            });
          }
          },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {

          // UI Part here

          return
            SafeArea(
            child:
            Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(onPressed: (){
                    _showPopupMenu();
                  }, icon: Icon(Icons.person))
                ],
              ),
              bottomNavigationBar: new BottomNavigationBar(
                currentIndex: index,
                onTap: (int index) {

                  setState(() {
                    this.index = index;
                  });
                  // widget[index];
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: appPrimaryColor,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home,size: 30,),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        Icon(Icons.shopping_cart,size: 30,),
                        if(cart!=null && cart!.length>0) Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: redColor,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Text("${cart!.length}",style: TextStyle(color: whiteColor,fontSize: 12),textAlign: TextAlign.center,),
                          ),
                        )
                      ],
                    ),
                    label: 'Shopping Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book_outlined,size: 30,),
                    label: 'Recent Orders',
                  ),

                ],
              ),
              body: IndexedStack(
                children: _widgetOptions,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }

}