import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/core/theme/shimmer/shimmer_box_decoration.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:splithawk/src/views/contacts/widgets/contact_list.dart';
import 'package:splithawk/src/views/contacts/widgets/selected_contact_list.dart';

class AddFriendScreen extends StatelessWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    TextEditingController searchText = TextEditingController(text: '');

    fetchContacts() async {
      context.read<ContactCubit>().fetchContacts();
    }

    return RefreshIndicator(
      onRefresh: () => fetchContacts(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenWidth * 0.25),
          child: SafeArea(
            child: Container(
              // height: screenHeight * 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 8),
                        child: TextButton(
                          onPressed: () => context.pop(),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.addFriend,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      BlocBuilder<ContactCubit, ContactState>(
                        builder: (context, state) {
                          return TextButton(
                            onPressed:
                                state.selectedContacts.isNotEmpty
                                    ? () {
                                      context.pushNamed(
                                        AppRoutesName.verifyFriendInfo,
                                      );
                                    }
                                    : null, // Disable the button if selectedContacts is empty
                            child: Text(AppLocalizations.of(context)!.next),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.85,

                    child: TextFormField(
                      autocorrect: false,
                      onChanged:
                          (value) => context
                              .read<ContactCubit>()
                              .updateSearchText(value),
                      controller: searchText,

                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: screenHeight * 0.03,
                        ),
                        suffixIcon: BlocBuilder<ContactCubit, ContactState>(
                          builder: (context, state) {
                            return IconButton(
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                Icons.cancel_outlined,
                                size: screenHeight * 0.02,
                              ),
                              onPressed: () {
                                context.read<ContactCubit>().updateSearchText(
                                  '',
                                );
                                searchText.text = '';
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: Permission.contacts.status,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isPermanentlyDenied) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.contactsPermissionDenied,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.permissionDenied,
                                  ),
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.contactsPermissionDenied,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        AppLocalizations.of(context)!.ok,
                                      ),
                                      onPressed: () {
                                        // Open app settings
                                        openAppSettings();
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.openSettings,
                          ),
                        ),
                      ],
                    );
                  } else {
                    fetchContacts();
                    return BlocConsumer<ContactCubit, ContactState>(
                      listener: (context, state) {
                        if (state.requestStatus == RequestStatus.error) {
                          state.error.showErrorDialog(context);
                        }
                      },
                      builder: (context, state) {
                        return state.requestStatus == RequestStatus.success
                            ? Column(
                              children: [
                                BlocBuilder<ContactCubit, ContactState>(
                                  builder: (context, state) {
                                    return SelectedContactList(
                                      selectedContacts: state.selectedContacts,
                                    );
                                  },
                                ),
                                // AddNewContact(),
                                BlocBuilder<ContactCubit, ContactState>(
                                  builder: (context, state) {
                                    return ContactList(
                                      contactsList:
                                          searchText.text.isNotEmpty
                                              ? state.filteredContacts
                                              : state.contactsList,
                                    );
                                  },
                                ),
                              ],
                            )
                            : Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,

                              child: Column(
                                children: [
                                  Container(
                                    height: screenHeight * 0.1,
                                    width: screenWidth * 0.85,
                                    decoration: shimmerBoxDecoration(
                                      colorScheme,
                                    ),
                                  ),
                                ],
                              ),
                            );
                      },
                    );
                  }
                } else {
                  return Text(snapshot.error.toString());
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
