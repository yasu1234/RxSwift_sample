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
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindButton()
        bindTextFeild()
    }
}

extension LoginViewController {
    private func bindButton() {
        loginButton.rx.tap
            .bind(to: viewModel.inputs.isLoginButtonTaped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isNextViewPresent
            .asObservable()
            .subscribe(onNext: { [weak self] isPresent in
                if isPresent {
                    self?.presentGithubSearchView()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoginButtonEnable
            .drive(onNext: { [weak self] isEnabled in
                if isEnabled {
                    self?.loginButton.isEnabled = true
                    self?.loginButton.setTitle("ログイン可能", for: UIControl.State.normal)
                } else {
                    self?.loginButton.isEnabled = false
                    self?.loginButton.setTitle("ログインできません", for: UIControl.State.normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTextFeild() {
        userIdTextField.rx.text
            .map{$0 ?? ""}
            .bind(to: viewModel.userId)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .map{$0 ?? ""}
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    private func presentGithubSearchView() {
        let githubSearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "GithubSearchViewController") as! GithubSearchViewController
        githubSearchViewController.modalPresentationStyle = .fullScreen
        present(githubSearchViewController, animated: true, completion: nil)
    }
}
