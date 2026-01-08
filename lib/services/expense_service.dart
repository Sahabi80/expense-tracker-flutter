import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense.dart';

class ExpenseService {
  final SupabaseClient _client = Supabase.instance.client;

  /// CREATE
  Future<void> addExpense({
    required String title,
    required double amount,
    String? category,
    String? note,
    required DateTime expenseDate,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _client.from('expenses').insert({
      'user_id': user.id,
      'title': title,
      'amount': amount,
      'category': category,
      'note': note,
      'expense_date': expenseDate.toIso8601String(),
    });
  }

  /// READ
  Future<List<Expense>> fetchExpenses() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final response = await _client
        .from('expenses')
        .select()
        .eq('user_id', user.id)
        .order('expense_date', ascending: false);

    return response.map<Expense>((e) => Expense.fromMap(e)).toList();
  }

  /// UPDATE
  Future<void> updateExpense({
    required String expenseId,
    required String title,
    required double amount,
    String? category,
    String? note,
    required DateTime expenseDate,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _client.from('expenses').update({
      'title': title,
      'amount': amount,
      'category': category,
      'note': note,
      'expense_date': expenseDate.toIso8601String(),
    }).eq('id', expenseId).eq('user_id', user.id);
  }

  /// DELETE
  Future<void> deleteExpense(String expenseId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _client
        .from('expenses')
        .delete()
        .eq('id', expenseId)
        .eq('user_id', user.id);
  }

  /// SUMMARY: total spent today
  double calculateTodayTotal(List<Expense> expenses) {
    final today = DateTime.now();
    return expenses
        .where((e) =>
    e.expenseDate.year == today.year &&
        e.expenseDate.month == today.month &&
        e.expenseDate.day == today.day)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  /// SUMMARY: total spent this month
  double calculateMonthlyTotal(List<Expense> expenses) {
    final now = DateTime.now();
    return expenses
        .where((e) =>
    e.expenseDate.year == now.year &&
        e.expenseDate.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }
}
