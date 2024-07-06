class Routes {
  Routes({
    this.sdmem,
    this.ypldate,
    this.zid,
    this.yplrouteNummer,
    this.id,
    this.yplrouteNamebspr,
  });

  String? sdmem;
  String? ypldate;
  String? zid;
  String? yplrouteNummer;
  String? id;
  String? yplrouteNamebspr;

  factory Routes.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return Routes();
    }
    return Routes(
      sdmem: json["ysdmem^such"] ?? '',
      ypldate: json["ypldate"] ?? '',
      zid: json["zid"] ?? '',
      yplrouteNummer: json["yplroute^nummer"] ?? '',
      id: json["id"] ?? '',
      yplrouteNamebspr: json["yplroute^namebspr"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "ysdmem^such": sdmem ?? '',
        "ypldate": ypldate ?? '',
        "zid": zid ?? '',
        "yplroute^nummer": yplrouteNummer ?? '',
        "id": id ?? '',
        "yplroute^namebspr": yplrouteNamebspr ?? '',
      };
}