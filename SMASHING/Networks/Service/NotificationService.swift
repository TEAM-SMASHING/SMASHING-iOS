//
//  NotificationService.swift
//  SMASHING
//
//  Created by 이승준 on 1/21/26.
//

import Combine
import Foundation

protocol NotificationServiceProtocol {
    func fetchNotifications(size: Int, cursor: String?, snapshotAt: String?) -> AnyPublisher<GenericResponse<NotificationCursorResponseDTO>, NetworkError>
    func markAsRead(notificationId: String) -> AnyPublisher<NotificationBaseResponseDTO, NetworkError>
    func checkSportMatch(notificationId: String) -> AnyPublisher<GenericResponse<NotificationSportMatchDTO>, NetworkError>
}

final class NotificationService: NotificationServiceProtocol {
    func fetchNotifications(size: Int, cursor: String?, snapshotAt: String?) -> AnyPublisher<GenericResponse<NotificationCursorResponseDTO>, NetworkError> {
        return NetworkProvider<NotificationAPI>.requestPublisher(
            .getNotifications(size: size, cursor: cursor, snapshotAt: snapshotAt),
            type: NotificationCursorResponseDTO.self
        )
    }

    func markAsRead(notificationId: String) -> AnyPublisher<NotificationBaseResponseDTO, NetworkError> {
        return NetworkProvider<NotificationAPI>.plainRequestPublisher(
            .readNotification(notificationId: notificationId),
            type: NotificationBaseResponseDTO.self
        )
    }

    func checkSportMatch(notificationId: String) -> AnyPublisher<GenericResponse<NotificationSportMatchDTO>, NetworkError> {
        return NetworkProvider<NotificationAPI>.requestPublisher(
            .checkSportMatch(notificationId: notificationId),
            type: NotificationSportMatchDTO.self
        )
    }
}
