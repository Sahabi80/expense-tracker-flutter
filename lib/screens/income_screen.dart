import 'package:flutter/material.dart';
import '../services/income_service.dart';
import '../models/income.dart';
import 'add_income_screen.dart';
import 'edit_income_screen.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final IncomeService _incomeService = IncomeService();

  double _totalIncome(List<Income> incomes) {
    return incomes.fold(0, (sum, i) => sum + i.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2F7),
      appBar: AppBar(
        title: const Text('Income'),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddIncomeScreen(),
            ),
          );
          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Income>>(
        future: _incomeService.fetchIncome(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final incomes = snapshot.data ?? [];

          if (incomes.isEmpty) {
            return const Center(
              child: Text(
                'No income added yet',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final total = _totalIncome(incomes);

          return Column(
            children: [
              /// -------- TOTAL INCOME CARD --------
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Income',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '৳${total.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),

              /// -------- INCOME LIST --------
              Expanded(
                child: ListView.builder(
                  itemCount: incomes.length,
                  itemBuilder: (context, index) {
                    final income = incomes[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(income.title),
                        subtitle: Text(
                          income.incomeDate
                              .toLocal()
                              .toString()
                              .split(' ')[0],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '৳${income.amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  size: 20),
                              onPressed: () async {
                                final result =
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditIncomeScreen(
                                            income: income),
                                  ),
                                );
                                if (result == true) {
                                  setState(() {});
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red,
                                  size: 20),
                              onPressed: () async {
                                await _incomeService
                                    .deleteIncome(income.id);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
