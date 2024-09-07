import 'package:payment/services/app_properties.dart';
import 'package:payment/screens/address/address_form.dart';
import 'package:flutter/material.dart';
import 'package:payment/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class AddAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Add Address',
            style: const TextStyle(
                color: darkGrey,
                fontWeight: FontWeight.w500,
                fontFamily: "Montserrat",
                fontSize: 18.0),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.white,
                          elevation: 3,
                          child: SizedBox(
                              height: 100,
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                          'assets/icons/address_home.png'),
                                    ),
                                    Text(
                                      'Add Address',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: darkGrey,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ))),
                    ],
                  ),
                  Container(
                    height: double.maxFinite,
                    child: _addAddress(ctx: context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addAddress({required BuildContext ctx, index}) {
    final cartProvider = Provider.of<CartProvider>(ctx);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return ListView.builder(
      itemCount: cartItemsList.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
            value: cartItemsList[index],
            child: AddAddressForm(
              q: cartItemsList[index].quantity,
            ));
      },
    );
  }
}
