import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/auth/auth_bloc.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/core/error/snackbar_error.dart';
import 'package:splithawk/src/core/validators/app_text_validators.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

class SignupForm extends StatelessWidget {
  final String? initEmail;
  SignupForm({super.key, this.initEmail});
  String? email;
  String? password;
  String? fullName;
  String? phoneNo;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    void submit() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        try {
          context.read<AuthBloc>().add(
            AuthSignUpWithEmailEvent(
              email: email!,
              password: password!,
              name: fullName!,
            ),
          );
        } on CustomError catch (e) {
          AppErrorSnackBar(error: e, context: context);
        } catch (e) {
          debugPrint("Signup form error Listener: ${e.toString()}");
          AppErrorSnackBar(context: context);
        }
      }
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool loading = state.authStatus == AuthStatus.loading;
        return Container(
          padding: EdgeInsets.symmetric(vertical: AppSize.paddingSizeL3),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(AppLocalizations.of(context)!.signUp),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.fullName,
                  ),
                  readOnly: loading,
                  autocorrect: false,
                  validator:
                      (value) =>
                          AppTextValidators.validateFullName(context, value),
                  onSaved: (newValue) => fullName = newValue,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: loading,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                  ),
                  autocorrect: false,
                  initialValue: initEmail,
                  validator:
                      (value) =>
                          AppTextValidators.validateEmail(context, value),
                  onSaved: (newValue) => email = newValue,
                ),
                // const SizedBox(height: 8),
                // TextFormField(
                //   readOnly: loading,
                //   decoration: InputDecoration(
                //     labelText: AppLocalizations.of(context)!.phoneNumber,
                //   ),
                //   autocorrect: false,
                //   validator:
                //       (value) =>
                //           AppTextValidators.validatePhoneNumber(context, value),
                //   onSaved: (newValue) => phoneNo = newValue,
                //   keyboardType: TextInputType.phone,
                // ),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: loading,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                  ),
                  autocorrect: false,
                  obscureText: true,
                  onFieldSubmitted: (value) => submit(),
                  enableSuggestions: false,
                  validator:
                      (value) =>
                          AppTextValidators.validatePassword(context, value),
                  onSaved: (newValue) => password = newValue,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: AppColors.highlight,
                    fixedSize: Size.fromWidth(200),
                  ),
                  onPressed: () => submit(),
                  child:
                      !loading
                          ? Text(AppLocalizations.of(context)!.signUp)
                          : CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
