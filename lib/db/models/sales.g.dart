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

class SaleItemBookModelAdapter extends TypeAdapter<SaleItemBookModel> {
  @override
  final int typeId = 7;

  @override
  SaleItemBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleItemBookModel(
      bookID: fields[0] as String,
      purchaseVariants:
          (fields[1] as List).cast<SaleItemBookPurchaseVariantModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SaleItemBookModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.bookID)
      ..writeByte(1)
      ..write(obj.purchaseVariants);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleItemBookModelAdapter &&
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
      books: (fields[1] as List).cast<SaleItemBookModel>(),
      grandTotal: fields[2] as double,
      customerName: fields[3] as String,
      customerBatch: fields[4] as String,
      paymentMode: fields[5] as String,
      createdDate: fields[6] as int,
      createdBy: fields[7] as String,
      modifiedDate: fields[8] as int,
      modifiedBy: fields[9] as String,
      status: fields[10] as int,
      saleID: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SaleModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.saleID)
      ..writeByte(1)
      ..write(obj.books)
      ..writeByte(2)
      ..write(obj.grandTotal)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.customerBatch)
      ..writeByte(5)
      ..write(obj.paymentMode)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.createdBy)
      ..writeByte(8)
      ..write(obj.modifiedDate)
      ..writeByte(9)
      ..write(obj.modifiedBy)
      ..writeByte(10)
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