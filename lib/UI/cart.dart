
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/utils/snackbar.dart';
import 'package:hive/hive.dart';

import '../constants/colors.dart';
import '../bloc/shop/shop_bloc.dart';

import '../utils/save_to_hive.dart';

class ShoppingCartPage extends StatefulWidget {

  ShoppingCartPage( {Key? key}) : super(key: key);
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  var bloc;
  Box? _userBox;
  List<dynamic>? _cartItems = [];

  @override
  void initState() {
    bloc = BlocProvider.of<ShopBloc>(context);
    bloc.add(CartInitializedEvent());
    print("init");
    initBox();

    super.initState();
  }

  initBox()async{
    _userBox = await Hive.openBox(HiveKeys.userBox);
    _cartItems = HiveData(_userBox!).getCartDetails;

  }
  bool loadingData = false;

  @override
  Widget build(BuildContext context) {

    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {

        if (state is ItemAddedCartState || state is ItemDeleteCartEvent) {
          setState(() {
            _cartItems = HiveData(_userBox!).getCartDetails;
          });
        }

        if(state is PlaceOrderState){
          setState(() {
            _cartItems = HiveData(_userBox!).getCartDetails;
          });
        }

      },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          double totalAmount= 0.0;

          if(_cartItems!=null)
          _cartItems!.forEach((element) {
            totalAmount += element.price!*element.addedQuantity;

          });
          return Container(
            child:
            loadingData
                ? Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ))
                : ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(top: 10),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _cartItems!=null ? _cartItems!.length : 0,
                    separatorBuilder: (context,index){
                      return Divider(height: 2,thickness: 2,);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      double itemTotal = _cartItems![index].price! * _cartItems![index].addedQuantity;
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_cartItems![index].title!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                Row(
                                  children: [
                                    Text("Modifiers : "),
                                    Icon(Icons.edit)
                                  ],
                                ),
                                Text("Red chutney, green chutney"),
                                Row(
                                  children: [
                                    Text("Notes : "),
                                    Icon(Icons.edit)
                                  ],
                                ),
                                Text("Extremely spicey"),

                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 30,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: appPrimaryColor),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: (_cartItems![index].addedQuantity==0)
                                      ?
                                  Center(child: InkWell(
                                      onTap: (){
                                        print("object");
                                        bloc.add(ItemAddedCartEvent(_cartItems![index]));

                                      },
                                      child: Text("ADD",style: TextStyle(color: appPrimaryColor),)))
                                      :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(child: Icon(Icons.remove,),onTap: (){
                                        bloc.add(ItemDeleteCartEvent(_cartItems![index]));
                                      },),
                                      Text("${_cartItems![index].addedQuantity ?? 0}"),
                                      InkWell(child: Icon(Icons.add,color: appPrimaryColor),onTap: (){
                                        bloc.add(ItemAddedCartEvent(_cartItems![index]));

                                      },),

                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 20,
                                  width: 60,
                                  child: Text("\$ ${itemTotal.toStringAsFixed(2)}",textAlign: TextAlign.end,
                                    style: TextStyle(fontWeight: FontWeight.bold),),
                                ),

                              ],
                            ),
                          ],
                        ),

                      );
                    },
                  ),
                ),
                SizedBox(height: 40,),
                Divider(height: 2,thickness: 2,),
                SizedBox(height: 40,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("\$ ${totalAmount.toStringAsFixed(2)}",style: TextStyle(fontWeight: FontWeight.bold),),
                      ElevatedButton(onPressed: (){

                        if(_cartItems!=null){
                          snackBar(context, "Order placed successfully", isSuccess: true);
                          bloc.add(PlaceOrderEvent(_userBox,_cartItems!));
                        }else{
                          snackBar(context, "Nothing to place order");
                        }
                        }, child: Text("Place order",
                        style: TextStyle(color: Colors.white),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(appPrimaryColor),
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
          );
        },
      ),
    );
  }
}
