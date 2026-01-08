class Expense {
  final String id;
  final String title;
  final double amount;
  final String? category;
  final String? note;
  final DateTime expenseDate;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    this.category,
    this.note,
    required this.expenseDate,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      category: map['category'],
      note: map['note'],
      expenseDate: DateTime.parse(map['expense_date']),
    );
  }
}
