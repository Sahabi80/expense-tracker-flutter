import 'package:flutter/material.dart';
import '../services/expense_service.dart';
import '../services/income_service.dart';
import '../services/profile_service.dart'; // ✅ ADD
import '../models/expense.dart';
import '../models/income.dart';
import 'edit_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpenseService _expenseService = ExpenseService();
  final IncomeService _incomeService = IncomeService();
  final ProfileService _profileService = ProfileService(); // ✅ ADD

  String _userName = ''; // ✅ ADD

  @override
  void initState() {
    super.initState();
    _loadProfile(); // ✅ ADD
  }

  // ✅ ADD
  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getProfile();
      setState(() {
        _userName = profile['name'] ?? '';
      });
    } catch (_) {}
  }

  double _totalExpense(List<Expense> expenses) {
    return expenses.fold(0, (sum, e) => sum + e.amount);
  }

  double _totalIncome(List<Income> incomes) {
    return incomes.fold(0, (sum, i) => sum + i.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2F7),

      // ================= APP BAR =================
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Analytics',
            onPressed: () {
              Navigator.pushNamed(context, '/analytics');
            },
          ),
          IconButton(
            icon: const Icon(Icons.attach_money),
            tooltip: 'Income',
            onPressed: () {
              Navigator.pushNamed(context, '/income');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () async {
              // ✅ IMPORTANT CHANGE
              final updated =
              await Navigator.pushNamed(context, '/profile');
              if (updated == true) {
                await _loadProfile(); // 🔥 instant refresh
              }
            },
          ),
        ],
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= WELCOME MESSAGE =================
            Text(
              _userName.isEmpty ? 'Welcome' : 'Welcome, $_userName',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  _expenseService.fetchExpenses(),
                  _incomeService.fetchIncome(),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final expenses =
                      snapshot.data?[0] as List<Expense>? ?? [];
                  final incomes =
                      snapshot.data?[1] as List<Income>? ?? [];

                  final totalExpense = _totalExpense(expenses);
                  final totalIncome = _totalIncome(incomes);
                  final netBalance = totalIncome - totalExpense;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= NET BALANCE CARD =================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Net Balance',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '৳${netBalance.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: netBalance >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Income: ৳${totalIncome.toStringAsFixed(0)}'),
                                Text(
                                    'Expense: ৳${totalExpense.toStringAsFixed(0)}'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Recent Expenses',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Expanded(
                        child: expenses.isEmpty
                            ? const Center(
                          child: Text(
                            'No expenses yet',
                            style:
                            TextStyle(color: Colors.grey),
                          ),
                        )
                            : ListView.builder(
                          padding:
                          const EdgeInsets.only(bottom: 16),
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final e = expenses[index];
                            return Card(
                              margin:
                              const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(e.title),
                                subtitle: Text(
                                  e.expenseDate
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                                ),
                                trailing: Row(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    Text(
                                      '৳${e.amount.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          size: 20),
                                      onPressed: () async {
                                        final updated =
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EditExpenseScreen(
                                                    expense: e),
                                          ),
                                        );
                                        if (updated == true) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await _expenseService
                                            .deleteExpense(e.id);
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
            ),
          ],
        ),
      ),

      // ================= ADD EXPENSE BUTTON =================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text(
            'Add Expense',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/add-expense')
                .then((_) => setState(() {}));
          },
        ),
      ),
    );
  }
}
