import 'dart:convert';

class AppUser {
  String uid;
  String name;
  String photoUrl;
  String email;
  String phoneNo;
  String token;

  num rating;
  num totalRides;
  double currentLat;
  double currentLng;
  AppUser({
    this.uid,
    this.name,
    this.photoUrl,
    this.email,
    this.phoneNo,
    this.token,
    this.rating,
    this.totalRides,
    this.currentLat,
    this.currentLng,
  });

  AppUser copyWith({
    String uid,
    String name,
    String photoUrl,
    String email,
    String phoneNo,
    String token,
    double rating,
    int totalRides,
    double currentLat,
    double currentLng,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      token: token ?? this.token,
      rating: rating ?? this.rating,
      totalRides: totalRides ?? this.totalRides,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'photoUrl': photoUrl,
      'email': email,
      'phoneNo': phoneNo,
      'token': token,
      'rating': rating,
      'totalRides': totalRides,
      'currentLat': currentLat,
      'currentLng': currentLng,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AppUser(
      uid: map['uid'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      email: map['email'],
      phoneNo: map['phoneNo'],
      token: map['token'],
      rating: map['rating'],
      totalRides: map['totalRides'],
      currentLat: map['currentLat'],
      currentLng: map['currentLng'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(uid: $uid, name: $name, photoUrl: $photoUrl, email: $email, phoneNo: $phoneNo,token: $token, rating: $rating, totalRides: $totalRides, currentLat: $currentLat, currentLng: $currentLng)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AppUser &&
        o.uid == uid &&
        o.name == name &&
        o.photoUrl == photoUrl &&
        o.email == email &&
        o.phoneNo == phoneNo &&
        o.token == token &&
        o.rating == rating &&
        o.totalRides == totalRides &&
        o.currentLat == currentLat &&
        o.currentLng == currentLng;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        photoUrl.hashCode ^
        email.hashCode ^
        phoneNo.hashCode ^
        token.hashCode ^
        rating.hashCode ^
        totalRides.hashCode ^
        currentLat.hashCode ^
        currentLng.hashCode;
  }
}
