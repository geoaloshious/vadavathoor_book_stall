// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stationary_purchase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StationaryPurchaseModelAdapter
    extends TypeAdapter<StationaryPurchaseModel> {
  @override
  final int typeId = 15;

  @override
  StationaryPurchaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StationaryPurchaseModel(
      purchaseID: fields[0] as String,
      purchaseDate: fields[1] as int,
      itemID: fields[2] as String,
      quantityPurchased: fields[4] as int,
      quantityLeft: fields[5] as int,
      price: fields[3] as double,
      createdDate: fields[6] as int,
      createdBy: fields[7] as String,
      modifiedDate: fields[8] as int,
      modifiedBy: fields[9] as String,
      status: fields[10] as int,
      synced: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StationaryPurchaseModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.purchaseID)
      ..writeByte(1)
      ..write(obj.purchaseDate)
      ..writeByte(2)
      ..write(obj.itemID)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantityPurchased)
      ..writeByte(5)
      ..write(obj.quantityLeft)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.createdBy)
      ..writeByte(8)
      ..write(obj.modifiedDate)
      ..writeByte(9)
      ..write(obj.modifiedBy)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StationaryPurchaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
