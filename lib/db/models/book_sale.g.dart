// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_sale.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookSaleItemModelAdapter extends TypeAdapter<BookSaleItemModel> {
  @override
  final int typeId = 4;

  @override
  BookSaleItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookSaleItemModel(
      id: fields[0] as int,
      bookID: fields[1] as String,
      originalPrice: fields[2] as String,
      soldPrice: fields[3] as String,
      quantity: fields[4] as int,
      itemType: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BookSaleItemModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookID)
      ..writeByte(2)
      ..write(obj.originalPrice)
      ..writeByte(3)
      ..write(obj.soldPrice)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.itemType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookSaleItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookSaleModelAdapter extends TypeAdapter<BookSaleModel> {
  @override
  final int typeId = 3;

  @override
  BookSaleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookSaleModel(
      items: (fields[1] as List).cast<BookSaleItemModel>(),
      grandTotal: fields[2] as double,
      customerName: fields[3] as String,
      customerBatch: fields[4] as String,
      createdDate: fields[5] as int,
      modifiedDate: fields[6] as int,
      deleted: fields[7] as bool,
      saleID: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookSaleModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.saleID)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.grandTotal)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.customerBatch)
      ..writeByte(5)
      ..write(obj.createdDate)
      ..writeByte(6)
      ..write(obj.modifiedDate)
      ..writeByte(7)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookSaleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
