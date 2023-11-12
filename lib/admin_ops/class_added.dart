class Added {
  int addId;
  String addBarcode;
  int demand;

  Added({
    required this.addId,
    required this.addBarcode,
    required this.demand,
  });

  factory Added.fromMap(Map<String, dynamic> map) {
    return Added(
      addId: map['add_id'],
      addBarcode: map['add_barcode'],
      demand: map['demand'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'add_id': addId,
      'add_barcode': addBarcode,
      'demand': demand,
    };
  }
}
