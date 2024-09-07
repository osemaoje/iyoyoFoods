import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:payment/inner_screens/product/product_page.dart';
import 'package:provider/provider.dart';
import '../model/products_model.dart';
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';
import 'favorite_btn.dart';
import 'text_widget.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  // String get textPrice => null;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    Size size = Utils(context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, ProductPage.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          child: Container(
            color: Color.fromARGB(255, 248, 243, 247),
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FancyShimmerImage(
                        imageUrl: productModel.imageUrl,
                        height: size.width * 0.15,
                        width: size.width * 0.25,
                        boxFit: BoxFit.contain,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              favorite_btn(
                                productId: productModel.id,
                                isInWishlist: _isInWishlist,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  PriceWidget(
                    salePrice: productModel.salePrice,
                    price: productModel.price,
                    textPrice: '1',
                    isOnSale: true,
                  ),
                  // const SizedBox(height: 25),
                  TextWidget(
                    text: productModel.title,
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                  // const SizedBox(height: 5),
                ]),
          ),
        ),
      ),
    );
  }
}

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  }) : super(key: key);
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    double userPrice = isOnSale ? salePrice : price;
    return FittedBox(
        child: Row(
      children: [
        TextWidget(
          text: '\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
          color: Colors.black,
          textSize: 18,
        ),
        const SizedBox(
          width: 5,
        ),
        Visibility(
          visible: isOnSale ? true : false,
          child: Text(
            '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.red,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ),
      ],
    ));
  }
}
