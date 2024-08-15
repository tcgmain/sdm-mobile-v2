class CreateSO {
  CreateSO({
    required this.nummer,
    required this.such,
    required this.ysdemp,
    required this.ysdorg,
    required this.ydat,
    required this.ysdorgorfr,
    required this.table,
  });

  String nummer;
  String such;
  String ysdemp;
  String ysdorg;
  String ydat;
  String ysdorgorfr;
  List<Table> table;

  factory CreateSO.fromJson(Map<String, dynamic> json) => CreateSO(
        nummer: json["nummer"],
        such: json["such"],
        ysdemp: json["ysdemp"],
        ysdorg: json["ysdorg"],
        ydat: json["ydat"],
        ysdorgorfr: json["ysdorgorfr"],
        table: List<Table>.from(json["table"].map((x) => Table.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nummer": nummer,
        "such": such,
        "ysdemp": ysdemp,
        "ysdorg": ysdorg,
        "ydat": ydat,
        "ysdorgorfr": ysdorgorfr,
        "table": List<dynamic>.from(table.map((x) => x.toJson())),
      };
}

class Table {
  Table({
    required this.yqty,
    required this.yprod,
  });

  double yqty;
  String yprod;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        yqty: json["yqty"].toDouble(),
        yprod: json["yprod"],
      );

  Map<String, dynamic> toJson() => {
        "yqty": yqty,
        "yprod": yprod,
      };
}
