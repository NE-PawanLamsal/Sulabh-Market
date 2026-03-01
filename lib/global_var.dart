import 'package:share_plus/share_plus.dart';

void shareProductInfo(String prodTitle, String prodDesc, String prodId) {
  // Implement the sharing logic here
  String link = createProductLink(prodId);
  String shareText =
      'Check out this product:\nTitle: $prodTitle\nDescription: $prodDesc\nLink: $link';
  Share.share(shareText);
}

String createProductLink(String productId) {
  return 'sulabhmarketapp://product?productId=$productId';
}
