// import 'package:flutter/material.dart';
// import 'package:share/share.dart'; // Import the share pack;
// class ProductDetailsPage extends StatelessWidget {
//   final String productTitle;
//   final String productDescription;

//   ProductDetailsPage({required this.productTitle, required this.productDescription});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product Details'),
//       ),
//       body: Column(
//         children: [
//           // Your product details widgets here
//           // ...
//           IconButton(
//             icon: Icon(
//               Icons.share_outlined,
//               color: blackColor,
//             ),
//             onPressed: () {
//               _shareProductInfo(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _shareProductInfo(BuildContext context) {
//     // Implement the sharing logic here
//     Share.share('Check out this product:\nTitle: $productTitle\nDescription: $productDescription');
//   }
// }
