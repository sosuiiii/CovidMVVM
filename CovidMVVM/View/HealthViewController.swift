//
//  HealthViewController.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import UIKit
import Instantiate
import InstantiateStandard

class HealthViewController: UIViewController, StoryboardInstantiatable {
    
    struct Dependeny {
        let viewModel: HealthViewModelType!
    }
    func inject(_ dependency: HealthViewController.Dependeny) {
        viewModel = dependency.viewModel
    }
    var viewModel: HealthViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }

}
