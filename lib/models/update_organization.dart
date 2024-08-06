class UpdateOrganization {
  UpdateOrganization(
      {required this.id,
      required this.yphone1,
      required this.yphone2,
      required this.ycustyp,
      required this.nummer,
      required this.yaddressl3,
      required this.yaddressl4,
      required this.yaddressl1,
      required this.yaddressl2,
      required this.table,
      required this.yemail,
      required this.yowname,
      required this.ymasonry,
      required this.ywaterpr,
      required this.yflooring,
      required this.yorgapp,
      required this.yselcolour
      });

  String id;
  String yphone1;
  String yphone2;
  String ycustyp;
  String nummer;
  String yaddressl3;
  String yaddressl4;
  String yaddressl1;
  String yaddressl2;
  List<dynamic> table;
  String yemail;
  String yowname;
  bool ymasonry;
  bool ywaterpr;
  bool yflooring;
  bool yorgapp;
  String yselcolour;

  factory UpdateOrganization.fromJson(Map<String, dynamic> json) => UpdateOrganization(
        id: json["id"] ?? "",
        yphone1: json["yphone1"] ?? "",
        yphone2: json["yphone2"] ?? "",
        ycustyp: json["ycustyp"] ?? "",
        nummer: json["nummer"] ?? "",
        yaddressl3: json["yaddressl3"] ?? "",
        yaddressl4: json["yaddressl4"] ?? "",
        yaddressl1: json["yaddressl1"] ?? "",
        yaddressl2: json["yaddressl2"] ?? "",
        table: json["table"] != null ? List<dynamic>.from(json["table"]) : [],
        yemail: json["yemail"] ?? "",
        yowname: json["yowname"] ?? "",
        ymasonry: json["ymasonry"] ?? false,
        ywaterpr: json["ywaterpr"] ?? false,
        yflooring: json["yflooring"] ?? false,
        yorgapp: json["yorgapp"] ?? false,
        yselcolour: json["yselcolour"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "yphone1": yphone1,
        "yphone2": yphone2,
        "ycustyp": ycustyp,
        "nummer": nummer,
        "yaddressl3": yaddressl3,
        "yaddressl4": yaddressl4,
        "yaddressl1": yaddressl1,
        "yaddressl2": yaddressl2,
        "table": List<dynamic>.from(table.map((x) => x)),
        "yemail": yemail,
        "yowname": yowname,
        "ymasonry": ymasonry,
        "ywaterpr": ywaterpr,
        "yflooring": yflooring,
        "yorgapp": yorgapp,
        "yselcolour": yselcolour,
      };
}
