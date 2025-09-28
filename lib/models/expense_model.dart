import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 2)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String vehicleId;

  @HiveField(5)
  String category;

  @HiveField(6)
  String? notes;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.vehicleId,
    required this.category,
    this.notes,
  });
}

@HiveType(typeId: 3)
enum ExpenseCategory {
  @HiveField(0)
  fuel,

  @HiveField(1)
  service,

  @HiveField(2)
  repair,

  @HiveField(3)
  maintenance,

  @HiveField(4)
  insurance,

  @HiveField(5)
  tax,

  @HiveField(6)
  other,
} 