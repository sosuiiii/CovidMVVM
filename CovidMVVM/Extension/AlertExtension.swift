//
//  AlertExtension.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import UIKit

open class AlertUtil {
    static func showErrorAlert(completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "通信エラー", message: "データの取得に失敗しました\n再起動するか、しばらく時間をおいて\n再起動してください。", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let completion = completion else {return}
            completion()
        })
        alert.addAction(action)
        return alert
    }
}
