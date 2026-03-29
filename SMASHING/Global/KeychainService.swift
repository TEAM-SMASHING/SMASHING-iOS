//
//  KeychainService.swift
//  SMASHING
//
//  Created by 이승준 on 1/16/26.
//

import Foundation

final class KeychainService {
    
    static func add(key: String, value: String) -> Bool {
        let addQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                         kSecAttrAccount: key,
                                         kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        
        let result: Bool = {
            let status = SecItemAdd(addQuery as CFDictionary, nil)
            if status == errSecSuccess {
                return true
            } else if status == errSecDuplicateItem {
                return update(key: key, value: value)
            }
            
            print("KeychainService AddItem Error : \(status.description))")
            return false
        }()
        
        return result
    }
    
    static func get(key: String) -> String? {
        let getQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: key,
                                      kSecReturnAttributes: true,
                                      kSecReturnData: true]
        var item: CFTypeRef?
        let result = SecItemCopyMatching(getQuery as CFDictionary, &item)
        
        if result == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        
        print("KeychainService GetItem Error : \(result.description)")
        return nil
    }
    
    static func update(key: String, value: String) -> Bool {
        let prevQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                        kSecAttrAccount: key]
        let updateQuery: [CFString: Any] = [kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        
        let result: Bool = {
            let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
            if status == errSecSuccess { return true }
            
            print("KeychainService UpdateItem Error : \(status.description)")
            return false
        }()
        
        return result
    }
    
    static func delete(key: String) -> Bool {
        let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                            kSecAttrAccount: key]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status == errSecSuccess { return true }

        print("KeychainService DeleteItem Error : \(status.description)")
        return false
    }

    /// 로그아웃·탈퇴 시 저장된 모든 인증 정보 삭제
    static func clearAll() {
        _ = delete(key: Environment.accessTokenKey)
        _ = delete(key: Environment.refreshTokenKey)
        _ = delete(key: Environment.kakaoId)
        _ = delete(key: Environment.userIdKey)
        _ = delete(key: Environment.nicknameKey)
        _ = delete(key: Environment.activeProfileKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.region)
    }
}
