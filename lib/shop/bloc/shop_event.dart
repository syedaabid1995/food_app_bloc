part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class ShopPageInitializedEvent extends ShopEvent {}

class InitializedEvent extends ShopEvent {}

class ItemAddedCartEvent extends ShopEvent {
  final ShopItem cartItems;

  ItemAddedCartEvent(this.cartItems);
}

class ItemDeleteCartEvent extends ShopEvent {
  final ShopItem cartItems;
  ItemDeleteCartEvent(this.cartItems, );
}
