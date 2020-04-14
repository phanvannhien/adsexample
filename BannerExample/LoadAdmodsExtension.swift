//
//  LoadAdmodsExtension.swift
//  BannerExample
//
//  Created by Phan Dinh on 4/13/20.
//  Copyright © 2020 Google. All rights reserved.
//

import Foundation
import GoogleMobileAds

extension ViewController{
    func addBannerViewToView(_ bannerView: GADBannerView, root : UIView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     root.addSubview(bannerView)
//     view.addConstraints(
//       [NSLayoutConstraint(item: bannerView,
//                           attribute: .bottom,
//                           relatedBy: .equal,
//                           toItem: bottomLayoutGuide,
//                           attribute: .top,
//                           multiplier: 1,
//                           constant: 0),
//        NSLayoutConstraint(item: bannerView,
//                           attribute: .centerX,
//                           relatedBy: .equal,
//                           toItem: view,
//                           attribute: .centerX,
//                           multiplier: 1,
//                           constant: 0)
//       ])
    }
    
    func showAdViewNative(_ nativeAdView: GADUnifiedNativeAdView,  rootView : UIView) {
   
       rootView.addSubview(nativeAdView)
       nativeAdView.translatesAutoresizingMaskIntoConstraints = false

       // Layout constraints for positioning the native ad view to stretch the entire width and height
       // of the nativeAdPlaceholder.
        
       let viewDictionary = ["_nativeAdView": nativeAdView]
       self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
       self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
     }
}
