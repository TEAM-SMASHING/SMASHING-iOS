//
//  GameSubmissionResponseDTO.swift
//  SMASHING
//
//  Created by 홍준범 on 1/19/26.
//

import Foundation

struct GameSubmissionResponseDTO: Decodable {
    let reviewId: String?
}

struct GameConfirmResponseDTO: Decodable {
    let reviewId: String
}
