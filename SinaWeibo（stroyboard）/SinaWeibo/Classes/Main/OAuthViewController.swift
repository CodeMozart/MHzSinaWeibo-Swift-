//
//  OAuthViewController.swift
//  SinaWeibo
//
//  Created by Minghe on 11/10/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.加载登陆界面
        loadPage()
    }
    
    /// 加载登陆界面
    private func loadPage() {
        let str = "https://api.weibo.com/oauth2/authorize?client_id=\(MHz_App_Key)&redirect_uri=\(MHz_Redirect_URI)"
        
        guard let url = NSURL(string: str) else {
            return
        }
        
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    // MARK: - 内部控制方法 ------------------------------
    
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 自定义填充账号密码
    @IBAction func fillBtnClick(sender: AnyObject) {
        
        let js = "document.getElementById('userId').value = 'zhaomingheaaa@gmail.com';"+"document.getElementById('passwd').value = '19910115qxmhz';"
        
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
    

}

extension OAuthViewController: UIWebViewDelegate
{
    
    func webViewDidStartLoad(webView: UIWebView) {
        // 显示提醒，提醒用户正在加载登陆界面
        SVProgressHUD.showInfoWithStatus("正在加载……", maskType: .Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 关闭提醒
        SVProgressHUD.dismiss()
    }
    
    // webView每次请求一个新的地址都会调用该方法，返回true代表允许访问，返回false代表不允许访问
    
    /*
        如果是新浪的界面：https://api.weibo.com/
        授权成功:http://www.520it.com/?code=87ed79fd39c8cfe5c55a4b4cf4e2c0d5
        授权失败:http://www.520it.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
    */
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.判断是否是授权回调地址，如果不是就允许继续跳转
        guard let urlStr = request.URL?.absoluteString where urlStr.hasPrefix(MHz_Redirect_URI) else
        {
            MHzLog("api.weibo.com")
            return true
        }
        
        // 2.判断是否授权成功
        let code = "code="
        guard urlStr.containsString(code) else
        {
            // 授权失败
            MHzLog("error_uri")
            return false
        }
        
        // 3.授权成功
        // .query获取的是？号后面的字符串
        if let temp = request.URL?.query
        {
            // 截取code=后面的字符串
            let codeStr = temp.substringFromIndex(code.endIndex)
            // 利用RequestToken换取AccessToken
            loadAccessToken(codeStr)
        }
        
        return false
    }
    
    /// 根据RequestToken换取AccessToken
    private func loadAccessToken(codeStr: String) {
        
        NetworkTools.shareInstance.loadAccessToken(codeStr) { (dict, error) -> () in
            
            // 0.进行安全校验
            if let _ = error {
                SVProgressHUD.showErrorWithStatus("换取AccessToken错误", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            guard let info = dict else {
                SVProgressHUD.showErrorWithStatus("服务器返回的数据为空", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            // 1.将授权信息转换为模型
            let userAccount = UserAccount(dict: info)
            // 2.根据授权信息获取用户信息
            self.loadUserInfo(userAccount)
            
        }
    }
    
    /// 获取用户信息（姓名&头像）
    private func loadUserInfo(account: UserAccount) {
        
        NetworkTools.shareInstance.loadUserInfo(account) { (dict, error) -> () in
            
            // 0.进行安全校验
            if let _ = error {
                SVProgressHUD.showErrorWithStatus("换取AccessToken错误", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            guard let info = dict else {
                SVProgressHUD.showErrorWithStatus("服务器返回的数据为空", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            // 1.获取到的用户信息
            account.screen_name = info["screen_name"] as? String
            account.avatar_large = info["avatar_large"] as? String

            // 2.保存用户授权信息
            account.saveAccount()
            
            // 3.切换到欢迎页面
            // 发送通知，通知AppDelegate切换根控制器
            NSNotificationCenter.defaultCenter().postNotificationName(MHzRootViewControllerChanged, object: self, userInfo: ["message": true])
            
        }
    }
}










