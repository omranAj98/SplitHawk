import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/core/constants/app_size.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/routes/names.dart';
import 'package:splithawk/src/core/theme/shimmer/shimmer_box_decoration.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:splithawk/src/views/contacts/widgets/contact_list.dart';
import 'package:splithawk/src/views/contacts/widgets/selected_contact_list.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  bool initialLoad = false;

  @override
  void initState() {
    super.initState();
    // Fetch contacts only once when the widget is initialized
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    if (!initialLoad) {
      context.read<ContactCubit>().fetchContacts();
      initialLoad = true; // Mark as loaded
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    TextEditingController searchText = TextEditingController(text: '');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160),
        child: SafeArea(
          bottom: false,
          child: Container(
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
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.addNewFriend,
                          style: TextStyle(color: colorScheme.primary),
                        ),
                        leading: Icon(Icons.person_add_alt_rounded),
                        onTap:
                            () => context.pushNamed(AppRoutesName.addNewFriend),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: AppSize.iconSize,
                        ),
                        tileColor: colorScheme.onSurface.withValues(
                          alpha: 0.04,
                        ),
                      ),
                      TextFormField(
                        autocorrect: false,
                        autofocus: true,
                        onChanged:
                            (value) => context
                                .read<ContactCubit>()
                                .updateSearchText(value),
                        controller: searchText,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.searchContacts,
                          prefixIcon: Icon(
                            Icons.search,
                            size: AppSize.defaultSize,
                          ),
                          suffixIcon: BlocBuilder<ContactCubit, ContactState>(
                            builder: (context, state) {
                              return IconButton(
                                highlightColor: Colors.transparent,
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  size: AppSize.iconSize,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchContacts(),
        child: SafeArea(
          minimum: EdgeInsets.only(
            // left: screenWidth * 0.05,
            // right: screenWidth * 0.05,
            top: AppSize.paddingSizeL1,
          ),
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
                                Expanded(
                                  child:
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
                                ),
                              ],
                            )
                            : state.requestStatus == RequestStatus.loading
                            ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                  vertical: AppSize.paddingSizeL1,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildShimmerItem(
                                      screenWidth,
                                      AppSize.contactItemHeight,
                                      colorScheme,
                                    ),
                                    SizedBox(height: AppSize.paddingSizeL2),
                                    _buildShimmerItem(
                                      screenWidth,
                                      AppSize.contactItemHeight,
                                      colorScheme,
                                    ),
                                    SizedBox(height: AppSize.paddingSizeL2),
                                    _buildShimmerItem(
                                      screenWidth,
                                      AppSize.contactItemHeight,
                                      colorScheme,
                                    ),
                                    SizedBox(height: AppSize.paddingSizeL2),
                                    _buildShimmerItem(
                                      screenWidth,
                                      AppSize.contactItemHeight,
                                      colorScheme,
                                    ),
                                    SizedBox(height: AppSize.paddingSizeL2),
                                    _buildShimmerItem(
                                      screenWidth,
                                      AppSize.contactItemHeight,
                                      colorScheme,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : SizedBox.shrink();
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

  Widget _buildShimmerItem(
    double screenWidth,
    double height,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: screenWidth * 0.9,
      height: height,
      decoration: shimmerBoxDecoration(colorScheme),
    );
  }
}
