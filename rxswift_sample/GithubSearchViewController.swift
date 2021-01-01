//
//  GithubSearchViewController.swift
//  rxswift_sample
//
//  Created by kuma on 2020/12/31.
//

import UIKit
import RxSwift
import RxCocoa

class GithubSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var githubTableView: UITableView!
    
    private let viewModel = GithubSearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
}

extension GithubSearchViewController {
    
    private func bindUI() {
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)
        
        viewModel.repositories
            .bind(to: githubTableView.rx.items(cellIdentifier: "GithubRepositoryItemCell", cellType: RepositortCell.self)) { (row, element, cell) in
                cell.setName(name: element.name)
                
            }
            .disposed(by: disposeBag)
        
        githubTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
}

extension GithubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
