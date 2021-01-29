import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/field.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class MainCategoriesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Field maincategory;
  MainCategoriesCarouselItemWidget({Key key, this.marginLeft, this.maincategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/MainCategory', arguments: RouteArgument(id: maincategory.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:10, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: maincategory.name,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(image: NetworkImage(maincategory.image.thumb), fit: BoxFit.contain),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsetsDirectional.only(start: 0, end: 20),
                child: Text('  '+
                  maincategory.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
            )
          ],
        ),
      ),
    );
  }
}
