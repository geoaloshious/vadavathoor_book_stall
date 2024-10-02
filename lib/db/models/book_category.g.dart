// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookCategoryModelAdapter extends TypeAdapter<BookCategoryModel> {
  @override
  final int typeId = 4;

  @override
  BookCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookCategoryModel(
      categoryID: fields[0] as String,
      categoryName: fields[1] as String,
      createdDate: fields[2] as int,
      createdBy: fields[3] as int,
      modifiedDate: fields[4] as int,
      modifiedBy: fields[5] as int,
      status: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BookCategoryModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.categoryID)
      ..writeByte(1)
      ..write(obj.categoryName)
      ..writeByte(2)
      ..write(obj.createdDate)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.modifiedDate)
      ..writeByte(5)
      ..write(obj.modifiedBy)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
