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
    /// 用户头像URL
    var avatarURL: NSURL?
    /// 用户头像地址(中图)，50x50
    var profile_image_url: String?
        {
        didSet{
            avatarURL = NSURL(string: profile_image_url ?? "")
        }
    }
    /// 认证图片
    var verifiedImage: UIImage?
    /// 认证类型 (-1：没有认证，0，个人认证，2,3,5: 企业认证，220: 达人)
    var verified_type: Int = -1 {
        didSet{
            switch verified_type {
            case 0:
                // 个人认证
                verifiedImage = UIImage(named: "avatar_vip")
            case 2, 3, 5:
                // 企业认证
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                // 微博达人
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                // 没有认证
                verifiedImage = nil
            }
        }
    }
    /// 会员图片
    var mbrankImage: UIImage?
    /// 会员等级
    var mbrank: Int = -1
        {
        didSet{
            if mbrank >= 1 && mbrank <= 6
            {
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    
    
    
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
