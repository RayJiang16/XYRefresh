//
//  BundleHelper.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/12.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

struct BundleHelper {
    
    static var bundle = Bundle.current
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
            _arrowImage = Bundle.image(named: "arrow")
        }
        return _arrowImage
    }
    
    static func localizedString(key: String) -> String {
        return localizedString(key: key, value: nil)
    }
    
    static func localizedString(key: String, value: String?) -> String {
        // 优先使用 languageBundle（针对特定 .lproj），找不到再使用资源 bundle，最后回退到 main bundle
        if let langBundle = languageBundle {
            let localized = langBundle.localizedString(forKey: key, value: nil, table: nil)
            if localized != key {
                return localized
            }
        }
        
        let resourceLocalized = bundle.localizedString(forKey: key, value: value, table: nil)
        if resourceLocalized != key {
            return resourceLocalized
        }
        
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
}

extension Bundle {
    
    private class _BundleClass { }
    
    static let current: Bundle = {
        let bundle = Bundle(for: _BundleClass.self)
        guard let url = bundle.url(forResource: "XYRefresh", withExtension: "bundle"), let resource = Bundle(url: url) else {
            return bundle
        }
        return resource
    }()
    
    static func image(named: String) -> UIImage? {
        return UIImage(named: named, in: current, compatibleWith: nil)
    }
}
