//
//  CovidMVVMTests.swift
//  CovidMVVMTests
//
//  Created by TanakaSoushi on 2021/02/04.
//

import RxSwift
import Quick
import Nimble
import RxTest

@testable import CovidMVVM

class HealthCheckTest: QuickSpec {
    let disposeBag = DisposeBag()
    
    override func spec() {
        describe("入力に対する出力") {
            context("健康診断で該当するポイントが入力される") {
                let scheduler = TestScheduler(initialClock: 0, resolution: 0.1)
                let inputSwitch = [
                    Recorded.next(1, 1),
                    Recorded.next(2, 1),
                    Recorded.next(3, 1),
                    Recorded.next(4, -1)
                ]
                it("ポイントの総計でモックデータと同じ結果が出力される") {
                    var titleObserver: TestableObserver<String>
                    var messageObserver: TestableObserver<String>
                    do {
                        let viewModel:HealthViewModelType = HealthViewModel()
                        
                        let switchAction = scheduler.createHotObservable(inputSwitch)
                        switchAction.asObservable()
                            .subscribe(onNext: { value in
                                viewModel.inputs.switchAction.onNext(value)
                            }).disposed(by: self.disposeBag)
                        
                        titleObserver = scheduler.createObserver(String.self)
                        messageObserver = scheduler.createObserver(String.self)
                        
                        viewModel.outputs.title.bind(to: titleObserver)
                            .disposed(by: self.disposeBag)
                        viewModel.outputs.message.bind(to: messageObserver)
                            .disposed(by: self.disposeBag)
                        
                        scheduler.start()
                    }
                    expect(titleObserver.events).to(equal ([
                        Recorded.next(1, "低"),
                        Recorded.next(2, "中"),
                        Recorded.next(3, "中"),
                        Recorded.next(4, "中")
                    ]))
                    expect(messageObserver.events).to(equal ([
                        Recorded.next(1, "感染している可能性は\n今のところ低いです。\n今後も気をつけましょう"),
                        Recorded.next(2, "やや感染している可能性が\nあります。外出は控えましょう。"),
                        Recorded.next(3, "やや感染している可能性が\nあります。外出は控えましょう。"),
                        Recorded.next(4, "やや感染している可能性が\nあります。外出は控えましょう。")
                    ]))
                }
            }
        }
    }
}

class CovidMVVMTests: XCTestCase {

    //セットアップ
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    //初期化
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //テスト
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
