import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? photoPath;

  @HiveField(2)
  String language;

  @HiveField(3)
  String currency;

  User({
    required this.name,
    this.photoPath,
    required this.language,
    required this.currency,
  });
} 