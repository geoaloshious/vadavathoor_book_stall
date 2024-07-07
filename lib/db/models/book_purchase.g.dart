// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_purchase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookPurchaseModelAdapter extends TypeAdapter<BookPurchaseModel> {
  @override
  final int typeId = 3;

  @override
  BookPurchaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookPurchaseModel(
      purchaseID: fields[0] as String,
      publisherID: fields[1] as String,
      purchaseDate: fields[2] as String,
      bookID: fields[3] as String,
      quantity: fields[5] as String,
      bookPrice: fields[4] as String,
      createdDate: fields[6] as String,
      modifiedDate: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookPurchaseModel obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.modifiedDate);
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
