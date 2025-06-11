import 'package:flutter/material.dart';
import 'package:splithawk/src/core/constants/app_icons.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/models/friend_data_model.dart';

class FriendItem extends StatelessWidget {
  final FriendDataModel friend;
  const FriendItem({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      final BorderSide border = BorderSide(
      width: 2,
      color: colorScheme.onTertiary.withAlpha(100),
    );
    return Padding(
      padding: const EdgeInsets.all(AppSize.paddingSizeL1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(child: Icon(AppIcons.contactIcon)),
                  const SizedBox(width: 12),
                  Text(
                    friend.friendName.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),

              if (friend.friendBalances != null &&
                  friend.friendBalances.isNotEmpty)
                Text(
                  '${friend.friendBalances.first.netAmount} ${friend.friendBalances!.first.currency}',
                  style: TextStyle(
                    color:
                        double.parse(
                                  friend.friendBalances.first.netAmount
                                      .toString(),
                                ) >=
                                0
                            ? colorScheme.primary.withAlpha(200)
                            : colorScheme.error.withAlpha(200),
                    fontWeight: FontWeight.bold,
                  ),
                ),

              if (friend.friendBalances == null)
                Text(AppLocalizations.of(context)!.settled),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 19.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (friend.friendBalances != null &&
                    friend.friendBalances!.isNotEmpty)
                  ...friend.friendBalances!.map(
                    (balance) => Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: BorderDirectional(
                              bottom: border,
                              start: border,
                            ),
                          ),
                          child: const SizedBox(height: 19.0, width: 20.0),
                        ),
                        (balance.netAmount > 0)
                            ? Text(
                              '${friend.friendName} ${AppLocalizations.of(context)!.owesYou} ${balance.netAmount} ${balance.currency}',
                              style: TextStyle(
                                color: colorScheme.primary.withAlpha(200),
                              ),
                            )
                            : (balance.netAmount < 0)
                            ? Text(
                              '${AppLocalizations.of(context)!.youOwe} ${friend.friendName} ${balance.netAmount.abs()} ${balance.currency}',
                              style: TextStyle(
                                color: colorScheme.error.withAlpha(200),
                              ),
                            )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
