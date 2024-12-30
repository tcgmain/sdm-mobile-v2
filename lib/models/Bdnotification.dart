class Bdnotification {
  Bdnotification(
    {
      this.yterritory_nummer,
      this.yowname,
      this.yorgowndob,
      this.such,
      this.id,
      this.orgnummer,
    }
  );

  String? yterritory_nummer;
  String? yowname;
  String? yorgowndob;
  String? such;
  String? id;
  String? orgnummer;

  factory Bdnotification.fromJson(Map<String, dynamic> json) {
    return Bdnotification(
      yterritory_nummer: json["yterritory^nummer"],
      yowname: json["yowname"],
      yorgowndob: json["yorgowndob"],
      such: json["such"],
      id: json["id"],
      orgnummer: json["nummer"],
     );
  }

  Map<String, dynamic> toJson() => {
    "yterritory^nummer": yterritory_nummer,
    "yowname": yowname,
    "yorgowndob": yorgowndob,
    "such": such,
    "id": id,
    "nummer": orgnummer
  };
 
}