//
//  UserSportProvider.swift
//  SMASHING
//
//  Created by JIN on 1/22/26.
//

import Foundation

protocol UserSportProviding {
    func currentSport() -> Sports
}

final class KeychainUserSportProvider: UserSportProviding {
    func currentSport() -> Sports {
        guard let userId = KeychainService.get(key: Environment.userIdKey), !userId.isEmpty else {
            return .badminton
        }

        let key = "\(Environment.sportsCodeKeyPrefix).\(userId)"
        guard let rawValue = KeychainService.get(key: key),
              let sport = Sports(rawValue: rawValue) else {
            return .badminton
        }

        return sport
    }
}
