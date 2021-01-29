import 'package:flutter/material.dart';
import 'package:markets/src/models/field.dart';

import '../elements/MainCategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class MainCategoriesCarouselWidget extends StatelessWidget {
  List<Field> maincategories;

  MainCategoriesCarouselWidget({Key key, this.maincategories}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return this.maincategories.isEmpty
        ? CircularLoadingWidget(height: 100)
        // : Container(
        //     height: 150,
        //     padding: EdgeInsets.symmetric(vertical: 10),
        //     child: ListView.separated(
        //       itemCount: this.maincategories.length,
        //       scrollDirection: Axis.vertical,
        //       shrinkWrap: true,
        //       primary: false,
        //       separatorBuilder: (context, index) {
        //         return SizedBox(height: 10);
        //       },
        //       itemBuilder: (context, index) {
        //         double _marginLeft = 0;
        //         (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
        //         return new MainCategoriesCarouselItemWidget(
        //           marginLeft: _marginLeft,
        //           maincategory: this.maincategories.elementAt(index),
        //         );
        //       },
        //     ));
    :GridView.count(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      childAspectRatio: (15/ 18),
      crossAxisSpacing: 10,
      mainAxisSpacing: 20,
      padding: EdgeInsets.symmetric(horizontal: 1),
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 3 :1,
      children: List.generate(6, (index) {
        return new MainCategoriesCarouselItemWidget(
                      maincategory: this.maincategories.elementAt(index),
                    );
      }),
    );

  }
}
