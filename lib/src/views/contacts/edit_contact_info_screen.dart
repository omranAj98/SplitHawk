import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/routes.dart';
import 'package:splithawk/src/models/contact_model.dart';

class EditContactInfoScreen extends StatelessWidget {
  final ContactModel contact;
  EditContactInfoScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    int selectedIndexPhoneNumber = 0;
    String selectedPhoneNumber = "";
    ContactModel editedContact = contact;
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
                      // width: 200,
                      child: Text(
                        AppLocalizations.of(context)!.editContact,
                        style: TextStyle(fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      // width: 120,
                      child: TextButton(
                        onPressed: () {
                          context.read<ContactCubit>().editContact(
                            contact: contact,
                            editedContact: editedContact,
                          );
                          context.goNamed(AppRoutesName.verifyFriendInfo);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: contact.displayName,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    // color: AppMaterialColors.primaryMaterial.shade200,
                  ), // Change the color to your desired color
                ),
              ),
            ),
            SizedBox(height: AppSize.paddingSizeL2),
            Text(AppLocalizations.of(context)!.phoneNumber),
            SizedBox(height: AppSize.paddingSizeL1),

            BlocBuilder<ContactCubit, ContactState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: contact.phones!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String phoneNumber = contact.phones![index]!;
                      String phoneNumberExtracted = context
                          .read<ContactCubit>()
                          .extractPhoneNumber(phoneNumber);

                      return Container(
                        padding: EdgeInsets.only(bottom: AppSize.paddingSizeL1),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: GestureDetector(
                                child:
                                    selectedIndexPhoneNumber == index
                                        ? Icon(Icons.circle_rounded)
                                        : Icon(Icons.circle_outlined),
                                onTap: () {
                                  selectedIndexPhoneNumber = index;
                                  selectedPhoneNumber = phoneNumberExtracted;
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: AppSize.textFormHeight,
                                child: TextFormField(
                                  onChanged:
                                      (value) => selectedPhoneNumber = value,
                                  initialValue: phoneNumberExtracted,
                                  enabled: selectedIndexPhoneNumber == index,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
