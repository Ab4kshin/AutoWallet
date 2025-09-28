import 'package:hive/hive.dart';

part 'vehicle_model.g.dart';

@HiveType(typeId: 1)
class Vehicle extends HiveObject {
  @HiveField(0)
  String make;

  @HiveField(1)
  String model;

  @HiveField(2)
  int? year;

  @HiveField(3)
  String? licensePlate;

  @HiveField(4)
  int? mileage;

  @HiveField(5)
  String? photoPath;

  @HiveField(6)
  String? fuelType;

  Vehicle({
    required this.make,
    required this.model,
    this.year,
    this.licensePlate,
    this.mileage,
    this.photoPath,
    this.fuelType,
  });

  String get fullName => '$make $model';
} 