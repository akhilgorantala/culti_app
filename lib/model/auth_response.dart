class AuthResponse {
  bool success;
  String message;
  int userId;
  String username;

  AuthResponse({
    required this.success,
    required this.message,
    required this.userId,
    required this.username,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    success: json["success"],
    message: json["message"],
    userId: json["user_id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "user_id": userId,
    "username": username,
  };
}