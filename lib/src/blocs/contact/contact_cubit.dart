import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:splithawk/src/core/enums/request_status.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/contact_model.dart';
import 'package:splithawk/src/repositories/contacts_repository.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactsRepository contactsRepository;
  final StreamController<String> _searchController =
      StreamController<String>. broadcast();

  ContactCubit({required this.contactsRepository})
    : super(ContactState.initial()) {
    _searchController.stream.listen((searchText) {
      searchContacts(searchText);
    });
  }
  
   @override
  Future<void> close() {
    // Any additional cleanup
    _searchController.close();
    // ContactState.initial();
    // debugPrint('ContactCubit closed');
    return super.close();
  }


  void updateSearchText(String searchText) {
    _searchController.add(searchText);
  }

  void editSelectedContact({
    required ContactModel contact,
    required ContactModel newEditedContact,
  }) async {
    final selectedContacts = List<ContactModel>.from(state.selectedContacts);
    if (selectedContacts.contains(contact)) selectedContacts.remove(contact);

    selectedContacts.add(newEditedContact);
    emit(
      state.copyWith(
        selectedContacts: selectedContacts,
        requestStatus: RequestStatus.success,
      ),
    );
  }

  String extractPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll('-', '');
    phoneNumber = phoneNumber.replaceAll('(', '');
    phoneNumber = phoneNumber.replaceAll(')', '');
    RegExp regExp = RegExp(r'^\D*(\d{1,3})');
    Match? match = regExp.firstMatch(phoneNumber);
    if (match != null) {
      String phoneNumberWithoutCountryCode = phoneNumber.replaceFirst(
        regExp,
        '',
      ); // Remove country code prefix
      List<String> parts = phoneNumberWithoutCountryCode.split(' ');
      if (parts.length > 1) {
        return parts[1];
      }
    }
    return phoneNumber; // Return the original phoneNumber if no match or only one part after splitting
  }

  // String extractCountryCode(String phoneNumber) {
  //   RegExp regExp = RegExp(r'^\D*(\d{1,3})');
  //   Match? match = regExp.firstMatch(phoneNumber);
  //   if (match != null) {
  //     return match.group(1)!;
  //   }
  //   return "";
  // }

  void fetchContacts() {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      contactsRepository.fetchContacts().then((contacts) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            contactsList: contacts,
          ),
        );
      });
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          error: CustomError(
            message: e.message,
            code: e.code,
            plugin: e.plugin,
          ),
        ),
      );
    }
  }

  void selectContact(ContactModel contact) {
    final selectedContacts = List<ContactModel>.from(state.selectedContacts);
    if (selectedContacts.contains(contact)) {
      selectedContacts.remove(contact);
    } else {
      selectedContacts.add(contact);
    }
    emit(
      state.copyWith(
        selectedContacts: selectedContacts,
        requestStatus: RequestStatus.success,
      ),
    );
  }

  void clearSelectedContacts() {
    emit(
      state.copyWith(
        selectedContacts: [],
        requestStatus: RequestStatus.success,
      ),
    );
  }

  // Add a method to completely reset the state
  void resetState() {
    emit(ContactState.initial());
  }

  void searchContacts(String name) {
    List<ContactModel> filteredContacts = [];
    if (name.isNotEmpty) {
      filteredContacts =
          state.contactsList
              .where(
                (contact) => contact.displayName.toLowerCase().contains(
                  name.toLowerCase(),
                ),
              )
              .toList();
    } else {
      filteredContacts = state.contactsList;
    }
    emit(state.copyWith(filteredContacts: filteredContacts));
  }

}
