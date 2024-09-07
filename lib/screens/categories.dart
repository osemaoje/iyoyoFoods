import 'package:flutter/material.dart';

import '../services/utils.dart';
import '../widgets/categories_widget.dart';
import '../widgets/text_widget.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
    const Color(0xff53B1D5),
    const Color(0xff53D100),
  ];

  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/iyoyo/foods.png',
      'catText': 'Food',
    },
    {
      'imgPath': 'assets/iyoyo/drinks.png',
      'catText': 'Drinks',
    },
    {
      'imgPath': 'assets/iyoyo/protein.png',
      'catText': 'Protein',
    },
    {
      'imgPath': 'assets/iyoyo/icecream.png',
      'catText': 'Ice Cream',
    },
    {
      'imgPath': 'assets/iyoyo/snacks.png',
      'catText': 'Snacks',
    },
    {
      'imgPath': 'assets/iyoyo/foods.png',
      'catText': 'Food',
    },
    {
      'imgPath': 'assets/iyoyo/drinks.png',
      'catText': 'Drinks',
    },
    {
      'imgPath': 'assets/iyoyo/snacks.png',
      'catText': 'Snacks',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Categories',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 200,
            crossAxisSpacing: 10,
            // Vertical spacing
            mainAxisSpacing: 10,
            // Horizontal spacing
            children: List.generate(8, (index) {
              return CategoriesWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                passedColor: gridColors[index],
              );
            }),
          ),
        ));
  }
}
