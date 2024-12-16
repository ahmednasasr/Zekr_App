import UIKit
import Flutter
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // تهيئة الإشعارات المحلية
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }

        // تهيئة Flutter
        GeneratedPluginRegistrant.register(with: self)

        // إعداد Wake Lock (اختياري)
        UIApplication.shared.isIdleTimerDisabled = true

        // تهيئة flutter_local_notifications
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // دعم الإشعارات أثناء فتح التطبيق
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound]) // عرض الإشعار أثناء الاستخدام
    }

    // معالجة النقر على الإشعارات
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // تنفيذ إجراء معين عند النقر على الإشعار
        print("Notification clicked with identifier: \(response.notification.request.identifier)")
        completionHandler()
    }
}
