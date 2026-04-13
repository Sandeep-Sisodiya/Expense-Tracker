import 'package:hive/hive.dart';

part 'expense_model.g.dart';

/// Expense category enum with Hive support
@HiveType(typeId: 2)
enum ExpenseCategory {
  @HiveField(0)
  food,

  @HiveField(1)
  travel,

  @HiveField(2)
  shopping,

  @HiveField(3)
  bills,

  @HiveField(4)
  others,
}

/// Expense model for tracking individual expenses
@HiveType(typeId: 1)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final ExpenseCategory category;

  @HiveField(4)
  final String note;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
    required this.createdAt,
  });

  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    ExpenseCategory? category,
    String? note,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
