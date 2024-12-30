class Town {
  Town({
    this.such,
    this.zid,
    this.namebspr,
    this.ytsublocNamebspr,
    this.ytsublocNummer,
    this.ytsublocSuch,
    this.id,
    this.nummer,
  });

  String? such;
  String? zid;
  String? namebspr;
  String? ytsublocNamebspr;
  String? ytsublocNummer;
  String? ytsublocSuch;
  String? id;
  String? nummer;

  factory Town.fromJson(Map<String, dynamic> json) => Town(
        such: json["such"],
        zid: json["zid"],
        namebspr: json["namebspr"],
        ytsublocNamebspr: json["ytsubloc^namebspr"],
        ytsublocNummer: json["ytsubloc^nummer"],
        ytsublocSuch: json["ytsubloc^such"],
        id: json["id"],
        nummer: json["nummer"],
      );

  Map<String, dynamic> toJson() => {
        "such": such,
        "zid": zid,
        "namebspr": namebspr,
        "ytsubloc^namebspr": ytsublocNamebspr,
        "ytsubloc^nummer": ytsublocNummer,
        "ytsubloc^such": ytsublocSuch,
        "id": id,
        "nummer": nummer,
      };
}
