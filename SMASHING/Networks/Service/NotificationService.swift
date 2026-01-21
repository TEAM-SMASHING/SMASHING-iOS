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
}

final class NotificationService: NotificationServiceProtocol {
    func fetchNotifications(size: Int, cursor: String?, snapshotAt: String?) -> AnyPublisher<GenericResponse<NotificationCursorResponseDTO>, NetworkError> {
        return NetworkProvider<NotificationTarget>.requestPublisher(
            .getNotifications(size: size, cursor: cursor, snapshotAt: snapshotAt),
            type: NotificationCursorResponseDTO.self
        )
    }

    func markAsRead(notificationId: String) -> AnyPublisher<NotificationBaseResponseDTO, NetworkError> {
        return NetworkProvider<NotificationTarget>.plainRequestPublisher(
            .readNotification(notificationId: notificationId),
            type: NotificationBaseResponseDTO.self
        )
    }
}
