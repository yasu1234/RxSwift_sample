//
//  LoginViewModel.swift
//  rxswift_sample
//
//  Created by kuma on 2020/12/27.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    
    let userId = PublishSubject<String>()
    let password = PublishSubject<String>()
    
    func isValid()-> Observable<Bool> {
        return Observable.combineLatest(userId.asObservable(), password.asObservable())
            .map {userId, password in
                return userId.count > 5 && password.count > 5
            }.startWith(false)
    }
}
