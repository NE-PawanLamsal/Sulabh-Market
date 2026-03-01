// import 'package:sulabh_market_app/constants/widgets.dart';
// import 'package:sulabh_market_app/models/popup_menu_model.dart';
// import 'package:sulabh_market_app/screens/chat/chat_stream.dart';
// import 'package:sulabh_market_app/constants/colors.dart';
// import 'package:sulabh_market_app/provider/product_provider.dart';
// import 'package:sulabh_market_app/services/user.dart';
// import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging

// class UserChatScreen extends StatefulWidget {
//   static const String screenId = 'user_chat_screen';
//   final String? chatroomId;
//   const UserChatScreen({Key? key, this.chatroomId}) : super(key: key);

//   @override
//   State<UserChatScreen> createState() => _UserChatScreenState();
// }

// class _UserChatScreenState extends State<UserChatScreen> {
//   TextEditingController msgController = TextEditingController();
//   UserService firebaseUser = UserService();

//   bool send = false;

//   @override
//   void dispose() {
//     msgController.dispose();
//     super.dispose();
//   }

//   sendMessage() {
//     if (msgController.text.isNotEmpty) {
//       FocusScope.of(context).unfocus();
//       Map<String, dynamic> message = {
//         'message': msgController.text,
//         'sent_by': firebaseUser.user!.uid,
//         'time': DateTime.now().microsecondsSinceEpoch,
//       };

//       firebaseUser.createChat(chatroomId: widget.chatroomId, message: message);
//       msgController.clear();

//       // Send push notification to the receiver
//       _sendNotificationToReceiver(message['message']);
//     }
//   }

//   // Method to send push notification to the receiver
//   void _sendNotificationToReceiver(String messageText) {
//     // Replace 'receiverFcmToken' with the FCM token of the receiver, obtained during user authentication.
//     String receiverFcmToken = 'receiverFcmToken';

//     // Create the notification message
//     var notification = {
//       'notification': {
//         'title': 'New Message',
//         'body': messageText,
//       },
//       'to': receiverFcmToken,
//     };

//     // In a real-world scenario, you should send this notification to your server
//     // Your server should then handle the actual push notification to deliver the message to the recipient's device.

//     // For demonstration purposes, we'll print the notification data here.
//     //print('Sending Notification:');
//     print(notification);
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   _body() {
//     return Container(
//       child: Stack(
//         children: [
//           ChatStream(
//             chatroomId: widget.chatroomId,
//           ),
//           Container(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: whiteColor,
//                 border: Border(
//                   top: BorderSide(
//                     color: disabledColor.withOpacity(0.2),
//                   ),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         onChanged: (value) {
//                           if (value.isNotEmpty) {
//                             setState(() {
//                               send = true;
//                             });
//                           } else {
//                             setState(() {
//                               send = false;
//                             });
//                           }
//                         },
//                         onSubmitted: (value) {
//                           /// Pressing Enter and Sending Message Case
//                           if (value.length > 0) {
//                             sendMessage();
//                           }
//                         },
//                         controller: msgController,
//                         style: TextStyle(
//                           color: blackColor,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: 'Enter you message...',
//                           hintStyle: TextStyle(
//                             color: blackColor,
//                           ),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: Icon(Icons.attach_file),
//                     ),
//                     Visibility(
//                       visible: send,
//                       child: IconButton(
//                         onPressed: sendMessage,
//                         icon: Icon(Icons.send),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var productProvider = Provider.of<ProductProvider>(context);
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: whiteColor,
//           elevation: 0,
//           iconTheme: IconThemeData(color: blackColor),
//           title: Text(
//             'Chat Details',
//             style: TextStyle(color: blackColor),
//           ),
//           actions: [
//             IconButton(onPressed: () {}, icon: Icon(Icons.call)),
//             customPopUpMenu(
//               context: context,
//               chatroomId: widget.chatroomId,
//             ),
//           ],
//         ),
//         body: _body());
//   }
// }
