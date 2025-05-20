import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/routes.dart';
import 'package:splithawk/src/core/validators/app_text_validators.dart';

class AddNewFriendScreen extends StatefulWidget {
  AddNewFriendScreen({super.key});

  @override
  State<AddNewFriendScreen> createState() => _AddNewFriendScreenState();
}

class _AddNewFriendScreenState extends State<AddNewFriendScreen> {
  String email = "";
  String name = "";
  final formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  _submit(BuildContext context) {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      context.read<FriendCubit>().addFriend(
        email: email,
        name: name,
        selfUserModel: context.read<UserCubit>().state.user!,
      );
      context.goNamed(AppRoutesName.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenWidth * 0.13),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    SizedBox(
                      child: Text(
                        AppLocalizations.of(context)!.addFriend,
                        style: TextStyle(fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      child: TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: Text(AppLocalizations.of(context)!.confirm),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: AppSize.paddingSizeL2,
          right: AppSize.paddingSizeL2,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: AppSize.paddingSizeL2),
              TextFormField(
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                validator:
                    (value) => AppTextValidators.validateName(context, value),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.nickName,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
                ),
                onChanged: (value) {
                  name = value;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                autocorrect: false,
                autofocus: true,
              ),
              SizedBox(height: AppSize.paddingSizeL2),
              TextFormField(
                focusNode: _emailFocusNode,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.none,
                validator:
                    (value) => AppTextValidators.validateEmail(context, value),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  label: Text(AppLocalizations.of(context)!.email),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
                ),
                onChanged: (value) {
                  email = value.trim();
                },
                onFieldSubmitted: (value) {
                  _submit(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
