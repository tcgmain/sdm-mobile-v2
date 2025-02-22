class Stock {
  Stock({
    this.id,
    this.ysdmemp,
    this.ysdmorg,
    this.table,
  });

  String? id;
  String? ysdmemp;
  String? ysdmorg;
  List<Product>? table;

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json["id"],
      ysdmemp: json["ysdmemp"],
      ysdmorg: json["ysdmorg"],
      table: (json["table"] as List<dynamic>?)?.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ysdmemp": ysdmemp,
        "ysdmorg": ysdmorg,
        "table": table?.map((item) => item.toJson()).toList(),
      };
}

class Product {
  Product({
    this.yprodsuch,
    this.ycurstoc,
    this.yprodnummer,
    this.yproddesc,
    this.productbrand,
    this.yproductcategory,
    this.ylastud,
    this.ylastub,
    this.yiscompetitor
  });

  String? yprodsuch;
  double? ycurstoc;
  String? yprodnummer;
  String? yproddesc;
  String? productbrand;
  String? yproductcategory;
  String? ylastud;
  String? ylastub;
  bool? yiscompetitor;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      yprodsuch: json["yprodsuch"],
      ycurstoc: json["ycurstoc"]?.toDouble(),
      yprodnummer: json["yprodnummer"],
      yproddesc: json["yproddesc"],
      productbrand: json["productbrand"],
      yproductcategory: json["yproductcategory"],
      ylastud: json["ylastud"],
      ylastub: json["ylastub"],
      yiscompetitor: json["yiscompetitor"],
    );
  }

  Map<String, dynamic> toJson() => {
        "yprodsuch": yprodsuch,
        "ycurstoc": ycurstoc,
        "yprodnummer": yprodnummer,
        "yproddesc": yproddesc,
        "productbrand": productbrand,
        "yproductcategory": yproductcategory,
        "ylastud": ylastud,
        "ylastub": ylastub,
        "yiscompetitor": yiscompetitor,
      };
}