part of 'shop_bloc.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

class ShopInitial extends ShopState {}

class ShopPageLoadedState extends ShopState {
  final ShopData? shopData;
  final ShopData? cartData;

  ShopPageLoadedState({this.cartData, this.shopData});
}

class DoingSomethingState extends ShopState {

  DoingSomethingState();
}

class ItemAddedCartState extends ShopState {
  final ShopItem cartItems;

  ItemAddedCartState(this.cartItems);
}

class ItemDeletingCartState extends ShopState {
  final ShopItem cartItems;

  ItemDeletingCartState(this.cartItems);
}
