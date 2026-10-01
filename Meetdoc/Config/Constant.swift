//
//  Constant.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

// GET LANGUAGE
var getLanguage = [String: String]()
var NCTRL = UINavigationController()
var isCalendar = false
var isProfileUpdate = false
var isPayout = false
var hospitalStatus = false
var selectedCurrency = Currencylist()
//var frequencyArray = ["once daily", "twice daily", "alternate days", "when the pain is severe", "every fourth hour", "every 12 hours", "every 6 hours"]
var frequencyArray = ["once_morning","once_afternoon","once_evening","twice_timedaily","three_timedaily","four_timedaily","new_sos","new_4hrs","new_3hrs","alternate_days","5_days_a_week","Once a week","Twice a week","Once a Month","Twice a Month","As per drug instructions Below"]


//var directionArray = ["before breakfast", "after breakfast", "before lunch", "after lunch", "before dinner", "after dinner"]
var directionArray = ["Before Food", "After Food", "With Food", "bed_time", "Local Application", "Anytime (Not specific)"]


// ADD Ons
// Banner Add
let IS_GOOGLE_ADSENSE = false
let BANNNER_ID = "ca-app-pub-3940256099942544/2934735716"

//connectycube
struct Segues
{
    static let callSceneID = "CallViewController1"
}

let DefaultUserPassword: String = "12345678"
let kVOIPEvent = "VOIPCall"

