class TransactionHistory {
  final int currentBalance;
  final int amount;
  final int reciver;
  final int sender;
  final int day;
  final int month;
  final int year;
  final int hour;
  final int minute;
  final int second;
  String name;

  TransactionHistory(
      this.currentBalance,
      this.amount,
      this.reciver,
      this.sender,
      this.day,
      this.month,
      this.year,
      this.hour,
      this.minute,
      this.second);

  @override
  String toString() {
    return 'TransactionHistory(currentBalance: $currentBalance, amount: $amount, reciver: $reciver, sender: $sender)';
  }
}
