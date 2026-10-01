//
//  HSView+UIView.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 14/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    //MARK: shadow effect
    func elevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
    }
    func elevationEffect1() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = UIColor(named: "ShadowColor-1")?.cgColor
    }
    func darkElevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        self.layer.shadowRadius = 3;
//        self.layer.shouldRasterize = true
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = UIColor(named: "divider")?.cgColor
    }
    func previewelevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.5;
        //        self.layer.borderWidth = 1
        //        self.layer.borderColor = TEXT_PRIMARY_COLOR
    }
    func elevationEffectOnBottom() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0.5)
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.2;
        //        self.layer.borderWidth = 1
        //        self.layer.borderColor = TEXT_PRIMARY_COLOR
    }
    
      func styleTextField(){
       // layer.borderStyle = .none
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5.0;
        self.layer.backgroundColor = (UIColor(named: "appbg") ?? .black).cgColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = (UIColor(named: "BlackColor") ?? .black).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3.0
    }
    
    func styleTextField1(){
     // layer.borderStyle = .none
        self.layer.borderColor = UIColor.clear.cgColor
  }
    
    //MARK: round corner radius
    func cornerViewRadius() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    func blurEffect() {
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.bounds
        self.addSubview(blurView)
    }
    //MARK: minimum corner radius
    func cornerViewMiniumRadius() {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
    func cornerViewMaxRadius() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    //MARK: remove corner radius
    func removeCornerRadius() {
        self.layer.cornerRadius = 0.0
        self.layer.masksToBounds = false
        self.clipsToBounds =  false
    }
    func viewRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    //MARK: apply gradient effect
//    func applyGradient()  {
//        let gradientLayer:CAGradientLayer = CAGradientLayer()
//        gradientLayer.frame.size = self.frame.size
//        gradientLayer.colors = PRIMARY_COLOR
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.2)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        self.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = self.bounds
//    }
    
    func removeGrandient()  {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    //MARK:Specific corner radius
    func specificCornerRadius(radius:Int)  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight , .topLeft, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
//        self.layer.backgroundColor = UIColor.green.cgColor
        //Here I'm masking the textView's layer with rectShape layer
        self.layer.mask = rectShape
    }
    
    //MARK: Set border
    func setViewBorder(color:UIColor) {
        self.cornerViewRadius()
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
    }
    func setViewMinBorder(color:UIColor) {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 0.5
        self.layer.borderColor = color.cgColor

    }
    func exportAsPdfFromView() -> String {
        
        let pdfPageFrame = self.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData)
        
    }
    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData) -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("yourPDF.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}


extension UITableView {
    
    // Export pdf from UITableView and save pdf in drectory and return pdf file path
    func exportAsPdfFromTable() -> String{
        let pageDimensions = self.bounds
        let pageSize = pageDimensions.size
        let totalSize = self.contentSize
        _ = Int(ceil(totalSize.width / pageSize.width))
        let numberOfPagesThatFitVertically = Int(ceil(totalSize.height / pageSize.height))
        let outputData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(outputData, pageDimensions, nil)
        self.contentInset = UIEdgeInsets.zero
        if let context = UIGraphicsGetCurrentContext()
        {
            for indexVertical in 0 ..< numberOfPagesThatFitVertically
            {
                UIGraphicsBeginPDFPage()
                _ = CGFloat(0) * pageSize.width
                let offsetVertical = CGFloat(indexVertical) * pageSize.height
                
                self.contentOffset = CGPoint(x: 0, y: offsetVertical)
                context.translateBy(x: -0, y: -offsetVertical) // NOTE: Negative offsets
                self.layer.render(in: context)
            }
        }
        UIGraphicsEndPDFContext()        // Save pdf data
        return self.saveTablePdf(data: outputData)

    }
    
    // Save pdf file in document directory
    func saveTablePdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("tablePdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}
