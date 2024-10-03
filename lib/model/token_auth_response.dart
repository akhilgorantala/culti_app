class TokenAuthResponse {
  String token;
  String userEmail;
  String userNicename;
  String userDisplayName;

  TokenAuthResponse({
    required this.token,
    required this.userEmail,
    required this.userNicename,
    required this.userDisplayName,
  });

  factory TokenAuthResponse.fromJson(Map<String, dynamic> json) =>
      TokenAuthResponse(
        token: json["token"],
        userEmail: json["user_email"],
        userNicename: json["user_nicename"],
        userDisplayName: json["user_display_name"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user_email": userEmail,
        "user_nicename": userNicename,
        "user_display_name": userDisplayName,
      };
}
