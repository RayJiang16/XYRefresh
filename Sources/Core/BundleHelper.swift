//
//  BundleHelper.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/12.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

struct BundleHelper {
    
    static var bundle = Bundle(for: RefreshComponent.self)
    static private var _languageBundle: Bundle?
    static private var _arrowImage: UIImage?
    
    static var languageBundle: Bundle? {
        if _languageBundle == nil {
            var language = (Locale.preferredLanguages.first ?? "en") as NSString
            if language.hasPrefix("zh") {
                if language.range(of: "Hans").location != NSNotFound {
                    language = "zh-Hans"
                } else {
                    language = "zh-Hant"
                }
            }
            _languageBundle = Bundle(path: bundle.path(forResource: language as String, ofType: "lproj") ?? "")
        }
        return _languageBundle
    }
    
    static var arrowImage: UIImage? {
        if _arrowImage == nil {
            _arrowImage = UIImage(named: "arrow", in: bundle, compatibleWith: nil)
        }
        return _arrowImage
    }
    
    static func localizedString(key: String) -> String {
        return localizedString(key: key, value: nil)
    }
    
    static func localizedString(key: String, value: String?) -> String {
        var value = value
        value = languageBundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
}
