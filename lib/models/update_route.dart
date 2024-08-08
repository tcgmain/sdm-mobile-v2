class UpdateRoute {
  UpdateRoute({
    this.id,
    this.table,
  });

  String? id;
  List<OrganizationDetails>? table;

  factory UpdateRoute.fromJson(Map<String, dynamic> json) {
    return UpdateRoute(
      id: json["id"],
      table: (json["table"] as List<dynamic>?)?.map((item) => OrganizationDetails.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "table": table?.map((item) => item.toJson()).toList(),
      };
}

class OrganizationDetails {
  OrganizationDetails({
    this.ysdmorg,
  });

  String? ysdmorg;
 

  factory OrganizationDetails.fromJson(Map<String, dynamic> json) {
    return OrganizationDetails(
      ysdmorg: json["ysdmorg"],
     
    );
  }

  Map<String, dynamic> toJson() => {
        "ysdmorg": ysdmorg,
     
      };
}
