//
//  Repository.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import Moya

final class CovidRepository {
    private static let apiProvider = MoyaProvider<CovidAPI>()
    private static let disposeBag = DisposeBag()
}
extension CovidRepository {
    
    static func getTotal() throws -> Observable<CovidInfo.Total> {
        return apiProvider.rx.request(.getTotal)
            .map { response in
                return try JSONDecoder().decode(CovidInfo.Total.self, from: response.data)
            }.asObservable()
    }
    static func getPrefecture() throws -> Observable<[CovidInfo.Prefecture]> {
        return apiProvider.rx.request(.getPrefecture)
            .map{ response in
                return try JSONDecoder().decode([CovidInfo.Prefecture].self, from: response.data)
            }.asObservable()
    }
}
