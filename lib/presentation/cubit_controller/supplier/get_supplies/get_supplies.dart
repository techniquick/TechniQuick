import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techni_quick/model/user.dart';

import '../../../../injection.dart';
import '../../../../model/Supplies.dart';

class GetSupplies {
  static Stream<List<Supplies>> getMySupplies() {
    final user = sl<FirebaseAuth>().currentUser!;
    final stream = sl<FirebaseFirestore>().doc('users/${user.uid}').snapshots();
    return stream.map((event) {
      return (userFromJson(event.data()!) as Supplier).supplies;
    });
  }

  static Stream<List<Supplier>> getSupplier() {
    final stream = sl<FirebaseFirestore>()
        .collection('users')
        .where('type', isEqualTo: 'supplier')
        .snapshots();
    return stream.map((event) =>
        event.docs.map((e) => (userFromJson(e.data())) as Supplier).toList());
  }
}
