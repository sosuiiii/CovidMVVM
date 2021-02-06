//
//  ViewController.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import UIKit
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa
import PKHUD

class TopViewController: UIViewController, StoryboardInstantiatable {
    
    //MARK: DI
    var viewModel: TopViewModelType!
    struct Dependency {
        let viewModel: TopViewModelType!
    }
    func inject(_ dependency: TopViewController.Dependency) {
        viewModel = dependency.viewModel
    }
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        let label = UILabel()
        label.text = "aa"
        label.tintColor = .black
        label.textColor = .black
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 50)
        view.addSubview(label)
        
        let _ = viewModel.inputs.fetchCovidTotal.onNext(Void())
    }


}

