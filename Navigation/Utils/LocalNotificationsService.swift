//
//
// LocalNotificationsService.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit
import UserNotifications

final class LocalNotificationsService: NSObject {
    
    private enum CategiesIds {
        static let update = "update"
    }
    private enum RequestIds {
        static let update = "updateRequest"
    }
    private enum CategoriesActions: String {
        case check
        case cancel
        static func rV(_ value: Self) -> String {
            value.rawValue
        }
    }

    private let center = UNUserNotificationCenter.current()
    
    func registeForLatestUpdatesIfPossible() {
        registerUpdatesCategory()
        
        center.removeAllPendingNotificationRequests()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            guard granted, let self else { return }
            self.center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    self.center.add(self.createRequest())
                }
            }
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func registerUpdatesCategory() {
        center.delegate = self
        
        let actionCheck = UNNotificationAction(
                identifier: CategoriesActions.check.rawValue,
                title: NSString.localizedUserNotificationString(forKey: "LocalNotificationsService.actionCheck.title", arguments: .none)
        )
        let actionCancel = UNNotificationAction(
                identifier: CategoriesActions.cancel.rawValue,
                title: NSString.localizedUserNotificationString(forKey: "LocalNotificationsService.actionCancel.title", arguments: .none),
                options: [.destructive]
        )
        let category = UNNotificationCategory(
                identifier: CategiesIds.update,
                actions: [actionCheck, actionCancel],
                intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    private func createRequest() -> UNNotificationRequest {
        
        var dateComponent = DateComponents()
        dateComponent.hour = 19
        dateComponent.minute = 0
        dateComponent.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        let content = UNMutableNotificationContent()

        content.badge = 1
        content.sound = .default
        content.title = NSString.localizedUserNotificationString(forKey: "LocalNotificationsService.content.title", arguments: .none)
        content.body = NSString.localizedUserNotificationString(forKey: "LocalNotificationsService.content.body",
                                                                arguments: .none)
        content.categoryIdentifier = CategiesIds.update

        let request = UNNotificationRequest(identifier: RequestIds.update, content: content, trigger: trigger)
        return request
    }
}

extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    private func setCountBadgeToZero() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                //Удаление доставленных уведомлений и обнуление значка на приложении
                setCountBadgeToZero()
                center.removeAllDeliveredNotifications()
            case CategoriesActions.rV(.check):
                //Печать в лог идентификатора и обнуление значка на приложении
                setCountBadgeToZero()
                print(response.actionIdentifier)
            case CategoriesActions.rV(.cancel):
                //Удаление запланированных уведомлений
                setCountBadgeToZero()
                center.removeAllPendingNotificationRequests()
            default:
                print("LocalNotificationsService.delegate.didReceive".localized)
        }
        completionHandler()
    }
}
