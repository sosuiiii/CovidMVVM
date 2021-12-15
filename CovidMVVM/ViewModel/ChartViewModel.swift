//
//  ChartViewModel.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import RxCocoa
import Charts

protocol ChartViewModelInput {
    var patternInput: AnyObserver<Int> {get}
    var index: AnyObserver<Int> {get}
}

protocol ChartViewModelOutPut {
    var covidPrefecture: [CovidInfo.Prefecture] {get}
    var entries: [BarChartDataEntry] {get}
    var names: [String] {get}
    var selectedSegment: Int {get}
    var indexValue: Observable<Int> {get}
}

protocol ChartViewModelType {
    var inputs: ChartViewModelInput {get}
    var outputs: ChartViewModelOutPut {get}
}

class ChartViewModel: ChartViewModelInput, ChartViewModelOutPut {
    
    //MARK: input
    var patternInput: AnyObserver<Int>
    var index: AnyObserver<Int>
    
    //MARK: output
    var covidPrefecture: [CovidInfo.Prefecture]
    var entries: [BarChartDataEntry] = []
    var names: [String] = []
    var pattern: Observable<Int>
    var indexValue: Observable<Int>
    
    //MARK: other
    var selectedSegment = 0
    private var disposeBag = DisposeBag()
    
    
    init(data: [CovidInfo.Prefecture]) {
        
        //MARK: Initialize
        self.covidPrefecture = data.sorted(by: {a,b in return a.cases > b.cases} )
        print(covidPrefecture)
        print("squash_fix6")
        var entries:[BarChartDataEntry] = []
        for i in 0...9 {
            entries += [BarChartDataEntry(x: Double(i), y: Double(self.covidPrefecture[i].cases))]
        }
        var names:[String] = []
        for i in 0...9 {
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
            var entries:[BarChartDataEntry] = []
            if value == 0 {
                self.covidPrefecture = data.sorted(by: {a,b in return a.cases > b.cases})
                for i in 0...9 {
                    entries += [BarChartDataEntry(x: Double(i), y: Double(self.covidPrefecture[i].cases))]
                }
            } else if value == 1 {
                self.covidPrefecture = data.sorted(by: {a,b in return a.pcr > b.pcr})
                for i in 0...9 {
                    entries += [BarChartDataEntry(x: Double(i), y: Double(self.covidPrefecture[i].pcr))]
                }
            } else if value == 2 {
                self.covidPrefecture = data.sorted(by: {a,b in return a.deaths > b.deaths})
                for i in 0...9 {
                    entries += [BarChartDataEntry(x: Double(i), y: Double(self.covidPrefecture[i].deaths))]
                }
            }
            var names:[String] = []
            for i in 0...9 {
                names += ["\(self.covidPrefecture[i].nameJa)"]
            }
            self.names = names
            self.entries = entries
        }).disposed(by: disposeBag)
    }
}

extension ChartViewModel: ChartViewModelType {
    var inputs: ChartViewModelInput {return self}
    var outputs: ChartViewModelOutPut {return self}
}
