//
//  MatchingManageHeaderView.swift
//  SMASHING
//
//  Created by JIN on 1/12/26.
//

import UIKit

class MatchingManageHeaderView: UIView {
    
    // MARK: - Types
    
    enum Tab: Int, CaseIterable {
        case received = 0
        case sent = 1
        case confirmed = 2
        
        var title: String {
            switch self {
            case .received: return "받은 요청"
            case .sent: return "보낸 요청"
            case .confirmed: return "매칭 확정"
            }
        }
    }
}
