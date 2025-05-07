import 'package:contacts_service/contacts_service.dart';
import 'package:splithawk/src/core/error/custom_error.dart';
import 'package:splithawk/src/models/contact_model.dart';

class ContactsRepository {
  // Future<ContactModel> searchContact(String name) async {
  //   // Fetch contacts
  //   try{
  //   final List<Contact> result = await ContactsService.getContacts(query: name);
  //   print(result);
  //   // Process result and create a ContactsModel
  //   final List<String?> phones = [];
  //   result.forEach((contact) {
  //     phones.addAll(contact.phones?.map((item) => item.value) ?? []);
  //   });

  //   // Return a ContactsModel instance
  //   return ContactModel(name: name, phones: phones);}
  //   catch (e) {
  //     throw CustomError(
  //       message: e.toString(),
  //       code: 'searchContact_error',
  //       plugin: 'contacts_service',
  //     );
  //   }
  // }

  Future<List<ContactModel>> fetchContacts() async {
    try {
      final List<Contact> contacts = await ContactsService.getContacts();
      List<ContactModel> contactModelList = [];
      for (var contact in contacts) {
        if (contact.phones == null || contact.phones!.isEmpty) {
          continue;
        }
        contactModelList.add(
          ContactModel.fromContact(
            id: contact.identifier ?? '', // Provide a fallback if null
            displayName:
                contact.displayName ?? 'Unknown', // Provide a fallback if null
            phones:
                contact.phones?.map((item) => item.value ?? '').toList() ??
                [], // Handle null values
            emails:
                contact.emails?.map((item) => item.value ?? '').toList() ??
                [], // Handle null values
            avatar: contact.avatar, // Avatar can remain nullable
            initials: contact.initials() ?? '', // Provide a fallback if null
          ),
        );
      }
      return contactModelList;
    } catch (e) {
      throw CustomError(
        message: e.toString(),
        code: 'fetchContacts_error',
        plugin: 'contacts_service',
      );
    }
  }

  void addContact(Contact contact) async {
    try {
      await ContactsService.addContact(contact);
    } catch (e) {
      throw CustomError(
        message: e.toString(),
        code: 'addContact_error',
        plugin: 'contacts_service',
      );
    }
  }

  void openExistingContact(Contact contact) async {
    try {
      await ContactsService.openExistingContact(contact);
    } catch (e) {
      throw CustomError(
        message: e.toString(),
        code: 'openExistingContact_error',
        plugin: 'contacts_service',
      );
    }
  }
}
