// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ContactModel extends Equatable {
  final String id;
  final String displayName;
  final List<String?>? emails;
  final List<String?>? phones;
  final String? chosenPhone;
  final Uint8List? avatar;

  const ContactModel({
    required this.id,
    required this.displayName,
    this.emails,
    this.phones,
    this.chosenPhone,
    this.avatar,
  });

  @override
  List<Object?> get props {
    return [id, displayName, emails, phones, chosenPhone, avatar];
  }

  ContactModel copyWith({
    String? id,
    String? displayName,
    List<String>? emails,
    List<String>? phones,
    String? chosenPhone,
    Uint8List? avatar,
  }) {
    return ContactModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      emails: emails ?? this.emails,
      phones: phones ?? this.phones,
      chosenPhone: chosenPhone ?? this.chosenPhone,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'emails': emails,
      'phones': phones,
      'chosenPhone': chosenPhone,
      // Convert Uint8List to base64 string to ensure proper JSON serialization
      'avatar': avatar != null ? base64Encode(avatar!) : null,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      emails:
          map['emails'] != null
              ? List<String>.from(map['emails'] as List)
              : null,
      phones:
          map['phones'] != null
              ? List<String>.from(map['phones'] as List)
              : null,
      chosenPhone: map['chosenPhone'] as String?,

      avatar:
          map['avatar'] != null ? base64Decode(map['avatar'] as String) : null,
    );
  }

  factory ContactModel.fromContact({
    required String id,
    required String displayName,
    List<String>? emails,
    required List<String>? phones,
    String? chosenPhone,
    Uint8List? avatar,
  }) {
    return ContactModel(
      id: id,
      displayName: displayName,
      emails: emails,
      phones: phones,
      chosenPhone: chosenPhone,
      avatar: avatar,
    );
  }
}
