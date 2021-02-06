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
    struct Dependency {
        let viewModel: TopViewModelType!
    }
    func inject(_ dependency: TopViewController.Dependency) {
        viewModel = dependency.viewModel
    }
    
    //MARK: Properties
    var viewModel: TopViewModelType!
    let disposeBag = DisposeBag()
    
    let centerView = UIView()
    let pcr = UILabel() //PCR
    let pcrNum = UILabel()
    let positive = UILabel() //感染
    let positiveNum = UILabel()
    let hospitalize = UILabel()  //入院
    let hospitalizeNum = UILabel()
    let severe = UILabel() //重症
    let severeNum = UILabel()
    let death = UILabel() //死者
    let deathNum = UILabel()
    let discharge = UILabel() //退院
    let dischargeNum = UILabel()
    
    var reloadButton = UIButton(type: .system)
    let chatButton = UIButton(type: .system)
    let goHealthVCButton = UIButton(type: .system)
    let goChartVCButton = UIButton(type: .system)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: ビューのセットアップ
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemGray6
        setupGradation()
        setupCenterView()
        setupContent()
        setupAPILabel()
        setupAPILabel()
        
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
                DispatchQueue.main.async {
                    self.pcrNum.text = "\(element.pcr)"
                    self.positiveNum.text = "\(element.positive)"
                    self.hospitalizeNum.text = "\(element.hospitalize)"
                    self.severeNum.text = "\(element.severe)"
                    self.deathNum.text = "\(element.death)"
                    self.dischargeNum.text = "\(element.discharge)"
                }
            }).disposed(by: disposeBag)
        
        
        //MARK: other
        let _ = reloadButton.rx.tap
            .withLatestFrom(reloadButton.rx.tap)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.loadView()
                self.viewDidLoad()
            }).disposed(by: disposeBag)
        
        let _ = chatButton.rx.tap
            .withLatestFrom(chatButton.rx.tap)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.performSegue(withIdentifier: "goChat", sender: nil)
            }).disposed(by: disposeBag)
        
        let _ = goHealthVCButton.rx.controlEvent(.touchUpInside)
            .withLatestFrom(goHealthVCButton.rx.tap)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.performSegue(withIdentifier: "goHealthCheck", sender: nil)
            }).disposed(by: disposeBag)
        
        let _ = goChartVCButton.rx.controlEvent(.touchUpInside)
            .withLatestFrom(goChartVCButton.rx.tap)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.performSegue(withIdentifier: "goChart", sender: nil)
            }).disposed(by: disposeBag)
        
    }
}

//MARK: ビュー
extension TopViewController {
    //背景トップのグラデーション
    func setupGradation() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 2)
        gradientLayer.colors = [Colors.bluePurple.cgColor, Colors.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    //真ん中のビュー
    func setupCenterView() {
        centerView.frame.size = CGSize(width: view.frame.size.width, height: 340)
        centerView.center = CGPoint(x: view.center.x, y: view.center.y)
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = 30
        centerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        centerView.layer.shadowColor = UIColor.gray.cgColor
        centerView.layer.shadowOpacity = 0.5
        view.addSubview(centerView)
    }
    //真ん中のビューの数値
    func setupAPILabel() {
        let size = CGSize(width: 200, height: 40)
        let leftX = view.frame.size.width * 0.38
        let rightX = view.frame.size.width * 0.85
        let font = UIFont.systemFont(ofSize: 35, weight: .heavy)
        let color = Colors.blue
        createAPILabel(pcrNum, size: size, centerX: leftX, y: 60, font: font, color: color)
        createAPILabel(positiveNum, size: size, centerX: rightX, y: 60, font: font, color: color)
        createAPILabel(hospitalizeNum, size: size, centerX: leftX, y: 160, font: font, color: color)
        createAPILabel(severeNum, size: size, centerX: rightX, y: 160, font: font, color: color)
        createAPILabel(deathNum, size: size, centerX: leftX, y: 260, font: font, color: color)
        createAPILabel(dischargeNum, size: size, centerX: rightX, y: 260, font: font, color: color)
        
    }
    func createAPILabel(_ label: UILabel, size: CGSize, centerX: CGFloat,y: CGFloat, font: UIFont, color: UIColor) {
        label.frame.size = size
        label.center.x = centerX
        label.frame.origin.y = y
        label.font = font
        label.textColor = color
        centerView.addSubview(label)
    }
    
    //タイトル、APIデータのタイトル、下部ボタン
    func setupContent() {
         
        let labelFont = UIFont.systemFont(ofSize: 15, weight: .heavy)
        let size = CGSize(width: 150, height: 50)
        let color = Colors.bluePurple
        let leftX = view.frame.size.width * 0.33
        let rightX = view.frame.size.width * 0.80
        createLabelTitle("Covid in Japan",
                   size: CGSize(width: 180, height: 35),
                   centerX: view.center.x - 20, y: -60,
                   font: .systemFont(ofSize: 25, weight: .heavy),
                   color: .white)
        createLabelTitle("PCR数", size: size, centerX:  leftX, y: 20, font: labelFont, color: color)
        createLabelTitle("感染者数", size: size, centerX: rightX , y: 20, font: labelFont, color: color)
        createLabelTitle("入院者数", size: size, centerX: leftX , y: 120, font: labelFont, color: color)
        createLabelTitle("重傷者数", size: size, centerX: rightX , y: 120, font: labelFont, color: color)
        createLabelTitle("死者数", size: size, centerX: leftX , y: 220, font: labelFont, color: color)
        createLabelTitle("退院者数", size: size, centerX: rightX , y: 220, font: labelFont, color: color)
        
        let height = view.frame.size.height / 2
        createButton(goHealthVCButton, "健康管理", size: size, y: height + 190, color: Colors.blue)
        createButton(goChartVCButton, "県別状況", size: size, y: height + 240, color: Colors.blue)
        createImageButton(chatButton, "chat", x: view.frame.size.width - 50)
        createImageButton(reloadButton, "reload", x: 10)
        
        let imageView = UIImageView()
        let image = UIImage(named: "virus")
        imageView.image = image
        imageView.frame = CGRect(x: view.frame.size.width, y: -65, width: 50, height: 50)
        centerView.addSubview(imageView)
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn], animations: {
            imageView.frame = CGRect(x: self.view.frame.size.width - 100, y: -65, width: 50, height: 50)
            imageView.transform = CGAffineTransform(rotationAngle: -90)
        }, completion: nil)
    }
    //APIデータのタイトル
    func createLabelTitle(_ text: String, size: CGSize, centerX: CGFloat,y: CGFloat, font: UIFont, color: UIColor){
        let label = UILabel()
        label.text = text
        label.frame.size = size
        label.center.x = centerX
        label.frame.origin.y = y
        label.font = font
        label.textColor = color
        centerView.addSubview(label)
    }
    //下部ボタン
    func createButton(_ button: UIButton, _ title: String, size: CGSize, y: CGFloat, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.frame.size = size
        button.center.x = view.center.x
        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.kern: 8.0])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.frame.origin.y = y
        button.setTitleColor(color, for: .normal)
        view.addSubview(button)
    }
    //上部ボタン
    func createImageButton(_ button: UIButton, _ name: String, x: CGFloat) {
        button.setImage(UIImage(named: name), for: .normal)
        button.frame.size = CGSize(width: 30, height: 30)
        button.tintColor = .white
        button.frame.origin = CGPoint(x: x, y: 25)
        view.addSubview(button)
    }
}
