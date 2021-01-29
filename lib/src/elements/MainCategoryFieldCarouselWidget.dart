import 'package:flutter/material.dart';

import '../elements/CardsCarouselLoaderWidget.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
// import 'CardWidget.dart';
import 'MainCategoryFieldCarouselItemWidget.dart';

// ignore: must_be_immutable
class MarketCarouselWidget extends StatefulWidget {
  List<Market> marketsList;
  String heroTag;

  MarketCarouselWidget({Key key, this.marketsList, this.heroTag}) : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<MarketCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.marketsList.isEmpty
        ? Container(
      height: 700,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 292,
            margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 5)),
              ],
            ),
            child: Image.asset(
              'assets/img/loading_card.gif',
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    )
        : Container(
      height: 700,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.marketsList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/Details',
                  arguments: RouteArgument(
                    id: '0',
                    param: widget.marketsList.elementAt(index).id,
                    heroTag: widget.heroTag,
                  ));
            },
            child: MarketCardWidget(market: widget.marketsList.elementAt(index), heroTag: widget.heroTag),
          );
        },
      ),
    );
  }
}
