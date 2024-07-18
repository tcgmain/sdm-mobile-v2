class SalesOrder {
  SalesOrder({
    this.ysdempNummer,
    this.yunit,
    this.ysdorgorfrNummer,
    this.ysdorgorfrNamebspr,
    this.yqty,
    this.ydat,
    this.ysdorgNummer,
    this.nummer,
    this.ysdorgNamebspr,
    this.ysdempYpasdefBezeich,
    this.such,
    this.yprodNamebspr,
    this.zid,
    this.id,
    this.yprodNummer,
  });

  String? ysdempNummer;
  String? yunit;
  String? ysdorgorfrNummer;
  String? ysdorgorfrNamebspr;
  double? yqty;
  String? ydat;
  String? ysdorgNummer;
  String? nummer;
  String? ysdorgNamebspr;
  String? ysdempYpasdefBezeich;
  String? such;
  String? yprodNamebspr;
  String? zid;
  String? id;
  String? yprodNummer;

  factory SalesOrder.fromJson(Map<String, dynamic> json) => SalesOrder(
    ysdempNummer: json["ysdemp^nummer"],
    yunit: json["yunit"],
    ysdorgorfrNummer: json["ysdorgorfr^nummer"],
    ysdorgorfrNamebspr: json["ysdorgorfr^namebspr"],
    yqty: json["yqty"],
    ydat: json["ydat"],
    ysdorgNummer: json["ysdorg^nummer"],
    nummer: json["nummer"],
    ysdorgNamebspr: json["ysdorg^namebspr"],
    ysdempYpasdefBezeich: json["ysdemp^ypasdef^bezeich"],
    such: json["such"],
    yprodNamebspr: json["yprod^namebspr"],
    zid: json["zid"],
    id: json["id"],
    yprodNummer: json["yprod^nummer"],
  );

  Map<String, dynamic> toJson() => {
    "ysdemp^nummer": ysdempNummer,
    "yunit": yunit,
    "ysdorgorfr^nummer": ysdorgorfrNummer,
    "ysdorgorfr^namebspr": ysdorgorfrNamebspr,
    "yqty": yqty,
    "ydat": ydat,
    "ysdorg^nummer": ysdorgNummer,
    "nummer": nummer,
    "ysdorg^namebspr": ysdorgNamebspr,
    "ysdemp^ypasdef^bezeich": ysdempYpasdefBezeich,
    "such": such,
    "yprod^namebspr": yprodNamebspr,
    "zid": zid,
    "id": id,
    "yprod^nummer": yprodNummer,
  };
}
