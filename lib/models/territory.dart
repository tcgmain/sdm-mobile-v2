class Territory {
  Territory({
    this.such,
    this.ytterritoryNummer,
    this.id,
    this.nummer,
    this.ytterritoryNamebspr,
    this.ytterritorySuch,
  });

  String? such;
  String? ytterritoryNummer;
  String? id;
  String? nummer;
  String? ytterritoryNamebspr;
  String? ytterritorySuch;

  factory Territory.fromJson(Map<String, dynamic> json) => Territory(
        such: json["such"],
        ytterritoryNummer: json["ytterritory^nummer"],
        id: json["id"],
        nummer: json["nummer"],
        ytterritoryNamebspr: json["ytterritory^namebspr"],
        ytterritorySuch: json["ytterritory^such"],
      );

  Map<String, dynamic> toJson() => {
        "such": such,
        "ytterritory^nummer": ytterritoryNummer,
        "id": id,
        "nummer": nummer,
        "ytterritory^namebspr": ytterritoryNamebspr,
        "ytterritory^such": ytterritorySuch,
      };
}
