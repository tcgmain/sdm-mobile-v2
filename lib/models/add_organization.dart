class AddOrganization {
  AddOrganization({
    required this.yphone1,
    required this.yphone2,
    required this.namebspr,
    required this.ycustyp,
    required this.yassigto,
    required this.nummer,
    required this.ygpslon,
    required this.such,
    required this.yaddressl3,
    required this.yaddressl4,
    required this.yaddressl1,
    required this.yaddressl2,
    required this.ygpslat,
    required this.table,
    required this.yemail,
    required this.yvisdis,
    required this.ymasonry,
    required this.ywaterpr,
    required this.yflooring,
    required this.yselcolour
  });

  String yphone1;
  String yphone2;
  String namebspr;
  String ycustyp;
  String yassigto;
  String nummer;
  String ygpslon;
  String such;
  String yaddressl3;
  String yaddressl4;
  String yaddressl1;
  String yaddressl2;
  String ygpslat;
  List<dynamic> table;
  String yemail;
  int yvisdis;
  bool ymasonry;
  bool ywaterpr;
  bool yflooring;
  String yselcolour;

  factory AddOrganization.fromJson(Map<String, dynamic> json) => AddOrganization(
        yphone1: json["yphone1"],
        yphone2: json["yphone2"],
        namebspr: json["namebspr"],
        ycustyp: json["ycustyp"],
        yassigto: json["yassigto"],
        nummer: json["nummer"],
        ygpslon: json["ygpslon"],
        such: json["such"],
        yaddressl3: json["yaddressl3"],
        yaddressl4: json["yaddressl4"],
        yaddressl1: json["yaddressl1"],
        yaddressl2: json["yaddressl2"],
        ygpslat: json["ygpslat"],
        table: List<dynamic>.from(json["table"]),
        yemail: json["yemail"],
        yvisdis: json["yvisdis"],
        ymasonry: json["ymasonry"],
        ywaterpr: json["ywaterpr"],
        yflooring: json["yflooring"],
        yselcolour: json["yselcolour"],
      );

  Map<String, dynamic> toJson() => {
        "yphone1": yphone1,
        "yphone2": yphone2,
        "namebspr": namebspr,
        "ycustyp": ycustyp,
        "yassigto": yassigto,
        "nummer": nummer,
        "ygpslon": ygpslon,
        "such": such,
        "yaddressl3": yaddressl3,
        "yaddressl4": yaddressl4,
        "yaddressl1": yaddressl1,
        "yaddressl2": yaddressl2,
        "ygpslat": ygpslat,
        "table": List<dynamic>.from(table.map((x) => x)),
        "yemail": yemail,
        "yvisdis": yvisdis,
        "ymasonry": ymasonry,
        "ywaterpr": ywaterpr,
        "yflooring": yflooring,
        "yselcolour": yselcolour,
      };
}
