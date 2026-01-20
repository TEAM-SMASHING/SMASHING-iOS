//
//  ReviewTag.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

enum ReviewTag: String, Codable, CaseIterable {
    case goodManner = "GOOD_MANNER"
    case onTime = "ON_TIME"
    case fairPlay = "FAIR_PLAY"
    case fastResponse = "FAST_RESPONSE"
    
    var displayText: String{
        switch self {
            case .goodManner: return "경기 매너가 좋아요"
            case .onTime: return "시간 약속을 잘 지켜요"
            case .fairPlay: return "승패를 깔끔하게 인정해요"
            case .fastResponse: return "응답이 빨라요"
        }
    }
}
