//
//  SecuredPreferencesKeychainServiceTests.swift
//  iOS Tests
//
//  Created by Basem Emara on 2020-02-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class SecuredPreferencesKeychainServiceTests: XCTestCase {
    // Unit test done here instead of core since Keychain needs application host
    // https://github.com/onmyway133/blog/issues/92
    // https://forums.swift.org/t/host-application-for-spm-tests/24363
    private lazy var keychain = SecuredPreferences(service: SecuredPreferencesKeychainService())
    
    override func setUp() {
        super.setUp()
        keychain.remove(.testString1)
        keychain.remove(.testString2)
    }
}

extension SecuredPreferencesKeychainServiceTests {
    
    func testString() {
        // Given
        let value1 = "abc"
        let value2 = "xyz"
        
        // When
        keychain.set(value1, forKey: .testString1)
        keychain.set(value2, forKey: .testString2)
        
        // Then
        XCTAssertEqual(keychain.get(.testString1), value1)
        XCTAssertEqual(keychain.get(.testString2), value2)
    }
}

extension SecuredPreferencesKeychainServiceTests {
    
    func testRemove() {
        // Given
        let value1 = "abc"
        let value2 = "xyz"
        
        // When
        keychain.set(value1, forKey: .testString1)
        keychain.set(value2, forKey: .testString2)
        keychain.remove(.testString1)
        keychain.remove(.testString2)
        
        // Then
        XCTAssertNil(keychain.get(.testString1))
        XCTAssertNil(keychain.get(.testString2))
    }
}

private extension SecuredPreferencesAPI.Key {
    static let testString1 = SecuredPreferencesAPI.Key("testString1")
    static let testString2 = SecuredPreferencesAPI.Key("testString2")
}
