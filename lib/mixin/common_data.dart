import 'dart:convert';

import 'package:SomanyHIL/model/product_catalog.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/utils.dart';

mixin CommonData {
  Future<ProductCatalog> getProductCatalogByCatalogId(
      String productCatalogId) async {
    var value = await Utils.getFromSharedPraferances(Constants.PRODUCTS);
    var tagsJson = jsonDecode(value) as List;
    List<ProductCatalog> productCatalogs =
        tagsJson.map((tagJson) => ProductCatalog.fromJson(tagJson)).toList();
    return productCatalogs
        .firstWhere((element) => element.productCatalogId == productCatalogId);
  }
}
