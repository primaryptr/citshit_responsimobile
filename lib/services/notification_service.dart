// ============================================================
//  notification_service.dart
//  Kerangka siap pakai untuk Notifikasi Lokal (Modul VII).
//
//  CARA MENGAKTIFKAN:
//  1. Uncomment dependency di pubspec.yaml:
//       flutter_local_notifications: ^17.2.4
//       timezone: ^0.9.4
//  2. Uncomment receiver di AndroidManifest.xml
//  3. Uncomment semua kode di file ini
//  4. Jalankan: flutter pub get
// ============================================================

// [GANTI SAAT RESPONSI: Uncomment semua import ini jika soal meminta notifikasi]
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import '../config/app_config.dart';

class NotificationService {
  NotificationService._();

  // [GANTI SAAT RESPONSI: Uncomment instance ini]
  // static final FlutterLocalNotificationsPlugin _plugin =
  //     FlutterLocalNotificationsPlugin();

  // ─── INISIALISASI ─────────────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Panggil NotificationService.init() di main() sebelum runApp()]
  static Future<void> init() async {
    // tz.initializeTimeZones(); // [GANTI SAAT RESPONSI: Uncomment untuk scheduled notif]
    // tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); // [GANTI SAAT RESPONSI: Timezone]

    // const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    // const initSettings = InitializationSettings(android: androidSettings);

    // await _plugin.initialize(
    //   initSettings,
    //   onDidReceiveNotificationResponse: (details) {
    //     // [GANTI SAAT RESPONSI: Navigasi ke screen tertentu saat notif di-tap]
    //     // Navigator.pushNamed(navigatorKey.currentContext!, '/detail');
    //   },
    // );

    // // Request permission (Android 13+)
    // await _plugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.requestNotificationsPermission();
  }

  // ─── NOTIFIKASI LANGSUNG (Immediate) ─────────────────────────────────────
  // [GANTI SAAT RESPONSI: Panggil NotificationService.showImmediate() untuk notif instan]
  static Future<void> showImmediate({
    // [GANTI SAAT RESPONSI: Ganti judul dan isi notifikasi]
    String title = 'Notifikasi',
    String body = 'Ini adalah notifikasi dari aplikasi',
  }) async {
    // const androidDetails = AndroidNotificationDetails(
    //   AppConfig.notifChannelId,
    //   AppConfig.notifChannelName,
    //   channelDescription: AppConfig.notifChannelDesc,
    //   importance: Importance.max,
    //   priority: Priority.high,
    // );
    // const details = NotificationDetails(android: androidDetails);

    // await _plugin.show(
    //   AppConfig.notifImmediateId,
    //   title,
    //   body,
    //   details,
    // );
  }

  // ─── NOTIFIKASI TERJADWAL (Scheduled) ────────────────────────────────────
  // [GANTI SAAT RESPONSI: Panggil NotificationService.showScheduled() untuk notif terjadwal]
  static Future<void> showScheduled({
    // [GANTI SAAT RESPONSI: Atur delay dalam detik]
    int delaySeconds = 5,
    String title = 'Pengingat',
    String body = 'Waktunya mengecek aplikasi!',
  }) async {
    // final scheduledTime = tz.TZDateTime.now(tz.local).add(
    //   Duration(seconds: delaySeconds),
    // );

    // const androidDetails = AndroidNotificationDetails(
    //   AppConfig.notifChannelId,
    //   AppConfig.notifChannelName,
    //   channelDescription: AppConfig.notifChannelDesc,
    //   importance: Importance.max,
    //   priority: Priority.high,
    // );
    // const details = NotificationDetails(android: androidDetails);

    // await _plugin.zonedSchedule(
    //   AppConfig.notifScheduledId,
    //   title,
    //   body,
    //   scheduledTime,
    //   details,
    //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );
  }

  // ─── CANCEL NOTIFIKASI ────────────────────────────────────────────────────
  static Future<void> cancelAll() async {
    // await _plugin.cancelAll();
  }
}
