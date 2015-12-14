//
//  NetworkTools.swift
//  SinaWeibo
//
//  Created by Minghe on 11/11/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {
    
    /// 单例
    static let shareInstance: NetworkTools = {
       // 注意:指定BaseURL的时候一定要包含/
        let url = NSURL(string: "https://api.weibo.com/")
        
        let instance = NetworkTools(baseURL: url, sessionConfiguration: .defaultSessionConfiguration())
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/json","text/javascript","text/plain") as Set<NSObject>
        return instance
    }()
    
    
    // MARK: - 外部控制方法 ------------------------------
    
    /// 根据RequestToken换取AccessToken
    func loadAccessToken(codeStr: String, finished: (dict: [String: AnyObject]?, error: NSError?)->()) {
        
        let path = "oauth2/access_token" // 拼接在baseURL后面，座位全路径
        let parameters = ["client_id": MHz_App_Key, "client_secret": MHz_APP_Secret, "grant_type": "authorization_code", "code": codeStr, "redirect_uri": MHz_Redirect_URI]
        
        NetworkTools.shareInstance.POST(path, parameters: parameters, success: { (task, objc) -> Void in
            /*
            {
            "access_token" = "2.00GhW4FD09TlQb07ddbcee293BFOME";
            "expires_in" = 157679999;
            "remind_in" = 157679999;
            uid = 2827887400;
            }
            */
            // 执行回调
            finished(dict: objc as? [String: AnyObject], error: nil)
            
            
            }) { (task, error) -> Void in
                
            // 执行回调
            finished(dict: nil, error: error)
        }
        
    }
    
    /// 获取用户信息
    func loadUserInfo(account: UserAccount, finished: (dict: [String: AnyObject]?, error: NSError?) -> ())
    {
        let path = "2/users/show.json"
        let parameters = ["access_token": account.access_token!, "uid": account.uid!]
        NetworkTools.shareInstance.GET(path, parameters: parameters, success: { (task, objc) -> Void in
            
            // 执行回调
            finished(dict: objc as? [String: AnyObject], error: nil)
            
            }) { (tase, error) -> Void in
                
            // 执行回调
            finished(dict: nil, error: error)
        }
    }
    
    /// 获取微博数据
    func loadStatus(finished: (dicts: [[String: AnyObject]]?, error: NSError?)->()) {
        
        let path = "2/statuses/home_timeline.json"
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token!]
        
        NetworkTools.shareInstance.GET(path, parameters: parameters, success: { (task, objc) -> Void in
            
            // 1.从服务器返回的字典中取出字典数组
            guard let array = (objc as! [String: AnyObject])["statuses"] else
            {
                
                finished(dicts: nil, error: NSError(domain: "com.520it.MHz", code: 1001, userInfo: ["message" : "没有找到statuses这个key"]))
                return
            }
            
//            MHzLog(array)
            finished(dicts: array as? [[String: AnyObject]], error: nil)
            
            }) { (task, error) -> Void in
                
                finished(dicts: nil, error: error)
        }
        
    }

    
    
    
}
