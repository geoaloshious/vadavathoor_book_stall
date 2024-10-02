// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_purchase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookPurchaseModelAdapter extends TypeAdapter<BookPurchaseModel> {
  @override
  final int typeId = 5;

  @override
  BookPurchaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookPurchaseModel(
      purchaseID: fields[0] as String,
      purchaseDate: fields[1] as int,
      bookID: fields[2] as String,
      quantityPurchased: fields[4] as int,
      quantityLeft: fields[5] as int,
      bookPrice: fields[3] as double,
      createdDate: fields[6] as int,
      createdBy: fields[7] as int,
      modifiedDate: fields[8] as int,
      modifiedBy: fields[9] as int,
      deleted: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BookPurchaseModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.purchaseID)
      ..writeByte(1)
      ..write(obj.purchaseDate)
      ..writeByte(2)
      ..write(obj.bookID)
      ..writeByte(3)
      ..write(obj.bookPrice)
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
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookPurchaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
