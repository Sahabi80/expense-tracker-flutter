import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/income.dart';

class IncomeService {
  final _client = Supabase.instance.client;

  Future<List<Income>> fetchIncome() async {
    final userId = _client.auth.currentUser!.id;

    final res = await _client
        .from('income')
        .select()
        .eq('user_id', userId)
        .order('income_date', ascending: false);

    return (res as List).map((e) => Income.fromMap(e)).toList();
  }

  Future<void> addIncome({
    required String title,
    required double amount,
    required DateTime incomeDate,
  }) async {
    final userId = _client.auth.currentUser!.id;

    await _client.from('income').insert({
      'user_id': userId,
      'title': title,
      'amount': amount,
      'income_date': incomeDate.toIso8601String(),
    });
  }

  Future<void> updateIncome({
    required String id,
    required String title,
    required double amount,
    required DateTime incomeDate,
  }) async {
    await _client.from('income').update({
      'title': title,
      'amount': amount,
      'income_date': incomeDate.toIso8601String(),
    }).eq('id', id);
  }

  Future<void> deleteIncome(String id) async {
    await _client.from('income').delete().eq('id', id);
  }
}
