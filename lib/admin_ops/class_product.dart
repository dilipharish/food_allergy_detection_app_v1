class Product {
  int productId;
  String productBarcode;
  String productName;
  String sugarContent;
  String preservativesContent;
  String oilsContent;
  String fatsContent;
  bool palmOil;
  String saltContent;
  String otherAllergy;

  Product({
    required this.productId,
    required this.productBarcode,
    required this.productName,
    required this.sugarContent,
    required this.preservativesContent,
    required this.oilsContent,
    required this.fatsContent,
    required this.palmOil,
    required this.saltContent,
    required this.otherAllergy,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        productId: map['product_id'],
        productBarcode: map['product_barcode'],
        productName: map['product_name'],
        sugarContent: map['sugar_content'],
        preservativesContent: map['preservatives_content'],
        oilsContent: map['oils_content'],
        fatsContent: map['fats_content'],
        palmOil:
            map['palm_oil'] is bool ? map['palm_oil'] : map['palm_oil'] == 1,
        saltContent: map['salt_content'],
        otherAllergy: map['otherallergy'].toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_barcode': productBarcode,
      'product_name': productName,
      'sugar_content': sugarContent,
      'preservatives_content': preservativesContent,
      'oils_content': oilsContent,
      'fats_content': fatsContent,
      'palm_oil': palmOil,
      'salt_content': saltContent,
      'otherallergy': otherAllergy,
    };
  }
}
