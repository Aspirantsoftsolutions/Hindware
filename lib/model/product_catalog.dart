class ProductCatalog {
  String createdTime;
  bool deleted;
  String imageId;
  String modifiedTime;
  int order;
  String productCatalogId;
  String productName;

  ProductCatalog(
      {this.createdTime,
      this.deleted,
      this.imageId,
      this.modifiedTime,
      this.order,
      this.productCatalogId,
      this.productName});

  ProductCatalog.fromJson(Map<String, dynamic> json) {
    createdTime = json['createdTime'];
    deleted = json['deleted'];
    imageId = json['imageId'];
    modifiedTime = json['modifiedTime'];
    order = json['order'];
    productCatalogId = json['productCatalogId'];
    productName = json['productName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdTime'] = this.createdTime;
    data['deleted'] = this.deleted;
    data['imageId'] = this.imageId;
    data['modifiedTime'] = this.modifiedTime;
    data['order'] = this.order;
    data['productCatalogId'] = this.productCatalogId;
    data['productName'] = this.productName;
    return data;
  }
}
