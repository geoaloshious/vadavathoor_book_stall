// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_sale.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      bookName: fields[1] as String,
      bookPrice: fields[2] as String,
      personName: fields[3] as String,
      personBatch: fields[4] as String,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, BookSaleModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookName)
      ..writeByte(2)
      ..write(obj.bookPrice)
      ..writeByte(3)
      ..write(obj.personName)
      ..writeByte(4)
      ..write(obj.personBatch);
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
