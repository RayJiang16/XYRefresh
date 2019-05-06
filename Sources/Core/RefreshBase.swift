//
//  RefreshBase.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/12.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import Foundation

public struct RefreshBase<Base> {
    
    public let base: Base
    
    public init(base: Base) {
        self.base = base
    }
}
