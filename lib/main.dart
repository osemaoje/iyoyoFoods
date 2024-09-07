import 'package:payment/inner_screens/feeds_search_screen.dart';
import 'package:payment/screens/auth/register_page.dart';
import 'package:payment/screens/auth/welcome_back_page.dart';
import 'package:payment/screens/main/main_page.dart';
import 'package:payment/inner_screens/product/product_page.dart';
import 'package:payment/providers/cart_provider.dart';
import 'package:payment/providers/dark_theme_provider.dart';
import 'package:payment/providers/orders_provider.dart';
import 'package:payment/providers/products_provider.dart';
import 'package:payment/providers/wishlist_provider.dart';
import 'package:payment/screens/orders/orders_screen.dart';
import 'package:payment/screens/wishlist/wishlist_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'firebase_options.dart';
import 'inner_screens/category_page.dart';
import 'inner_screens/on_sale_screen.dart';
import 'screens/auth/forget_pass.dart';

// To Initialize Firebase in the main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //th5//
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  //th5//
  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    //th5//
    getCurrentAppTheme();

    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // - In main.dart file, modify the return statement in build function to
    // return a FutureBuilder instead of the Material app. FutureBuilder will
    // allow the app the perform asynchronous operations where the function will
    // return a Widget based on the result we get from that operation.
    // In our case, the operation will be the Firebase app initialization which is
    // defined in the FutureBuilder’s future property. If the app is successfully
    // initialized, it will return the Material app. If the initialization fails,
    // it will return a Text to display an error message.
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: Text('An error occured'),
              )),
            );
          }
          //th5//
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Iyoyo Foods',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  home: RegisterPage(),
                  routes: {
                    WelcomeBackPage.routeName: (ctx) => WelcomeBackPage(),
                    RegisterPage.routeName: (ctx) => RegisterPage(),
                    ForgetPasswordScreen.routeName: (ctx) =>
                        const ForgetPasswordScreen(),
                    ProductPage.routeName: (ctx) => const ProductPage(),
                    OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                    FeedsSearchScreen.routeName: (ctx) =>
                        const FeedsSearchScreen(),
                    CategoryPage.routeName: (ctx) => const CategoryPage(),
                    WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                    OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                    MainPage.routeName: (ctx) => MainPage()
                  });
            }),
          );
        });
  }
}
