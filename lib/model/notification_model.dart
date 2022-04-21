import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {

  String? to = FirebaseMessaging.instance.getToken().toString();
  Notification? notification;
  Android? android;
  Data? data;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    notification = Notification.fromJson(json['notification']);
    android = Android.fromJson(json['android']);
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['to'] = to;
    _data['notification'] = notification?.toJson();
    _data['android'] = android?.toJson();
    _data['data'] = data?.toJson();
    return _data;
  }
}

class Notification {
  Notification({
    required this.title,
    required this.body,
    required this.sound
  });

  String? title = "title";
  String? body = "body";
  String sound = "default";

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    sound = json['sound'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['body'] = body;
    _data['sound'] = sound;
    return _data;
  }
}

class Android {
  Android({
    required this.priority,
    required this.notifications,
  });

  String priority = "HIGH";
  Notifications? notifications;

  Android.fromJson(Map<String, dynamic> json) {
    priority = json['priority'];
    notifications = Notifications.fromJson(json['notifications']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['priority'] = priority;
    _data['notifications'] = notifications?.toJson();
    return _data;
  }
}

class Notifications {
  Notifications({
    required this.notificationPriority,
    required this.sound,
    required this.defaultSound,
    required this.defaultVibrateTimings,
    required this.defaultLightSettings,
  });

  String notificationPriority = "PRIORITY_MAX";
  String sound = "default";
  bool defaultSound = true;
  bool defaultVibrateTimings = true;
  bool defaultLightSettings = true;

  Notifications.fromJson(Map<String, dynamic> json) {
    notificationPriority = json['notification_priority'];
    sound = json['sound'];
    defaultSound = json['default_sound'];
    defaultVibrateTimings = json['default_vibrate_timings'];
    defaultLightSettings = json['default_light_settings'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notification_priority'] = notificationPriority;
    _data['sound'] = sound;
    _data['default_sound'] = defaultSound;
    _data['default_vibrate_timings'] = defaultVibrateTimings;
    _data['default_light_settings'] = defaultLightSettings;
    return _data;
  }
}

class Data {
  Data({
    required this.type,
    required this.id,
    required this.clickAction,
  });

  String type = "order";
  String id = "87";
  String clickAction = "FLUTTER_NOTIFICATION_CLICK";

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    clickAction = json['click_action'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['id'] = id;
    _data['click_action'] = clickAction;
    return _data;
  }
}
