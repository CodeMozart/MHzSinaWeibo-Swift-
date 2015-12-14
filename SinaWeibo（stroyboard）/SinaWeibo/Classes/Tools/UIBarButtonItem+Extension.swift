//
//  UIBarButtonItem+Extension.swift
//  SinaWeibo
//
//  Created by Minghe on 11/9/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(imageName: String, target: AnyObject, action: Selector) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        btn.sizeToFit()
        
        self.init(customView: btn)
    }
}
