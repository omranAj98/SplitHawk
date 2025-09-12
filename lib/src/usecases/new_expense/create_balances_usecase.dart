import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/models/balance_model.dart';
import 'package:splithawk/src/models/expense/expense_model.dart';
import 'package:splithawk/src/models/expense/split_model.dart';

class CreateBalancesUseCase {
  List<BalanceModel> execute({
    required ExpenseModel expense,
    required List<SplitModel> splits,
  }) {
    List<BalanceModel> balances = [];
    for (final split in splits) {
      // Create balance for the user
      final userBalance = BalanceModel(
        currency: expense.currency,
        docRef: FirebaseFirestore.instance
            .collection('users')
            .doc(split.userRef.id)
            .collection('friends')
            .doc(split.owedToUserRef.id)
            .collection('balances')
            .doc(expense.currency),
        netAmount: (split.paidAmount ?? 0) - split.owedAmount,
      );
      final friendBalance = BalanceModel(
        currency: expense.currency,
        docRef: FirebaseFirestore.instance
            .collection('users')
            .doc(split.owedToUserRef.id)
            .collection('friends')
            .doc(split.userRef.id)
            .collection('balances')
            .doc(expense.currency),
        netAmount: split.owedAmount - (split.paidAmount ?? 0),
      );

      // Add overall net balances for both users
      final userNetBalance = BalanceModel(
        currency: expense.currency,
        docRef: FirebaseFirestore.instance
            .collection('users')
            .doc(split.userRef.id)
            .collection('netBalance')
            .doc(expense.currency),
        netAmount: (split.paidAmount ?? 0) - split.owedAmount,
      );

      final owedToUserNetBalance = BalanceModel(
        currency: expense.currency,
        docRef: FirebaseFirestore.instance
            .collection('users')
            .doc(split.owedToUserRef.id)
            .collection('netBalance')
            .doc(expense.currency),
        netAmount: split.owedAmount - (split.paidAmount ?? 0),
      );

      balances.add(userBalance);
      balances.add(friendBalance);
      balances.add(userNetBalance);
      balances.add(owedToUserNetBalance);
    }
    return balances;
  }
}
