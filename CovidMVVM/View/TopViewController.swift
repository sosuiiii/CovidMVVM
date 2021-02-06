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
        
        
        //MARK: Inputs
        let _ = viewModel.inputs.fetchCovidTotal.onNext(Void())
        
        
        //MARK: Outputs
        let _ = viewModel.outputs.apiProgress
            .subscribe(onNext: { bool in
                if bool {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            }).disposed(by: disposeBag)
        
        let _ = viewModel.outputs.error
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.present(AlertUtil.showErrorAlert(completion: {
                    self.dismiss(animated: true, completion: nil)
                }), animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        let _ = viewModel.outputs.covidTotalResponse
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                guard let element = element else {return}
            }).disposed(by: disposeBag)
    }


}

