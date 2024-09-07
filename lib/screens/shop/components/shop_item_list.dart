import 'package:payment/services/app_properties.dart';
import 'package:payment/inner_screens/product/components/color_list.dart';
import 'package:payment/inner_screens/product/components/shop_product.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:payment/inner_screens/product/product_page.dart';
import 'package:payment/model/cart_model.dart';
import 'package:payment/providers/cart_provider.dart';
import 'package:payment/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ShopItemList extends StatefulWidget {
  const ShopItemList({Key? key, required this.onRemove, required this.q})
      : super(key: key);
  final int q;
  final VoidCallback onRemove;

  @override
  _ShopItemListState createState() => _ShopItemListState();
}

class _ShopItemListState extends State<ShopItemList> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);

    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductPage.routeName,
            arguments: cartModel.productId);
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        height: 130,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0, 0.8),
              child: Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: shadow,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 12.0, right: 12.0),
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                getCurrProduct.title,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: darkGrey,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 160,
                                  padding: const EdgeInsets.only(
                                      left: 32.0, top: 8.0, bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ColorOption(Colors.red),
                                      Text(
                                        '${getCurrProduct.price}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: darkGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Theme(
                            data: ThemeData(
                                textTheme: TextTheme(
                                  titleLarge: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  bodyLarge: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                colorScheme: ColorScheme.fromSwatch()
                                    .copyWith(secondary: Colors.black)),
                            child: NumberPicker(
                              value: 1,
                              minValue: 1,
                              maxValue: 10,
                              onChanged: (value) {
                                setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) -
                                              1)
                                          .toString();
                                });
                              },
                            ))
                      ])),
            ),
            Positioned(
                top: 5,
                child: ShopProductDisplay(
                  q: cartItemsList.length,
                  onPressed: () async {
                    await cartProvider.removeOneItem(
                      cartId: cartModel.id,
                      productId: cartModel.productId,
                      quantity: cartModel.quantity,
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
