import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:payment/app_properties.dart';
import 'package:payment/services/custom_background.dart';
import 'package:provider/provider.dart';

import '../consts/contss.dart';
import '../inner_screens/feeds_search_screen.dart';
import '../inner_screens/on_sale_screen.dart';
import '../model/products_model.dart';
import '../providers/products_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/feed_items.dart';
import '../widgets/on_sale_widget.dart';
import '../widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    Size size = utils.getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    return Scaffold(
      backgroundColor: mediumYellow,
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: MainBackground(),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.33,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        Constss.offerImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                    autoplay: true,
                    itemCount: Constss.offerImages.length,
                    pagination: const SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.white, activeColor: Colors.red)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Discounts',
                      color: Colors.red,
                      textSize: 22,
                      isTitle: true,
                    ),
                    // const Spacer(),
                    TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: OnSaleScreen.routeName);
                      },
                      child: TextWidget(
                        text: 'View all',
                        maxLines: 1,
                        color: Colors.blue,
                        textSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: SizedBox(
                      height: size.height * 0.24,
                      child: ListView.builder(
                          itemCount: productsOnSale.length < 10
                              ? productsOnSale.length
                              : 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            return ChangeNotifierProvider.value(
                                value: productsOnSale[index],
                                child: const OnSaleWidget());
                          }),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Yummy Meals',
                      color: Colors.redAccent,
                      textSize: 22,
                      isTitle: true,
                    ),
                    // const Spacer(),
                    TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: FeedsSearchScreen.routeName);
                      },
                      child: TextWidget(
                        text: 'Browse all',
                        maxLines: 1,
                        color: Colors.blue,
                        textSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                childAspectRatio: size.width / (size.height * 0.73),
                children: List.generate(
                    allProducts.length < 4
                        ? allProducts.length // length 3
                        : 4, (index) {
                  return ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child: const FeedsItems(),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
