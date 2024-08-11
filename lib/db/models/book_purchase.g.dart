// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_purchase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookPurchaseModelAdapter extends TypeAdapter<BookPurchaseModel> {
  @override
  final int typeId = 2;

  @override
  BookPurchaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookPurchaseModel(
      purchaseID: fields[0] as String,
      publisherID: fields[1] as String,
      purchaseDate: fields[2] as int,
      bookID: fields[3] as String,
      quantityPurchased: fields[5] as int,
      quantityLeft: fields[6] as int,
      bookPrice: fields[4] as double,
      createdDate: fields[7] as int,
      modifiedDate: fields[8] as int,
      deleted: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BookPurchaseModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.purchaseID)
      ..writeByte(1)
      ..write(obj.publisherID)
      ..writeByte(2)
      ..write(obj.purchaseDate)
      ..writeByte(3)
      ..write(obj.bookID)
      ..writeByte(4)
      ..write(obj.bookPrice)
      ..writeByte(5)
      ..write(obj.quantityPurchased)
      ..writeByte(6)
      ..write(obj.quantityLeft)
      ..writeByte(7)
      ..write(obj.createdDate)
      ..writeByte(8)
      ..write(obj.modifiedDate)
      ..writeByte(9)
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
