import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:payment/app_properties.dart';
import 'package:payment/inner_screens/product/product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/products_model.dart';
import '../providers/wishlist_provider.dart';
import 'favorite_btn.dart';

class FeedsItems extends StatefulWidget {
  const FeedsItems({Key? key}) : super(key: key);

  @override
  State<FeedsItems> createState() => _FeedsItemsState();
}

class _FeedsItemsState extends State<FeedsItems> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    double height = MediaQuery.of(context).size.height / 2.7;
    double width = MediaQuery.of(context).size.width / 1.8;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductPage.routeName,
            arguments: productModel.id);
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: mediumYellow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                favorite_btn(
                  productId: productModel.id,
                  isInWishlist: _isInWishlist,
                ),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            productModel.title,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        )),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          color: Color.fromRGBO(224, 69, 10, 1),
                        ),
                        child: Text(
                          '\$${productModel.price}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // Positioned Image with Loading Indicator
          Positioned(
            child: Hero(
              tag: productModel.title,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(24), // Match container radius
                child: Image.network(
                  productModel.imageUrl,
                  height: height / 1.7,
                  width: width / 1.4,
                  fit: BoxFit.contain,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      // Image has finished loading
                      return child;
                    } else {
                      // While the image is loading, show a CircularProgressIndicator
                      return Container(
                        height: height / 1.7,
                        width: width / 1.4,
                        alignment: Alignment.center,
                        child: SpinKitFadingFour(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: height / 1.7,
                    width: width / 1.4,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
