class Organization {
  Organization(
      {this.id,
      this.such,
      this.yassigto,
      this.yassigtoNummer,
      this.yassigtoNamebspr,
      this.namebspr,
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
      this.yactiv,
      this.ylev,
      this.ysuporgNummer,
      this.ysuporgNamebspr,
      this.ycustypSuch,
      this.ycustypId,
      this.ycustypNamebspr,
      this.yowname,
      this.yorgowndob,
      this.ymasonry,
      this.ywaterpr,
      this.yflooring,
      this.ywhtapp,
      this.erfass,
      this.yorgappu,
      this.yorgappdt,
      this.yscemet,
      this.ystilea,
      this.yswaterp,
      this.ysanmet,
      this.yspaint});

  String? id;
  String? such;
  String? yassigto;
  String? yassigtoNummer;
  String? yassigtoNamebspr;
  String? namebspr;
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
  bool? yactiv;
  int? ylev;
  String? ysuporgNummer;
  String? ysuporgNamebspr;
  String? ycustypSuch;
  String? ycustypId;
  String? ycustypNamebspr;
  String? yowname;
  String? yorgowndob;
  bool? ymasonry;
  bool? ywaterpr;
  bool? yflooring;
  String? ywhtapp;
  String? erfass;
  String? yorgappu;
  String? yorgappdt;
  bool? yscemet;
  bool? ystilea;
  bool? yswaterp;
  bool? ysanmet;
  bool? yspaint;

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json["id"],
      such: json["such"],
      yassigto: json["yassigto^such"],
      yassigtoNummer: json["yassigto^nummer"],
      yassigtoNamebspr: json["yassigto^namebspr"],
      namebspr: json["namebspr"],
      orgnummer: json["nummer"],
      yphone1: json["yphone1"],
      yphone2: json["yphone2"],
      yaddressl1: json["yaddressl1"],
      yaddressl2: json["yaddressl2"],
      yaddressl3: json["yaddressl3"],
      yaddressl4: json["yaddressl4"],
      colour: json["yselcolour^such"],
      longitude: json["ygpslon"],
      latitude: json["ygpslat"],
      distance: json["yvisdis"],
      yemail: json["yemail"],
      yactiv: json["yactiv"],
      ylev: json["ylev"],
      ysuporgNummer: json["ysuporg^nummer"],
      ysuporgNamebspr: json["ysuporg^namebspr"],
      ycustypSuch: json["ycustyp^such"],
      ycustypId: json["ycustyp^id"],
      ycustypNamebspr: json["ycustyp^namebspr"],
      yowname: json["yowname"],
      yorgowndob: json["yorgowndob"],
      ymasonry: json["ymasonry"],
      ywaterpr: json["ywaterpr"],
      yflooring: json["yflooring"],
      ywhtapp: json["ywhtapp"],
      erfass: json["erfass"],
      yorgappu: json["yorgappu"],
      yorgappdt: json["yorgappdt"],
       yscemet: json["yscemet"] ?? '',
      ystilea: json["ystilea"] ?? '',
      yswaterp: json["yswaterp"] ?? '',
      ysanmet: json["ysanmet"] ?? '',
      yspaint: json["yspaint"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "such": such,
        "yassigto^such": yassigto,
        "yassigto^nummer": yassigtoNummer,
        "yassigto^namebspr": yassigtoNamebspr,
        "namebspr": namebspr,
        "nummer": orgnummer,
        "yphone1": yphone1,
        "yphone2": yphone2,
        "yaddressl1": yaddressl1,
        "yaddressl2": yaddressl2,
        "yaddressl3": yaddressl3,
        "yaddressl4": yaddressl4,
        "yselcolour^such": colour,
        "ygpslon": longitude,
        "ygpslat": latitude,
        "yvisdis": distance,
        "yemail": yemail,
        "yactiv": yactiv,
        "ylev": ylev,
        "ysuporg^nummer": ysuporgNummer,
        "ysuporg^namebspr": ysuporgNamebspr,
        "ycustyp^such": ycustypSuch,
        "ycustyp^id": ycustypId,
        "ycustyp^namebspr": ycustypNamebspr,
        "yowname": yowname,
        "yorgowndob": yorgowndob,
        "ymasonry": ymasonry,
        "ywaterpr": ywaterpr,
        "yflooring": yflooring,
        "ywhtapp": ywhtapp,
        "erfass": erfass,
        "yorgappu": yorgappu,
        "yorgappdt": yorgappdt,
        "yscemet": yscemet ?? '',
        "ystilea": ystilea ?? '',
        "yswaterp": yswaterp ?? '',
        "ysanmet": ysanmet ?? '',
        "yspaint": yspaint ?? '',
      };
}
