class MarkVisit {
  MarkVisit({
    required this.such,
    required this.yorg,
    required this.yvrout,
    required this.yvdat,
    required this.yvtim,
    required this.nummer,
    required this.ysdmempv,
    required this.table,
  });

  String such;
  String yorg;
  String yvrout;
  String yvdat;
  String yvtim;
  String nummer;
  String ysdmempv;
  List<dynamic> table;

  factory MarkVisit.fromJson(Map<String, dynamic> json) => MarkVisit(
        such: json["such"],
        yorg: json["yorg"],
        yvrout: json["yvrout"],
        yvdat: json["yvdat"],
        yvtim: json["yvtim"],
        nummer: json["nummer"],
        ysdmempv: json["ysdmempv"],
        table: List<dynamic>.from(json["table"]),
      );

  Map<String, dynamic> toJson() => {
        "such": such,
        "yorg": yorg,
        "yvrout": yvrout,
        "yvdat": yvdat,
        "yvtim": yvtim,
        "nummer": nummer,
        "ysdmempv": ysdmempv,
        "table": List<dynamic>.from(table.map((x) => x)),
      };
}
