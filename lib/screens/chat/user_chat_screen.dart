import 'package:sulabh_market_app/constants/widgets.dart';
import 'package:sulabh_market_app/models/popup_menu_model.dart';
import 'package:sulabh_market_app/screens/chat/chat_stream.dart';
import 'package:sulabh_market_app/constants/colors.dart';
import 'package:sulabh_market_app/provider/product_provider.dart';
import 'package:sulabh_market_app/services/user.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging

class UserChatScreen extends StatefulWidget {
  static const String screenId = 'user_chat_screen';
  final String? chatroomId;
  const UserChatScreen({Key? key, this.chatroomId}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  TextEditingController msgController = TextEditingController();
  UserService firebaseUser = UserService();
  bool send = false;

  FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance; // Create an instance of FirebaseMessaging

  @override
  void initState() {
    super.initState();

    // Request permission for receiving push notifications (optional, but recommended)
    _firebaseMessaging.requestPermission();

    // Get the FCM token and save it to your server for this user
    _firebaseMessaging.getToken().then((token) {
      // Save the 'token' to your server or perform any necessary actions.
      // You should associate this token with the user on your server so that you can send push notifications to this specific device.
      // In a real-world scenario, you'll want to send the token to your backend server and associate it with the user's account.
      print('FCM Token: $token');

      // Ensure that the token is not null before passing it to _sendTokenToServer
      if (token != null) {
        _sendTokenToServer(token);
      }
    });

    // Handle incoming messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the incoming message here
      print(
          'Message received while app is in the foreground: ${message.notification?.body}');
    });

    // Handle the case where the user clicks on the notification when the app is in the background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the message when the user clicks on the notification and the app is opened (in the background or terminated)
      print(
          'Message clicked and app is opened from background or terminated: ${message.notification?.body}');
    });
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  sendMessage() {
    if (msgController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      Map<String, dynamic> message = {
        'message': msgController.text,
        'sent_by': firebaseUser.user!.uid,
        'time': DateTime.now().microsecondsSinceEpoch,
      };

      // Ensure that the chatroomId is not null before passing it to createChat
      String chatroomId = widget.chatroomId!;

      firebaseUser.createChat(chatroomId: chatroomId, message: message);
      msgController.clear();

      // Send push notification to the receiver
      _sendNotificationToReceiver(message['message']);
    }
  }

  // Method to send the FCM token to your backend server
  void _sendTokenToServer(String token) {
    // Implement the logic to send the token to your backend server and associate it with the user's account.
    // You can use HTTP requests or any other suitable communication method to send the token to the server.
    // Example: Make an HTTP POST request to your server API with the user's ID and the FCM token.
    // Your server should then handle the storage and association of the token with the user's account in your database.
    // Replace 'userId' with the actual ID of the user.
    // Example using HTTP package (import 'package:http/http.dart' as http):
    // final response = await http.post('https://your-server.com/save_fcm_token',
    //   body: {'user_id': 'userId', 'fcm_token': token},
    // );
  }

  // Method to send push notification to the receiver
  void _sendNotificationToReceiver(String messageText) {
    // Replace 'receiverFcmToken' with the FCM token of the receiver, obtained during user authentication.
    String receiverFcmToken = 'receiverFcmToken';

    // Create the notification message
    var notification = {
      'notification': {
        'title': 'New Message',
        'body': messageText,
      },
      'to': receiverFcmToken,
    };

    // In a real-world scenario, you should send this notification to your server
    // Your server should then handle the actual push notification to deliver the message to the recipient's device.

    // For demonstration purposes, we'll print the notification data here.
    print('Sending Notification:');
    print(notification);
  }

  _body() {
    return Container(
      child: Stack(
        children: [
          ChatStream(
            chatroomId: widget.chatroomId,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border(
                  top: BorderSide(
                    color: disabledColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              send = true;
                            });
                          } else {
                            setState(() {
                              send = false;
                            });
                          }
                        },
                        onSubmitted: (value) {
                          /// Pressing Enter and Sending Message Case
                          if (value.length > 0) {
                            sendMessage();
                          }
                        },
                        controller: msgController,
                        style: TextStyle(
                          color: blackColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your message...',
                          hintStyle: TextStyle(
                            color: blackColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.attach_file),
                    ),
                    Visibility(
                      visible: send,
                      child: IconButton(
                        onPressed: sendMessage,
                        icon: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(color: blackColor),
        title: Text(
          'Chat Details',
          style: TextStyle(color: blackColor),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          customPopUpMenu(
            context: context,
            chatroomId: widget.chatroomId,
          ),
        ],
      ),
      body: _body(),
    );
  }
}
