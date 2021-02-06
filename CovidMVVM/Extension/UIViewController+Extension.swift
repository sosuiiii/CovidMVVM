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
        navi.modalPresentationStyle = .fullScreen
//        vc.navigationController?.pushViewController(navi, animated: true)
        self.present(navi, animated: true, completion: nil)
    }
    func goChart() {
        
    }
    func goCircleVC() {
        
    }
}
