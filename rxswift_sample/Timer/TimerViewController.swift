//
//  TimerViewController.swift
//  rxswift_sample
//
//  Created by kuma on 2020/12/27.
//

import UIKit
import RxSwift
import RxCocoa

class TimerViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    
    // Relay can emit onNext action only
    private let timerCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    private let isStart: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        setupLabel()
        setupTimer()
    }
}

extension TimerViewController {
    private func setupButtons() {
        // isStart set false as initial value
        stopButton.rx.tap.map { false }
            .bind(to: isStart)
            .disposed(by: disposeBag)
        
        // isStart set true as initial value
        startButton.rx.tap.map { true }
            .bind(to: isStart)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap.map{0}
            .bind(to: timerCount)
            .disposed(by: disposeBag)
        
        // reset button is enable only when stop timer
        isStart.map{!$0}
            .bind(to: resetButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        nextPageButton.rx.tap.subscribe ({ [weak self] _ in
            self?.presentLoginViewController()
        }).disposed(by: disposeBag)
    }
    
    private func setupLabel() {
        timerCount
            .map { String(format: "%02i:%02i:%02i", $0 / 3600, $0 / 60 % 60, $0 % 60) }
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // present value bind to label every time change timer value
    // only when status change, use distinctUntilChanged()
    private func setupTimer() {
        isStart
            .distinctUntilChanged()
            .flatMapLatest { $0
                ? Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                : Observable.empty() }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.timerCount.accept(self.timerCount.value + 1)
            })
            .disposed(by: disposeBag)
    }
}

extension TimerViewController {
    private func presentLoginViewController() {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true, completion: nil)
    }
}

