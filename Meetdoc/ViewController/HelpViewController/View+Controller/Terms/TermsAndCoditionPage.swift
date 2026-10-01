 //
 //  TermsAndCoditionPage.swift
 //  Meetdoc
 //
 //  Created by Hitasoft on 08/01/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //
 
 import UIKit
 import WebKit
 
 class TermsAndCoditionPage: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var termsString = ""
    var titleString = ""
    let child = SpinnerViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: titleString) as? String ?? titleString, fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
//        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.checkReachability()
        self.view.addSubview(indicatorView)
        Utility().startAnimation(viewController: self)
        self.webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        // Change Text Color For Dark Theme
        let theme = appDelegate.checkTheme()
        var htmlString:String = "<font face=\(WebViewFont) size='10'>\(termsString)" //  color= 'white'
        if theme == "dark" {
            htmlString = "<font face=\(WebViewFont) size='10' color= 'white'>\(termsString)"
        }
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            htmlString = "<font face=\(WebViewFont) size='10'><div dir='rtl'>\(termsString)<div>"
            if theme == "dark" {
                htmlString = "<font face=\(WebViewFont) size='10' color= 'white'><div dir='rtl'>\(termsString)<div>"
            }
        }
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
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
    
 }
 extension TermsAndCoditionPage: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utility.shared.stopAnimation(viewController: self)
    }
 }
