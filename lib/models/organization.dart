class Organization {
    Organization({
        this.yassigto,
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
    });
 
    String? yassigto;
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
   
    factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        yassigto: json["yassigto^such"],
        namebspr :  json["namebspr"],
        orgnummer :  json["nummer"],
        yphone1 :  json["yphone1"],
        yphone2 :  json["yphone2"],
        yaddressl1 :  json["yaddressl1"],
        yaddressl2 :  json["yaddressl2"],
        yaddressl3 :  json["yaddressl3"],
        yaddressl4 :  json["yaddressl4"],
        colour:  json["yselcolour^such"],
        longitude :  json["ygpslon"],
        latitude :  json["ygpslat"],
        distance:  json["yvisdis"],


    );
 
    Map<String, dynamic> toJson() => {
        "yassigto^such" : yassigto,
        "such" : namebspr,
        "nummer": orgnummer,
        "yphone1" : yphone1,
        "yphone2" : yphone2,
        "yaddressl1" : yaddressl1,
        "yaddressl2" : yaddressl2,
        "yaddressl3" : yaddressl3,
        "yaddressl4" : yaddressl4,
        "yselcolour^such" : colour,
        "ygpslon" : longitude,
        "ygpslat" : latitude,
        "yvisdis" : distance,
    };
}