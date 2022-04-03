import 'package:SomanyHIL/mixin/e_dimension.dart';
import 'package:SomanyHIL/model/product_catalog.dart';
import 'package:SomanyHIL/utils/constants.dart';
import 'package:SomanyHIL/utils/inspection_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../rest/eightfolds_retrofit.dart';
import '../style/text_style.dart';

class ProductCard extends StatefulWidget {
  @override
  _ProductCardState createState() => _ProductCardState();

  final ProductCatalog item;
  final Function onTap;

  ProductCard(
    this.item,
    this.onTap,
  );
}

class _ProductCardState extends State<ProductCard> with EDimension {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String url = "";
    if (widget.item.imageId != null && widget.item.imageId.isNotEmpty) {
      url = EightFoldsRetrofit.GET_FILE_URL + widget.item.imageId;
    } else {
      url = EightFoldsRetrofit.GET_FILE_URL;
    }
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: getWidthAsPerScreenRatio(context, 100),
          child: Column(
            children: [
              Card(
                elevation: 0,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Container(
                  width: 90,
                  height: 90,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: const Color(0xff00538E))),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          width: 54,
                          height: 54,
                          imageUrl: url,
                          fit: BoxFit.cover,
                          // placeholder: (context, url) => Image(
                          //     height: 54,
                          //     width: 54,
                          //     fit: BoxFit.cover,
                          //     image: AssetImage(Constants.product_default)),
                          errorWidget: (context, url, error) => Image(
                              height: 54,
                              width: 54,
                              fit: BoxFit.cover,
                              image: AssetImage(Constants.product_default)),
                        ),
                      ),
                      if ((InspectionUtils()
                                  ?.getInspactionByProductCatalogId(
                                      widget.item.productCatalogId)
                                  ?.length ??
                              0) !=
                          0)
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.fromLTRB(2, 2, 4, 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF5A442)),
                            child: Text(
                              "${InspectionUtils()?.getInspactionByProductCatalogId(widget.item.productCatalogId)?.length ?? 0}",
                              style: AppTextStyle.blackRubik12
                                  .copyWith(fontSize: 8, color: Colors.white),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Expanded(
                  child: Text(
                widget.item.productName ?? '',
                style: AppTextStyle.blackRubik12,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
