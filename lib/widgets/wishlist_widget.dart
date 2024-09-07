import 'package:payment/inner_screens/product/product_page.dart';
import 'package:payment/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';
import '../model/wishlist_model.dart';
import 'favorite_btn.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final getCurrProduct =
        productProvider.findProdById(wishlistModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Container(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductPage.routeName,
                arguments: wishlistModel.productId);
          },
          child: Container(
            height: size.height * 0.20,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 243, 247),
              border: Border.all(color: color, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    // width: size.width * 0.2,
                    height: size.width * 0.25,
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.imageUrl,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            favorite_btn(
                              productId: getCurrProduct.id,
                              isInWishlist: _isInWishlist,
                            )
                          ],
                        ),
                      ),
                      TextWidget(
                        text: getCurrProduct.title,
                        color: color,
                        textSize: 20.0,
                        maxLines: 2,
                        isTitle: true,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextWidget(
                        text: '\$${usedPrice.toStringAsFixed(2)}',
                        color: color,
                        textSize: 18.0,
                        maxLines: 1,
                        isTitle: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
