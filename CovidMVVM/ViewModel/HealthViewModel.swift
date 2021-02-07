//
//  HealthCheckViewModel.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import RxCocoa

protocol HealthViewModelInput {
    var switchAction: AnyObserver<Int> {get}
}

protocol HealthViewModelOutPut {
    var title:String {get}
    var message:String {get}
}

protocol HealthViewModelType {
    var inputs: HealthViewModelInput {get}
    var outputs: HealthViewModelOutPut {get}
}

class HealthViewModel: HealthViewModelInput, HealthViewModelOutPut {
    
    //MARK: Input
    var switchAction: AnyObserver<Int>
    
    //MARK: Output
    var title = ""
    var message = ""
    
    //MARK: other
    private var disposeBag = DisposeBag()
    private var point:Observable<Int>
    private var sum = 0
    
    
    init() {
        
        let _point = PublishRelay<Int>()
        self.point = _point.asObservable()
        
        //MARK: Input
        self.switchAction = AnyObserver<Int>() {value in
            guard let value = value.element else {return}
            _point.accept(value)
        }
        
        //MARK: Output
        let _ = _point.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            
            self.sum += value
            if self.sum >= 4 {
                self.title = "高"
                self.message = "感染している可能性が\n比較的高いです。\nPCR検査をしましょう。"
            } else if self.sum >= 2 {
                self.title = "中"
                self.message = "やや感染している可能性が\nあります。外出は控えましょう。"
            } else {
                self.title = "低"
                self.message = "感染している可能性は\n今のところ低いです。\n今後も気をつけましょう"
            }
        }).disposed(by: disposeBag)
        
    }
}

extension HealthViewModel: HealthViewModelType {
    var inputs: HealthViewModelInput {return self}
    var outputs: HealthViewModelOutPut {return self}
}
