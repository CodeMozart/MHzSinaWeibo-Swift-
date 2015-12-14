//
//  WelcomeViewController.swift
//  SinaWeibo
//
//  Created by Minghe on 11/12/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var iconBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置头像
        // 断言：断定一定有授权模型，如果没有程序就会崩溃，并且会输出后面message中的内容
        assert(UserAccount.loadUserAccount() != nil, "用户当前还没有授权")
        
        let url = NSURL(string: UserAccount.loadUserAccount()!.avatar_large!)
        iconView.sd_setImageWithURL(url)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let offset = view.bounds.height - iconBottomConstraint.constant
        iconBottomConstraint.constant = offset
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            
            }) { (_) -> Void in
                
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.tipLabel.alpha = 1.0
                    }, completion: { (_) -> Void in
                        
                        // 发送通知，通知AppDelegate切换控制器
                        NSNotificationCenter.defaultCenter().postNotificationName(MHzRootViewControllerChanged, object: self, userInfo: nil)
                })
        }

        
    }

}
