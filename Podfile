
platform :ios, '12.0'

install! 'cocoapods', :deterministic_uuids => false

target 'Meetdoc' do
  use_frameworks!

  # --- Core Pods ---
  pod 'Alamofire', '~> 4.9.1'
  pod 'SDWebImage'
  pod 'Cosmos'
  pod 'NVActivityIndicatorView'
  pod 'GooglePlaces'
  pod 'GoogleMaps'
  pod 'KSTokenView'
  pod 'ValidationComponents'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
  pod 'FirebaseCore'
  pod 'FirebaseMessaging'
  pod 'FirebaseAnalytics'
  pod 'FirebaseUI/Auth'
  pod 'FirebaseUI/Phone'
  pod 'Socket.IO-Client-Swift', '~> 13.1.0'
  pod 'SwiftyJSON'
  pod 'PhoneNumberKit'
  pod 'DropDown'
  pod 'Toast-Swift', '~> 3.0.1'
  pod 'AttributedString.swift'
  pod 'Stripe'
  pod 'IQKeyboardManagerSwift'
  pod 'ImageSlideshow/SDWebImage'
  pod 'MXSegmentedPager'
  pod 'GoogleWebRTC'
  pod 'razorpay-pod'
  pod 'ZegoUIKitPrebuiltCall'
  pod 'ZegoUIKitSignalingPlugin'
  pod 'Google-Mobile-Ads-SDK'
  pod 'SwiftMessages'
  pod 'YapDatabase'
  pod 'SVProgressHUD'
  pod 'Reusable'
  pod 'SwiftDate'
  pod 'JTMaterialTransition'

  # --- ConnectyCube ---
  pod 'ConnectyCube'
  pod 'ConnectyCubeCalls'

  # --- Disable Bitcode for ALL Pods ---
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
  end

end
