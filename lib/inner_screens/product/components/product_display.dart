import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:payment/services/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:payment/providers/products_provider.dart';
import 'package:payment/providers/wishlist_provider.dart';
import 'package:payment/widgets/favorite_btn.dart';
import 'package:provider/provider.dart';

class ProductDisplay extends StatelessWidget {
  const ProductDisplay({Key? key});
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(-1, 0),
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Container(
              height: screenAwareSize(220, context),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 18.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          child: Hero(
                            tag: getCurrProduct.title,
                            child: ClipRRect(
                              child: Image.network(
                                getCurrProduct.imageUrl,
                                fit: BoxFit.contain,
                                height: 230,
                                width: 230,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    // Image has finished loading
                                    return child;
                                  } else {
                                    // While the image is loading, show a CircularProgressIndicator
                                    return Container(
                                      alignment: Alignment.center,
                                      child: SpinKitFadingFour(
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
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
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
            left: 20.0,
            bottom: 0.0,
            child: favorite_btn(
              productId: productId,
              isInWishlist: _isInWishlist,
            ))
      ],
    );
  }
}
