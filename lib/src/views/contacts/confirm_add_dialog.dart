// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:split/constants/app_strings.dart';
// import 'package:split/constants/sizes.dart';
// import 'package:split/features/core/controllers/add_friend_controller.dart';
// import 'package:split/helper/app_text_validators.dart';
// import 'package:splithawk/src/core/constants/app_size.dart';
// import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';

// class ConfirmAddDialog extends StatelessWidget {
//   final Contact contact;

//   ConfirmAddDialog({required this.contact});

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;

//     String phoneNumber = contact.phones![0].value!;
//     String phoneNumberExtracted = controller.extractPhoneNumber(phoneNumber);
//     final _formKey = GlobalKey<FormState>();

//     return AlertDialog(
//       title: Text(AppLocalizations.of(context)!.confirmAddContact),
//       content: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(AppLocalizations.of(context)!.checkNumberBeforeConfirmation),
//             SizedBox(height: AppSize.paddingSizeL1),
//             Text(
//               contact.displayName ?? 'No name available',
//               style: textTheme.headlineMedium?.copyWith(
//                 color: colorScheme.onSurface,
//               ),
//             ),
//             SizedBox(height: AppSize.paddingSizeL1),
//             TextFormField(
//               onChanged:
//                   (value) => controller.selectedPhoneNumber.value = value,
//               validator: AppTextValidators.validatePhoneNumber,
//               decoration: InputDecoration(
//                 helperText: AppStrings.examplePhoneNumber,
//               ),
//               initialValue: phoneNumberExtracted,
//             ),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () async {
//             if (_formKey.currentState!.validate()) {
//               controller.addFriend();
//               Navigator.of(context).pop(true);
//             }
//           },
//           child: Text(AppStrings.yes),
//         ),
//         TextButton(
//           onPressed: () {
//             // Close the dialog without performing the action
//             Navigator.of(
//               context,
//             ).pop(false); // Pass false to indicate cancellation
//           },
//           child: Text(AppStrings.no),
//         ),
//       ],
//     );
//   }
// }
