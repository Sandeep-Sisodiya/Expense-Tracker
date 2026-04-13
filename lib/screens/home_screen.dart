import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../widgets/expense_list_tile.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/shimmer_widgets.dart';
import 'add_edit_expense_screen.dart';
import 'all_expenses_screen.dart';
import 'login_screen.dart';

/// Main home dashboard screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, _) {
          if (expenseProvider.isLoading) {
            return const SafeArea(child: DashboardShimmer());
          }

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () => expenseProvider.loadExpenses(),
              color: theme.colorScheme.primary,
              child: CustomScrollView(
                slivers: [
                  // ── App Bar ─────────────────────────────────────
                  SliverToBoxAdapter(
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: _buildHeader(context, isDark),
                    ),
                  ),

                  // ── Total Balance Card ──────────────────────────
                  SliverToBoxAdapter(
                    child: FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 500),
                      child: _buildTotalCard(
                          context, expenseProvider, isDark),
                    ),
                  ),

                  // ── Category Summary ────────────────────────────
                  if (expenseProvider.categoryTotals.isNotEmpty)
                    SliverToBoxAdapter(
                      child: FadeInDown(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                          child: _buildCategorySummary(
                              context, expenseProvider, isDark),
                        ),
                      ),
                    ),

                  // ── Pie Chart ───────────────────────────────────
                  if (expenseProvider.categoryTotals.isNotEmpty)
                    SliverToBoxAdapter(
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          child: ExpensePieChart(
                            categoryTotals: expenseProvider.categoryTotals,
                            totalExpenses: expenseProvider.totalExpenses,
                          ),
                        ),
                      ),
                    ),

                  // ── Recent Transactions Header ──────────────────
                  SliverToBoxAdapter(
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 350),
                      duration: const Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Transactions',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (expenseProvider.expenses.length > 5)
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AllExpensesScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'View All',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Empty state or list ─────────────────────────
                  if (expenseProvider.expenses.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyStateWidget(
                        icon: Icons.receipt_long_rounded,
                        title: 'No Expenses Yet',
                        subtitle:
                            'Start tracking your spending\nby adding your first expense',
                        buttonText: 'Add Expense',
                        onButtonPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AddEditExpenseScreen(),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final expense =
                                expenseProvider.recentExpenses[index];
                            return FadeInUp(
                              delay:
                                  Duration(milliseconds: 400 + index * 60),
                              duration: const Duration(milliseconds: 400),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10),
                                child: ExpenseListTile(
                                  expense: expense,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AddEditExpenseScreen(
                                          expense: expense,
                                        ),
                                      ),
                                    );
                                  },
                                  onDelete: () {
                                    expenseProvider
                                        .deleteExpense(expense.id);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Expense deleted'),
                                        backgroundColor:
                                            Color(0xFFFF6B6B),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          childCount:
                              expenseProvider.recentExpenses.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FadeInUp(
        delay: const Duration(milliseconds: 600),
        duration: const Duration(milliseconds: 500),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, animation, __) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: const AddEditExpenseScreen(),
                ),
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Expense'),
        ),
      ),
    );
  }

  /// Builds the header with greeting and settings
  Widget _buildHeader(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final authProvider = context.read<AuthProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final userName = authProvider.currentUser?.name ?? 'User';
    final firstName = userName.split(' ').first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                firstName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  firstName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Dark mode toggle
          IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(
              isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: theme.colorScheme.primary,
            ),
            style: IconButton.styleFrom(
              backgroundColor:
                  theme.colorScheme.primary.withOpacity(0.08),
            ),
          ),
          const SizedBox(width: 8),
          // Logout
          IconButton(
            onPressed: () => _handleLogout(context),
            icon: Icon(
              Icons.logout_rounded,
              color: const Color(0xFFFF6B6B),
            ),
            style: IconButton.styleFrom(
              backgroundColor:
                  const Color(0xFFFF6B6B).withOpacity(0.08),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the total expenses card
  Widget _buildTotalCard(
    BuildContext context,
    ExpenseProvider expenseProvider,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF2D1B69), const Color(0xFF6C5CE7)]
                : [const Color(0xFF6C5CE7), const Color(0xFFA29BFE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C5CE7).withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Total Expenses',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '₹${NumberFormat('#,##,###.##').format(expenseProvider.totalExpenses)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${expenseProvider.expenses.length} transaction${expenseProvider.expenses.length != 1 ? 's' : ''} total',
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds horizontal scrollable category summary chips
  Widget _buildCategorySummary(
    BuildContext context,
    ExpenseProvider expenseProvider,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final categories = expenseProvider.categoryTotals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Overview',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final entry = categories.entries.elementAt(index);
              final info = AppConstants.categoryData[entry.key]!;
              return Container(
                width: 130,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF222244)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: info.color.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: info.color.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: info.gradient,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        info.icon,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${NumberFormat.compact().format(entry.value)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: info.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Handle logout with confirmation
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final authProvider = context.read<AuthProvider>();
              final expenseProvider = context.read<ExpenseProvider>();
              expenseProvider.clear();
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF6B6B),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
