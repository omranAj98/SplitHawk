import 'package:splithawk/src/core/enums/split_options.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/expense/split_model.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplitEquallyBillUseCase {
  List<SplitModel> execute({
    required double amount,
    required DocumentReference selfUserRef,
    required FriendDataModel selectedFriend,
    SplitOptions splitOption = SplitOptions.youPaidFullSplitEqual,
  }) {
    List<SplitModel> splits = [];
    try {
      final friend = selectedFriend;
    

      double friendPaidAmount = 0.0;
      double friendOwedAmount = 0.0;
      double selfPaidAmount = 0.0;
      double selfOwedAmount = 0.0;

      switch (splitOption) {
        case SplitOptions.youPaidFullSplitEqual:
          // You paid full, split equally
          selfPaidAmount = amount;
          selfOwedAmount = amount / 2;
          friendPaidAmount = 0;
          friendOwedAmount = amount / 2;
          break;
        case SplitOptions.youPaidFullTheyOweFull:
          // You paid full, they owe full
          selfPaidAmount = amount;
          selfOwedAmount = 0;
          friendPaidAmount = 0;
          friendOwedAmount = amount;
          break;
        case SplitOptions.theyPaidFullSplitEqual:
          // They paid full, split equally
          selfPaidAmount = 0;
          selfOwedAmount = amount / 2;
          friendPaidAmount = amount;
          friendOwedAmount = amount / 2;
          break;

          case SplitOptions.theyPaidFullYouOweFull:
          // They paid full, you owe full
          selfPaidAmount = 0;
          selfOwedAmount = amount;
          friendPaidAmount = amount;
          friendOwedAmount = 0;
          break;

        default:
          throw Exception('Invalid split option selected.');
      }

      // Create split model for the friend
      splits.add(
        SplitModel(
          userRef: friend.userRef,
          owedToUserRef: selfUserRef,
          paidAmount: friendPaidAmount,
          owedAmount: friendOwedAmount,
          userName: friend.friendName,
          owedToName: "you"
        ),
      );

      // Create split model for yourself
      splits.add(
        SplitModel(
          userRef: selfUserRef,
          owedToUserRef: friend.userRef,
          paidAmount: selfPaidAmount,
          owedAmount: selfOwedAmount,
          userName: "you",
          owedToName: friend.friendName,
        ),
      );

      return splits;
    } catch (e) {
      throw CustomError(
        message: 'Failed to split bill: ${e.toString()}',
        code: 'split_bill_error',
        plugin: "SplitEquallyBillUseCase",
      );
    }
  }
}
