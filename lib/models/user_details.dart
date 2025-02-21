class UserDetails {
  UserDetails({
    this.ynic,
    this.email,
    this.str,
    this.yusrloc,
    this.ydes,
    this.bezeich,
    this.ydepcodelNamebspr,
    this.nummer,
    this.namebspr,
    this.yepf,
    this.id,
    this.ydepcodel,
    this.yhrisid,
    this.yorgNummer,
    this.designationNummer,
    this.yenableupdatelocationpermission,
    this.ytterritoryNummer,
  });

  String? ynic;
  String? email;
  String? str;
  String? yusrloc;
  String? ydes;
  String? bezeich;
  String? ydepcodelNamebspr;
  String? nummer;
  String? namebspr;
  String? yepf;
  String? id;
  String? ydepcodel;
  String? yhrisid;
  String? yorgNummer;
  String? designationNummer;
  bool? yenableupdatelocationpermission;
  String? ytterritoryNummer;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
      ynic: json["ypasdef^passmitarb^ynic"],
      email: json["ypasdef^passmitarb^email"],
      str: json["ypasdef^passmitarb^str"],
      yusrloc: json["ypasdef^yusrloc^namebspr"],
      ydes: json["ypasdef^passmitarb^ydes"],
      bezeich: json["ypasdef^bezeich"],
      ydepcodelNamebspr: json["ypasdef^passmitarb^ydepcodel^namebspr"],
      nummer: json["nummer"],
      namebspr: json["ypasdef^namebspr"],
      yepf: json["ypasdef^passmitarb^yepf"],
      id: json["id"],
      ydepcodel: json["ypasdef^passmitarb^ydepcodel"],
      yhrisid: json["ypasdef^passmitarb^yhrisid"],
      yorgNummer: json["yorg^nummer"],
      designationNummer: json["ypasdef^passmitarb^ytitle^nummer"],
      yenableupdatelocationpermission: json["yenableupdatelocationpermission"],
      ytterritoryNummer: json["ytterritory^nummer"]);

  Map<String, dynamic> toJson() => {
        "ypasdef^passmitarb^ynic": ynic,
        "ypasdef^passmitarb^email": email,
        "ypasdef^passmitarb^str": str,
        "ypasdef^yusrloc^namebspr": yusrloc,
        "ypasdef^passmitarb^ydes": ydes,
        "ypasdef^bezeich": bezeich,
        "ypasdef^passmitarb^ydepcodel^namebspr": ydepcodelNamebspr,
        "nummer": nummer,
        "ypasdef^namebspr": namebspr,
        "ypasdef^passmitarb^yepf": yepf,
        "id": id,
        "ypasdef^passmitarb^ydepcodel": ydepcodel,
        "ypasdef^passmitarb^yhrisid": yhrisid,
        "yorg^nummer": yorgNummer,
        "ypasdef^passmitarb^ytitle^nummer": designationNummer,
        "yenableupdatelocationpermission": yenableupdatelocationpermission,
        "ytterritory^nummer": ytterritoryNummer,
      };
}