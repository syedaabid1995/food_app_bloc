// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopDataAdapter extends TypeAdapter<ShopData> {
  @override
  final int typeId = 3;

  @override
  ShopData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopData(
      shopItems: (fields[0] as List?)?.cast<ShopItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, ShopData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.shopItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
