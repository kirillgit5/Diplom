import Foundation
import KeychainAccess

public protocol KeychainStorageAbstract: AnyObject {
    func contains(byName name: KeychainStorage.Name) -> Bool
    func load<Type>(byName name: KeychainStorage.Name) -> Type?
    func save(_ value: Any?, byName name: KeychainStorage.Name)
    func delete(byName name: KeychainStorage.Name)
    func flushStorage()
}

public enum KeychainStorageName: String {
    case refreshToken
    case isBiometryUsed
    case password
    case phoneNumber
    case firstName
    case userType
    case wasDriver
}

public final class KeychainStorage: KeychainStorageAbstract {
    public typealias Name = KeychainStorageName

    private static let keychain: Keychain = {
        guard let service = Bundle.main.infoDictionary?[String(kCFBundleIdentifierKey)] as? String else {
            fatalError("Failed to resolve bundle identifier from .plist dict")
        }

        return Keychain(service: service)
            .accessibility(.whenUnlockedThisDeviceOnly)
    }()

    private var keychain: Keychain {
        KeychainStorage.keychain
    }

    public init() { }

    public func contains(byName name: Name) -> Bool {
        let name = name.rawValue
        do {
            if let data = try keychain.getData(name),
               let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any] {
                return dictionary[name] != nil
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return false
    }

    public func load<Type>(byName name: Name) -> Type? {
        let name = name.rawValue
        do {
            if let data = try keychain.getData(name),
               let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any],
               let value = dictionary[name] as? Type {
                return value
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return nil
    }

    public func save(_ value: Any?, byName name: Name) {
        guard let value = value else {
            delete(byName: name)
            return
        }
        let name = name.rawValue
        do {
            let data = [name: value]
            try keychain.set(NSKeyedArchiver.archivedData(withRootObject: data,
                                                          requiringSecureCoding: false),
                             key: name)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    public func delete(byName name: Name) {
        let name = name.rawValue
        do {
            try keychain.remove(name)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    public func flushStorage() {
        do {
            try keychain.removeAll()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
