//
//  Ex+Refresh.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/12.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

extension UIScrollView: RefreshCompatible { }

private var refreshHeaderKey: UInt8 = 0
private var refreshFooterKey: UInt8 = 0

extension RefreshBase where Base: UIScrollView {
    
    public var header: RefreshBaseHeader? {
        get {
            return objc_getAssociatedObject(base, &refreshHeaderKey) as? RefreshBaseHeader
        }
        nonmutating set {
            if let newValue = newValue, header != newValue {
                header?.removeFromSuperview()
                base.insertSubview(newValue, at: 0)
                
                base.willChangeValue(forKey: RefreshConst.headerWillChangeKey)
                objc_setAssociatedObject(base, &refreshHeaderKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
                base.didChangeValue(forKey: RefreshConst.headerDidChangeKey)
            }
        }
    }
    
    public var footer: RefreshBaseFooter? {
        get {
            return objc_getAssociatedObject(base, &refreshFooterKey) as? RefreshBaseFooter
        }
        nonmutating set {
            if let newValue = newValue, footer != newValue {
                footer?.removeFromSuperview()
                base.insertSubview(newValue, at: 0)
                
                base.willChangeValue(forKey: RefreshConst.footerWillChangeKey)
                objc_setAssociatedObject(base, &refreshFooterKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
                base.didChangeValue(forKey: RefreshConst.footerDidChangeKey)
            }
        }
    }
    
}
