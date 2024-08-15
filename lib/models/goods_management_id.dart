class GoodManagementID {
    GoodManagementID({
        this.such,
        this.id,
        this.nummer,
    });
 
    String? such;
    String? id;
    String? nummer;
   
    factory GoodManagementID.fromJson(Map<String, dynamic> json) => GoodManagementID(
        such: json["such"],
        id :  json["id"],
        nummer :  json["nummer"],

    );
 
    Map<String, dynamic> toJson() => {
        "such" : such,
        "id" : id,
        "nummer": nummer,
    };
}