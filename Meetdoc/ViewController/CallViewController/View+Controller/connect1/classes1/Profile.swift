//
//  Profile.swift
//  sample-videochat-swift
//
//  Copyright © 2018 ConnectyCube. All rights reserved.
//

import ConnectyCube
import ConnectyCubeCalls


class Profile {
    
    static func load() {
        
        if let mediaStreamConfiguration = mediaStreamConfiguration
        {
            CallConfig.setMediaStreamConfiguration(mediaStreamConfiguration)
        }
        else
        {
            mediaStreamConfiguration = CallConfig.mediaStreamConfiguration()
        }
        
        if let metalDrawing = metalDrawing
        {
            CallRemoteVideoView.preferMetal = metalDrawing
        }
        else
        {
            metalDrawing = CallRemoteVideoView.preferMetal
        }
        if videoFormat == nil
        {
            let videoFormat = CallVideoFormat()
           // videoFormat.frameRate = 21
            videoFormat.frameRate = 30
            videoFormat.pixelFormat = .format420f
            videoFormat.width = 640
            videoFormat.height = 480
            self.videoFormat = videoFormat
        }
    }
    
    /// Current User profile
    static var currentProfile : User?
    {
        /*
        set {
            
            UserDefaults.standard.set(newValue!, forKey: "currentProfile")
            
        }
        get {
            
            let user: User? =  ((UserDefaults.standard.value(forKey: "currentProfile")) as! User)
            user?.password = DefaultUserPassword
            return user
            
        }
        */
        
        set
        {
            guard let val = newValue else {return}
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: val, requiringSecureCoding: false)
            {
                let defaults = UserDefaults.standard
                defaults.set(savedData, forKey: "currentProfile")
            }
        }
        get
        {
            return UserDefaultModule.shared.getCurrentProfile()
        }
        
        
        
        /*
         UserDefaults.standard.set(self.currentProfile, forKey: "currentProfile")
         
         //set {Cache.keyValue.insert(newValue!, forKey: "currentProfile")}
         //  get {
         
         let user: User? = (UserDefaults.standard.value(forKey: "currentProfile") as! User)
         //let user: User? = Cache.keyValue.object(forKey: "currentProfile")
         user?.password = DefaultUserPassword
         return user
         //  }
         */
    }
    
    /// Last users fetch date
    static var lastUsersFetchDate : Date?
    {
        
        set {
            UserDefaults.standard.set(newValue!, forKey: "lastUsersFetchDate")
        }
        get {
            return ((UserDefaults.standard.value(forKey: "lastUsersFetchDate")) as! Date)
        }
        
        /*
         UserDefaults.standard.set(self.lastUsersFetchDate, forKey: "lastUsersFetchDate")
         
         return ((UserDefaults.standard.value(forKey: "lastUsersFetchDate")) as! Date)
         */
        
        /*
         set {Cache.keyValue.insert(newValue!, forKey: "lastUsersFetchDate")}
         get {return Cache.keyValue.object(forKey: "lastUsersFetchDate")}
         */
    }
    
    /// Last dialogs fetch date
    static var lastDialogsFetchDate : Date? {
        
        
        set {
            UserDefaults.standard.set(newValue!, forKey: "lastDialogsFetchDate")
        }
        get {
            return ((UserDefaults.standard.value(forKey: "lastDialogsFetchDate")) as! Date)
        }
        
        
        /*
         
         UserDefaults.standard.set(self.lastDialogsFetchDate, forKey: "lastDialogsFetchDate")
         
         return ((UserDefaults.standard.value(forKey: "lastDialogsFetchDate")) as! Date)
         */
        
        /*
         
         set {Cache.keyValue.insert(newValue!, forKey: "lastDialogsFetchDate")}
         get {return Cache.keyValue.object(forKey: "lastDialogsFetchDate")}
         */
        
    }
    
    /// Video format
    static var videoFormat : CallVideoFormat?
    {
        
        set {
            guard let val = newValue else {return}
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: val, requiringSecureCoding: false) {
                let defaults = UserDefaults.standard
                defaults.set(savedData, forKey: "videoFormat")
            }
        }
        get {
            return UserDefaultModule.shared.getVideo()
        }
        

        /*
        
        set
        {
            UserDefaults.standard.set(newValue!, forKey: "videoFormat")
        }
        get
        {
            return ((UserDefaults.standard.value(forKey: "videoFormat")) as? CallVideoFormat)
        }
        */
        /*
         UserDefaults.standard.set(self.videoFormat, forKey: "videoFormat")
         
         return ((UserDefaults.standard.value(forKey: "videoFormat")) as! CallVideoFormat)
         
         */
        
        /*
         set {Cache.keyValue.insert(newValue!, forKey: "videoFormat")}
         get {return Cache.keyValue.object(forKey: "videoFormat")}
         */
    }
    
    /// Metal drawing
    static var metalDrawing : Bool?
    {
        
        
        set {
            UserDefaults.standard.set(newValue!, forKey: "metalDrawing")
        }
        get {
            return ((UserDefaults.standard.value(forKey: "metalDrawing")) as? Bool) ?? false
        }
        
        
        /*
         UserDefaults.standard.set(self.metalDrawing, forKey: "metalDrawing")
         
         return ((UserDefaults.standard.value(forKey: "metalDrawing")) as! Bool)
         
         */
        
        /*
         set {Cache.keyValue.insert(newValue!, forKey: "metalDrawing")}
         get {return Cache.keyValue.object(forKey: "metalDrawing")}
         */
    }
    
    /// Media stream config
    static var mediaStreamConfiguration : CallMediaStreamConfiguration? {
        
        set {
            guard let val = newValue else {return}
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: val, requiringSecureCoding: false) {
                let defaults = UserDefaults.standard
                defaults.set(savedData, forKey: "mediaStreamConfiguration")
            }
        }
        get {
            return UserDefaultModule.shared.getData()
        }
        
        
        /*
         UserDefaults.standard.set(self.mediaStreamConfiguration, forKey: "mediaStreamConfiguration")
         
         return ((UserDefaults.standard.value(forKey: "mediaStreamConfiguration")) as! CallMediaStreamConfiguration)
         
         */
        
        /*
         
         set {Cache.keyValue.insert(newValue!, forKey: "mediaStreamConfiguration")}
         get {return Cache.keyValue.object(forKey: "mediaStreamConfiguration")}
         */
    }
    
}
