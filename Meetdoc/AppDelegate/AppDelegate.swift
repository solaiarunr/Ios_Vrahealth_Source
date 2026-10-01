  //
  //  AppDelegate.swift
  //  Meetdoc
  //
  //  Created by BTMani on 21/03/18.
  //  Copyright © 2018 BTMani. All rights reserved.
  //
  
  import UIKit
  import GooglePlaces
  import GoogleMaps
  import FBSDKLoginKit
  import FBSDKShareKit
  import GoogleSignIn
  import FirebaseUI
  import Stripe
  import SafariServices
  import FirebaseMessaging
  import SwiftyJSON
  import IQKeyboardManagerSwift
  import PushKit
  import CallKit
  import Firebase
  import GoogleMobileAds
  import FirebaseCore
import ConnectyCube
import ConnectyCubeCalls
import ClockKit
import ZegoUIKitPrebuiltCall
//import ZegoUIKitSignalingPlugin
  @UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CallClientDelegate, CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("just")
    }
    
    var window: UIWindow?
    var windowWidth = CGFloat()
    var windowHeight = CGFloat()
    var SearchResultListArray = NSMutableArray()
    var savedPageArray = NSMutableArray()
    var tempDetailsDict = NSMutableDictionary()
    var fbUserDetailDict = NSMutableDictionary()
    var FilterDetailDict = NSMutableDictionary()
    var delegateUserDict  = NSMutableDictionary()
    var InProgressListDict  = NSMutableDictionary()
    var languageDict: [AnyHashable : Any]?
    var receiver_img = ""
    var caller_id = ""
    var call_id = ""
    var viewModel = CallViewModel()
    var viewModel1 = BookingHistoryViewModel()
    var bookingResultModel: BookingHistoryResultModel?
    var adminData: AdminDataModel?
    //    var suggestionListDict = NSMutableArray()
    // CALLKIT
    var provider: CXProvider!
    static let providerConfiguration: CXProviderConfiguration = {
        let localizedName = NSLocalizedString("Calling From", comment: "VRA HEALTH")
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportsVideo = true
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        return providerConfiguration
    }()
    var baseUUId = UUID()
    var callController = CXCallController()
    var isAlreadyInCall = false
    var callNotifyDict: JSON!
      //connectycube
      var myNumber : NSNumber!

      public var session: CallSession?
      //public var callUUID: UUID?
      var callUUID : UUID?

      public var pushRegistry: PKPushRegistry!
      public var backgroundTask: UIBackgroundTaskIdentifier!
      
      var callModel = SocketCallModel()
      var callername = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //launch delay
        FirebaseApp.configure()
  //      self.callinit()
        Thread.sleep(forTimeInterval: 3.0)
        UIApplication.shared.isIdleTimerDisabled = true
        UserDefaults.standard.set(APP_RTC_URL, forKey: "web_rtc_web")
        //connectycube
        Settings.applicationID = 6032
        Settings.authKey = "VJ2pjHZqYcPSN9P"
        Settings.authSecret = "ngZLFH2U7ctQ4Nc"
        Settings.accountKey = "LJrmiaPM9ks5rsmZQc3f"
        Settings.autoReconnectEnabled = true
        Settings.logLevel = .nothing
        CallConfig.setLogLevel(.nothing)
        CallRemoteVideoView.preferMetal = false
        
        CallClient.initializeRTC()
        Profile.load()
        if Profile.currentProfile != nil {
            /*
            CallsApp.logOut {
                print("successfully connectycube logged out in as meet")
            }
            */
           CallsApp.connect()
        }
        SocketClass.sharedInstance.connect()
        SocketClass.sharedInstance.delegate1 = self
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
//        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_KEY
        
        self.languageAndCurrency()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses  = [InviteFriends.self]
        self.registerForPushNotification(application)
        self.voipRegistration()
        Messaging.messaging().delegate = self
        self.checkNetworkStatus()
        Utility.shared.configureLanguage()
        DatePickerData.shared.initDates()
        self.loadAdminData()
        if #available(iOS 15, *)
             {
               let appearance = UINavigationBarAppearance()
               appearance.configureWithOpaqueBackground()
               appearance.backgroundColor = UIColor(named: "AppColor")
               appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
               UINavigationBar.appearance().standardAppearance = appearance
               UINavigationBar.appearance().scrollEdgeAppearance = appearance
             }
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        self.changeTheme()
        return true
    }
    func loadAdminData() {
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = getLanguage["done"] ?? "done"
        DispatchQueue.main.async {
            if (UserDefaultModule.shared.getLoginData().userId ?? "") != "" {
                if (UserDefaultModule.shared.getLoginData().userId ?? "") == "1"{
                    let viewModel1 = SettingViewModel()
                    viewModel1.getAdminData(user_id: (UserDefaultModule().getCurrentUserID() as String? ?? ""), onSuccess: { (success) in
                        print(success)
                        self.adminData = viewModel1.adminData
                    }) { (fail) in
                        print(fail)
                    }
                }else{
                    SettingViewModel().getAdminData(user_id: (UserDefaultModule().getCurrentUserID() as String? ?? ""), onSuccess: { (success) in
                        print(success)
                        self.callinit()
                    }) { (fail) in
                        print(fail)
                    }
                }
            }
        }
    }
    func changeTheme() {
        if #available(iOS 13.0, *) {
            let theme = UserDefaultModule.shared.getAppTheme()
            if  theme.lowercased() == "light"{
                window!.overrideUserInterfaceStyle = .light
            }
            else if theme.lowercased() == "dark"{
                window!.overrideUserInterfaceStyle = .dark
            }
            else {
                if UITraitCollection.current.userInterfaceStyle == .light {
                    window!.overrideUserInterfaceStyle = .light
                }
                else{
                    window!.overrideUserInterfaceStyle = .dark
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    func checkTheme() -> String{
        if #available(iOS 13.0, *) {
            let theme = UserDefaultModule.shared.getAppTheme()
            if  theme.lowercased() != "light" || theme.lowercased() != "dark"{
                if UITraitCollection.current.userInterfaceStyle == .light {
                    return "light"
                }
                else{
                    return "dark"
                }
            }
            else {
                return theme
            }
        }
        else {
            return "light"
        }
        
    }
    //MARK: ZEGO CALLFUNCTION
    func callinit(){
        if UserDefaultModule.shared.getLoginData().userId != "1" && UserDefaults.standard.value(forKey: "zego_appId") as? UInt32 != nil {
            let appID: UInt32 = UserDefaults.standard.value(forKey: "zego_appId") as! UInt32
            let appSign: String = UserDefaults.standard.value(forKey: "zego_appSignin") as! String
            //        let appID: UInt32 = 567721591
            //        let appSign: String = "cbbe7ec5c377afb9232c8f1076c5320e7b63b809d3a2a93eee115fd93f25e2a1"
            print("ZEGOAPPID:\(UserDefaults.standard.value(forKey: "zego_appId") as! UInt32)")
            print("ZEGOAPPSIGNIN:\(UserDefaults.standard.value(forKey: "zego_appSignin") as! String)")
            print("ZEGOAPPRESOURCEID:\(UserDefaults.standard.value(forKey: "zego_resourceID") as! String)")
            let config: ZegoUIKitPrebuiltCallInvitationConfig = ZegoUIKitPrebuiltCallInvitationConfig(notifyWhenAppRunningInBackgroundOrQuit: true, isSandboxEnvironment: false)
            var userName = String()
            if UserDefaultModule.shared.getLoginData().type == "doctor"{
                userName = "Dr.\(UserDefaultModule.shared.getLoginData().firstName ?? "")"
            }else{
                userName = UserDefaultModule.shared.getLoginData().firstName ?? ""
            }
            let selfUserID: String = UserDefaultModule.shared.getLoginData().userId ?? ""
            ZegoUIKitPrebuiltCallInvitationService.shared.initWithAppID(appID, appSign: appSign, userID: selfUserID, userName: userName, config: config)
            print("BOOKINGID:\(UserDefaults.standard.value(forKey: "BookingID") ?? "")")
            print("RECEIVERID:\(UserDefaults.standard.value(forKey: "ReciverID") ?? "")")
        }
    }
    //MARK: Register for push notification
    func registerForPushNotification(_ application: UIApplication)  {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    // Register for VoIP notifications
    func voipRegistration() {
        
        // Create a push registry object
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
        self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        self.setCallKit()
    }
    func setCallKit() {
        // Create the provider and attach the custom delegate object
        // used by the app to respond to updates.
        self.provider = CXProvider(configuration: type(of: self).providerConfiguration)
        self.provider.setDelegate(self, queue: nil)
//        _ = CallKitAdapter.configuration()
    }
    func checkNetworkStatus() {
        do {
            try Network.reachability = Reachability(hostname: webURL)
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
    }
    func languageAndCurrency(){
        
        if (UserDefaultModule().getAppLanguage().isEmpty)
        {
            self.setLanguage(languageName: DEFAULT_LANGUAGE)
        }
        else{
            let language = UserDefaultModule().getAppLanguage()
            self.setLanguage(languageName: language)
        }
    }
    func setAppLanguage(_ vc: UIViewController){
        UserDefaultModule().setAppLanguage(language: UserDefaultModule().getAppLanguage())
        setInitialViewController(initialView: vc)
    }
    func setLanguage(languageName: String){
        UserDefaultModule().setAppLanguage(language: languageName)
        Utility.shared.configureLanguage()
        window = UIWindow(frame: UIScreen.main.bounds)
        windowWidth = (window?.frame.size.width)!
        windowHeight = (window?.frame.size.height)!
        print(windowWidth)
        if (UserDefaultModule().getCurrentUserID() != nil){
//            SwiftGoogleTranslate.shared.selectdLanguage = UserDefaultModule.shared.getChatLanguage()
            if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor" {
                setInitialViewController(initialView: DoctorTabViewController())
            }
            else if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "digitalclinic" {
                self.setInitialViewController(initialView: DCTabbarViewController())
            }
            else {
                self.setInitialViewController(initialView: UserTabbarController())
            }
        }
        else{
//            self.setInitialViewController(initialView: HomeLogin())
            self.setInitialViewController(initialView: UserSigninViewController())
//            setInitialViewController(initialView: UserTabbarController())
        }
        performSelector(inBackground: #selector(self.getUserProfileData), with: nil)
    }
    
    func setInitialViewController(initialView: UIViewController)
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = initialView
        NCTRL = UINavigationController(rootViewController: homeViewController)
        NCTRL.navigationBar.barStyle = .blackTranslucent
        NCTRL.navigationBar.barTintColor = UIColor(named: "AppColor") ?? .white
        window!.rootViewController = NCTRL
        window!.makeKeyAndVisible()
        self.changeTheme()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any)-> Bool{
        if ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation){
            return true
        }
        else if (((GIDSignIn.sharedInstance.handle(url))) != nil){
            return true
        }
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CallClient.initializeRTC()
        if Profile.currentProfile != nil {
           Profile.load()
           CallsApp.connect()
        }
        SocketClass.sharedInstance.connect()
        self.callinit()
        print("BACKGROUND")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        CallClient.initializeRTC()
        if Profile.currentProfile != nil {
           Profile.load()
           CallsApp.connect()
        }
        SocketClass.sharedInstance.connect()
   //     DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.callinit()
            print("FOREGROUND")
   //     }
//        SocketClass.sharedInstance.connect()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        CallClient.initializeRTC()
        if Profile.currentProfile != nil {
        Profile.load()
        CallsApp.connect()
        }
        SocketClass.sharedInstance.connect()
        self.callinit()
        print("BECOMEACTIVE")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
      func handleIncomingSession(_ session: CallSession) {
          print("handle session for call1:\(session)")
          self.session = session
          self.callUUID = UUID()
          
          //changes
          var opponentIDs: [Int] = [session.initiatorID.intValue]
        
          for userID in session.opponentsIDs
          {
              guard userID.uintValue != Profile.currentProfile!.id else
              {
                  continue
              }
              opponentIDs.append(userID.intValue)
          }
          
              CallKitAdapter.shared.callerName = self.callername
          
              CallKitAdapter.shared.reportIncomingCall(with: opponentIDs, session: session, uuid: self.callUUID!, onAcceptAction: {
                  
                  let callVC =  CallViewController1()
//                  callVC.UserNameLbl.text = self.callername
                  callVC.userName = self.callername
                  callVC.session = self.session
                  callVC.callUUID = self.callUUID
                  callVC.user_img = self.receiver_img
                  callVC.modalPresentationStyle = .fullScreen
                  self.window!.makeKeyAndVisible()
                  self.window?.rootViewController?.present(callVC, animated: true, completion: nil)
           
                  //self.performSegue(withIdentifier: Segues.callSceneID, sender: self.callUUID)
              })
           
      }


    func applicationWillTerminate(_ application: UIApplication) {
        self.callinit()
        print("TERMINATE")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @objc func getUserProfileData()
    {
        if (UserDefaultModule().getCurrentUserID() != nil){
            let requestDict = NSMutableDictionary.init()
            requestDict.setValue(UserDefaultModule().getCurrentUserID(), forKey: "user_id")
            
            let getsearchData = CallParsingFunction()
            getsearchData.getUserProfileDetails(user_id: (UserDefaultModule().getCurrentUserID() as String? ?? ""), onSuccess:{
                response in
                print(response)
                self.delegateUserDict.removeAllObjects()
                if response.object(forKey: "result") != nil {
                    self.delegateUserDict.addEntries(from: response.object(forKey: "result") as! [AnyHashable : Any])
                    print(self.delegateUserDict)
                }
                else {
                    let alertController = UIAlertController(title: "VRA HEALTH", message: response.object(forKey: "message") as? String ?? "", preferredStyle: .actionSheet)
                    let okAction = UIAlertAction(title: getLanguage["OK"] ?? "", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        self.setInitialViewController(initialView: UserSigninViewController())
                    }
                    
                    alertController.addAction(okAction)
                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }, onFailure: {errorResponse in
                //            Utility().stopAnimation(viewController: self)
                print(errorResponse ?? "Error")
            })
        }
    }
    
  }
  
  extension AppDelegate: UNUserNotificationCenterDelegate,MessagingDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let jsonDict = JSON(response.notification.request.content.userInfo)
        print(jsonDict)
//        let type = jsonDict["gcm.notification.type"].stringValue

//        let notificationData = JSON(userInfo)
        print(" NOTIFICATION \(jsonDict["gcm.notification.message"].stringValue)")
        print(" NOTIFICATION1 \(jsonDict["gcm.message"].stringValue)")
        print(" NOTIFICATION2 \(jsonDict["message"].stringValue)")

        if let message = self.stringToJSON(jStr: jsonDict["message"].stringValue) {
            if message["trigger_type"].stringValue == "request" {
                let pageObj = BookingDetailsViewController()
                pageObj.isForCall = true
                pageObj.type = (UserDefaultModule.shared.getLoginData().type ?? "").lowercased()
                pageObj.booking_id = message["room_id"].stringValue
                setInitialViewController(initialView: pageObj)
            }
            else {
                if message["type"].stringValue == "chat"{
                    let pageObj = ChatViewController()
                    pageObj.isFromPushNotification = true
                    pageObj.id = message["id"].stringValue
                    setInitialViewController(initialView: pageObj)
                }
                else if message["type"].stringValue == "review"{
                    let pageObj = ReviewPage()
                    setInitialViewController(initialView: pageObj)
                }
                else if message["type"].stringValue.lowercased() == "accepted" || message["type"].stringValue.lowercased() == "cancelled" || message["type"].stringValue.lowercased() == "refunded" || message["type"].stringValue.lowercased() == "declined" || message["type"].stringValue.lowercased() == "paid" || message["type"].stringValue.lowercased() == "completed" || message["type"].stringValue.lowercased() == "request" || message["type"].stringValue.lowercased() == "pending" || message["type"].stringValue.lowercased() == "reservation"{
                    let pageObj = BookingDetailsViewController()
                    pageObj.type = (UserDefaultModule.shared.getLoginData().type ?? "").lowercased()
                    pageObj.isForCall = true
                    pageObj.booking_id = message["id"].stringValue
                    setInitialViewController(initialView: pageObj)
                }
                else {
                    let pageNaviObj = NotificationPage()
                    pageNaviObj.isFromAppdelegate = true
                    setInitialViewController(initialView: pageNaviObj)
                }
            }
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if DEBUG
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        #else
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
        #endif
//        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        ZegoUIKitPrebuiltCallInvitationService.setRemoteNotificationsDeviceToken(deviceToken)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase Token: \(fcmToken)")
        UserDefaultModule.shared.setFCMToken(fcm_token: fcmToken)
        // register token for pushnotification
        if UserDefaultModule.shared.getFCMToken() != nil && (UserDefaultModule().getCurrentUserID() != nil) {
            Utility.shared.registerPushServices()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let notificationData = JSON(notification.request.content.userInfo)
        print(" NOTIFICATION \(notificationData)")
        let jsonData = notificationData["message"].stringValue
        if let message = self.stringToJSON(jStr: jsonData) {
            if (UIApplication.shared.keyWindow?.rootViewController as? UITabBarController) != nil {
            } else if let navigationCtrl = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                if let currentVC = navigationCtrl.visibleViewController as? ChatViewController {
                    if currentVC.id == (message["id"].stringValue) {
                     }
                    else {
                        completionHandler([.alert, .badge, .sound])
                    }
                }
                else {
                    completionHandler([.alert, .badge, .sound])
                }
            }
        }
    }
    
    func stringToJSON(jStr: String) -> JSON? {
        let data = Data(jStr.utf8)
        
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                return JSON(json)
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return nil
    }
  }
  //MARK: - PKPushRegistryDelegate
  extension AppDelegate : PKPushRegistryDelegate {
    
    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        //         let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        let deviceToken = credentials.token.hexString
        print("PUSH KIT TOKEN \(deviceToken)")
        UserDefaultModule.shared.setPushToken(fcm_token: deviceToken)
        if ( UserDefaultModule.shared.getFCMToken() != nil && UserDefaultModule.shared.getPushToken() != nil) {
            Utility.shared.registerPushServices()
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
    }
      func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("PUSHKIT NOTIFICATION \(payload.dictionaryPayload)")
        if type == .voIP {
            let jsonDict = JSON(payload.dictionaryPayload)
            self.callNotifyDict = jsonDict
            if callNotifyDict["aps","type"].stringValue == "call" {
                self.baseUUId = UUID()
                let update = CXCallUpdate()
                update.remoteHandle = CXHandle(type: .generic, value: "VRA HEALTH")
                update.hasVideo = true
                isAlreadyInCall = true
                provider.reportNewIncomingCall(with: baseUUId, update: update, completion: { error in })
                let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                print("hello")
                if var topController = keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
//                        if topController.isKind(of: CallViewController.self) {
//                            self.endCall()
//                        }
                    }
                }
//                let id = callNotifyDict["aps","connecty_userId"].stringValue
//                let convertint_Id = UInt(id)
//                let user = User()
//                user.id = convertint_Id ?? 0
//                user.email = callNotifyDict["aps","email"].stringValue
//                user.login = callNotifyDict["aps","connecty_userlogin"].stringValue
//                user.fullName = callNotifyDict["aps","receiver_name"].stringValue
//                user.password = callNotifyDict["aps","connecty_password"].stringValue
//                self.callername = "\(callNotifyDict["aps","user_name"].stringValue)"
//                print("The delegate is not called")
//                Profile.currentProfile = user
//                CallsApp.connect()
//                CallClient.instance().add(self)
            
            }
            else
            {
                if self.callUUID != nil{
                    CallKitAdapter.shared.endCall(with: self.callUUID!)
                    self.session = nil
                    self.callUUID = nil
                }
            }
        }
    }
  }

  extension SFSafariViewController {
    override open var modalPresentationStyle: UIModalPresentationStyle {
        get { return .fullScreen}
        set { super.modalPresentationStyle = newValue }
    }
  }
  extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
  }
//connectycube
extension AppDelegate {
    
    func didReceiveNewSession(_ session: CallSession, userInfo: [String : String]? = nil) {
        print("WORKING FINE .........")
        if self.session != nil
        {
            // already having a session
            session.rejectCall(nil)
            return;
        }
        print("handle session for call:\(session)")
        handleIncomingSession(session)
    }
    func sessionDidClose(_ session: CallSession) {
        guard self.session == session else {
            return
        }
        if self.backgroundTask != UIBackgroundTaskIdentifier.invalid
        {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0)
        {
            if UIApplication.shared.applicationState == .background
                && self.backgroundTask == UIBackgroundTaskIdentifier.invalid {
                // dispatching chat disconnect in 1 second so message about call end
                // from webrtc does not cut mid sending
                // checking for background task being invalid though, to avoid disconnecting
                // from chat when another call has already being received in background
               // Chat.instance.disconnect(completionBlock: nil)
            }
        }
        CallKitAdapter.shared.endCall(with: self.callUUID!)
//        self.callUUID = nil
        self.session = nil
    }
}
extension AppDelegate: socketClassDelegate1 {
    func gotSocketInfo1(dict: Array<Any>, type: String) {
        if type == "initiatecall" {
            let typingRes = SocketCallModel.init(fromJson: JSON(dict.first))
            self.callModel = typingRes
        }else if type == "acceptcall" {
            let typingRes = SocketCallModel.init(fromJson: JSON(dict.first))
            self.callModel = typingRes
            self.caller_id = self.callModel.caller_id
            self.call_id = self.callModel.call_id
        }else if type == "endcall" {
            let typingRes = SocketCallModel.init(fromJson: JSON(dict.first))
            self.callModel = typingRes
            print("CALLERID:\(self.caller_id)")
        }
    }
}

extension AppDelegate: ZegoUIKitPrebuiltCallInvitationServiceDelegate, UITextFieldDelegate, ZegoSendCallInvitationButtonDelegate {

    func onPressed(_ errorCode: Int, errorMessage: String?, errorInvitees: [ZegoUIKitPrebuiltCall.ZegoCallUser]?) {
        var toastMessage: String?
        if errorCode != 0 {
            toastMessage = String(format: "Failed to send a call invitation. code: %d,message:%@",errorCode, errorMessage ?? "")
      //      self.view.makeToast(toastMessage, duration: 2.0, position: .center)
        } else {
            let errorInvitees: [ZegoCallUser]? = errorInvitees
            guard let errorInvitees = errorInvitees else { return }
            var errorUsers: String = ""
            var index: Int = 0
            for user in errorInvitees {
                if index > 4 {
                    errorUsers.append(contentsOf: "...")
                    break
                }
                if index == 0 {
                    errorUsers.append(contentsOf: String(format: "%@", user.id ?? ""))
                } else {
                    errorUsers.append(contentsOf: String(format: ",%@", user.id ?? ""))
                }
                index = index + 1
            }
            toastMessage = String(format: "User doesn't exist or is offline: %@", errorUsers)
            if errorInvitees.count > 0 {
                getCurrentViewController()?.view.makeToast(toastMessage, duration: 2.0, position: .center)
            }
        }
    }

    //MARK: -ZegoUIKitPrebuiltCallInvitationServiceDelegate
    func requireConfig(_ data: ZegoCallInvitationData) -> ZegoUIKitPrebuiltCallConfig {
        if data.type == .voiceCall {
            if data.invitees?.count ?? 0 > 1 {
                let config = ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                config.topMenuBarConfig.isVisible = true
//                config.topMenuBarConfig.buttons = [.minimizingButton]
                return config
            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
                config.topMenuBarConfig.isVisible = true
//                config.topMenuBarConfig.buttons = [.minimizingButton]
                return config
            }
        } else {
            if data.invitees?.count ?? 0 > 1 {
                let config = ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                config.topMenuBarConfig.isVisible = true
//                config.topMenuBarConfig.buttons = [.minimizingButton]
                return config
            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                config.topMenuBarConfig.isVisible = true
//                config.topMenuBarConfig.buttons = [.minimizingButton]
                return config
            }
        }
    }

    func onIncomingCallDeclineButtonPressed() {

    }
    func onIncomingCallAcceptButtonPressed() {

    }
    func onOutgoingCallCancelButtonPressed() {
        print("TESTING:\(self.bookingResultModel?.bookingId ?? "")")
    }

    func onIncomingCallReceived(_ callID: String, caller: ZegoCallUser, callType: ZegoCallType, callees: [ZegoCallUser]?) {
        print("TESTING:\(self.bookingResultModel?.bookingId ?? "")")
    }
    func onIncomingCallCanceled(_ callID: String, caller: ZegoCallUser) {

    }
    func onOutgoingCallAccepted(_ callID: String, callee: ZegoCallUser) {

    }
    func onOutgoingCallRejectedCauseBusy(_ callID: String, callee: ZegoCallUser) {

    }
    func onOutgoingCallDeclined(_ callID: String, callee: ZegoCallUser) {

    }
    func onIncomingCallTimeout(_ callID: String,  caller: ZegoCallUser){

    }
    func onOutgoingCallTimeout(_ callID: String, callees: [ZegoCallUser]) {

    }

    func getCurrentViewController() -> (UIViewController?) {
       var window = UIApplication.shared.keyWindow
       if window?.windowLevel != UIWindow.Level.normal{
         let windows = UIApplication.shared.windows
         for  windowTemp in windows{
           if windowTemp.windowLevel == UIWindow.Level.normal{
              window = windowTemp
              break
            }
          }
        }
       let vc = window?.rootViewController
       return currentViewController(vc)
    }

    func currentViewController(_ vc :UIViewController?) -> UIViewController? {
       if vc == nil {
          return nil
       }
       if let presentVC = vc?.presentedViewController {
          return currentViewController(presentVC)
       }
       else if let tabVC = vc as? UITabBarController {
          if let selectVC = tabVC.selectedViewController {
              return currentViewController(selectVC)
           }
           return nil
        }
        else if let naiVC = vc as? UINavigationController {
           return currentViewController(naiVC.visibleViewController)
        }
        else {
           return vc
        }
     }
}

  
