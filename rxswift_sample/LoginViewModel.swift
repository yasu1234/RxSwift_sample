//
//  LoginViewModel.swift
//  rxswift_sample
//
//  Created by kuma on 2020/12/27.
//

import RxSwift
import RxCocoa

protocol LoginViewModelInputs: AnyObject {
    var userId: PublishSubject<String> { get }
    var password: PublishSubject<String> { get }
    var isLoginButtonTaped: PublishSubject<Void> { get }
 }

protocol LoginViewModelOutputs: AnyObject {
    var isLoginButtonEnable: Driver<Bool> { get }
    var isNextViewPresent: PublishSubject<Bool> { get }
}

protocol LoginViewModelType: AnyObject {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
    var inputs: LoginViewModelInputs {return self}
    var outputs: LoginViewModelOutputs {return self}
    
    var userId = PublishSubject<String>()
    var password = PublishSubject<String>()
    var isLoginButtonTaped = PublishSubject<Void>()
    
    let isLoginButtonEnable: Driver<Bool>
    let isNextViewPresent = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        isLoginButtonEnable = Observable.combineLatest(userId, password)
            .map {userId, password in
                return userId.count > 5 && password.count > 5
            }.asDriver(onErrorJustReturn: false)
        
        isLoginButtonTaped.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.isNextViewPresent.onNext(true)
            })
            .disposed(by: disposeBag)
    }
}
