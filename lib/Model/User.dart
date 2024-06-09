class User{
  String? name;
  String? id;
  String? email;

  User({this.id, this.name, this.email});

  User.fromFireStore(Map <String ,dynamic> data){
    id = data?['id'];
    name = data?['name'];
    email = data?['email'];
  }

  Map<String ,dynamic> toFireStore(){
    return {
      'id' : id,
      'name' : name,
      'email' : email,
    };
  }
}