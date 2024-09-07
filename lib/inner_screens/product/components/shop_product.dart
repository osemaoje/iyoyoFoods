import 'package:payment/services/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:payment/model/cart_model.dart';
import 'package:payment/providers/cart_provider.dart';
import 'package:payment/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ShopProduct extends StatelessWidget {
  const ShopProduct({
    Key? key,
    required this.q,
    required this.onRemove,
  }) : super(key: key);
  final int q;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          children: <Widget>[
            ShopProductDisplay(
              q: cartItemsList.length,
              onPressed: () async {
                await cartProvider.removeOneItem(
                  cartId: cartModel.id,
                  productId: cartModel.productId,
                  quantity: cartModel.quantity,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getCurrProduct.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkGrey,
                ),
              ),
            ),
            Text(
              '\$${getCurrProduct.price}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: darkGrey, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ],
        ));
  }
}

class ShopProductDisplay extends StatelessWidget {
  final int q;
  final VoidCallback onPressed;

  const ShopProductDisplay({required this.q, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.productId);
    return SizedBox(
      height: 150,
      width: 200,
      child: Stack(children: <Widget>[
        Positioned(
          left: 25,
          child: SizedBox(
            height: 150,
            width: 150,
            child: Transform.scale(
              scale: 1.2,
              child: Image.asset('assets/bottom_yellow.png'),
            ),
          ),
        ),
        Positioned(
          left: 50,
          top: 5,
          child: SizedBox(
              height: 80,
              width: 80,
              child: Image.network(
                '${getCurrProduct.imageUrl}',
                fit: BoxFit.contain,
              )),
        ),
        Positioned(
          right: 30,
          bottom: 25,
          child: Align(
            child: IconButton(
              icon: Image.asset('assets/red_clear.png'),
              onPressed: onPressed,
            ),
          ),
        )
      ]),
    );
  }
}
