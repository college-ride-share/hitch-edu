//
//  KeychainHelper.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/20/24.
//

import Security
import Foundation

class KeychainHelper {
    static let shared = KeychainHelper()

    func save(_ value: String, for key: String) {
        guard let data = value.data(using: .utf8) else { return }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    func retrieve(for key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var data: AnyObject?
        SecItemCopyMatching(query, &data)
        guard let retrievedData = data as? Data else { return nil }
        return String(data: retrievedData, encoding: .utf8)
    }

    func delete(for key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(query)
    }
}
