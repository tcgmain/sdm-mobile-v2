class Permission {
    Permission({
        this.nummer,
        this.such,
        this.namebspr,
        this.ydefzSuch,
        this.id,
       

    });
 
    String? nummer;
    String? such;
    String? namebspr;
    String? ydefzSuch;
    String? id;
 
    factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        nummer : json["nummer"],
        such : json["such"],
        namebspr : json["namebspr"],
        ydefzSuch : json["ydefz^such"],
        id : json["id"],
    );
 
    Map<String, dynamic> toJson() => {
        "nummer"    : nummer,
        "such"    : such,
        "namebspr"   : namebspr,
        "ydefz^such"    : ydefzSuch,
        "id"         : id,
    };
}