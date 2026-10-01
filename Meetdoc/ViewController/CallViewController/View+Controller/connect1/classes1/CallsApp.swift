//
//  CallsApp.swift
//  sample-videochat-swift
//
//  Copyright © 2018 ConnectyCube. All rights reserved.
//

import ConnectyCube
//import YapDatabase
import UIKit

struct CallsApp {
    /// Users service
    static let users = Users()
}

// MARK: Connect / Disconnect

extension CallsApp {
    
    /// Connect to chat / Login if needed / Dialogs updates
    static func connect() {
        //Validate session
        let user: User = Profile.currentProfile!
        /*
         //need to work while working call related functionalities
        print("tata:\(user)")
        user.login = 
        user.fullName =
        user.password =
        user.id =
        */
        
        print(user)
        if Session.current.currentUserID == 0 || Session.current.tokenHasExpired {
            users.login(withUser: user) { }
        }
        
        //NotificationBar.showStatus(with: "Connecting...")
        Chat.instance.connect(withUserID: user.id, password: user.password!){ (error) in
        
            NotificationBar.hideAll()
        }
    }
    
    /// Logout from app
    ///
    /// - Parameter completion: completion handler
    static func logOut(completion: @escaping () -> Void) {
        Chat.instance.disconnect(completionBlock: { (error) in
            // Clearing cache
            //Cache.removeAll()
            Profile.currentProfile = nil
            
        })
        
        Request.unregisterSubscription(forUniqueDeviceIdentifier: UIDevice.current.identifierForVendor!.uuidString, successBlock: {
            self.requestLogout(completion: completion)
        }) { (error) in
            self.requestLogout(completion: completion)
        }
        
    }
    
    // Private request
    static private func requestLogout(completion: @escaping () -> Void) {
        Request.logOut(successBlock: {
            completion()
        }) { (error) in
            completion()
        }
    }
}


/*
struct Cache {
    
    static let keyValue = Storage(withFileName:"storage.sqlite")
    static let users = ObservableStorage(withFileName: "users.sqlite")
    static let dialogs = ObservableStorage(withFileName: "dialogs.sqlite")
    static let messages = ObservableStorage(withFileName: "messages.sqlite")
    
    static func removeAll()
    {
        
        keyValue.removeAllObjectsInAllCollections()
        users.removeAllObjectsInAllCollections()
        dialogs.removeAllObjectsInAllCollections()
        messages.removeAllObjectsInAllCollections()
        
    }
}

*/

/*
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
*/
