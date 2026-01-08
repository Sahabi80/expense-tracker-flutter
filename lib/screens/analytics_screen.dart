import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  static const Map<String, Color> categoryColors = {
    'Food': Color(0xFF6A5AE0),
    'Transport': Color(0xFF00BFA6),
    'Bills': Color(0xFFEF5350),
    'Shopping': Color(0xFFFFB74D),
    'Entertainment': Color(0xFF42A5F5),
    'Others': Color(0xFFAB47BC),
  };

  Map<String, double> _categoryTotals(List<Expense> expenses) {
    final Map<String, double> totals = {};
    for (final e in expenses) {
      final category = e.category ?? 'Others';
      totals[category] = (totals[category] ?? 0) + e.amount;
    }
    return totals;
  }

  double _thisMonthTotal(List<Expense> expenses) {
    final now = DateTime.now();
    return expenses
        .where((e) =>
    e.expenseDate.month == now.month &&
        e.expenseDate.year == now.year)
        .fold(0, (sum, e) => sum + e.amount);
  }

  double _lastMonthTotal(List<Expense> expenses) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    return expenses
        .where((e) =>
    e.expenseDate.month == lastMonth.month &&
        e.expenseDate.year == lastMonth.year)
        .fold(0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    final expenseService = ExpenseService();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F2F7),
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Expense>>(
        future: expenseService.fetchExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final expenses = snapshot.data ?? [];
          if (expenses.isEmpty) {
            return const Center(child: Text('No analytics data'));
          }

          final thisMonth = _thisMonthTotal(expenses);
          final lastMonth = _lastMonthTotal(expenses);
          final categories = _categoryTotals(expenses);

          double? percentChange;
          if (lastMonth > 0) {
            percentChange =
                ((thisMonth - lastMonth) / lastMonth) * 100;
          }

          final isIncrease =
              percentChange != null && percentChange > 0;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    /// ---------- MONTHLY COMPARISON ----------
                    const Text(
                      'Monthly Comparison',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'This Month',
                                style: TextStyle(
                                    color: Colors.grey[600]),
                              ),
                              Text(
                                '৳${thisMonth.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Last Month: ৳${lastMonth.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          if (percentChange != null)
                            Row(
                              children: [
                                Icon(
                                  isIncrease
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  color: isIncrease
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${percentChange.abs().toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: isIncrease
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            )
                          else
                            const Text(
                              'No previous data',
                              style:
                              TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// ---------- CATEGORY DISTRIBUTION ----------
                    const Text(
                      'Category Distribution',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 50,
                              sectionsSpace: 2,
                              sections: categories.entries
                                  .map((entry) {
                                return PieChartSectionData(
                                  value: entry.value,
                                  color:
                                  categoryColors[entry.key] ??
                                      Colors.grey,
                                  showTitle: false,
                                  radius: 70,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        Expanded(
                          child: Column(
                            children: categories.entries
                                .map((entry) {
                              return Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                    vertical: 6),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color:
                                            categoryColors[entry.key] ??
                                                Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(entry.key),
                                      ],
                                    ),
                                    Text(
                                      '৳${entry.value.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
