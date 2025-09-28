import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 4)
class Event extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? vehicleId;

  @HiveField(5)
  bool notificationEnabled;

  Event({
    required this.id,
    required this.title,
    required this.dateTime,
    this.description,
    this.vehicleId,
    this.notificationEnabled = true,
  });
} 