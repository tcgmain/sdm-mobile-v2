class AddOrganization {
  AddOrganization({
    required this.table,
  });

  List<dynamic> table;

  factory AddOrganization.fromJson(Map<String, dynamic> json) => AddOrganization(
        table: List<dynamic>.from(json["table"]),
      );

  Map<String, dynamic> toJson() => {
        "table": List<dynamic>.from(table.map((x) => x)),
      };
}
