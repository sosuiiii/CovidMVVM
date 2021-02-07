//
//  UIViewController+Extension.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import UIKit

extension UIViewController {
    
    func goChatVC() {
        
    }
    func goHealthVC() {
        let vm = HealthViewModel()
        let dependency = HealthViewController.Dependeny(viewModel: vm)
        let vc = HealthViewController.instantiate(with: dependency)
        let navi = UINavigationController(rootViewController: vc)
//        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true, completion: nil)
    }
    func goChart() {
        let vm = ChartViewModel(data: CovidSingleton.shared.prefecture)
        let dependency = ChartViewController.Dependency(viewModel: vm)
        let vc = ChartViewController.instantiate(with: dependency)
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true, completion: nil)
    }
    func goCircleVC() {
        
    }
}
