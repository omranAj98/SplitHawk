import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splithawk/src/models/friend_model.dart';

class FriendRepository {
  final FirebaseFirestore firebaseFirestore;

  FriendRepository({required this.firebaseFirestore});

  addfriend(FriendModel friend) async {
    //   await firebaseFirestore
    //       .collection('users')
    //       .add(friend.toMap());
  }
}
