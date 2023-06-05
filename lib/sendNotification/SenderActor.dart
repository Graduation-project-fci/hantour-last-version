import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hantourgo/sendNotification/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

void retrieveFCMToken(String CollectionName, String token) async {
  print('FCM Token: $token');
  // Save the token to Firebase
  saveTokenToFirebase(token!, '${CollectionName}');
}

void saveTokenToFirebase(String token, String CollectionName) async {
  List<String> TOKENS = [];
  TOKENS = await fetchAllTokens('${CollectionName}');
  var api = API();
  if (api.Is_Token_Exists(token, TOKENS) == false) {
    await FirebaseFirestore.instance
        .collection('${CollectionName}')
        .doc() // Optionally, you can provide a specific document ID
        .set({'token': token});
    print('Token saved to Firebase');
  } else {
    print("Token already Exists ");
  }
}

Future<List<String>> fetchAllTokens(String CollectionName) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('${CollectionName}').get();

    final List<String> tokens =
        querySnapshot.docs.map((doc) => doc.data()['token'] as String).toList();
    print("all token from driver collection");

    return tokens;
  } catch (e, stackTrace) {
    print('Error retrieving tokens: $e\n$stackTrace');
    return [];
  }
}

Future<void> sendNotificationToUsers(
    List<String> userTokens, String title, String body) async {
  final String serverKey =
      'AAAAGx_dmbw:APA91bGUVawdCUxK4PTR_Q2uiPkd4DBd7W3_UgVPPdCG1GseD3_taSDP0XT_AvFS_uqtDZ_ziAZ026CcR-tg8z6flGssRvkCZYx_NtSDtR5YPe7I2EhgZfga4N5uu2jBiXPsA86Buz_I';
  final String firebaseUrl = 'https://fcm.googleapis.com/fcm/send';

  final Map<String, dynamic> notification = {
    'title': title,
    'body': body,
    'sound': 'default',
  };

  final Map<String, dynamic> message = {
    'notification': notification,
    'registration_ids': userTokens,
  };

  try {
    final http.Response response = await http.post(
      Uri.parse(firebaseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Notification sending failed. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}

Future<List<String>> GetAllUserTokens(String userId) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('UserTokens')
            .doc(userId)
            .get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic>? data = documentSnapshot.data();
      if (data != null) {
        final List<dynamic> tokenList = data['tokens'] as List<dynamic>;
        final List<String> tokens =
            tokenList.map((token) => token as String).toList();

        return tokens;
      } else {
        print('User data is null');
        return [];
      }
    } else {
      print('User document does not exist');
      return [];
    }
  } catch (e, stackTrace) {
    print('Error retrieving user tokens: $e\n$stackTrace');
    return [];
  }
}
