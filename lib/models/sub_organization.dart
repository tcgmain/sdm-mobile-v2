class SubOrganization {
  SubOrganization(
      {this.ysuporgNamebspr,
      this.namebspr,
      this.yassigtoNamebspr,
      this.yassigtoNummer,
      this.id,
      this.nummer,
      this.ysuporgNummer
    });

  String? ysuporgNamebspr;
  String? namebspr;
  String? yassigtoNamebspr;
  String? yassigtoNummer;
  String? id;
  String? nummer;
  String? ysuporgNummer;

  factory SubOrganization.fromJson(Map<String, dynamic> json) => SubOrganization(
        ysuporgNamebspr: json["ysuporg^namebspr"],
        namebspr: json["namebspr"],
        yassigtoNamebspr: json["yassigto^namebspr"],
        yassigtoNummer: json["yassigto^nummer"],
        id: json["id"],
        nummer: json["nummer"],
        ysuporgNummer: json["ysuporg^nummer"],
      );

  Map<String, dynamic> toJson() => {
        "ysuporg^namebspr": ysuporgNamebspr,
        "namebspr": namebspr,
        "yassigto^namebspr": yassigtoNamebspr,
        "yassigto^nummer": yassigtoNummer,
        "id": id,
        "nummer": nummer,
        "ysuporg^nummer": ysuporgNummer,
      };
}
