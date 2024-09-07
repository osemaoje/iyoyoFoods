import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier {
  final String id, title, imageUrl, description,productCategoryName;
  final double price,salePrice;
  final bool isOnSale;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.productCategoryName,

    required this.salePrice,
    required this.isOnSale,
  });
}
