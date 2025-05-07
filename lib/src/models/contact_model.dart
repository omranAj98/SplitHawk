// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ContactModel extends Equatable {
  final String id;
  final String displayName;
  final List<String?>? emails;
  final List<String?>? phones;
  final Uint8List? avatar;
  final String? initials;
  const ContactModel({
    required this.id,
    required this.displayName,
    this.emails,
    this.phones,
    this.avatar,
    this.initials,
  });

  @override
  List<Object?> get props {
    return [id, displayName, emails, phones, avatar, initials];
  }

  ContactModel copyWith({
    String? id,
    String? displayName,
    List<String>? emails,
    List<String>? phones,
    Uint8List? avatar,
    String? initials,
  }) {
    return ContactModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      emails: emails ?? this.emails,
      phones: phones ?? this.phones,
      avatar: avatar ?? this.avatar,
      initials: initials ?? this.initials,
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
      'avatar': avatar?.toList(),
      'initials': initials,
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
      avatar:
          map['avatar'] != null
              ? Uint8List.fromList(map['avatar'] as List<int>)
              : null,
      initials: map['initials'] != null ? map['initials'] as String : null,
    );
  }

  factory ContactModel.fromContact({
    required String id,
    required String displayName,
    List<String>? emails,
    required List<String>? phones,
    Uint8List? avatar,
    String? initials,
    List<String>? countryPhoneCode,
  }) {
    return ContactModel(
      id: id,
      displayName: displayName,
      emails: emails,
      phones: phones,
      avatar: avatar,
      initials: initials,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
