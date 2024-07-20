class Team {
  Team({
    this.yorgNummer,
    this.yorgNamebspr,
    this.ypasdefNamebspr,
    this.ypasdefNummer,
    this.ypasdefBezeich,
    this.id,
    this.nummer,
    this.such,
  });

  String? yorgNummer;
  String? yorgNamebspr;
  String? ypasdefNamebspr;
  String? ypasdefNummer;
  String? ypasdefBezeich;
  String? id;
  String? nummer;
  String? such;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        yorgNummer: json["yorg^nummer"],
        yorgNamebspr: json["yorg^namebspr"],
        ypasdefNamebspr: json["ypasdef^namebspr"],
        ypasdefNummer: json["ypasdef^nummer"],
        ypasdefBezeich: json["ypasdef^bezeich"],
        id: json["id"],
        nummer: json["nummer"],
        such: json["such"],
      );

  Map<String, dynamic> toJson() => {
        "yorg^nummer": yorgNummer,
        "yorg^namebspr": yorgNamebspr,
        "ypasdef^namebspr": ypasdefNamebspr,
        "ypasdef^nummer": ypasdefNummer,
        "ypasdef^bezeich": ypasdefBezeich,
        "id": id,
        "nummer": nummer,
        "such": such,
      };
}
