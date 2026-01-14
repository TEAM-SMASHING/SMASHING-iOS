//
//  ReviewTag.swift
//  SMASHING
//
//  Created by 이승준 on 1/13/26.
//

enum ReviewTag: String, Codable {
    case goodManner = "경기 매너가 좋아요"
    case onTime = "시간 약속을 잘 지켜요"
    case fairPlay = "승패를 깔끔하게 인정해요"
    case fastResponse = "응답이 빨라요"
    
    enum CodingKeys: String, CodingKey {
        case tableTennis = "TT"
        case tennis = "TN"
        case badminton = "BM"
    }
}
