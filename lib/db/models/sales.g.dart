// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleItemBookPurchaseVariantModelAdapter
    extends TypeAdapter<SaleItemBookPurchaseVariantModel> {
  @override
  final int typeId = 8;

  @override
  SaleItemBookPurchaseVariantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleItemBookPurchaseVariantModel(
      purchaseID: fields[0] as String,
      soldPrice: fields[2] as double,
      quantity: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SaleItemBookPurchaseVariantModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.purchaseID)
      ..writeByte(2)
      ..write(obj.soldPrice)
      ..writeByte(3)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleItemBookPurchaseVariantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SaleItemModelAdapter extends TypeAdapter<SaleItemModel> {
  @override
  final int typeId = 7;

  @override
  SaleItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleItemModel(
      itemType: fields[0] as int,
      itemID: fields[1] as String,
      purchaseVariants:
          (fields[2] as List).cast<SaleItemBookPurchaseVariantModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SaleItemModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.itemType)
      ..writeByte(1)
      ..write(obj.itemID)
      ..writeByte(2)
      ..write(obj.purchaseVariants);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SaleModelAdapter extends TypeAdapter<SaleModel> {
  @override
  final int typeId = 6;

  @override
  SaleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleModel(
      books: (fields[1] as List).cast<SaleItemModel>(),
      stationaryItems: (fields[2] as List).cast<SaleItemModel>(),
      grandTotal: fields[3] as double,
      customerID: fields[4] as String,
      customerBatchID: fields[5] as String,
      paymentMode: fields[6] as String,
      createdDate: fields[7] as int,
      createdBy: fields[8] as String,
      modifiedDate: fields[9] as int,
      modifiedBy: fields[10] as String,
      status: fields[11] as int,
      saleID: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SaleModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.saleID)
      ..writeByte(1)
      ..write(obj.books)
      ..writeByte(2)
      ..write(obj.stationaryItems)
      ..writeByte(3)
      ..write(obj.grandTotal)
      ..writeByte(4)
      ..write(obj.customerID)
      ..writeByte(5)
      ..write(obj.customerBatchID)
      ..writeByte(6)
      ..write(obj.paymentMode)
      ..writeByte(7)
      ..write(obj.createdDate)
      ..writeByte(8)
      ..write(obj.createdBy)
      ..writeByte(9)
      ..write(obj.modifiedDate)
      ..writeByte(10)
      ..write(obj.modifiedBy)
      ..writeByte(11)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
