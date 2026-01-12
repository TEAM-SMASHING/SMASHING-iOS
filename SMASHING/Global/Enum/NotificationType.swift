//
//  NotificationType.swift
//  SMASHING
//
//  Created by 이승준 on 1/12/26.
//

enum NotificationType {
    case matchingRequested
    
    var message: String {
        switch self {
        case .matchingRequested:
            return "matching requested"
        }
    }
}
