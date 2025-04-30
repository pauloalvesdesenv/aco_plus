class FCMDataModel {
  final String title;
  final String description;
  final String? token;
  final Map<String, dynamic>? data;

  FCMDataModel({
    required this.title,
    required this.description,
    required this.token,
    this.data,
  });

  Map<String, dynamic> toMap() => {
        "message": {
          "token": token,
          "notification": {"title": title, "body": description},
          "android": {
            "notification": {"click_action": "TOP_STORY_ACTIVITY"},
          },
          "apns": {
            "payload": {
              "aps": {"category": "NEW_MESSAGE_CATEGORY"},
            },
          },
        },
        "data": data,
      };
}
