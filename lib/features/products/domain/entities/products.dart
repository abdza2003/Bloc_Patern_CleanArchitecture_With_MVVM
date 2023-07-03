class Product {
  var id;
  var name;
  var barcode;
  var image;
  var description;
  var price;
  var modelType;
  var modelId;
  var createdAt;
  var updatedAt;
  var showOnMobile;
  dynamic quantity;
  bool selected = false;
  var isMarket = "true";
  bool? isAvailableToBook;
  RestaurantDatedProduct? restaurantDatedProduct;

  Product(
      {this.id,
      this.name,
      this.barcode,
      this.image,
      this.description,
      this.price,
      this.modelType,
      this.modelId,
      this.createdAt,
      this.updatedAt,
      this.showOnMobile,
      this.quantity,
      this.isAvailableToBook,
      this.restaurantDatedProduct});
}

class RestaurantDatedProduct {
  var id;
  var availableQuantity;
  var availableDate;
  var productId;
  var createdAt;
  var updatedAt;
  var dayName;
  dynamic dayId;

  RestaurantDatedProduct(
      {this.id,
      this.availableQuantity,
      this.availableDate,
      this.productId,
      this.createdAt,
      this.updatedAt,
      this.dayName,
      this.dayId});

  RestaurantDatedProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    availableQuantity = json['available_quantity'];
    availableDate = json['available_date'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dayName = json['day_name'];
    dayId = json['day_id'];
  }
}
