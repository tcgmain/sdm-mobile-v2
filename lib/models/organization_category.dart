class OrganizationCategory {
  OrganizationCategory({
    this.zid,
    this.namebspr,
    this.aebez,
    this.vaufzelemNummer,
    this.vaufzelemId,
    this.id,
    this.nummer,
  });

  String? zid;
  String? namebspr;
  String? aebez;
  String? vaufzelemNummer;
  String? vaufzelemId;
  String? id;
  String? nummer;

  factory OrganizationCategory.fromJson(Map<String, dynamic> json) => OrganizationCategory(
        zid: json["id"],
        namebspr: json["namebspr"],
        aebez: json["aebez"],
        vaufzelemNummer: json["vaufzelem^nummer"],
        vaufzelemId: json["vaufzelem^id"],
        id: json["id"],
        nummer: json["nummer"],
      );

  Map<String, dynamic> toJson() => {
        "zid": zid,
        "namebspr": namebspr,
        "aebez": aebez,
        "vaufzelem^nummer": vaufzelemNummer,
        "vaufzelem^id": vaufzelemId,
        "id": id,
        "nummer": nummer,
      };
}