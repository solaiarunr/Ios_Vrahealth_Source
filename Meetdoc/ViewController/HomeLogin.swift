//
//  HomeLogin.swift
//  Meetdoc
//
//  Created by HTS-105 on 06/06/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit


class HomeLogin: UIViewController {

    @IBOutlet weak var Doctor_signin: UIButton!
    @IBOutlet weak var Digitalclinic_signin: UIButton!
    @IBOutlet weak var User_signin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
       self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func customUI() {
        self.view.addSubview(indicatorView)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "AppColor") ?? .white
        self.Doctor_signin.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "doctor_signin")
        self.Doctor_signin.cornerMiniumRadius()
        self.Doctor_signin.backgroundColor = UIColor(named: "AppColor")
        self.Digitalclinic_signin.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "digitalclinic_signin")
        self.Digitalclinic_signin.cornerMiniumRadius()
        self.Digitalclinic_signin.backgroundColor = UIColor(named: "AppColor")
        self.User_signin.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "user_signin")
        self.User_signin.cornerMiniumRadius()
        self.User_signin.backgroundColor = UIColor(named: "AppColor")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func DoctorButtonAct(_ sender: UIButton) {
        let pageObj = DoctorSignInPage()
        pageObj.isFromUserSignin = true
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    @IBAction func DigitalClinicButtonAct(_ sender: UIButton) {
       
    }
    @IBAction func UserButtonAct(_ sender: UIButton) {
        let userObj = UserSigninViewController()
        self.navigationController?.pushViewController(userObj, animated: true)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
