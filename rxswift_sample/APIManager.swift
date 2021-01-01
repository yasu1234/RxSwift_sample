//
//  APIManager.swift
//  rxswift_sample
//
//  Created by kuma on 2020/12/31.
//

import RxSwift

class APIMAnager {
    
    static func serachRepository(query: String) -> Observable<[Repository]> {
        
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)") else {
            return Observable.just([])
            
        }
        
        return URLSession.shared.rx
            .json(url: url)
            .retry(3)
            .map(parse(json:))
            .catchErrorJustReturn([])
    }
    
    static func parse(json: Any) -> [Repository] {
            
        let res = json as AnyObject
        let items = res.object(forKey: "items")! as? [AnyObject] ?? []
        var repositories = [Repository]()

        items.forEach {
            guard let name = $0["name"] as? String,
                let url = $0["html_url"] as? String else {
                    return
            }
            repositories.append(Repository(name: name, url: url))
        }
        return repositories
    }
}
