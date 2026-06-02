class User {
  int? id;
  String nama;
  String email;
  String hp;

  String pasword;

  User({
    this.id,
    required this.nama,
    required this.email,
    required this.hp,

    required this.pasword,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'hp': hp,
      'pasword': pasword,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nama: map['nama'],
      email: map['email'],
      hp: map['hp'],
      pasword: map['pasword'],
    );
  }
}
