//
//  GithubSearchViewModel.swift
//  rxswift_sample
//
//  Created by kuma on 2020/12/31.
//

import Foundation
import RxSwift
import RxCocoa

class GithubSearchViewModel {
    
    var searchQuery = BehaviorRelay(value: "")
    var repositories: Observable<[Repository]>
    
    init() {
        repositories = searchQuery.asObservable().distinctUntilChanged()
            .flatMapLatest{ query -> Observable<[Repository]> in
                if (query.isEmpty) {
                    return Observable.just([])
                } else {
                    return APIMAnager.serachRepository(query: query)
                }
            }
        
    }

}
