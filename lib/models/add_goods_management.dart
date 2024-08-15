class AddGoodsManagement {
  AddGoodsManagement({
    required this.table,
  });

  List<dynamic> table;

  factory AddGoodsManagement.fromJson(Map<String, dynamic> json) => AddGoodsManagement(
        table: List<dynamic>.from(json["table"]),
      );

  Map<String, dynamic> toJson() => {
        "table": List<dynamic>.from(table.map((x) => x)),
      };
}
