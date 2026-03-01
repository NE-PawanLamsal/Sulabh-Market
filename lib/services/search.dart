import 'package:sulabh_market_app/components/product_listing_widget.dart';
import 'package:sulabh_market_app/components/search_card.dart';
import 'package:sulabh_market_app/constants/colors.dart';
import 'package:sulabh_market_app/models/product_model.dart';
import 'package:sulabh_market_app/provider/product_provider.dart';
import 'package:sulabh_market_app/screens/product/product_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:sulabh_market_app/global_var2.dart';

import 'auth.dart';
import 'user.dart';

Auth authService = Auth();
UserService firebaseUser = UserService();

class Search {
  searchQueryPage(
      {required BuildContext context,
      required List<Products> products,
      required String address,
      DocumentSnapshot? sellerDetails,
      required ProductProvider provider}) {
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
          barTheme: ThemeData(
              appBarTheme: AppBarTheme(
                  backgroundColor: whiteColor,
                  elevation: 0,
                  surfaceTintColor: primaryColor,
                  iconTheme: IconThemeData(color: blackColor),
                  actionsIconTheme: IconThemeData(color: blackColor))),
          onQueryUpdate: (s) => print(s),
          items: products,
          searchLabel: 'Search bikes, mobiles, properties...',
          suggestion: const SingleChildScrollView(child: ProductListing()),
          failure: const Center(
            child: Text('No product found, Please check and try again..'),
          ),
          filter: (product) => [
                product.title,
                product.description,
                product.category,
                product.subcategory,
              ],
          builder: (product) {
            return InkWell(
                onTap: () {
                  provider.setProductDetails(product.document);
                  provider.setSellerDetails(sellerDetails);
                  //String Subcategory = product.subcategory ?? '';
                  updateRecommend(
                      firebaseUser.user!.uid, product.subcategory ?? '');
                  Navigator.pushNamed(context, ProductDetail.screenId);
                },
                child: SearchCard(
                  product: product,
                  address: address,
                ));
          }),
    );
  }
}
