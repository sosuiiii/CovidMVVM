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
    //共通化できていないのであまり意味ない
    static func showHealthCheckResult(vc: UIViewController, title: String, message: String, today: String) {
        let alert = UIAlertController(title: "診断を完了しますか？", message: "診断は1日に1回までです", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "完了", style: .default, handler: { _ in
            let alert = UIAlertController(title: "感染している可能性「\(title)」", message: message, preferredStyle: .alert)
            vc.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    vc.dismiss(animated: true, completion: nil)
                })
            })
            //診断結果をローカルに保存
            UserDefaults.standard.set(title, forKey: today)
        })
        let noAction = UIAlertAction(title: "キャンセル", style: .destructive, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
