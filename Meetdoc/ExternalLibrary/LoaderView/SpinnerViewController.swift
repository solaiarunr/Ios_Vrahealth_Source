//
//  SpinnerViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 09/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
class SpinnerViewController: UIViewController {

    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    let backgroundView = UIView()
    let stackView = UIStackView()
    let textLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        backgroundView.layer.cornerRadius = 5
        backgroundView.clipsToBounds = false
        view.addSubview(backgroundView)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(stackView)
        
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        stackView.addArrangedSubview(spinner)

        textLabel.config(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), font: fontRegular, align: .left, text: "loading")
        textLabel.numberOfLines = 0
        stackView.addArrangedSubview(textLabel)

        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let heightConst = NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)
        let widthConst = NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)
        NSLayoutConstraint.activate([heightConst,widthConst])

        stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true

        let leadingConst = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConst = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConst = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConst = NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: stackView, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConst, trailingConst,topConst,bottomConst])
        
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
extension UIViewController {
    func createSpinnerView(_ child: UIViewController) {
        // add the spinner view controller
        self.addChild(child)
        child.view.frame = UIScreen.main.bounds
        child.modalPresentationStyle = .overFullScreen
         self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
   
    func removeSpinnerView(_ child: UIViewController) {
        // wait two seconds to simulate some work happening
        // then remove the spinner view controller
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    func checkReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: nil)
    }
    @objc func statusManager(_ notification: Notification) {
    }
}
