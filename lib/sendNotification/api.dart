import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class API {
  // Replace with server token from firebase console settings.
  final String serverToken =
      'AAAAGx_dmbw:APA91bGUVawdCUxK4PTR_Q2uiPkd4DBd7W3_UgVPPdCG1GseD3_taSDP0XT_AvFS_uqtDZ_ziAZ026CcR-tg8z6flGssRvkCZYx_NtSDtR5YPe7I2EhgZfga4N5uu2jBiXPsA86Buz_I';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void sendAndRetrieveMessage(
      List<String> tokens, String title, String body) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '$body',
              'title': '$title',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'name': 'mostafa',
            },
            'registration_ids':
                tokens //'fA_fbsfYTPW0sVjJsdKZAp:APA91bEpjIXsJnyHEPBjwLHtXrfOmPXhwB1w8vtRz5dWikTlmIo7tSAQBpWmcDW0Ljg4dTt5iBu_2tFqBCCEVK6zvFpp4vGxF8bAkal5HWUTr4bh097jwmtHASrhzBy9F_XXC6uqEgio',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print(
            'Notification sending failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<String> sendAndRetrieveMessage_New(List<String> tokens, String title,
      String body, String Sender_token) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '$body',
              'title': '$title',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'name': 'mostafa',
            },
            'registration_ids':
                tokens //'fA_fbsfYTPW0sVjJsdKZAp:APA91bEpjIXsJnyHEPBjwLHtXrfOmPXhwB1w8vtRz5dWikTlmIo7tSAQBpWmcDW0Ljg4dTt5iBu_2tFqBCCEVK6zvFpp4vGxF8bAkal5HWUTr4bh097jwmtHASrhzBy9F_XXC6uqEgio',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print(
            'Notification sending failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
    return Sender_token;
  }

  void AcceptOrderMessage(String token, String title, String body) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '$body',
              'title': '$title',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'name': 'mostafa',
            },
            'to':
                token //'fA_fbsfYTPW0sVjJsdKZAp:APA91bEpjIXsJnyHEPBjwLHtXrfOmPXhwB1w8vtRz5dWikTlmIo7tSAQBpWmcDW0Ljg4dTt5iBu_2tFqBCCEVK6zvFpp4vGxF8bAkal5HWUTr4bh097jwmtHASrhzBy9F_XXC6uqEgio',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to Single user');
      } else {
        print(
            'Notification sending failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  bool Is_Token_Exists(String token, List<String> Tokens) {
    for (int i = 0; i < Tokens.length; i++) {
      if (Tokens[i] == token) return true;
    }
    return false;
  }

  void ResetPassword(String email) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully
    } catch (e) {
      print('Error sending password reset email: $e');
      // Handle the error
    }
  }
}
