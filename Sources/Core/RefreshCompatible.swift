//
//  RefreshCompatible.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/12.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import Foundation

public protocol RefreshCompatible {
    
    associatedtype RefreshCompatible
    
    var refresh: RefreshBase<RefreshCompatible> { get }
}

extension RefreshCompatible {
    
    public var refresh: RefreshBase<Self> {
        get {
            return RefreshBase(base: self)
        }
    }
}
