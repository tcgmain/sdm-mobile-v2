class RouteList {
  RouteList(
      {this.id,
      this.nummer,
      this.namebsprRoute,
     });

  String? id;
  String? nummer;
  String? namebsprRoute;
 

  factory RouteList.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return RouteList();
    }
    return RouteList(
      id: json["id"] ?? '',
      nummer: json["nummer"] ?? '',
      namebsprRoute: json["namebspr"] ?? '',
    
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id ?? '',
        "nummer": nummer ?? '',
        "namebspr": namebsprRoute ?? '',
      
      };
}
