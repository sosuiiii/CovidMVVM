//
//  CircleChartViewModel.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import RxCocoa
import Charts

protocol CircleChartViewModelInput {
    var patternInput: AnyObserver<Int> {get}
    var index: AnyObserver<Int> {get}
}

protocol CircleChartViewModelOutPut {
    var covidPrefecture: [CovidInfo.Prefecture] {get}
    var entries: [PieChartDataEntry] {get}
    var names: [String] {get}
    var selectedSegment: Int {get}
    var indexValue: Observable<Int> {get}
}

protocol CircleChartViewModelType {
    var inputs: CircleChartViewModelInput {get}
    var outputs: CircleChartViewModelOutPut {get}
}

class CircleChartViewModel: CircleChartViewModelInput, CircleChartViewModelOutPut {
    
    //MARK: input
    var patternInput: AnyObserver<Int>
    var index: AnyObserver<Int>
    
    //MARK: output
    var covidPrefecture: [CovidInfo.Prefecture]
    var entries: [PieChartDataEntry] = []
    var names: [String] = []
    var pattern: Observable<Int>
    var indexValue: Observable<Int>
    
    //MARK: other
    var selectedSegment = 0
    private var disposeBag = DisposeBag()
    
    init(data: [CovidInfo.Prefecture] ) {
        //MARK: Initialize
        self.covidPrefecture = data.sorted(by: {a,b in return a.cases > b.cases} )
        
        var entries:[PieChartDataEntry] = []
        for i in 0...4 {
            entries += [PieChartDataEntry(value: Double(self.covidPrefecture[i].cases), label: self.covidPrefecture[i].nameJa)]
        }
        var names:[String] = []
        for i in 0...4 {
            names += ["\(self.covidPrefecture[i].nameJa)"]
        }
        self.names = names
        self.entries = entries
        
        let _pattern = PublishRelay<Int>()
        self.pattern = _pattern.asObservable()
        
        let _indexValue = PublishRelay<Int>()
        self.indexValue = _indexValue.asObservable()
        
        //MARK: Input
        self.patternInput = AnyObserver<Int>() { value in
            guard let value = value.element else {return}
            _pattern.accept(value)
        }
        self.index = AnyObserver<Int>() { index in
            guard let index = index.element else {return}
            _indexValue.accept(index)
        }
        
        //MARK: Output
        //セグメント選択
        let _ = _pattern.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            self.selectedSegment = value
            var entries:[PieChartDataEntry] = []
            if value == 0 {
                self.covidPrefecture = data.sorted(by: {a,b in return a.cases > b.cases})
                for i in 0...4 {
                    entries += [PieChartDataEntry(value: Double(self.covidPrefecture[i].cases), label: self.covidPrefecture[i].nameJa)]
                }
            } else if value == 1 {
                self.covidPrefecture = data.sorted(by: {a,b in return a.pcr > b.pcr})
                for i in 0...4 {
                    entries += [PieChartDataEntry(value: Double(self.covidPrefecture[i].pcr), label: self.covidPrefecture[i].nameJa)]
                }
            } else if value == 2 {
                self.covidPrefecture = data.sorted(by: {a,b in return a.deaths > b.deaths})
                for i in 0...4 {
                    entries += [PieChartDataEntry(value: Double(self.covidPrefecture[i].deaths), label: self.covidPrefecture[i].nameJa)]
                }
            }
            var names:[String] = []
            for i in 0...4 {
                names += ["\(self.covidPrefecture[i].nameJa)"]
            }
            self.names = names
            self.entries = entries
        }).disposed(by: disposeBag)
    }
}

extension CircleChartViewModel: CircleChartViewModelType {
    var inputs: CircleChartViewModelInput {return self}
    var outputs: CircleChartViewModelOutPut {return self}
}
