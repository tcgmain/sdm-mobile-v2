class Login {
    Login({
        this.ylogver,
        this.yerrmsg,
        this.ylogimei,
        this.ylogpwd,
        this.id,
        this.ylogopr,
        this.table,
        this.message, 
        this.ypwdid

    });
 
    bool? ylogver;
    String? yerrmsg;
    String? ylogimei;
    String? ylogpwd;
    String? id;
    String? ypwdid;
    String? ylogopr;
    List<dynamic>? table;
    String? message;
 
    factory Login.fromJson(Map<String, dynamic> json) => Login(
        ylogver : json["ylogver"],
        yerrmsg : json["yerrmsg"],
        ylogimei : json["ylogimei"],
        ylogpwd : json["ylogpwd"],
        id : json["id"],
        ylogopr : json["ylogopr"],
        table : json["table"],
        message : json["message"],
        ypwdid :json["ypwdid"],
    );
 
    Map<String, dynamic> toJson() => {
        "ylogver"    : ylogver,
        "yerrmsg"    : yerrmsg,
        "ylogimei"   : ylogimei,
        "ylogpwd"    : ylogpwd,
        "id"         : id,
        "ylogopr"    : ylogopr,
        "table"      : table,
        "message"    : message,
        "ypwdid"     : ypwdid,
    };
}