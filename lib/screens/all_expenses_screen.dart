import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_list_tile.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/shimmer_widgets.dart';
import 'add_edit_expense_screen.dart';

/// Screen showing all expenses with search and sort
class AllExpensesScreen extends StatelessWidget {
  const AllExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, _) {
          if (expenseProvider.isLoading) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: ShimmerList(itemCount: 8),
            );
          }

          if (expenseProvider.expenses.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.receipt_long_rounded,
              title: 'No Expenses Yet',
              subtitle: 'Start tracking your spending\nby adding your first expense',
            );
          }

          return RefreshIndicator(
            onRefresh: () => expenseProvider.loadExpenses(),
            color: theme.colorScheme.primary,
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: expenseProvider.expenses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final expense = expenseProvider.expenses[index];
                return FadeInUp(
                  delay: Duration(milliseconds: index * 50),
                  duration: const Duration(milliseconds: 400),
                  child: ExpenseListTile(
                    expense: expense,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddEditExpenseScreen(expense: expense),
                        ),
                      );
                    },
                    onDelete: () {
                      expenseProvider.deleteExpense(expense.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Expense deleted'),
                          backgroundColor: Color(0xFFFF6B6B),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
