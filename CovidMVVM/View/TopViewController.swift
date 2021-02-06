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
            .subscribe(onNext: { _ in
                let alert = UIAlertController(title: "通信エラー", message: "データの取得に失敗しました\n再起動するか、しばらく時間をおいて\n再起動してください。", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            })
    }


}

