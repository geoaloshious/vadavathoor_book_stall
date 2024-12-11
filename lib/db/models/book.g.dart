// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookModelAdapter extends TypeAdapter<BookModel> {
  @override
  final int typeId = 1;

  @override
  BookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookModel(
      bookID: fields[0] as String,
      bookName: fields[1] as String,
      authorID: fields[2] as String,
      publisherID: fields[3] as String,
      bookCategoryID: fields[4] as String,
      createdDate: fields[5] as int,
      createdBy: fields[6] as String,
      modifiedDate: fields[7] as int,
      modifiedBy: fields[8] as String,
      status: fields[9] as int,
      synced: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.bookID)
      ..writeByte(1)
      ..write(obj.bookName)
      ..writeByte(2)
      ..write(obj.authorID)
      ..writeByte(3)
      ..write(obj.publisherID)
      ..writeByte(4)
      ..write(obj.bookCategoryID)
      ..writeByte(5)
      ..write(obj.createdDate)
      ..writeByte(6)
      ..write(obj.createdBy)
      ..writeByte(7)
      ..write(obj.modifiedDate)
      ..writeByte(8)
      ..write(obj.modifiedBy)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
