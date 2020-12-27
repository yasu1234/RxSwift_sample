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
    private let loginViewModel = LoginViewModel()
    
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
        
        userIdTextField.rx.text
            .map{$0 ?? ""}
            .bind(to: loginViewModel.userId)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .map{$0 ?? ""}
            .bind(to: loginViewModel.password)
            .disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
}
