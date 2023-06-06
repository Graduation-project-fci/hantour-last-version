import 'package:firebase_database/firebase_database.dart';

class Database {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("drivers");
  updateDriverLocation(String lat, String long) async {
    await ref.set({
      "name": "John",
      "age": 18,
      "address": {"line1": "100 Mountain View"}
    });
  }
}
