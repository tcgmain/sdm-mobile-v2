class Bdnotification {
  Bdnotification(
    {
      this.yterritoryNummer,
      this.yowname,
      this.yorgowndob,
      this.such,
      this.id,
      this.nummer,
      this.namebspr,
      this.yphone1,
      this.yphone2,
      this.ywhtapp,
    }
  );

  String? yterritoryNummer;
  String? yowname;
  String? yorgowndob;
  String? such;
  String? id;
  String? nummer;
  String? namebspr;
  String? yphone1;
  String? yphone2;
  String? ywhtapp;

  factory Bdnotification.fromJson(Map<String, dynamic> json) {
    return Bdnotification(
      yterritoryNummer: json["yterritory^nummer"],
      yowname: json["yowname"],
      yorgowndob: json["yorgowndob"],
      such: json["such"],
      id: json["id"],
      nummer: json["nummer"],
      namebspr: json["namebspr"],
      yphone1: json["yphone1"],
      yphone2: json["yphone2"],
      ywhtapp: json["ywhtapp"],
     );
  }

  Map<String, dynamic> toJson() => {
    "yterritory^nummer": yterritoryNummer,
    "yowname": yowname,
    "yorgowndob": yorgowndob,
    "such": such,
    "id": id,
    "nummer": nummer,
    "namebspr": namebspr,
    "yphone1": yphone1,
    "yphone2": yphone2,
    "ywhtapp": ywhtapp
  };
 
}