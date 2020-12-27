//
//  LoginViewController.swift
//  rxswift_sample
//
//  Created by kuma on 2020/12/27.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindButton()
        bindTextFeild()
    }
}

extension LoginViewController {
    private func bindButton() {
        loginButton.rx.tap.subscribe({ _ in
            print("OK")
        }).disposed(by: disposeBag)
    }
    
    private func bindTextFeild() {
        let userIdValid = userIdTextField.rx.text.orEmpty
            .map {$0.count > 5}
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map{$0.count > 5}
            .share(replay: 1)
        
        let isLoginEnable = Observable.combineLatest(userIdValid, passwordValid) {$0 && $1}
            .share(replay: 1)
        
        isLoginEnable.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
}
