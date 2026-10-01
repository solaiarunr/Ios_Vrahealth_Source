//
//  Config.swift
//  Meetdoc
//
//  Created by BTMani on 22/03/18.
//  Copyright © 2018 BTMani. All rights reserved.


import UIKit
import Foundation
//com.app.vrahealth
////Live
//let webURL = "https://yoursiteurl.com"
//let siteurl = "https://yoursiteurl.com/api/" // "\(webURL)/api/"
//let ImageURL = "https://yoursiteurl.com/imageuploadapi.php" // "\(webURL)/imageuploadapi.php"

// Live Latest
let webURL = "https://vrahealth.com/"
let siteurl = "https://vrahealth.com/api/" // "\(webURL)/api/"
let ImageURL = "https://vrahealth.com/imageuploadapi.php" // "\(webURL)/imageuploadapi.php"

let socketurl = "https://vrahealth.com:8081"
var APP_RTC_URL = "http://142.93.222.16:8080"




//Dev
//let webURL = "https://appservices.hitasoft.in/vrahealth/"
//let siteurl = "https://appservices.hitasoft.in/vrahealth/api/" // "\(webURL)/api/"
//let ImageURL = "https://appservices.hitasoft.in/vrahealth/imageuploadapi.php" // "\(webURL)/imageuploadapi.php"
//
//let socketurl = "https://appservices.hitasoft.in:8089"
//var APP_RTC_URL = "http://142.93.222.16:8080"
#if DEBUG
let DEVICE_MODE = "0"
#else
let DEVICE_MODE = "1"
#endif

//let DEVICE_MODE = "0"

//MARK: Google API
//AIzaSyDfpkQFSbAVMVTD6O7eFJxktJsyM6qI6GA
var GOOGLE_API_KEY = "AIzaSyDNhJuH7CukV3Pf4ZONKEluS6yxAOM08Y0"
let GOOGLE_CLIENT_KEY = "177871694787-irompcd07tr9jpb9m9oeqki9tt0rr1dk.apps.googleusercontent.com"

//MARK: Default Language
let DEFAULT_LANGUAGE = "English"


let home_Page_URL = "home"
let API_CHANGE_USERIMAGE = "changeuserimage"
let social_login_URL = "sociallogin"
let Get_Message_URL = "getmessages"
let Get_TRIPS_URL = "gettrips"
//let Get_saved_lists = "getwishlists"
let Get_saved_lists = "getlikes"
let LIKE_URL = "sendlike"
let Get_user_notification = "getnotifications"
let Get_wish_list_listings = "getwishlistlisting"
let Get_search = "search"
let Get_profile = "profile"
let Edit_profile = "editprofile"
let Get_admin_datas = "adminlistingproperties"
let Get_language_datas = "getlanguages"
let Get_specialities_datas = "getspecialitylist"
let Get_hospital_datas = "gethospital"
let Add_hospital_datas = "addhospital"
let Get_Insurance_datas = "getinsurancelist"
let Get_illness_datas = "getillnesslist"
let UPLOAD_DOC = "imageuploadapi"
let Help_URL = "help"
let Invite_URL = "sendinvitefriends"
let Admin_URL = "admindata"
let Login_URL = "login"
let email_Validate = "validateemail"
let getBookingURL = "getbookings"
let ListImageUpload_Url = "imageuploadapi.php"
let createListings_URL = "createlisting"
let getSettings_URL = "getsettings"
let setSettings_URL = "setsettings"
let changePassword_URL = "changepassword"
let CurrencyList_URL = "getcurrencylist"
let ChangeCurrency_URL = "changecurrency"
let ListBookingDetails = "getbookingdetails"
let CheckAvailability_URL = "checkavailability"
let ListDetails_URL = "listdetail"
let CreateWishList_URL = "createwishlist"
let AddandRemoveWishList_URL = "addandremovewishlist"
let GetReportList_URL = "getreportlist"
let Read_Review_URL = "readreview"
let Read_Host_Review_URL = "readhostreview"
let get_review = "reviewlist"
let getDashBoard_URL = "dashboard"
let calendar_URL = "getcalendarsetting"
let reservation_URL = "getreservation"
let REPORT_DOCTOR_URL = "reportdoctor"
let Report_User_URL = "reportuser"
let Signup_URL = "usersignup"
let Doctor_SignUp = "doctorsignup"
let Forgot_Password_URL = "forgotpassword"
let type_search_URL = "typesearch"
let change_Reservation_Status_URL = "changereservestatus"
let get_Conversation_URL = "getconversation"
let send_Conversation_URL = "sendconversation"

let API_GET_HOST_COUNTRY = "gethostcountry"
let API_CREATE_HOST_ACCOUNT = "createhostaccount"
let API_TIME_ZONE = "timezone"
let API_BASE_PRICE = "baseprice"

let API_TRANSACTION_HISTORY = "transactionhistory"
let API_WRITE_REVIEW = "writereview"
let API_EMAIL_VERIFICATION = "emailverification"
let API_ADD_DEVICE_ID = "adddeviceid"
let API_SIGN_OUT = "pushsignout"


let DOCTOR_PROFILE_API = "doctorprofile"
let DOCTOR_EDIT_PROFILE_URL = "doctoreditprofile"
let DOCTOR_DETAILS_URL = "doctordetails"
let HOSPITAL_DETAILS_URL = "hospitaldetails"
let DOCTOR_SEARCH_URL = "getdoctors"
let FILTER_URL = "filter"
let GET_SLOT_URL = "getslot"
let SET_CALENDAR_SETTING_API = "setcalendarsetting"
let GET_DOCTOR_ILLNESS_LIST_API = "getdoctorillnesslist"
let BOOKING_APPOINMENT_API = "bookappointment"
let GET_BOOKING_DETAILS = "getbookingdetails"
let CANCEL_BOOKING_API = "cancelbooking"
let RESCHEDULE_BOOKING = "reschedulebooking"
let UNUSUAL_BOOKING = "unusualbooking"
let COMPLETEBOOKING = "completebooking"
let DayOffCheck = "daycheck"

// CALL URLS
let MAKE_CALL_URL = "makecall"
let CHECK_ROOM_URL = "checkroom"
let MISSED_CALL_URL = "missedcall"
let END_CALL_URL = "endcall"
let PAYMENT_URL = "payment"
let PAYMENT_VERIFICATION = "requestpayment"
let CREATE_ORDER_ID = "createorderid"
let BALLENCE_SHEET_URL = "balancesheet"
let CHECK_CHAT_ROOM_URL = "checkchatroom"
let BLOCK_URL = "block"
let CALL_INITIATE = "callinitiate"
let CALL_END = "callend"
let MISSED_CALL = "callmissed"
let VIEW_PRESCRIPTION = "viewprescription"
//let prescriptionURL = "https://appservices.hitasoft.in/vrahealth/api/addprescription" //MARK: DEV URL
let prescriptionURL = "https://vrahealth.com/api/addprescription"

//DC section
let DCSIGNUP_URL = "digitalclinicsignup"

// Prescription
let GET_PRESCRIPTION_URL = "getprescription"
let SAVE_PRESCRIPTION_URL = "saveprescription"
let DELETE_PRESCRIPTION_URL = "deleteprescription"
let PRESCRIPTIONLIST_URL = "prescriptionlist"

// AddOns
let MOBILE_LOGIN_URL = "mobilelogin"

// Account Deletion
let ACCOUNT_DELETION_API = "accountdeletion"
