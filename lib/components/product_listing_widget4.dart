// import 'package:sulabh_market_app/constants/colors.dart';
// import 'package:sulabh_market_app/provider/category_provider.dart';
// import 'package:sulabh_market_app/provider/product_provider.dart';
// import 'package:sulabh_market_app/screens/product/product_details_screen.dart';
// import 'package:sulabh_market_app/services/auth.dart';
// import 'package:sulabh_market_app/services/user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:sulabh_market_app/global_var2.dart';

// // Add the following import for geolocator package
// import 'package:geolocator/geolocator.dart';

// class ProductListing extends StatefulWidget {
//   final bool? isProductByCategory;

//   const ProductListing({Key? key, this.isProductByCategory}) : super(key: key);

//   @override
//   State<ProductListing> createState() => _ProductListingState();
// }

// class _ProductListingState extends State<ProductListing> {
//   Auth authService = Auth();
//   UserService firebaseUser = UserService();

//   // Method to calculate the distance between the buyer and the seller
//   Future<double> calculateDistance(String sellerUid) async {
//     try {
//       // Fetch the buyer's location
//       Position buyerPosition = await Geolocator.getCurrentPosition();
      
//       // Fetch the seller's location from the 'users' table using the 'sellerUid'
//       DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(sellerUid)
//           .get();
//       double sellerLatitude = sellerSnapshot['location']['latitude'];
//       double sellerLongitude = sellerSnapshot['location']['longitude'];
      
//       // Calculate the distance using the Haversine formula
//       double distanceInMeters = Geolocator.distanceBetween(
//         buyerPosition.latitude, buyerPosition.longitude,
//         sellerLatitude, sellerLongitude,
//       );
      
//       // Convert the distance from meters to kilometers
//       double distanceInKm = distanceInMeters / 1000.0;
      
//       return distanceInKm;
//     } catch (e) {
//       return 0.0;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var productProvider = Provider.of<ProductProvider>(context);
//     var categoryProvider = Provider.of<CategoryProvider>(context);
//     final numberFormat = NumberFormat('##,##,##0');

//     return FutureBuilder<String>(
//       future: getRecommend(firebaseUser.user!.uid),
//       builder: (BuildContext context, AsyncSnapshot<String> recommendSnapshot) {
//         if (recommendSnapshot.hasError) {
//           return const Center(child: Text('Error loading recommendation..'));
//         }

//         if (recommendSnapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: secondaryColor,
//             ),
//           );
//         }

//         String recommendSubcategory = recommendSnapshot.data ?? '';

//         return FutureBuilder<QuerySnapshot>(
//           future: (widget.isProductByCategory == true)
//               ? authService.products
//                   .orderBy('posted_at')
//                   .where('category',
//                       isEqualTo: categoryProvider.selectedCategory)
//                   .where('subcategory',
//                       isEqualTo: categoryProvider.selectedSubCategory)
//                   .get()
//               : authService.products
//                   .orderBy('posted_at')
//                   .where('subcategory', isEqualTo: recommendSubcategory)
//                   .get(),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return const Center(child: Text('Error loading products..'));
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   color: secondaryColor,
//                 ),
//               );
//             }

//             return (snapshot.data!.docs.isEmpty)
//                 ? SizedBox(
//                     height: MediaQuery.of(context).size.height - 50,
//                     child: const Center(
//                       child: Text('No Products Found.'),
//                     ),
//                   )
//                 : Container(
//                     padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         (widget.isProductByCategory != null)
//                             ? const SizedBox()
//                             : Container(
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       'Recommendation',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18,
//                                         color: blackColor,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                         GridView.builder(
//                           physics: const ScrollPhysics(),
//                           scrollDirection: Axis.vertical,
//                           shrinkWrap: true,
//                           gridDelegate:
//                               const SliverGridDelegateWithMaxCrossAxisExtent(
//                             maxCrossAxisExtent: 200,
//                             childAspectRatio: 2 / 2.8,
//                             mainAxisExtent: 250,
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 10,
//                           ),
//                           itemCount: snapshot.data!.size,
//                           itemBuilder: (BuildContext context, int index) {
//                             return FutureBuilder<double>(
//                               future: calculateDistance(snapshot.data!.docs[index]['seller_uid']),
//                               builder: (BuildContext context, AsyncSnapshot<double> distanceSnapshot) {
//                                 if (distanceSnapshot.connectionState == ConnectionState.waiting) {
//                                   return Center(
//                                     child: CircularProgressIndicator(
//                                       color: secondaryColor,
//                                     ),
//                                   );
//                                 }

//                                 double distanceInKm = distanceSnapshot.data ?? 0.0;
//                                 var data = snapshot.data!.docs[index];
//                                 var price = int.parse(data['price']);
//                                 String formattedPrice = numberFormat.format(price);

//                                 return ProductCard(
//                                   data: data,
//                                   formattedPrice: formattedPrice,
//                                   numberFormat: numberFormat,
//                                   // Pass the calculated distance to the ProductCard widget
//                                   distanceInKm: distanceInKm,
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//           },
//         );
//       },
//     );
//   }
// }

// class ProductCard extends StatelessWidget {
//   final DocumentSnapshot data;
//   final String formattedPrice;
//   final NumberFormat numberFormat;
//   final double distanceInKm;

//   ProductCard({
//     required this.data,
//     required this.formattedPrice,
//     required this.numberFormat,
//     required this.distanceInKm,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           Text('Product Name: ${data['name']}'),
//           Text('Price: $formattedPrice'),
//           Text('Distance: $distanceInKm km'),
//           // Add other product details here...
//         ],
//       ),
//     );
//   }
// }
