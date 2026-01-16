//
//  KakaoResponse.swift
//  SMASHING
//
//  Created by 이승준 on 1/5/26.
//

import Foundation

struct KakaoAddressResponseDTO: Decodable {
    let documents: [KakaoAddressDocumentDTO]
    let meta: KakaoAddressMeta
}

struct KakaoAddressDocumentDTO: Decodable {
    let addressName: String
    let addressType: String
    let x: String
    let y: String
    let address: KakaoAddressInfoDTO?
    let roadAddress: KakaoRoadAddressInfoDTO?
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case addressType = "address_type"
        case x, y, address
        case roadAddress = "road_address"
    }
}

struct KakaoRoadAddressInfoDTO: Decodable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let roadName: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case x, y
    }
}

struct KakaoAddressInfoDTO: Decodable {
    let addressName: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case x, y
    }
}

struct KakaoAddressMeta: Decodable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
