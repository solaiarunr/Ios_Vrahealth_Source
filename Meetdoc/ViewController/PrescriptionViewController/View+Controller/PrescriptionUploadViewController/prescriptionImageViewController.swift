//
//  prescriptionImageViewController.swift
//  Meetdoc
//
//  Created by suriya on 01/06/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class prescriptionImageViewController: UIViewController {
    @IBOutlet weak var wkwebview: WKWebView!
    
    var patientName = ""
    var patientAge = ""
    var patientWeight = ""
    var patientGender = ""
    var slotTime = ""
    var bookingDate = ""
    var doctorName = ""
    var doctorqualification = ""
    var speciality = ""
    var doctorregno = ""
    var prescriptionImageUrl = ""
    var prescriptionImageArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
 //       self.createPDF()
        print("ImageUrl:\(self.prescriptionImageUrl)")
        let fileUrl = URL(string: self.prescriptionImageUrl)!
        let request = URLRequest(url: fileUrl)
        self.wkwebview.load(request)
        // Do any additional setup after loading the view.
    }
    /*
    func createFlyer() -> Data {
            let pdfMetaData = [
                kCGPDFContextCreator: "Jokerz app",
                kCGPDFContextAuthor: "http://jokerz.fun",
                kCGPDFContextTitle: "PRIVATE KEY"
            ]
            let format = UIGraphicsPDFRendererFormat()
            format.documentInfo = pdfMetaData as [String: Any]
            
            let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
            let newpageRect = CGRect(x: 0, y: 0, width: 100, height: 30) // A4, 72 dpi
            let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
            
            let data = renderer.pdfData { (context) in
                context.beginPage()
                let imageBottom = addImage(pageRect: pageRect, Top: 50)
                let titleBottom = addTitle(pageRect: pageRect, imageBottom: imageBottom + 20)
                let nameTitle = nameTitle(pageRect: newpageRect, Top: 50 )
                let ageTitle = ageTitle(pageRect: newpageRect, nameTitle: nameTitle + 5)
               let weightTitle = weightTitle(pageRect: newpageRect, ageTitle: ageTitle + 5)
               let bookingslotTitle = bookingslotTitle(pageRect: newpageRect, weightTitle: weightTitle + 5)
                let prescriptionImage = prescriptionImage(pageRect: newpageRect, Top: bookingslotTitle + 5 )
                let doctorName = doctorTittle(pageRect: newpageRect, weightTitle: prescriptionImage + 5)
                let qualification = qualificationTitle(pageRect: newpageRect, weightTitle: doctorName + 5)
                let consult = consultTitle(pageRect: newpageRect, weightTitle: qualification + 5)
                let reg = regTitle(pageRect: newpageRect, weightTitle: consult + 5)
                let doctorbooking = doctorbookingslotTitle(pageRect: newpageRect, weightTitle: reg + 5)
                
                
                let context = context.cgContext
            //    drawBox(context, pageRect: pageRect, top: titleBottom + 35)
                
                addBodyText(pageRect: pageRect, textTop: titleBottom + 35 + 60)
            }
            
            return data
        }

    func createPDF(){
        // 1. Create Print Formatter with input text.

            let formatter = UIMarkupTextPrintFormatter(markupText: "HELLO")

            // 2. Add formatter with pageRender

            let render = UIPrintPageRenderer()
            render.addPrintFormatter(formatter, startingAtPageAt: 0)


            // 3. Assign paperRect and printableRect

            let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
            let printable = page.insetBy(dx: 0, dy: 0)

            render.setValue(NSValue(cgRect: page), forKey: "paperRect")
            render.setValue(NSValue(cgRect: printable), forKey: "printableRect")


            // 4. Create PDF context and draw
            let rect = CGRect.zero

            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, rect, nil)


            for i in 1...render.numberOfPages {

                UIGraphicsBeginPDFPage();
                let bounds = UIGraphicsGetPDFContextBounds()
                render.drawPage(at: i - 1, in: bounds)
            }

            UIGraphicsEndPDFContext();


            // 5. Save PDF file

            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

            pdfData.write(toFile: "\(documentsPath)/new.pdf", atomically: true)

            print("saved success:\(documentsPath)")
        
        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("new").appendingPathExtension("pdf")
                
        else { fatalError("Destination URL not created") }

         print("OUTPUTURL:\(outputURL)")
        
        let cfdata = createFlyer()
                do {
                    try cfdata.write(to: outputURL)
                }
                catch {
                    print(error.localizedDescription)
                }

        let urlRequest = URLRequest(url: outputURL)
        wkwebview.load(urlRequest)


    }
      
    func loadPDF(filename: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent(filename).appendingPathExtension("pdf")
        let urlRequest = URLRequest(url: url)
        wkwebview.load(urlRequest)
    }
    func addImage(pageRect: CGRect, Top: CGFloat) -> CGFloat {
            let image = UIImage(named: "logo")!
            let maxHeight = pageRect.height * 0.2
            let maxWidth = pageRect.width * 0.4
            
            let aspectWidth = maxWidth / image.size.width
            let aspectHeight = maxHeight / image.size.height
            let aspectRatio = min(aspectWidth, aspectHeight)
            
            let scaledWidth = 100
            let scaledHeight = 75
            
        let imageX = (pageRect.width - CGFloat(scaledWidth)) / 2.0
        let imageRect = CGRect(x: 120, y: Top, width: CGFloat(scaledWidth), height: CGFloat(scaledHeight))
            
            image.draw(in: imageRect)
            return imageRect.origin.y + imageRect.size.height
        }
    func prescriptionImage(pageRect: CGRect, Top: CGFloat) -> CGFloat {
         //  let image = UIImage(named: "doctorSignin")!
        print("ImageUrl12:\(self.prescriptionImageArray)")
        let testImage = NSData(contentsOf: URL(string: self.prescriptionImageUrl)!)
        print("TESTIMAGE:\(testImage)")
        if testImage != nil{
            let image = UIImage(data: testImage as! Data)
            let maxHeight = pageRect.height * 0.2
            let maxWidth = pageRect.width * 0.4
            
//            let aspectWidth = maxWidth / image.size.width
//            let aspectHeight = maxHeight / image.size.height
//            let aspectRatio = min(aspectWidth, aspectHeight)
            
            let scaledWidth = 400
            let scaledHeight = 400
            
        let imageX = (pageRect.width - CGFloat(scaledWidth)) / 2.0
        let imageRect = CGRect(x: 100 , y: 190, width: CGFloat(scaledWidth), height: CGFloat(scaledHeight))
            
        image?.draw(in: imageRect)
            return imageRect.origin.y + imageRect.size.height
        }else{
            print("Success")
            return 0
        }
        }
        func addTitle(pageRect: CGRect, imageBottom: CGFloat) -> CGFloat {
         //   let titleFont = titleHighBold
            let titleAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: fontRegular18]
            let attributedTitle = NSAttributedString(string: "TELE-CONSULATION", attributes: titleAttributes)
            let titleStringSize = attributedTitle.size()
            let titleStringRect = CGRect(x: 80,
                                         y: imageBottom, width: titleStringSize.width,
                                         height: titleStringSize.height)
            attributedTitle.draw(in: titleStringRect)
            return titleStringRect.origin.y + titleStringRect.size.height
        }
    func nameTitle(pageRect: CGRect, Top: CGFloat) -> CGFloat {
     //   let titleFont = titleHighBold
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: regular14]
        let attributedTitle = NSAttributedString(string: self.patientName, attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: 350,
                                     y: Top, width: titleStringSize.width,
                                     height: 20)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    func ageTitle(pageRect: CGRect, nameTitle: CGFloat) -> CGFloat {
     //   let titleFont = titleHighBold
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: regular14]
        let attributedTitle = NSAttributedString(string: "\(self.patientAge) years,  \(patientGender)", attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: 350,
                                     y: nameTitle, width: titleStringSize.width,
                                     height: 20)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    func weightTitle(pageRect: CGRect, ageTitle: CGFloat) -> CGFloat {
     //   let titleFont = titleHighBold
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: regular14]
        let attributedTitle = NSAttributedString(string: "Weight -\(self.patientWeight)", attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: 350,
                                     y: ageTitle, width: titleStringSize.width,
                                     height: 20)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    func bookingslotTitle(pageRect: CGRect, weightTitle: CGFloat) -> CGFloat {
     //   let titleFont = titleHighBold
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: regular14]
        let attributedTitle = NSAttributedString(string: "BookingSlot-\(self.bookingDate), \(self.slotTime)", attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: 350,
                                     y: weightTitle, width: titleStringSize.width,
                                     height: 20)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    func doctorTittle(pageRect: CGRect, weightTitle: CGFloat) -> CGFloat {
     //   let titleFont = titleHighBold
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: regular14]
        let attributedTitle = NSAttributedString(string: "DR.\(self.doctorName)", attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: 30,
                                     y: weightTitle, width: titleStringSize.width,
                                     height: 20)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    func qualificationTitle(pageRect: CGRect, weightTitle: CGFloat) -> CGFloat {
     //   let titleFont = titleHighBold
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: regular14]
        let attributedTitle = NSAttributedString(string: self.doctorqualification, attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: 30,
                                     y: weightTitle, width: titleStringSize.width,
                                     height: 20)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    func consultTitle(pageRect: CGRect, weightTitle: CGFloat) -> CGFloat {
     //   let titleFont = titleHighBold
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: regular14]
        let attributedTitle = NSAttributedString(string: self.speciality, attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: 30,
                                     y: weightTitle, width: titleStringSize.width,
                                     height: 20)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    func regTitle(pageRect: CGRect, weightTitle: CGFloat) -> CGFloat {
     //   let titleFont = titleHighBold
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: regular14]
        let attributedTitle = NSAttributedString(string: self.doctorregno, attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: 30,
                                     y: weightTitle, width: titleStringSize.width,
                                     height: 20)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    func doctorbookingslotTitle(pageRect: CGRect, weightTitle: CGFloat) -> CGFloat {
     //   let titleFont = titleHighBold
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: regular14]
        let attributedTitle = NSAttributedString(string: "\(self.bookingDate),\(self.slotTime)", attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: 30,
                                     y: weightTitle, width: titleStringSize.width,
                                     height: 20)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
        
        func addBodyText(pageRect: CGRect, textTop: CGFloat) {

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .natural
            paragraphStyle.lineBreakMode = .byWordWrapping
            let textAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
              //  NSAttributedString.Key.font: textFont
            ]
            let attributedText = NSAttributedString(string: "", attributes: textAttributes)
            let textRect = CGRect(x: 70, y: textTop, width: pageRect.width - 140, height: 100)
            attributedText.draw(in: textRect)
        }
    func drawBox(_ drawContext: CGContext, pageRect: CGRect, top: CGFloat) {
            drawContext.saveGState()
            drawContext.setLineWidth(2.0)
            
            var A = CGPoint(x: 50, y: top)
            var B = CGPoint(x: pageRect.width - 50, y: top)
            var C = CGPoint(x: 50, y: top + 200)
            var D = CGPoint(x: pageRect.width - 50, y: top + 200)
            
            drawContext.move(to: A)
            drawContext.addLine(to: B)
            
            drawContext.move(to: C)
            drawContext.addLine(to: D)
            
            var AC = CGPoint(x: A.x, y: C.y)
            drawContext.move(to: A)
            drawContext.addLine(to: AC)
            
            var BD = CGPoint(x: B.x, y: D.y)
            drawContext.move(to: B)
            drawContext.addLine(to: BD)
            
            drawContext.strokePath()
            drawContext.restoreGState()
        }
    */

}
