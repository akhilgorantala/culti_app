class AuthResponse {
  bool success;
  String message;
  int userId;
  String username;
  String firmwareUrl;
  String firmwareVersion;

  AuthResponse({
    required this.success,
    required this.message,
    required this.userId,
    required this.username,
    required this.firmwareUrl,
    required this.firmwareVersion,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        success: json["success"],
        message: json["message"],
        userId: json["user_id"],
        username: json["username"],
        firmwareUrl: json["firmware_url"],
        firmwareVersion: json["firmware_version"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user_id": userId,
        "username": username,
        "firmware_url": firmwareUrl,
        "firmware_version": firmwareVersion,
      };
}
