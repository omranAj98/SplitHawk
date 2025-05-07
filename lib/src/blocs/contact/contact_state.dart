// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'contact_cubit.dart';

class ContactState extends Equatable {
  final RequestStatus requestStatus;
  final List<ContactModel> contactsList;
  final List<ContactModel> selectedContacts;
  final List<ContactModel> filteredContacts;
  final CustomError error;

  const ContactState({
    required this.requestStatus,
    required this.contactsList,
    required this.selectedContacts,
    required this.filteredContacts,
    required this.error,
  });

  factory ContactState.initial() {
    return ContactState(
      requestStatus: RequestStatus.initial,
      contactsList: [],
      selectedContacts: [],
      filteredContacts: [],
      error: CustomError(message: ''),
    );
  }

  @override
  List<Object?> get props => [
    requestStatus,
    contactsList,
    selectedContacts,
    filteredContacts,
    error,
  ];

  ContactState copyWith({
    RequestStatus? requestStatus,
    List<ContactModel>? contactsList,
    List<ContactModel>? selectedContacts,
    List<ContactModel>? filteredContacts,
    CustomError? error,
  }) {
    return ContactState(
      requestStatus: requestStatus ?? this.requestStatus,
      contactsList: contactsList ?? this.contactsList,
      selectedContacts: selectedContacts ?? this.selectedContacts,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      error: error ?? this.error,
    );
  }

  @override
  bool get stringify => true;
}
