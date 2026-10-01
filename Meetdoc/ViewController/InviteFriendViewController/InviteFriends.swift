 //
 //  InviteFriends.swift
 //  Meetdoc
 //
 //  Created by HTS-SERVICETEAM on 31/10/18.
 //  Copyright © 2018 BTMani. All rights reserved.
 //

 import UIKit
 import ValidationComponents
 import KSTokenView

 class InviteFriends: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var tokenView: KSTokenView!
    @IBOutlet weak var inviteTitleLabel: UILabel!
    @IBOutlet weak var inviteDescLabel: UILabel!
    @IBOutlet weak var shareLinkButton: UIButton!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var terms_conditionBtn: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    
    var tokenValue: NSArray?
    var viewModel = SettingViewModel()
    let predicate = EmailValidationPredicate()
    var emailId: String?
    var parser: String?
    var loginData = [UserLoginResultModel]()
    var count: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.customUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func customUI() {
        self.loginData = [UserDefaultModule.shared.getLoginData()]
        self.view.addSubview(indicatorView)
        self.inviteDescLabel.config(color: UIColor(named: "primary_text") ?? .white, font: regularFont, align: .left, text: "invite_desc")
        
        self.shareLinkButton.cornerMiniumRadius()
        self.shareLinkButton.backgroundColor = UIColor(named: "AppColor") ?? .white
        self.shareLinkButton.config(color: UIColor(named: "White") ?? .white, font: fontRegular16, align: .center, title: "share_link")
        
        self.emailTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: UIFont(name: regularFontName, size: 18), align: .left, text: "email_invite")
        
        self.inviteButton.cornerMiniumRadius()
        self.inviteButton.backgroundColor = UIColor(named: "AppColor") ?? .white
        self.inviteButton.config(color: UIColor(named: "White") ?? .white, font: fontRegular16, align: .center, title: "invite")
        self.terms_conditionBtn.config(color: UIColor(named: "primary_text") ?? .white, font: regular14, align: .left, title: "terms")
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["invite_friends"] ?? "invite_friends", fColor: "White", fontName: fontRegular16, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.tokenView.delegate = self
        tokenView.promptText = ""
        self.tokenView.placeholder = Utility().language().value(forKey: "email_prompt") as? String ?? "email_prompt"
        self.tokenView.placeholderColor = UIColor(named: "primary_text") ?? .white
        self.tokenView.paddingX = 0
        self.tokenView.maxTokenLimit = -1
//        self.tokenView.searchResultBackgroundColor = UIColor.clear
        self.tokenView.tokenizingCharacters = [" ",","]
        self.tokenView.shouldHideSearchResultsOnSelect = true
//        self.tokenView.activityIndicatorColor = UIColor.gray
        self.tokenView.backgroundColor = UIColor.clear
        self.tokenView.searchResultHeight = 0.0
        self.tokenView.maximumHeight = 100
        self.tokenView.style = .squared
//        self.tokenView.placeholderColor = UIColor(named: "SubTitleColor") ?? .white
        self.tokenView.font = regular14!
        //         self.borderView.elevationEffect()
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            //            self.tokenView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.tokenView.isArabic = true
        }
        
    }
    
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func shareButtonAct(_ sender: UIButton) {
        let text = self.loginData.first?.referalUrl ?? ""
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        
        if let popoverController = vc.popoverPresentationController{
            popoverPresentationController?.sourceView = self.view
            popoverPresentationController?.sourceRect = self.view.bounds
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func inviteButtonAct(_ sender: UIButton) {
        if let emailId : String = self.emailId, emailId != "" {
            Utility().startAnimation(viewController: self)
            CallParsingFunction().getInviteFriendsData(user_id:  (UserDefaultModule().getCurrentUserID() as String? ?? ""), email_id: emailId, onSuccess: { (response) in
                let status:String = response.value(forKey: "status") as! String
                if status == "true" {
                    self.emailId = ""
                    self.view.makeToast(response.value(forKey: "message") as? String ?? "")
                    self.tokenView.deleteAllTokens()
                    Utility().stopAnimation(viewController: self)
                    self.tokenView.placeholder = Utility().language().value(forKey: "email_prompt") as? String ?? "email_prompt"
                    self.tokenView.becomeFirstResponder()
                    self.tokenView.resignFirstResponder()
                }
            }) { (error) in
                Utility().stopAnimation(viewController: self)
            }
        } else {
            self.view.endEditing(true)
            self.view.makeToast(Utility().language().value(forKey: "enter_email") as? String ?? "")
            print("error")
            Utility().stopAnimation(viewController: self)
        }
    }
    @IBAction func TermsButtonAct(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        sender.preventRepeatedPresses()
        self.viewModel.getAdminData(user_id: (UserDefaultModule().getCurrentUserID() as String? ?? ""), onSuccess: { (success) in
            if self.viewModel.adminData?.status ?? false{
                sender.isUserInteractionEnabled = true
                let pageObj = TermsAndCoditionPage()
                pageObj.titleString = getLanguage["terms"] ?? "terms"
                pageObj.termsString = (self.viewModel.adminData?.result.termsConditions.mainContent ?? "") + (self.viewModel.adminData?.result.termsConditions.subContent ?? "")
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else {
                sender.isUserInteractionEnabled = true
            }
        }) { (failure) in
            sender.isUserInteractionEnabled = true
        }
    }
 }
    
 
 extension InviteFriends: KSTokenViewDelegate {
    
     func tokenViewDidEndEditing(_ tokenView: KSTokenView) {
         if self.tokenView.tokens()?.count == 0{
             if self.tokenView.text != "" {
                 self.tokenView.text = self.tokenView.text
                 tokenView.addToken(KSToken(title: self.tokenView.text))
             }
         }
     }
     
     func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((Array<AnyObject>) -> Void)?) {
     }
     func tokenView(_ tokenView: KSTokenView, displayTitleForObject object: AnyObject) -> String {
         return ""
     }
     func tokenView(_ tokenView: KSTokenView, willAddToken token: KSToken) {
         if self.tokenView.tokens()?.count == 0{
             self.emailId = nil
         }
     }
     
     func tokenView(_ tokenView: KSTokenView, didAddToken token: KSToken) {
         print("token \(token)")
         let key = token.title
         if self.predicate.evaluate(with: key){
             self.tokenView.activityIndicatorColor = UIColor(named: "AppColor") ?? .white
             print("predicate.evaluate")
             if self.emailId == nil {
                 self.emailId = key
             }else{
                 self.emailId?.append(",")
                 self.emailId = (self.emailId! + key)
             }
             print(self.emailId!)
         }
         else{
             print("fail")
             self.tokenView.deleteLastToken()
         }
     }
     func tokenView(_ tokenView: KSTokenView, willDeleteToken token: KSToken) {
         print("token \(token)")
     }
     func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken) {
         let key:String = token.title
         let bfrcoma = (","+key)
         let aftComa = (key+",")
         
         print(bfrcoma)
         print(aftComa)
         
         if let range = self.emailId?.range(of: bfrcoma){
             self.emailId?.removeSubrange(range)
             print(key)
             print(self.emailId!)
         }else if let range = self.emailId?.range(of: aftComa){
             self.emailId?.removeSubrange(range)
             print(self.emailId!)
         }
         else if let range = self.emailId?.range(of: key){
             self.emailId?.removeSubrange(range)
         }
     }
  }
  
 extension UIButton {
    func preventRepeatedPresses(inNext seconds: Double = 1) {
           self.isUserInteractionEnabled = false
           DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
               self.isUserInteractionEnabled = true
        }
 }
 }
