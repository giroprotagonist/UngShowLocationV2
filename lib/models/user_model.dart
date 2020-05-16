class UserModel {
  String name, email, gendle, uid, urlAvatar;

  UserModel({this.name, this.email, this.gendle, this.uid, this.urlAvatar});

  UserModel.fromJSON(Map<String, dynamic> map) {
    name = map['Name'];
   email = map['Email'];
    gendle = map['Gendle'];
    uid = map['Uid'];
    urlAvatar = map['UrlAvatar'];
  }
}
