class ExpenseItem {
  const ExpenseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isPaid,
  });

  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isPaid;

  ExpenseItem copyWith({
    String? id,
    String? title,
    String? category,
    double? amount,
    bool? isPaid,
  }) {
    return ExpenseItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
