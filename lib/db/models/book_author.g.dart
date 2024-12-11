// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_author.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAuthorModelAdapter extends TypeAdapter<BookAuthorModel> {
  @override
  final int typeId = 2;

  @override
  BookAuthorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookAuthorModel(
      authorID: fields[0] as String,
      authorName: fields[1] as String,
      createdDate: fields[2] as int,
      createdBy: fields[3] as String,
      modifiedDate: fields[4] as int,
      modifiedBy: fields[5] as String,
      status: fields[6] as int,
      synced: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BookAuthorModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.authorID)
      ..writeByte(1)
      ..write(obj.authorName)
      ..writeByte(2)
      ..write(obj.createdDate)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.modifiedDate)
      ..writeByte(5)
      ..write(obj.modifiedBy)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAuthorModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
