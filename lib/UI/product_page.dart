
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/colors.dart';
import '../model/shop/shop.dart';
import '../bloc/shop/shop_bloc.dart';

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

    // initBox();
    super.initState();

  }
  /// We can use this if necessary
  // initBox ()async{
  //   Box? _userBox;
  //
  //   _userBox = await Hive.openBox(HiveKeys.userBox);
  // }
  bool loadingData = true;

  // To add data into cart

  // To display all products
  List<ShopItem> shopItems = [];


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
        if (state is ItemAddedCartState || state is ItemDeleteCartEvent) {
          loadingData = false;
          }
        },
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {

          // UI Part here

          return Container(
            child:             loadingData
                ? Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ))
                : ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Salads & many more",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
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
                                        Text("\$ ${shopItems[index].price.toString()}", style: TextStyle(color: appPrimaryColor),),
                                        Container(
                                          height: 30,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: appPrimaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          child: (shopItems[index].addedQuantity==0)
                                              ?
                                          Center(child: InkWell(
                                              onTap: (){
                                                bloc.add(ItemAddedCartEvent(shopItems[index]));

                                              },
                                              child: Text("ADD",style: TextStyle(color: appPrimaryColor),)))
                                              :
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(child: Icon(Icons.remove,),onTap: (){
                                                bloc.add(ItemDeleteCartEvent(shopItems[index]));
                                              },),
                                              Text("${shopItems[index].addedQuantity}"),
                                              InkWell(child: Icon(Icons.add,color: appPrimaryColor),onTap: (){
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
            ),
          );
        },
      ),
    );
  }
}
