class RouteOrganization {
  RouteOrganization(
      {
      this.id,
      this.nummer,
      this.namebsprRoute,
      this.namebspr,
      this.ysdmorg,
      this.ysdmorgId,
      this.orgnummer,
      this.yphone1,
      this.yphone2,
      this.yaddressl1,
      this.yaddressl2,
      this.yaddressl3,
      this.yaddressl4,
      this.colour,
      this.longitude,
      this.latitude,
      this.distance,
      this.yemail,
      this.ysuporgNummer,
      this.ysuporgNamebspr,
      this.ycustypId,
      this.ycustypSuch,
      this.ycustypNamebspr,
      this.yowname,
      this.ymasonry,
      this.ywaterpr,
      this.yflooring,
      this.ywhtapp});

  String? id;
  String? nummer;
  String? namebsprRoute;
  String? namebspr;
  String? ysdmorg;
  String? ysdmorgId;
  String? orgnummer;
  String? yphone1;
  String? yphone2;
  String? yaddressl1;
  String? yaddressl2;
  String? yaddressl3;
  String? yaddressl4;
  String? colour;
  String? longitude;
  String? latitude;
  int? distance;
  String? yemail;
  String? ysuporgNummer;
  String? ysuporgNamebspr;
  String? ycustypId;
  String? ycustypSuch;
  String? ycustypNamebspr;
  String? yowname;
  bool? ymasonry;
  bool? ywaterpr;
  bool? yflooring;
  String? ywhtapp;

  factory RouteOrganization.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return RouteOrganization();
    }
    return RouteOrganization(
      id: json["id"] ?? '',
      nummer: json["nummer"] ?? '',
      namebsprRoute: json["namebspr"] ?? '',
      ysdmorg: json["ysdmorg^such"] ?? '',
      ysdmorgId: json["ysdmorg^id"] ?? '',
      orgnummer: json["ysdmorg^nummer"] ?? '',
      yphone1: json["ysdmorg^yphone1"] ?? '',
      yphone2: json["ysdmorg^yphone2"] ?? '',
      yaddressl1: json["ysdmorg^yaddressl1"] ?? '',
      yaddressl2: json["ysdmorg^yaddressl2"] ?? '',
      yaddressl3: json["ysdmorg^yaddressl3"] ?? '',
      yaddressl4: json["ysdmorg^yaddressl4"] ?? '',
      colour: json["ysdmorg^yselcolour^such"] ?? '',
      longitude: json["ysdmorg^ygpslon"] ?? '',
      latitude: json["ysdmorg^ygpslat"] ?? '',
      distance: json["ysdmorg^yvisdis"] ?? '',
      namebspr: json["ysdmorg^namebspr"] ?? '',
      yemail: json["ysdmorg^yemail"] ?? '',
      ysuporgNummer: json["ysdmorg^ysuporg^nummer"] ?? '',
      ysuporgNamebspr: json["ysdmorg^ysuporg^namebspr"] ?? '',
      ycustypId: json["ysdmorg^ycustyp^id"] ?? '',
      ycustypSuch: json["ysdmorg^ycustyp^such"] ?? '',
      ycustypNamebspr: json["ysdmorg^ycustyp^namebspr"] ?? '',
      yowname: json["ysdmorg^yowname"] ?? '',
      ymasonry: json["ysdmorg^ymasonry"] ?? '',
      ywaterpr: json["ysdmorg^ywaterpr"] ?? '',
      yflooring: json["ysdmorg^yflooring"] ?? '',
      ywhtapp: json["ysdmorg^ywhtapp"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id ?? '',
        "nummer": nummer ?? '',
        "namebspr": namebsprRoute ?? '',
        "ysdmorg^such": ysdmorg ?? '',
        "ysdmorg^nummer": orgnummer ?? '',
        "ysdmorg^yphone1": yphone1 ?? '',
        "ysdmorg^yphone2": yphone2 ?? '',
        "ysdmorg^yaddressl1": yaddressl1 ?? '',
        "ysdmorg^yaddressl2": yaddressl2 ?? '',
        "ysdmorg^yaddressl3": yaddressl3 ?? '',
        "ysdmorg^yaddressl4": yaddressl4 ?? '',
        "ysdmorg^yselcolour^such": colour ?? '',
        "ysdmorg^ygpslon": longitude ?? '',
        "ysdmorg^ygpslat": latitude ?? '',
        "ysdmorg^yvisdis": distance ?? '',
        "ysdmorg^namebspr": namebspr ?? '',
        "ysdmorg^yemail": yemail ?? '',
        "ysdmorg^ysuporg^nummer": ysuporgNummer ?? '',
        "ysdmorg^ysuporg^namebspr": ysuporgNamebspr ?? '',
        "ysdmorg^ycustyp^id": ycustypId ?? '',
        "ysdmorg^ycustyp^such": ycustypSuch ?? '',
        "ysdmorg^ycustyp^namebspr": ycustypNamebspr ?? '',
        "ysdmorg^yowname": yowname ?? '',
        "ysdmorg^ymasonry": ymasonry ?? '',
        "ysdmorg^ywaterpr": ywaterpr ?? '',
        "ysdmorg^yflooring": yflooring ?? '',
        "ysdmorg^ywhtapp": ywhtapp ?? '',
      };
}
