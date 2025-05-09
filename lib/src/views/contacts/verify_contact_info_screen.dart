import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/core/constants/app_icons.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/models/contact_model.dart';

class VerifyContactInfoScreen extends StatelessWidget {
  List<ContactModel> selectedContacts = [];
  VerifyContactInfoScreen({super.key, required this.selectedContacts});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenWidth * 0.13),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // color: Colors.yellow,
                      // height: screenHeight * 0.1,
                      padding: EdgeInsets.only(left: 8),
                      child: TextButton(
                        onPressed: () => context.pop(),
                        child: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.verifyContacts,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    TextButton(
                      onPressed: () async {
                        for (var contact in selectedContacts) {
                          // bool? confirm = await showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return ConfirmAddDialog(contact: contact);
                          //   },
                          // );
                          // if (confirm == true) {
                          //   print('${contact.displayName} confirmed');
                          //   context.read<ContactCubit>().selectContact(contact);
                          // } else {
                          //   print('${contact.displayName} canceled');
                          // }
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.finish),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ContactCubit, ContactState>(
        builder: (context, state) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.selectedContacts.length,
                itemBuilder: (context, index) {
                  final contact = state.selectedContacts[index];
                  return ListTile(
                    title: Text(contact.displayName.toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (contact.phones!.isNotEmpty)
                          Text(
                            contact.chosenPhone ??
                                contact.phones!.first!.toString() ??
                                '',
                          ),
                        //Show Email
                        // if (contact.emails!.isNotEmpty)
                        //   Text(contact.emails!.first.value!),
                      ],
                    ),
                    leading:
                        (contact.avatar != null && contact.avatar!.isNotEmpty)
                            ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar!),
                            )
                            : CircleAvatar(child: Icon(AppIcons.contactIcon)),
                    trailing: GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          AppRoutesName.editContactInfo,
                          extra: contact,
                        );
                      },
                      //  Get.toNamed(
                      //   AppRoutes.editContactInfo,
                      //   parameters: {'index': contact.identifier!},
                      // ),
                      child: Text(
                        AppLocalizations.of(context)!.edit,
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
