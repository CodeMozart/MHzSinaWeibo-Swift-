//
//  UserAccount.swift
//  SinaWeibo
//
//  Created by Minghe on 11/11/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    
    ///
    static var userAccount: UserAccount?
    
    ///
    var uid: String?
    ///
    var access_token: String?
    /// access_token的生命周期，单位是秒数
    var expires_in: NSNumber?
        {
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
        }
    }
    /// 过期时间(年月日时分秒)
    var expires_Date: NSDate?
    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址（大图）,180*180
    var avatar_large: String?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

    override var description: String {
        let property = ["access_token","expires_in","uid"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
    

    static let filePath = "userAccount.plist".cacheDir()
    
    // MARK: - 外部控制方法 ------------------------------
    /// 保存授权模型到文件中
    func saveAccount() {
        
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    /// 从文件中读取保存的授权模型
    class func loadUserAccount() -> UserAccount?
    {
//        print(filePath)
        // 1.判断是否已经加载过
        if userAccount != nil {
//            MHzLog("已经加载过了，直接返回")
            return userAccount
        }
        
        // 2.如果没有加载过，就从文件中加载
        userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.filePath) as? UserAccount
        
        // 3.判断是否过期
        guard let date = userAccount?.expires_Date where date.compare(NSDate()) == NSComparisonResult.OrderedDescending else
        {
            MHzLog("已经过期了")
            userAccount = nil
            return userAccount
        }
        
        return userAccount
    }
    
    /// 判断是否已经登陆
    class func login() -> Bool {
        return UserAccount.loadUserAccount() != nil
    }
    
    
    // MARK: - NSCoding ------------------------------
    //
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
    //
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")

    }
}
