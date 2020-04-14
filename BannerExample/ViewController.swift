//
//  Copyright (C) 2015 Google, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import GoogleMobileAds
import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var nativeAdPlaceholder: UIView!
    /// The banner view.

    /// The ad unit ID.
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    
    let op = GoogleBannerManager()
    
    @IBAction func showNativeAds(_ sender: Any) {
        op.loadNativeAds(adUnitID: adUnitID, viewcontroller: self) { [weak self](adView : GADUnifiedNativeAdView) in
            guard let strongSelf = self else {return}
            
            strongSelf.showAdViewNative(adView, rootView: strongSelf.nativeAdPlaceholder)
        }
    }
    
    @IBAction func showads(_ sender: Any) {
        op.loadBannerAdmods(uuId: "ca-app-pub-3940256099942544/2934735716", viewController: self) {[weak self] (ab:GADBannerView) in
            guard let strongSelf = self else {return}

            strongSelf.addBannerViewToView(ab, root: strongSelf.nativeAdPlaceholder)
        }
    }
    
    
   
}
