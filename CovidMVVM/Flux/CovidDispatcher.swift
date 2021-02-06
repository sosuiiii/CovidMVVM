//
//  CovidDispatcher.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import RxCocoa

final class CovidDispatcher {
    let fetchCovidTotal = PublishRelay<CovidInfo.Total>()
    let fetchCovidPrefecture = PublishRelay<[CovidInfo.Prefecture]>()
    let error = PublishRelay<Error>()
}
