class RouteOrganization {
  RouteOrganization({
    this.nummer,
    this.namebsprRoute,
    this.namebspr,
    this.ysdmorg,
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
   
  });

  String? nummer;
  String? namebsprRoute;
  String? namebspr;
  String? ysdmorg;
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
  
  factory RouteOrganization.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return RouteOrganization();
    }
    return RouteOrganization(
      nummer: json["nummer"] ?? '',
      namebsprRoute: json["namebspr"] ?? '',
      ysdmorg: json["ysdmorg^such"] ?? '',
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
  
    );
  }

  Map<String, dynamic> toJson() => {
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
        "ysdmorg^namebspr":namebspr ?? '',
      };
}