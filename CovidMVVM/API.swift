//
//  API.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Moya

enum CovidAPI {
    case getTotal
    case getPrefecture
}
extension CovidAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConst.COVID_BASE_URL)!
    }
    var path: String {
        switch self {
        case .getTotal:
            return APIConst.GET_COVID_TOTAL
        case .getPrefecture:
            return APIConst.GET_COVID_PREFECTURE
        }
    }
    var method: Method {
        switch self {
        case .getTotal:
            return .get
        case .getPrefecture:
            return .get
        }
    }
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        return .requestPlain
    }
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
