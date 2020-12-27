//
//  ViewController.swift
//  rxswift_sample
//
//  Created by kuma on 2020/12/26.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    
    // BehaviorRelay-> has initial value, can use next event, stream present value when subscribe
    // PublishRelay-> do not have initial value, can use next event
    private var count = BehaviorRelay(value: 0)
    
    private let disposeBag = DisposeBag()
    private var isButtonEnabled = PublishSubject<Bool>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindButton()
        bindLabel()
    }
}

extension ViewController {
    private func bindButton() {
        
        upButton.rx.tap.subscribe { [weak self] _ in
            self?.increment()
        }.disposed(by: disposeBag)
        
        downButton.rx.tap.subscribe { [weak self] _ in
            self?.decrement()
        }.disposed(by: disposeBag)
        
        nextPageButton.rx.tap.subscribe { [weak self] _ in
            self?.presentTimerViewController()
        }.disposed(by: disposeBag)
    }
    
    
    private func bindLabel() {
        // 'asObservable()' means convert to Observable
        count.asObservable().subscribe(onNext: { [weak self] count in
            self?.countLabel.text = String(count)
        }).disposed(by: disposeBag)
    }
}

extension ViewController {
    
    private func increment() {
        // 'accept' means next event
        count.accept(count.value + 1)
    }
    
    private func decrement() {
        count.accept(count.value - 1)
    }
}

extension ViewController {
    
    private func presentTimerViewController() {
        let timerViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        timerViewController.modalPresentationStyle = .fullScreen
        self.present(timerViewController, animated: true, completion: nil)
    }
}

