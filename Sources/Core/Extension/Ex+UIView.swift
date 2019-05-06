//
//  Ex+UIView.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/11.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

extension UIView {
    
    var x: CGFloat {
        get {
            return frame.origin.x
        } set {
            frame.origin.x = newValue
        }
    }
    
    var y : CGFloat {
        get {
            return frame.origin.y
        } set {
            frame.origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        } set {
            frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        } set {
            frame.size.height = newValue
        }
    }
    
    var size: CGSize {
        get {
            return frame.size
        } set {
            frame.size = newValue
        }
    }
    
    var origin: CGPoint {
        get {
            return frame.origin
        } set {
            frame.origin = newValue
        }
    }
    
}

