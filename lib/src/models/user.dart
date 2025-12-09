import 'package:meta/meta.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    this.avatar,
  });

  final String id;
  final String name;
  final String? avatar;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (avatar != null) 'avatar': avatar,
      };
}
