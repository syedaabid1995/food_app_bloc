
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/utils/save_to_hive.dart';
import 'package:hive/hive.dart';
import '../constants/colors.dart';
import '../bloc/shop/shop_bloc.dart';

class RecentOrders extends StatefulWidget {
  const RecentOrders({Key? key}) : super(key: key);
  @override
  _RecentOrdersState createState() => _RecentOrdersState();
}

class _RecentOrdersState extends State<RecentOrders> {
  var bloc;
  Box? _userBox;

  @override
  void initState() {
    bloc = BlocProvider.of<ShopBloc>(context);
    bloc.add(ShopPageInitializedEvent());

    initBox();
    super.initState();

  }

  initBox ()async{
    _userBox = await Hive.openBox(HiveKeys.userBox);
    recentOrders = HiveData(_userBox!).getRecentOrders;

    print(recentOrders);
  }

  List<dynamic> recentOrders = [];



  @override
  Widget build(BuildContext context) {


    return BlocListener<ShopBloc, ShopState>(
      listener: (context, state) {

      if(state is PlaceOrderState){
        recentOrders = HiveData(_userBox!).getRecentOrders;

        setState(() {

        });
      }
      },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {

          // UI Part here

          return Container(
              child:
              ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(top: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("My Recent Orders",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recentOrders.length,
                            separatorBuilder: (context,index){
                              return Divider(height: 2,thickness: 2,);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              double totalValue = double.parse(recentOrders[index].price.toString())* double.parse((recentOrders[index].addedQuantity.toString()));
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: 4),

                                  leading: Image.network(recentOrders[index].thumbnail!),
                                  title: Text("${recentOrders[index].title!} (x${recentOrders[index].addedQuantity.toString()})",style: TextStyle(fontWeight: FontWeight.bold),),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 50,
                                        child: Text(recentOrders[index].description ?? "", style: TextStyle(fontSize: 12),),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Total cost \$${totalValue.toStringAsFixed(2)}", style: TextStyle(color: appPrimaryColor),),
                                        ],
                                      )
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
                  // Container(
                  //   height: MediaQuery.of(context).size.height*.1,
                  //   padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Icon(Icons.shopping_cart_outlined,color: Colors.grey,),
                  //           Text(" ${_cartItems==null ?0 :  _cartItems!.length.toString()} Items")
                  //         ],
                  //       ),
                  //       ElevatedButton(onPressed: (){
                  //
                  //
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (_) => BlocProvider.value(
                  //                     value: BlocProvider.of<ShopBloc>(context),
                  //                     child: ShoppingCartPage())));
                  //
                  //       }, child: Text("Place order",
                  //         style: TextStyle(color: Colors.white),),
                  //           style: ButtonStyle(
                  //               backgroundColor: MaterialStateProperty.all(appPrimaryColor),
                  //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //                   RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(18.0),
                  //                   )
                  //               )
                  //           ))
                  //     ],
                  //   ),
                  // )
                ],
              )
          );
        },
      ),
    );
  }
}
