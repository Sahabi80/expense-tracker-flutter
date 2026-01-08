class Income {
  final String id;
  final String title;
  final double amount;
  final DateTime incomeDate;

  Income({
    required this.id,
    required this.title,
    required this.amount,
    required this.incomeDate,
  });

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      incomeDate: DateTime.parse(map['income_date']),
    );
  }
}
