class TargetAchievement {
  TargetAchievement({
    this.ytargetprodbrand,
    this.ytargetyr,
    this.ytottargetqty,
    this.ytotachqty,
    this.yprodtecl,
    this.ytargetprodSuch,
    this.ytargetmn,
    this.yprodtccl,
    this.ytargetprodNummer,
    this.nummer,
    this.ytargetempNummer,
    this.ytargetempSuch,
    this.yindachqty,
    this.zid,
    this.ytargetqty,
    this.ytargetprodNamebspr,
    this.ydirachqty,
    this.id,
    this.yindtargetqty,
    this.yisassignprod,
  });

  String? ytargetprodbrand;
  String? ytargetyr;
  int? ytottargetqty;
  int? ytotachqty;
  String? yprodtecl;
  String? ytargetprodSuch;
  int? ytargetmn;
  String? yprodtccl;
  String? ytargetprodNummer;
  String? nummer;
  String? ytargetempNummer;
  String? ytargetempSuch;
  int? yindachqty;
  String? zid;
  int? ytargetqty;
  String? ytargetprodNamebspr;
  int? ydirachqty;
  String? id;
  int? yindtargetqty;
  bool? yisassignprod;

  factory TargetAchievement.fromJson(Map<String, dynamic> json) => TargetAchievement(
        ytargetprodbrand: json["ytargetprodbrand"],
        ytargetyr: json["ytargetyr"],
        ytottargetqty: json["ytottargetqty"],
        ytotachqty: json["ytotachqty"],
        yprodtecl: json["yprodtecl"],
        ytargetprodSuch: json["ytargetprod^such"],
        ytargetmn: json["ytargetmn"],
        yprodtccl: json["yprodtccl"],
        ytargetprodNummer: json["ytargetprod^nummer"],
        nummer: json["nummer"],
        ytargetempNummer: json["ytargetemp^nummer"],
        ytargetempSuch: json["ytargetemp^such"],
        yindachqty: json["yindachqty"],
        zid: json["zid"],
        ytargetqty: json["ytargetqty"],
        ytargetprodNamebspr: json["ytargetprod^namebspr"],
        ydirachqty: json["ydirachqty"],
        id: json["id"],
        yindtargetqty: json["yindtargetqty"],
        yisassignprod: json["yisassignprod"],
      );

  Map<String, dynamic> toJson() => {
        "ytargetprodbrand": ytargetprodbrand,
        "ytargetyr": ytargetyr,
        "ytottargetqty": ytottargetqty,
        "ytotachqty": ytotachqty,
        "yprodtecl": yprodtecl,
        "ytargetprod^such": ytargetprodSuch,
        "ytargetmn": ytargetmn,
        "yprodtccl": yprodtccl,
        "ytargetprod^nummer": ytargetprodNummer,
        "nummer": nummer,
        "ytargetemp^nummer": ytargetempNummer,
        "ytargetemp^such": ytargetempSuch,
        "yindachqty": yindachqty,
        "zid": zid,
        "ytargetqty": ytargetqty,
        "ytargetprod^namebspr": ytargetprodNamebspr,
        "ydirachqty": ydirachqty,
        "id": id,
        "yindtargetqty": yindtargetqty,
        "yisassignprod": yisassignprod,
      };
}
