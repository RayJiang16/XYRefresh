//
//  RefreshConst.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/12.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

public struct RefreshConst {
    
    private init() { }
    
    static public var headerHeight: CGFloat = 54.0
    static public var footerHeight: CGFloat = 44.0
    static public var animationDuration: TimeInterval = 0.25
    
    // Label
    static public var labelFont = UIFont.boldSystemFont(ofSize: 14)
    static public var labelTextColor = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    
    // KVC
    static public var headerWillChangeKey: String = "RefreshHeaderWillChangeKey"
    static public var headerDidChangeKey: String  = "RefreshHeaderDidChangeKey"
    static public var footerWillChangeKey: String = "RefreshFotterWillChangeKey"
    static public var footerDidChangeKey: String  = "RefreshFotterDidChangeKey"
    
    static public var lastUpdatedTimeKey: String = "RefreshLastUpdatedTimeKey"
    
    // Language
    static public var headerIdleText = "RefreshHeaderIdleText"
    static public var headerPullingText = "RefreshHeaderPullingText"
    
    static public var footerIdleText = "RefreshAutoFooterIdleText"
    static public var footerPullingText = "RefreshAutoFooterPullingText"
    static public var footerNoMoreDataText = "RefreshAutoFooterNoMoreDataText"
    
}
