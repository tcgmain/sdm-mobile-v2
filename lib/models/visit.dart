class Visit {
  Visit({
    this.yorgNummer,
    this.yorgNamebspr,
    this.ysdmempvNummer,
    this.ysdmempvSuch,
    this.yvdat,
    this.id,
    this.yvroutNamebspr,
    this.yvtim,
    this.nummer,
  });

  String? yorgNummer;
  String? yorgNamebspr;
  String? ysdmempvNummer;
  String? ysdmempvSuch;
  String? yvdat;
  String? id;
  String? yvroutNamebspr;
  String? yvtim;
  String? nummer;

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
        yorgNummer: json["yorg^nummer"],
        yorgNamebspr: json["yorg^namebspr"],
        ysdmempvNummer: json["ysdmempv^nummer"],
        ysdmempvSuch: json["ysdmempv^such"],
        yvdat: json["yvdat"],
        id: json["id"],
        yvroutNamebspr: json["yvroutNamebspr"],
        yvtim: json["yvtim"],
        nummer: json["nummer"],
      );

  Map<String, dynamic> toJson() => {
        "yorg^nummer": yorgNummer,
        "yorg^namebspr": yorgNamebspr,
        "ysdmempv^nummer": ysdmempvNummer,
        "ysdmempv^such": ysdmempvSuch,
        "yvdat": yvdat,
        "id": id,
        "yvrout^namebspr": yvroutNamebspr,
        "yvtim": yvtim,
        "nummer": nummer,
      };
}
