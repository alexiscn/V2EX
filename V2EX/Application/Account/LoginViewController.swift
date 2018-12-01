//
//  LoginViewController.swift
//  V2EX
//
//  Created by xu.shuifeng on 2018/6/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var captchaButton: UIButton!
    @IBOutlet weak var captchaTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var loginForm: LoginFormData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = NSLocalizedString("用户名", comment: "Login Page Username Label")
        usernameTextField.placeholder = NSLocalizedString("用户名或者电子邮箱", comment: "Login Page Username placeholder")
        passwordLabel.text = NSLocalizedString("密码", comment: "")
        passwordTextField.placeholder = NSLocalizedString("密码", comment: "")
        signInButton.setTitle(NSLocalizedString("登录", comment: ""), for: .normal)
        
        loadCaptcha()
    }
    
    private func loadCaptcha() {
        activityIndicator.isHidden = false
        captchaButton.setImage(UIImage(), for: .normal)
        V2SDK.refreshCode { [weak self] (formData, error) in
            self?.activityIndicator.isHidden = true
            if let formData = formData {
                self?.loginForm = formData
                let url = V2SDK.captchaURL(once: formData.once)
                Alamofire.request(url).responseData(completionHandler: { dataResponse in
                    if let data = dataResponse.data {
                        let img = UIImage(data: data)
                        self?.captchaButton.setImage(img, for: .normal)
                    }
                })
            } else {
                print(error ?? "")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func captchaButtonTapped(_ sender: Any) {
        if !activityIndicator.isHidden {
            return
        }
        loadCaptcha()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        guard let captcha = captchaTextField.text else {
            return
        }
        
        guard let formData = loginForm else {
            return
        }
        // TODO: check
        V2SDK.login(username: username, password: password, captcha: captcha, formData: formData)
    }
    
}
