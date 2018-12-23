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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameLineView: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLineView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var captchaButton: UIButton!
    @IBOutlet weak var captchaTextField: UITextField!
    @IBOutlet weak var captchaLineView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var loginForm: LoginFormData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.current.backgroundColor
        closeButton.tintColor = Theme.current.titleColor
        titleLabel.textColor = Theme.current.titleColor
        containerView.backgroundColor = Theme.current.cellBackgroundColor
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10.0
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 10.0
        usernameLabel.textColor = Theme.current.subTitleColor
        usernameTextField.textColor = Theme.current.titleColor
        passwordLabel.textColor = Theme.current.subTitleColor
        passwordTextField.textColor = Theme.current.titleColor
        usernameLineView.backgroundColor = Theme.current.backgroundColor
        passwordLineView.backgroundColor = Theme.current.backgroundColor
        captchaTextField.textColor = Theme.current.titleColor
        captchaLineView.backgroundColor = Theme.current.backgroundColor
        signInButton.setTitleColor(Theme.current.titleColor, for: .normal)
        
        usernameLabel.text = Strings.LoginUsername
        usernameTextField.placeholder = Strings.LoginUsernamePlaceholder
        passwordLabel.text = Strings.LoginPassword
        passwordTextField.placeholder = Strings.LoginPasswordPlaceholder
        signInButton.setTitle(Strings.LoginButtonTitle, for: .normal)
        
        usernameTextField.becomeFirstResponder()
        loadCaptcha()
    }
    
    private func loadCaptcha() {
        activityIndicator.isHidden = false
        captchaButton.setImage(UIImage(), for: .normal)
        V2SDK.request(EndPoint.onceToken(), parser: OnceTokenParser.self) { [weak self] (response: V2Response<LoginFormData>) in
            self?.activityIndicator.isHidden = true
            switch response {
            case .success(let formData):
                self?.loginForm = formData
                let url = V2SDK.captchaURL(once: formData.once)
                Alamofire.request(url).responseData(completionHandler: { dataResponse in
                    if let data = dataResponse.data {
                        let img = UIImage(data: data)
                        self?.captchaButton.setImage(img, for: .normal)
                    }
                })
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.current.statusBarStyle
    }
    
    private func hideKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordLabel.resignFirstResponder()
        captchaTextField.resignFirstResponder()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        hideKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func captchaButtonTapped(_ sender: Any) {
        if !activityIndicator.isHidden {
            return
        }
        loadCaptcha()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        guard let formData = loginForm else {
            HUD.show(message: Strings.LoginRefreshCaptchaAlerts)
            return
        }
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            HUD.show(message: Strings.LoginUsernameAlerts)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            HUD.show(message: Strings.LoginPasswordAlerts)
            return
        }
        guard let captcha = captchaTextField.text, !captcha.isEmpty else {
            HUD.show(message: Strings.LoginCaptchaAlerts)
            return
        }
        hideKeyboard()
        HUD.showIndicator()
        let endPoint = EndPoint.signIn(username: username, password: password, captcha: captcha, formData: formData)
        V2SDK.request(endPoint, parser: SignInParser.self) { (response: V2Response<Account>) in
            HUD.removeIndicator()
            switch response {
            case .success(let account):
                print(account)
                V2SDK.once = formData.once
                AppContext.current.account = account
                self.postLoginSuccessNotification()
                self.dismiss(animated: true, completion: nil)
            case .error(let error):
                HUD.show(message: error.description)
            }
        }
    }
    
    func postLoginSuccessNotification() {
        NotificationCenter.default.post(name: NSNotification.Name.V2.LoginSuccess, object: nil)
    }
    
}
