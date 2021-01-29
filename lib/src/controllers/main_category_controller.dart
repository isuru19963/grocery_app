import 'package:flutter/cupertino.dart';
import 'package:markets/src/models/field.dart';
import 'package:markets/src/repository/field_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/slide.dart';
import '../repository/category_repository.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/slider_repository.dart';
import 'package:flutter/material.dart';
class MainCategoryController extends ControllerMVC {
  List<Market> allMarkets = <Market>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  MainCategoryController() {
    listenForALlMarkets();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<void> listenForALlMarkets() async {
    final Stream<Market> stream = await getAllMarkets(deliveryAddress.value, deliveryAddress.value);
    stream.listen((Market _market) {
      setState(() => allMarkets.add(_market));
    }, onError: (a) {}, onDone: () {});
  }


  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome() async {
    setState(() {
      allMarkets = <Market>[];
    });
    await listenForALlMarkets();
  }
  Future<void> refreshCategory() async {
    allMarkets.clear();
  }
}
