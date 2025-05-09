import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/core/constants/app_icons.dart';
import 'package:splithawk/src/models/contact_model.dart';

class SelectedContactList extends StatelessWidget {
  List<ContactModel>? selectedContacts = [];
  SelectedContactList({super.key, this.selectedContacts});

  @override
  Widget build(BuildContext context) {
    return selectedContacts!.isNotEmpty
        ? SizedBox(
          height: 110,
          child: ListView.builder(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            // shrinkWrap: true,
            itemCount: selectedContacts!.length,
            itemBuilder: (context, index) {
              final contact = selectedContacts![index];
              return SizedBox(
                // height: screenHeight * 20 / 100,
                width: 80,
                //margin: EdgeInsets.all(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        (contact.avatar != null && contact.avatar!.isNotEmpty)
                            ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar!),
                              radius: 30, // Adjust the radius as needed
                            )
                            : CircleAvatar(
                              radius: 25.sp,
                              child: Icon(AppIcons.contactIcon)
                            ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              context.read<ContactCubit>().selectContact(
                                contact,
                              );
                              // controller.unselectContact(contact);
                            },
                            child: CircleAvatar(
                              radius: 9.sp,
                              child: Icon(Icons.cancel, size: 18.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      (contact.displayName.toString().length <= 11)
                          ? contact.displayName.toString()
                          : '${contact.displayName.toString().substring(0, 11)}...',
                      style: TextStyle(fontSize: 9.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        )
        : SizedBox.shrink();
  }
}
