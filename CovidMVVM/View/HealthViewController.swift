//
//  HealthViewController.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import UIKit
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa
import FSCalendar
import CalculateCalendarLogic

class HealthViewController: UIViewController, StoryboardInstantiatable {
    
    struct Dependeny {
        let viewModel: HealthViewModelType!
    }
    func inject(_ dependency: HealthViewController.Dependeny) {
        viewModel = dependency.viewModel
    }
    var viewModel: HealthViewModelType!
    var today = ""
    var resultButton = UIButton(type: .system)
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        today = Date().dateFormatter()
        setupView()
        
        //MARK: Input
        let _ = resultButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                let title = self.viewModel.outputs.title
                let message = self.viewModel.outputs.message
                AlertUtil.showHealthCheckResult(vc: self, title: title, message: message, today: self.today)
            }).disposed(by: disposeBag)
        
    }
    @objc func switchAction(sender: UISwitch) {
        viewModel.inputs.switchAction.onNext(sender.isOn ? 1 : -1)
    }
    
}
//MARK: FSCalendarDelegate
extension HealthViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    //Delegateで紐付けた関数
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if let result = UserDefaults.standard.string(forKey: date.dateFormatter()) {
            return result
        }
        return ""
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return .init(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        if date.dateFormatter() == today {
            return Colors.bluePurple
        }
        return .clear
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 0.5
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date.judgeWeekday() == 1 {
            return UIColor(red: 150/255, green: 30/255, blue: 0/255, alpha: 0.9)
        } else if date.judgeWeekday() == 7 {
            return UIColor(red: 0/255, green: 30/255, blue: 150/255, alpha: 0.9)
        }
        if date.judgeHoliday() {
            return UIColor(red: 150/255, green: 30/255, blue: 0/255, alpha: 0.9)
        }
        return Colors.black
    }
}

//MARK: ビュー
extension HealthViewController {
    
    func setupView() {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 950)
        view.addSubview(scrollView)
        
        let calendar = FSCalendar()
        calendar.frame = CGRect(x: 20, y: 10, width: view.frame.size.width - 40, height: 300)
        scrollView.addSubview(calendar)
        calendar.appearance.headerTitleColor = Colors.bluePurple
        calendar.appearance.weekdayTextColor = Colors.bluePurple
        calendar.delegate = self
        calendar.dataSource = self
        
        let checkLabel = UILabel()
        checkLabel.text = "健康チェック"
        checkLabel.textColor = Colors.white
        checkLabel.frame = CGRect(x: 0, y: 340, width: view.frame.size.width, height: 20)
        checkLabel.backgroundColor = Colors.blue
        checkLabel.textAlignment = .center
        checkLabel.center.x = view.center.x
        scrollView.addSubview(checkLabel)
        
        let touples:[(CGFloat, String, String, Selector)] = [
            (380, "37.5度以上の熱がある", "check1", #selector(switchAction)),
            (465, "のどの痛みがある", "check2", #selector(switchAction)),
            (550, "匂いを感じない", "check3", #selector(switchAction)),
            (635, "味が薄く感じる", "check4", #selector(switchAction)),
            (720, "だるさがある", "check5", #selector(switchAction))
        ]
        for touple in touples {
            let uiView = createView(y: touple.0)
            scrollView.addSubview(uiView)
            createLabel(parentView: uiView, text: touple.1)
            createImage(parentView: uiView, imageName: touple.2)
            createUISwitch(parentView: uiView, action: touple.3)
        }

        resultButton.frame = CGRect(x: 0, y: 820, width: 200, height: 40)
        resultButton.center.x = scrollView.center.x
        resultButton.titleLabel?.font = .systemFont(ofSize: 20)
        resultButton.layer.cornerRadius = 5
        resultButton.setTitle("診断完了", for: .normal)
        resultButton.setTitleColor(Colors.white, for: .normal)
        resultButton.backgroundColor = Colors.blue
        scrollView.addSubview(resultButton)
        
        if UserDefaults.standard.string(forKey: today) != nil {
            resultButton.isEnabled = false
            resultButton.setTitle("診断済み", for: .normal)
            resultButton.backgroundColor = .white
            resultButton.setTitleColor(.gray, for: .normal)
        }
    }
    func createUISwitch(parentView: UIView, action: Selector) {
        let uiSwitch = UISwitch()
        uiSwitch.frame = CGRect(x: parentView.frame.size.width - 60, y: 20, width: 50, height: 30)
        uiSwitch.addTarget(self, action: action, for: .valueChanged)
        parentView.addSubview(uiSwitch)
    }
    
    func createLabel(parentView: UIView, text: String) {
        let label = UILabel()
        label.text = text
        label.frame = CGRect(x: 60, y: 15, width: 200, height: 40)
        parentView.addSubview(label)
    }
    
    func createImage(parentView: UIView, imageName: String) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.frame = CGRect(x: 10, y: 12, width: 40, height: 40)
        parentView.addSubview(imageView)
    }
    
    func createView(y: CGFloat) -> UIView {
        let uiView = UIView()
        uiView.frame = CGRect(x: 20, y: y, width: view.frame.size.width - 40, height: 70)
        uiView.backgroundColor = .white
        uiView.layer.cornerRadius = 20
        uiView.layer.shadowColor = UIColor.black.cgColor
        uiView.layer.shadowOpacity = 0.3
        uiView.layer.shadowRadius = 4
        uiView.layer.shadowOffset = CGSize(width: 0, height: 2)
        return uiView
    }
}
