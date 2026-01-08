import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

const List<String> expenseCategories = [
  'Food',
  'Transport',
  'Bills',
  'Shopping',
  'Entertainment',
  'Others',
];

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  late String _selectedCategory;
  late DateTime _selectedDate;

  final ExpenseService _expenseService = ExpenseService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.expense.title);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _noteController =
        TextEditingController(text: widget.expense.note ?? '');

    _selectedCategory =
        widget.expense.category ?? expenseCategories.first;
    _selectedDate = widget.expense.expenseDate;
  }

  Future<void> _updateExpense() async {
    setState(() => _isLoading = true);

    await _expenseService.updateExpense(
      expenseId: widget.expense.id,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      expenseDate: _selectedDate,
    );

    setState(() => _isLoading = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: expenseCategories
                    .map(
                      (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _updateExpense,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
