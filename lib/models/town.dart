class Town {
  Town({
    this.ylatitude,
    this.namebspr,
    this.id,
    this.nummer,
    this.ylongtitude,
  });

  String? ylatitude;
  String? namebspr;
  String? id;
  String? nummer;
  String? ylongtitude;

  factory Town.fromJson(Map<String, dynamic> json) => Town(
        ylatitude: json["ylatitude"],
        namebspr: json["namebspr"],
        id: json["id"],
        nummer: json["nummer"],
        ylongtitude: json["ylongtitude"],
      );

  Map<String, dynamic> toJson() => {
        "ylatitude": ylatitude,
        "namebspr": namebspr,
        "id": id,
        "nummer": nummer,
        "ylongtitude": ylongtitude,
      };
}
