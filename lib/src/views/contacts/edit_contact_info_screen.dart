import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/routes.dart';
import 'package:splithawk/src/models/contact_model.dart';

class EditContactInfoScreen extends StatefulWidget {
  final ContactModel contact;
  EditContactInfoScreen({super.key, required this.contact});

  @override
  State<EditContactInfoScreen> createState() => _EditContactInfoScreenState();
}

class _EditContactInfoScreenState extends State<EditContactInfoScreen> {
  int selectedIndexPhoneNumber = 0;
  String selectedPhoneNumber = "";
  late ContactModel editedContact = widget.contact;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    editedContact = widget.contact;
    // Initialize selectedPhoneNumber with the first phone number if available
    if (widget.contact.phones != null && widget.contact.phones!.isNotEmpty) {
      selectedPhoneNumber = context.read<ContactCubit>().extractPhoneNumber(
        widget.contact.phones![0]!,
      );
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
                        AppLocalizations.of(context)!.editContact,
                        style: TextStyle(fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      child: TextButton(
                        onPressed: () {
                          ContactModel newdEditedContact = editedContact
                              .copyWith(chosenPhone: selectedPhoneNumber);

                          context.read<ContactCubit>().editSelectedContact(
                            contact: widget.contact,
                            newEditedContact: newdEditedContact,
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
              initialValue: widget.contact.displayName,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
              ),
              onChanged: (value) {
                editedContact = editedContact.copyWith(displayName: value);
              },
            ),
            SizedBox(height: AppSize.paddingSizeL2),
            Text(AppLocalizations.of(context)!.phoneNumber),
            SizedBox(height: AppSize.paddingSizeL1),

            BlocBuilder<ContactCubit, ContactState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: widget.contact.phones!.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Extract phone number for each list item independently
                      final String phoneNumberForThisItem = context
                          .read<ContactCubit>()
                          .extractPhoneNumber(widget.contact.phones![index]!);

                      // If this is the selected index, update the selected phone number
                      if (index == selectedIndexPhoneNumber && !_loaded) {
                        selectedPhoneNumber = phoneNumberForThisItem;
                      }

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
                                  setState(() {
                                    selectedIndexPhoneNumber = index;
                                    selectedPhoneNumber =
                                        phoneNumberForThisItem;
                                    editedContact = editedContact.copyWith(
                                      chosenPhone: phoneNumberForThisItem,
                                    );
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: AppSize.textFormHeight,
                                child: TextFormField(
                                  onChanged: (value) {
                                    // Update the selected phone number when edited
                                    if (selectedIndexPhoneNumber == index) {
                                      selectedPhoneNumber = value;

                                      // Create a copy of the phones list
                                      List<String>? updatedPhones =
                                          List<String>.from(
                                            widget.contact.phones ?? [],
                                          );

                                      // Update the specific index with the new value
                                      if (index < updatedPhones.length) {
                                        updatedPhones[index] = value;
                                      }

                                      // Update the contact with the modified phones list
                                      editedContact = editedContact.copyWith(
                                        chosenPhone: value,
                                        phones: updatedPhones,
                                      );
                                    }
                                  },
                                  initialValue: phoneNumberForThisItem,
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
