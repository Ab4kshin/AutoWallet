// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleAdapter extends TypeAdapter<Vehicle> {
  @override
  final int typeId = 1;

  @override
  Vehicle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vehicle(
      make: fields[0] as String,
      model: fields[1] as String,
      year: fields[2] as int?,
      licensePlate: fields[3] as String?,
      mileage: fields[4] as int?,
      photoPath: fields[5] as String?,
      fuelType: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.make)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.licensePlate)
      ..writeByte(4)
      ..write(obj.mileage)
      ..writeByte(5)
      ..write(obj.photoPath)
      ..writeByte(6)
      ..write(obj.fuelType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
