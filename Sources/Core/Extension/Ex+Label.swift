//
//  Ex+Label.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/12.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

extension UILabel {
    
    internal static func refreshLabel() -> UILabel {
        let view = UILabel()
        view.font = RefreshConst.labelFont
        view.textColor = RefreshConst.labelTextColor
        view.textAlignment = .center
        return view
    }
    
    internal var labelWidth: CGFloat {
        guard let str = text, str.count > 0 else { return 0 }
        guard let font = font else { return 0 }
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 100)
        return str.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).integral.width
    }
}
