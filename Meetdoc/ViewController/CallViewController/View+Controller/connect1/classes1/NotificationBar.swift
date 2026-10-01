//
//  NotificationBar.swift
//  sample-videochat-swift
//
//  Copyright © 2018 ConnectyCube. All rights reserved.
//

import Foundation
import SwiftMessages
import ConnectyCube

struct NotificationBar {
    
    static func showMessage(with message: ChatMessage) {
        
        
        /*
        UserDefaults.standard.set(message.senderID, forKey: "message.senderID")
        let user: User = (UserDefaults.standard.value(forKey: "message.senderID")) as! User
        
        

        if message.senderID != Profile.currentProfile?.id,
            let user: User = Cache.users.object(forKey: "\(message.senderID)") {
            
            //View setup
            let view: MessageView = MessageView.viewFromNib(layout: .cardView)
            view.button?.isHidden = true
            view.configureDropShadow()
            view.configureTheme(.info, iconStyle: .default)
            view.configureTheme(backgroundColor: #colorLiteral(red: 0.9539465085, green: 0.9814870651, blue: 1, alpha: 0.9533406826), foregroundColor: .black)
            view.configureContent(title: user.fullName!, body: message.text!)
           // view.iconImageView!.setImage(from: user.customData, title: user.fullName!)
            view.iconImageView!.layer.cornerRadius = view.iconImageView!.frame.size.width / 2
            view.bodyLabel?.numberOfLines = 2
            view.iconImageView!.isHidden = false
            //Cofnig setup
            var config = SwiftMessages.defaultConfig
            config.duration = .seconds(seconds: 3)
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar.rawValue)
            
            SwiftMessages.show(config: config, view: view)
        }
         */
    }
    
    static func showStatus(with text: String) {
        let view = MessageView.viewFromNib(layout: .statusLine)
//        view.backgroundView.backgroundColor = #colorLiteral(red: 0.2862856432, green: 0.2862856432, blue: 0.2862856432, alpha: 1)
//        view.bodyLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.backgroundView.backgroundColor = UIColor(named: "HeaderColor")
        view.bodyLabel?.textColor = UIColor(named: "HeaderColor")
        
        view.configureContent(body: text)
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level(rawValue: UIWindow.Level.normal.rawValue) ?? .normal)
        config.preferredStatusBarStyle = .lightContent
        config.duration = .forever
        SwiftMessages.show(config: config, view: view)
    }
    
    static func hideAll() {
        SwiftMessages.hideAll()
    }
}
