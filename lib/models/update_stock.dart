class UpdateStock {
  UpdateStock({
    this.id,
    this.table,
  });

  String? id;
  List<StockDetails>? table;

  factory UpdateStock.fromJson(Map<String, dynamic> json) {
    return UpdateStock(
      id: json["id"],
      table: (json["table"] as List<dynamic>?)?.map((item) => StockDetails.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "table": table?.map((item) => item.toJson()).toList(),
      };
}

class StockDetails {
  StockDetails({
    this.yuser,
    this.ycurstoc,
    this.yrecqty,
    this.yentdat,
    this.yprod,
    this.yissqty,
    this.yvis,
  });

  String? yuser;
  double? ycurstoc;
  double? yrecqty;
  String? yentdat;
  String? yprod;
  double? yissqty;
  String? yvis;

  factory StockDetails.fromJson(Map<String, dynamic> json) {
    return StockDetails(
      yuser: json["yuser"],
      ycurstoc: json["ycurstoc"]?.toDouble(),
      yrecqty: json["yrecqty"]?.toDouble(),
      yentdat: json["yentdat"],
      yprod: json["yprod"],
      yissqty: json["yissqty"]?.toDouble(),
      yvis: json["yvis"],
    );
  }

  Map<String, dynamic> toJson() => {
        "yuser": yuser,
        "ycurstoc": ycurstoc,
        "yrecqty": yrecqty,
        "yentdat": yentdat,
        "yprod": yprod,
        "yissqty": yissqty,
        "yvis": yvis,
      };
}
