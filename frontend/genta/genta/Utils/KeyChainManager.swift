
//  Created by Tony Avis on 12/26/23.

import SwiftUI

class KeyChainManager{
    
    enum KeyChainError : Error{
        case duplicateEntry
        case unknown(OSStatus)
        case notFound
        case errorCreatingToken
        case updateError
        case delete
    }
    
    
    //    static let server = "www.example.com"
    let account = "genta-app.com"
    let service = "token"
    
    static let shared = KeyChainManager()

    
    func upsert(
        token : String
    ) -> Bool {
        //        returns bool true if successful false if not succesfull
        print("Attempting to upsert token in Keychains")
        do{
            /*
             if the token doens't exist it will create it if it does exist it will update it
             */
            let tokenFound = search()
            if tokenFound{// update
                print("Token found updating it...")
                if update(token: token){
                    return true
                }
                throw KeyChainError.updateError
            }else{//create token
                print("Token not found creating it...")
                if save(token: token){
                    return true
                }
                throw KeyChainError.errorCreatingToken
            }
        }
        catch let err as KeyChainError{
            print("Err upserting token err:", err)
            switch err{
            case .errorCreatingToken:
                print("Error creating token")
            default:
                print("Unkown error occured")
            }
            return false
        }
        catch{
            print("An uncaught error occured when saving or updating when upserting")
            return false
        }
    }
    
    
    func save(
        token : String
    )-> Bool{
        //returns bool true if successful false if not succesfull
        do{
            //service, account, password, class
            let query : [String : Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service as AnyObject,
                //                kSecAttrServer : CFString server as CFString , error
                kSecAttrAccount as String: account as AnyObject,
                kSecValueData as String: token.data(using: .utf8) ?? Data() as AnyObject,
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            guard status != errSecDuplicateItem else {
                //            duplitcate item found when saving
                throw KeyChainError.duplicateEntry
            }
            
            guard status == errSecSuccess else{
                //            if any know were found that wasnt caught than this
                throw KeyChainError.unknown(status)
            }
            print("Saved data to keychain, status:", status)
            return true
        }catch{
            print("Error saving/updating token to keychains, err: ", error)
            return false
        }
    }
    
    func get()  -> (err: Bool, result: Data?) {
        /*
         unlike search this will retrieve the item
         */
        //service, account, password, class
        print("Attempting to retrieve data to keychain")
        let query : [String : AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne //return only one match
        ]
        var result: AnyObject?
        SecItemCopyMatching(
            query as CFDictionary,
            &result //should be data or nil if its successes in finding a match
        )
        if result == nil{
            print("Getting token from keychain returned nil")
            return (true, nil)
        }
        print("Successfully retrieved token from keychain")
        return (false, result as? Data)
    }
    
    func search()  -> Bool {
        //        returns bool true if successful false if not succesfull
        print("Searching for token in keychains")
        let query : [String : AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne //return only one match
        ]
        var result: AnyObject?
        SecItemCopyMatching(
            query as CFDictionary,
            &result //should be data or nil if its successes in finding a match
        )
        if result == nil{
            print("Token not in keychains")
            return false
        }
        print("Found token")
        return true
        //        return result as? Data
    }
    
    
    func update(token: String) -> Bool{
        //        returns bool true if successful false if not succesfull
        print("Attempting to update token")
        let query : [String : Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            //                kSecAttrServer : CFString server as CFString , error
            kSecAttrAccount as String: account as AnyObject,
        ]
        let status = SecItemUpdate(
            query as CFDictionary,
            [ kSecValueData as String: token.data(using: .utf8) ?? Data() ] as CFDictionary
        )
        print("status: ",status)
        guard status == errSecSuccess else{
            //            any errors
            return false
        }
        print("Updated token in keychains")
        return true
    }
    
    func delete() ->Bool{
        //        returns bool if successful or not
        print("Attempting to delete token from keychains")
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        print("Status from deleting token", status)
        if status == errSecSuccess {
            print("Token deleted successfully.")
            return true
        } else {
            print("Error deleting Token from Keychain. Status: \(status)")
            return false
        }
    }
}
