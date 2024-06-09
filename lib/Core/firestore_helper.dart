import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/User.dart';

class FireStoreHelper{

 static CollectionReference<User> getUserCollection(){
    var reference = FirebaseFirestore.instance.collection("User").withConverter(
      fromFirestore: (snapshot, options) {
        Map<String, dynamic>? doc = snapshot.data();
        return User.fromFireStore(doc!);
      },
      toFirestore: (user, options) {
        return user.toFireStore();
      },
    );
    return reference ;
  }
  static Future<void> addNewUser(User user) async {
    var useCollection = getUserCollection();
    var documentReference = useCollection.doc(user.id!);
    await documentReference.set(user);
  }
  static Future<User?> getUser(String userId) async {
   var userCollection = getUserCollection();
   var docReference = userCollection.doc(userId);
   var snapshot = await docReference.get();
   var user = snapshot.data();
   return user;
  }
}