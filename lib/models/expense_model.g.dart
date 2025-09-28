// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 2;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      date: fields[3] as DateTime,
      vehicleId: fields[4] as String,
      category: fields[5] as String,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.vehicleId)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseCategoryAdapter extends TypeAdapter<ExpenseCategory> {
  @override
  final int typeId = 3;

  @override
  ExpenseCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExpenseCategory.fuel;
      case 1:
        return ExpenseCategory.service;
      case 2:
        return ExpenseCategory.repair;
      case 3:
        return ExpenseCategory.maintenance;
      case 4:
        return ExpenseCategory.insurance;
      case 5:
        return ExpenseCategory.tax;
      case 6:
        return ExpenseCategory.other;
      default:
        return ExpenseCategory.fuel;
    }
  }

  @override
  void write(BinaryWriter writer, ExpenseCategory obj) {
    switch (obj) {
      case ExpenseCategory.fuel:
        writer.writeByte(0);
        break;
      case ExpenseCategory.service:
        writer.writeByte(1);
        break;
      case ExpenseCategory.repair:
        writer.writeByte(2);
        break;
      case ExpenseCategory.maintenance:
        writer.writeByte(3);
        break;
      case ExpenseCategory.insurance:
        writer.writeByte(4);
        break;
      case ExpenseCategory.tax:
        writer.writeByte(5);
        break;
      case ExpenseCategory.other:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
