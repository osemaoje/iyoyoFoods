import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:payment/services/custom_background.dart';
import 'package:provider/provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../services/utils.dart';
import '../../../widgets/empty_screen.dart';
import '../../../widgets/text_widget.dart';
import 'orders_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ordersList.isEmpty
              ? const EmptyScreen(
                  title: 'You haven\'t ordered any Food',
                  subtitle: 'Click for Yummy Meals',
                  buttonText: 'Let\'s Go',
                  imagePath: 'assets/iyoyo/emptycart.png',
                )
              : Scaffold(
                  appBar: AppBar(
                    leading: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        IconlyLight.arrowLeft2,
                        color: color,
                      ),
                    ),
                    elevation: 0,
                    centerTitle: false,
                    title: TextWidget(
                      text: 'Your orders (${ordersList.length})',
                      color: color,
                      textSize: 24.0,
                      isTitle: true,
                    ),
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                  ),
                  body: ListView.separated(
                    itemCount: ordersList.length,
                    itemBuilder: (ctx, index) {
                      return CustomPaint(
                        painter: MainBackground(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 6),
                          child: ChangeNotifierProvider.value(
                            value: ordersList[index],
                            child: const OrderWidget(),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: color,
                        thickness: 1,
                      );
                    },
                  ));
        });
  }
}
