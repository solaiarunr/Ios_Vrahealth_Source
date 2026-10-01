//
//  ReviewViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 17/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Cosmos

class ReviewViewController: UIViewController {

    @IBOutlet weak var reviewView: UIView!
     @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ratingView: CosmosView!
     @IBOutlet weak var reviewCountLabel: UILabel!
 
    var keyboardHeight = Float(0)
    var viewModel = ReviewViewModel()
    var doctorData: DoctorResultModel?
    var reviewData: ReviewModel?
    var refreshChat: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.addSubview(indicatorView)
         self.checkReachability()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
         self.configUI()
    }
    override func viewWillDisappear(_ animated: Bool) {

        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    
 
    func configUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

//        self.navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor") ?? .white

        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "edit_review") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
         
            Utility().stopAnimation(viewController: self)
        
        self.navigationController?.customRightBarButtonView(title: Utility().language().value(forKey: "save") as? String ?? "" , fColor: "White", fontName: fontRegular16, imageName: "", isLeft: false, vc: self, transparantView: false)

          self.reviewCountLabel.config(color: UIColor(named: "secondary_text") ?? .white, font: regular17, align: .left, text: "out_of")
 //        self.ratingView.rating = 0
        self.textView.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .left, text: "write_your_review")
        self.textView.textColor = UIColor(named: "fifth_text") ?? .white
        self.textView.textContainerInset = UIEdgeInsets.zero
        self.textView.textContainer.lineFragmentPadding = 10
        self.reviewView.elevationEffect()
        self.textView.addDoneButtonOnKeyboard()
        self.ratingView.rating = Double(self.reviewData?.reviewRating ?? "0") ?? Double(0)
        self.reviewCountLabel.text = "\(self.reviewData?.reviewRating ?? "0") \(Utility().language().value(forKey: "out_of") ?? "")"

        if self.reviewData?.userReview ?? "" != "" {
            self.textView.text = self.reviewData?.userReview ?? ""
            self.textView.tag = 1
        }
       
          ratingView.didTouchCosmos = { rating in
            self.reviewCountLabel.text = "\(rating)  \(Utility().language().value(forKey: "out_of") ?? "")"
                 }
       }
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.keyboardHeight = Float(keyboardFrame.height)
       // self.stackViewBottomConst.constant = CGFloat(self.keyboardHeight  - 55)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        self.viewDidLayoutSubviews()
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        self.keyboardHeight = Float(0)
       // self.stackViewBottomConst.constant = 15
       // print(self.stackViewBottomConst.constant)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
                     self.navigationController?.popViewController(animated: true)
             }
            else {
                self.saveBtnTapped()
            }
        }
    }
    func saveBtnTapped(){
        let textVal = self.textView.text.trimmingCharacters(in: .whitespaces)
        self.textView.endEditing(true)
        if self.ratingView.rating != 0 && self.textView.tag != 0 && textVal != ""{
            Utility().startAnimation(viewController: self)
            self.viewModel.writeReview(user_id: (UserDefaultModule().getCurrentUserID() as String? ?? ""), doctor_id: "\(self.reviewData?.reviewerId ?? "0")", reservation_id: "\(self.reviewData?.bookingId ?? "0")", rating: "\(self.ratingView.rating)", review: "\(self.textView.text!)", review_id: "\(self.reviewData?.reviewId ?? "0")", language: UserDefaultModule().getAppLanguage(), onSuccess: { (success) in
                Utility().stopAnimation(viewController: self)
                self.refreshChat!()
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.popViewController(animated: true)
            }) { (failure) in
                Utility().stopAnimation(viewController: self)
            }
        }
        else {
            if self.ratingView.rating == 0 {
                self.view.makeToast(Utility().language().value(forKey: "enter_some_rating") as? String ?? "enter_some_rating")
            }
            else {
                self.view.makeToast(Utility().language().value(forKey: "enter_some_review") as? String ?? "enter_some_review")
            }
        }
    }
 }
extension ReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewAct(textView)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewAct(textView)
        textViewDidChange(textView)
      }
    func textViewDidChange(_ textView: UITextView) {
    }
    func textViewAct(_ textView: UITextView) {
        if textView.tag == 0 {
            textView.text = ""
            textView.textColor = UIColor(named: "TitleColor") ?? .white
            textView.tag = 1
        }
        else {
            if textView.text == "" && textView.tag == 1{
                textView.text = Utility().language().value(forKey: "write_your_review") as? String ?? ""
                textView.tag = 0
                textView.textColor = UIColor(named: "fifth_text") ?? .white
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.containsEmoji {
            return false
        }
        let strLength = textView.text?.count ?? 0
        let lngthToAdd = text.count
        let lengthCount = strLength + lngthToAdd
        if lengthCount > 400 {
            let alert = UIAlertController(title: nil, message: getLanguage["Maximum 250 Character only allowed"] ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}
