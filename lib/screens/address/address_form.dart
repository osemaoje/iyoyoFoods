import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payment/services/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:payment/screens/main/main_page.dart';
import 'package:payment/model/cart_model.dart';
import 'package:payment/providers/cart_provider.dart';
import 'package:payment/providers/orders_provider.dart';
import 'package:payment/providers/products_provider.dart';
import 'package:payment/providers/wishlist_provider.dart';
import 'package:payment/services/global_methods.dart';
import 'package:payment/services/utils.dart';
import 'package:payment/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddAddressForm extends StatefulWidget {
  const AddAddressForm({Key? key, required this.q}) : super(key: key);
  final int q;
  @override
  State<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  final _quantityTextController = TextEditingController();
  bool hasPurchased = false;

  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    plugin.initialize(publicKey: publicKey);
    getUserData();

    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String publicKey = 'YOUR_PUBLC_KEY';
  final plugin = PaystackPlugin();
  String message = '';

  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  bool _isLoading = false;
  bool purchased = false; // Initially product is not purchased

  void makePayment() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    double total = 0.0;

    // Calculate total price
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += getCurrProduct.price * value.quantity;
    });
    int price = (total * 100).toInt(); // Convert total to cents
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now()}'
      ..email = emailController.text
      ..currency = 'NGN';

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status == true) {
      message = 'Payment Successful... Ref: ${response.reference}';
      setState(() {
        purchased = true;
      });

      if (mounted) {}
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => _checkout(ctx: context)),
          ModalRoute.withName('/'));
    } else {
      print(response.message);
    }
  }

  void purchaseProduct() {
    makePayment();
  }

  String? _email;
  String? address;
  final User? user = FirebaseAuth.instance.currentUser;

  // method to fetch user data from firebase
  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // To create errorDialog method
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    double total = 0.0;

    // Calculate total price
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += getCurrProduct.price * value.quantity;
    });
    Widget finishButton = InkWell(
      onTap: () {
        makePayment();
        User? user = FirebaseAuth.instance.currentUser;
        final orderId = const Uuid().v4();
        final productProvider =
            Provider.of<ProductsProvider>(context, listen: false);
        final ordersProvider = Provider.of<OrdersProvider>(context);
        cartProvider.getCartItems.forEach((key, value) async {
          final getCurrProduct = productProvider.findProdById(
            value.productId,
          );
          try {
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(orderId)
                .set({
              'orderId': orderId,
              'userId': user!.uid,
              'productId': value.productId,
              'price': (getCurrProduct.price) * value.quantity,
              'totalPrice': total,
              'quantity': value.quantity,
              'imageUrl': getCurrProduct.imageUrl,
              'userName': user.displayName,
              'orderDate': Timestamp.now(),
            });
            await cartProvider.clearOnlineCart();
            cartProvider.clearLocalCart();
            ordersProvider.fetchOrders();
            await Fluttertoast.showToast(
              msg: "Your order has been placed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
          } catch (error) {
            GlobalMethods.errorDialog(
                subtitle: error.toString(), context: context);
          } finally {}
        });
      },
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: Text("Finish",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Flat Number/House Number'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Street'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.orange, width: 2)),
                        color: Colors.orange[100],
                      ),
                      child: TextFormField(
                        controller: emailController..text = _email.toString(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the email';
                          }
                          return _email;
                        },
                        decoration: const InputDecoration(
                            hintText: 'example@gmail.com',
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            enabled: false),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: amountController..text = total.toString(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      prefix: Text('NGN'),
                      hintText: '1000',
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      enabled: false),
                ),
              ),
            ],
          ),
          Center(child: finishButton)
        ],
      ),
    );
  }

  Widget _checkout({required BuildContext ctx}) {
    final cartProvider = Provider.of<CartProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0.0;

    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 180,
        ),
        Icon(
          Icons.task_alt_outlined,
          size: 250,
          color: Colors.green,
        ),
        SizedBox(
          height: 80,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  final orderId = const Uuid().v4();
                  final productProvider =
                      Provider.of<ProductsProvider>(ctx, listen: false);
                  // payment method here

                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrProduct = productProvider.findProdById(
                      value.productId,
                    );
                    try {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getCurrProduct.price) * value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getCurrProduct.imageUrl,
                        'userName': user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                      ordersProvider.fetchOrders();
                      await Fluttertoast.showToast(
                        msg: "Your order has been placed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => MainPage()));
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: error.toString(), context: ctx);
                    } finally {}
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                    text: 'Click to Complete Payment',
                    textSize: 20,
                    color: Colors.white,
                  ),
                ),
              ))
        ])
      ],
    ));
  }
}
