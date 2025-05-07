import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/models/contact_model.dart';

class ContactList extends StatelessWidget {
  final List<ContactModel> contactsList;
  const ContactList({super.key, required this.contactsList});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: contactsList.length,
          itemBuilder: (context, index) {
            final contact = contactsList[index];
            return ListTile(
              title: Text(contact.displayName.toString()),
              subtitle: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.phones!
                                .take(2)
                                .map((phone) => phone ?? '')
                                .join(',') +
                            (contact.phones!.length > 2 ? ', ...' : ''),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.emails!
                                .take(1)
                                .map((email) => email ?? '')
                                .join(',') +
                            (contact.emails!.length > 1 ? ', ...' : ''),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: GestureDetector(
                onTap: () {
                  context.read<ContactCubit>().selectContact(contact);
                },
                child:
                    state.selectedContacts.contains(contact)
                        ? Icon(Icons.circle)
                        : Icon(Icons.circle_outlined),
              ),

              leading:
                  (contact.avatar != null && contact.avatar!.isNotEmpty)
                      ? CircleAvatar(
                        backgroundImage: MemoryImage(contact.avatar!),
                      )
                      : CircleAvatar(child: Text(contact.initials!)),
            );
          },
        );
      },
    );
  }
}
