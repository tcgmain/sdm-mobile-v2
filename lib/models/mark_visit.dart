class MarkVisit {
  MarkVisit({
    required this.table,
  });

  List<dynamic> table;

  factory MarkVisit.fromJson(Map<String, dynamic> json) => MarkVisit(
        table: List<dynamic>.from(json["table"]),
      );

  Map<String, dynamic> toJson() => {
        "table": List<dynamic>.from(table.map((x) => x)),
      };
}
