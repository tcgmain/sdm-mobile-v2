class ChangePassword {
  ChangePassword({
    required this.table,
  });

  List<dynamic> table;

  factory ChangePassword.fromJson(Map<String, dynamic> json) => ChangePassword(
        table: List<dynamic>.from(json["table"]),
      );

  Map<String, dynamic> toJson() => {
        "table": List<dynamic>.from(table.map((x) => x)),
      };
}