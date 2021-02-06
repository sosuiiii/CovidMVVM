//
//  APIConst.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation

struct APIConst {
    static let BASE_URL = "https://covid19-japan-web-api.now.sh/api/v1/"
    static let GET_COVID_PREFECTURE = BASE_URL + "prefectures"
    static let GET_COVID_TOTAL = BASE_URL + "total"
}
