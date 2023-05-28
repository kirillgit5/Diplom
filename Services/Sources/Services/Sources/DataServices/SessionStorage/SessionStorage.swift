import Foundation
import Core

public final class SessionStorage {
    static public let shared = SessionStorage(keychainStorage: .init())

    private let keychainStorage: KeychainStorage

    private  init(keychainStorage: KeychainStorage) {
        self.keychainStorage = keychainStorage
    }

    public var accessToken: String?

    public var refreshToken: String? {
        get { keychainStorage.load(byName: .refreshToken) }
        set { keychainStorage.save(newValue, byName: .refreshToken) }
    }

    public var isBiometryUsed: Bool? {
        get { keychainStorage.load(byName: .isBiometryUsed) }
        set { keychainStorage.save(newValue, byName: .isBiometryUsed) }
    }

    public var password: String? {
        get { keychainStorage.load(byName: .password) }
        set { keychainStorage.save(newValue, byName: .password) }
    }

    public var phoneNumber: String? {
        get { keychainStorage.load(byName: .phoneNumber) }
        set { keychainStorage.save(newValue, byName: .phoneNumber) }
    }

    public var firstName: String? {
        get { keychainStorage.load(byName: .phoneNumber) }
        set { keychainStorage.save(newValue, byName: .phoneNumber) }
    }

    public var surname: String? {
        get { keychainStorage.load(byName: .phoneNumber) }
        set { keychainStorage.save(newValue, byName: .phoneNumber) }
    }

    public var userType: UserType {
        get { keychainStorage.load(byName: .userType) ?? .companion }
        set { keychainStorage.save(newValue, byName: .userType) }
    }

    public var wasDriver: Bool {
        get { keychainStorage.load(byName: .wasDriver) ?? false }
        set { keychainStorage.save(newValue, byName: .wasDriver) }
    }
}
