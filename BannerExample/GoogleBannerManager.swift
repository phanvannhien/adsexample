//
//  GoogleBannerManager.swift
//  BannerExample
//
//  Created by Phan Dinh on 4/13/20.
//  Copyright © 2020 Google. All rights reserved.
//

import Foundation
import GoogleMobileAds

class GoogleBannerManager : NSObject{
    
    /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
    /// process.
    var adLoader: GADAdLoader!

    /// The native ad view that is being presented.
    var nativeAdView: GADUnifiedNativeAdView!
    var nativeAdsResult : ((_ nativeAdView : GADUnifiedNativeAdView) -> Void)? = nil

    
    var bannerView : GADBannerView!
    
    var bannerResult : ((_ banner: GADBannerView) -> Void)? = nil
    
    
    public func loadBannerAdmods(uuId: String, viewController: UIViewController, result: @escaping (_ banner: GADBannerView)-> Void){
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.rootViewController = viewController
        bannerView.delegate = self
        
        self.bannerResult = result
        bannerView.adUnitID = uuId
        bannerView.load(GADRequest())
    }
    
    func loadNativeAds(adUnitID : String, viewcontroller : UIViewController, result : @escaping (_ nativeAdView : GADUnifiedNativeAdView) -> Void){
        nativeAdView = loadNativeView()
        self.nativeAdsResult = result
        
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: viewcontroller,
                               adTypes: [ .unifiedNative ], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func loadNativeView() -> GADUnifiedNativeAdView{
        guard let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil),
             let adView = nibObjects.first as? GADUnifiedNativeAdView else {
               assert(false, "Could not load nib file for adView")
           }
        return adView
    }
    
    
    
}

extension GoogleBannerManager : GADBannerViewDelegate{
    /// Tells the delegate an ad request loaded an ad.
       func adViewDidReceiveAd(_ bannerView: GADBannerView) {
           print("adViewDidReceiveAd")
           bannerResult?(bannerView)
       }
       
       /// Tells the delegate an ad request failed.
       func adView(_ bannerView: GADBannerView,
                   didFailToReceiveAdWithError error: GADRequestError) {
           print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
       }
       
       /// Tells the delegate that a full-screen view will be presented in response
       /// to the user clicking on an ad.
       func adViewWillPresentScreen(_ bannerView: GADBannerView) {
           print("adViewWillPresentScreen")
       }
       
       /// Tells the delegate that the full-screen view will be dismissed.
       func adViewWillDismissScreen(_ bannerView: GADBannerView) {
           print("adViewWillDismissScreen")
       }
       
       /// Tells the delegate that the full-screen view has been dismissed.
       func adViewDidDismissScreen(_ bannerView: GADBannerView) {
           print("adViewDidDismissScreen")
       }
       
       /// Tells the delegate that a user click will open another app (such as
       /// the App Store), backgrounding the current app.
       func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
           print("adViewWillLeaveApplication")
       }
}

extension GoogleBannerManager : GADVideoControllerDelegate {
  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    print(#function)
  }

}

extension GoogleBannerManager: GADAdLoaderDelegate {

  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
  }
}

extension GoogleBannerManager: GADUnifiedNativeAdLoaderDelegate{
    /// Returns a `UIImage` representing the number of stars from the given star rating; returns `nil`
     /// if the star rating is less than 3.5 stars.
     func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
       guard let rating = starRating?.doubleValue else {
         return nil
       }
       if rating >= 5 {
         return UIImage(named: "stars_5")
       } else if rating >= 4.5 {
         return UIImage(named: "stars_4_5")
       } else if rating >= 4 {
         return UIImage(named: "stars_4")
       } else if rating >= 3.5 {
         return UIImage(named: "stars_3_5")
       } else {
         return nil
       }
     }
    
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAdView.nativeAd = nativeAd

        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self

        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

        // Some native ads will include a video asset, while others do not. Apps can use the
        // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
        // UI accordingly.
        let mediaContent = nativeAd.mediaContent
        if mediaContent.hasVideoContent {
          // By acting as the delegate to the GADVideoController, this ViewController receives messages
          // about events in the video lifecycle.
          mediaContent.videoController.delegate = self
//          videoStatusLabel.text = "Ad contains a video asset."
        }
        else {
         // videoStatusLabel.text = "Ad does not contain a video."
        }

        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
//          heightConstraint = NSLayoutConstraint(item: mediaView,
//                                                attribute: .height,
//                                                relatedBy: .equal,
//                                                toItem: mediaView,
//                                                attribute: .width,
//                                                multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
//                                                constant: 0)
//          heightConstraint?.isActive = true
        }

        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from:nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        
        nativeAdsResult?(nativeAdView)
    }
    
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension GoogleBannerManager : GADUnifiedNativeAdDelegate {

  func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
    print("\(#function) called")
  }
}
