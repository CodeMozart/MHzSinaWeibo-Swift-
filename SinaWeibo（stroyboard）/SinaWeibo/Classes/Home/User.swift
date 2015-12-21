//
//  User.swift
//  SinaWeibo
//
//  Created by Minghe on 15/11/15.
//  Copyright © 2015年 Stanford swift. All rights reserved.
//

import UIKit

class User: NSObject {

    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址(中图)，50x50
    var profile_image_url: String?
    
    /// 认证类型 (-1：没有认证，0，个人认证，2,3,5: 企业认证，220: 达人)
    var verified_type: Int = -1 
    /// 会员等级
    var mbrank: Int = -1
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["screen_name","profile_image_url","verified_type"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
    
}
