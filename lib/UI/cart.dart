import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/shop.dart';
import '../shop/bloc/shop_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCartPage extends StatefulWidget {
  List<ShopItem> _cartItems = [];

  ShoppingCartPage(this._cartItems , {Key? key}) : super(key: key);
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  var bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<ShopBloc>(context);

    // bloc.add(InitializedEvent());
    initSharedPreferences();
    super.initState();
  }
  bool loadingData = false;
  SharedPreferences? sharedPreferences;

  void initSharedPreferences()async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {

      },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          double totalAmount= 0.0;

          widget._cartItems.forEach((element) {
            totalAmount += element.price!*element.addedQuantity;
            print(totalAmount);

          });
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
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget._cartItems.length,
                      separatorBuilder: (context,index){
                        return Divider(height: 2,thickness: 2,);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget._cartItems[index].title!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
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
                                          border: Border.all(color: Colors.green),
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: (widget._cartItems[index].addedQuantity==0)
                                          ?
                                      Center(child: InkWell(
                                          onTap: (){
                                            bloc.add(ItemAddedCartEvent(widget._cartItems[index]));

                                          },
                                          child: Text("ADD",style: TextStyle(color: Colors.green),)))
                                          :
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(child: Icon(Icons.remove,),onTap: (){
                                            bloc.add(ItemDeleteCartEvent(widget._cartItems[index]));
                                          },),
                                          Text("${widget._cartItems[index].addedQuantity ?? 0}"),
                                          InkWell(child: Icon(Icons.add,color: Colors.green),onTap: (){
                                            bloc.add(ItemAddedCartEvent(widget._cartItems[index]));

                                          },),

                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      height: 20,
                                      width: 60,
                                      child: Text("\$ ${widget._cartItems[index].price! *widget._cartItems[index].addedQuantity}",textAlign: TextAlign.end,
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
                  Container(
                    height: MediaQuery.of(context).size.height*.1,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("\$ $totalAmount",style: TextStyle(fontWeight: FontWeight.bold),)
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
