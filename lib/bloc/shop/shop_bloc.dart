// import 'dart:async';
//
// import 'package:bloc/bloc.dart';
//
// import '../../repository/shop_data_repository.dart';
//
// part 'shop_event.dart';
// part 'shop_state.dart';
//
// class ShopBloc extends Bloc<ShopEvent, ShopState> {
//   ShopDataProvider shopDataProvider = ShopDataProvider();
//   ShopBloc() : super(ShopInitial()) {
//     add(ShopPageInitializedEvent());
//   }
// //
//   @override
//   Stream<ShopState> mapEventToState(
//     ShopEvent event,
//   ) async* {
//     if (event is ShopPageInitializedEvent) {
//       ShopData shopData = await shopDataProvider.getShopItems();
//       ShopData cartData = await shopDataProvider.geCartItems();
//       yield ShopPageLoadedState(shopData: shopData, cartData: cartData);
//     }
//     if (event is ItemAddingCartEvent) {
//       yield ItemAddingCartState(cartItems: event.cartItems);
//     }
//     if (event is ItemAddedCartEvent) {
//       yield ItemAddedCartState(cartItems: event.cartItems);
//     }
//     if (event is ItemDeleteCartEvent) {
//       yield ItemDeletingCartState(cartItems: event.cartItems);
//     }
//   }
// }



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/utils/save_to_hive.dart';
import 'package:hive/hive.dart';

import '../../model/shop/shop_data.dart';
import '../../repository/shop_data_repository.dart';

import 'package:equatable/equatable.dart';
import '../../model/shop/shop.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopDataProvider shopDataProvider = ShopDataProvider();

  ShopBloc() : super(ShopInitial()) {
    on<ShopEvent>((event, emit) async {


      if (event is CartInitializedEvent) {
        emit(CartInitial());
      }
      if (event is ShopPageInitializedEvent) {
        ShopData shopData = await shopDataProvider.getShopItems();
        emit(ShopPageLoadedState(shopData: shopData,));
      }

      if (event is ItemAddedCartEvent) {
        emit(CartInitial());
        emit( ItemAddedCartState(event.cartItems));
      }
      if (event is ItemDeleteCartEvent) {
        emit(CartInitial());
        emit( ItemDeletingCartState( event.cartItems));
      }
      if (event is PlaceOrderEvent) {
        var cartData = HiveData(event.userBox!).getRecentOrders+event.cartItems;

        HiveData(event.userBox!).setRecentOrders(cartData);
        HiveData(event.userBox!).setCartDetails([]);
        emit( PlaceOrderState());
        ShopData shopData = await shopDataProvider.getShopItems();
        emit(ShopPageLoadedState(shopData: shopData,));
      }


    });
  }
}
