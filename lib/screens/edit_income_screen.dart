import 'package:flutter/material.dart';
import '../models/income.dart';
import '../services/income_service.dart';

class EditIncomeScreen extends StatefulWidget {
  final Income income;

  const EditIncomeScreen({super.key, required this.income});

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  late DateTime _selectedDate;

  final IncomeService _incomeService = IncomeService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.income.title);
    _amountController =
        TextEditingController(text: widget.income.amount.toString());
    _selectedDate = widget.income.incomeDate;
  }

  Future<void> _updateIncome() async {
    setState(() => _isLoading = true);

    await _incomeService.updateIncome(
      id: widget.income.id,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text),
      incomeDate: _selectedDate,
    );

    setState(() => _isLoading = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Income'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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

            Row(
              children: [
                const Text('Date:'),
                const SizedBox(width: 12),
                Text(
                  _selectedDate.toLocal().toString().split(' ')[0],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _updateIncome,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Update Income'),
            ),
          ],
        ),
      ),
    );
  }
}
