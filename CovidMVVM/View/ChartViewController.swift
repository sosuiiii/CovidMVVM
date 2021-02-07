//
//  ChartViewController.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import UIKit
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa
import Charts

class ChartViewController: UIViewController, StoryboardInstantiatable {
    
    struct Dependency {
        let viewModel: ChartViewModelType!
    }
    func inject(_ dependency: Dependency) {
        viewModel = dependency.viewModel
    }
    var viewModel: ChartViewModelType!
    
    let colors = Colors()
    var prefecture = UILabel()
    var pcr = UILabel()
    var pcrCount = UILabel()
    var cases = UILabel()
    var casesCount = UILabel()
    var deaths = UILabel()
    var deathsCount = UILabel()
    var segment = UISegmentedControl()
    var chartView: HorizontalBarChartView!
    var searchBar = UISearchBar()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.isHidden = true
        
        //MARK: Output
        let _ = viewModel.outputs.indexValue
            .subscribe(onNext: { [weak self] index in
                guard let self = self else {return}
                self.prefecture.text = "\(self.viewModel.outputs.covidPrefecture[index].nameJa)"
                self.pcrCount.text = "\(self.viewModel.outputs.covidPrefecture[index].pcr)"
                self.casesCount.text = "\(self.viewModel.outputs.covidPrefecture[index].cases)"
                self.deathsCount.text = "\(self.viewModel.outputs.covidPrefecture[index].deaths)"
            }).disposed(by: disposeBag)
        setView()
        dataSet()
    }
    
    @objc func switchAction(sender: UISegmentedControl) {
        viewModel.inputs.patternInput.onNext(sender.selectedSegmentIndex)
        loadView()
        viewDidLoad()
    }
    @objc func backButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    @objc func goCircle() {
        goCircleVC()
    }
}

//MARK: UISearchBarDelegate
extension ChartViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar:UISearchBar) {
        view.endEditing(true)
        if let index = viewModel.outputs.covidPrefecture
            .firstIndex(where: { $0.nameJa == searchBar.text }) {
            viewModel.inputs.index.onNext(index)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
    }
}

//MARK: ChartViewDelegate
extension ChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] {
           let index = dataSet.entryIndex(entry: entry)
            viewModel.inputs.index.onNext(index)
        }
    }
}

//MARK: ビュー
extension ChartViewController {
    func setView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        gradientLayer.colors = [Colors.bluePurple.cgColor,
                                Colors.blue.cgColor,]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        view.layer.insertSublayer(gradientLayer, at:0)
        
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.tintColor = Colors.white
        backButton.titleLabel?.font = .systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
        
        let nextButton = UIButton(type: .system)
        nextButton.frame = CGRect(x: view.frame.size.width - 105, y: 25, width: 100, height: 30)
        nextButton.setTitle("円グラフ", for: .normal)
        nextButton.setTitleColor(Colors.white, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(goCircle), for: .touchUpInside)
        view.addSubview(nextButton)
        
        segment = UISegmentedControl(items: ["感染者数", "PCR数", "死者数"])
        segment.frame = CGRect(x: 10, y: 70, width: view.frame.size.width - 20, height: 20)
        segment.selectedSegmentTintColor = Colors.blue
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.bluePurple], for: .normal)
        segment.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        segment.selectedSegmentIndex = viewModel.outputs.selectedSegment
        view.addSubview(segment)
        
        searchBar.frame = CGRect(x: 10, y: 100, width: view.frame.size.width - 20, height: 20)
        searchBar.delegate = self
        searchBar.placeholder = "都道府県を漢字で入力"
        searchBar.showsCancelButton = true
        searchBar.tintColor = Colors.blue
        view.addSubview(searchBar)
        
        let uiView = UIView()
        uiView.frame = CGRect(x: 10, y: view.frame.size.height - 200, width: view.frame.size.width - 20, height: 167)
        uiView.layer.cornerRadius = 10
        uiView.backgroundColor = .white
        uiView.layer.shadowColor = Colors.black.cgColor
        uiView.layer.shadowOffset = CGSize(width: 0, height: 2)
        uiView.layer.shadowOpacity = 0.4
        uiView.layer.shadowRadius = 10
        view.addSubview(uiView)
        
        bottomLabel(uiView, prefecture, 1, 10, text: "東京", size: 30, weight: .ultraLight, color: Colors.black)
        bottomLabel(uiView, pcr, 0.39, 50, text: "PCR数", size: 15, weight: .bold, color: Colors.bluePurple)
        bottomLabel(uiView, pcrCount, 0.39, 85, text: "2222222", size: 30, weight: .bold, color: Colors.blue)
        bottomLabel(uiView, cases, 1, 50, text: "感染者数", size: 15, weight: .bold, color: Colors.bluePurple)
        bottomLabel(uiView, casesCount, 1, 85, text: "22222", size: 30, weight: .bold, color: Colors.blue)
        bottomLabel(uiView, deaths, 1.61, 50, text: "死者数", size: 15, weight: .bold, color: Colors.bluePurple)
        bottomLabel(uiView, deathsCount, 1.61, 85, text: "2222", size: 30, weight: .bold, color: Colors.blue)
        
        for i in 0..<self.viewModel.outputs.covidPrefecture.count {
            if self.viewModel.outputs.covidPrefecture[i].nameJa == "東京" {
                viewModel.inputs.index.onNext(i)
                break
            }
        }
        
        chartView = HorizontalBarChartView(frame: CGRect(x: 0, y: 150, width: view.frame.size.width, height: view.frame.size.height - 353))
        chartView.animate(yAxisDuration: 1.0, easingOption: .easeOutCirc)
        chartView.xAxis.labelCount = 10
        chartView.xAxis.labelTextColor = Colors.bluePurple
        chartView.doubleTapToZoomEnabled = false
        chartView.delegate = self
        chartView.pinchZoomEnabled = false
        chartView.leftAxis.labelTextColor = Colors.bluePurple
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
    }
    func bottomLabel(_ parentView: UIView, _ label: UILabel,  _ x: CGFloat,_ y: CGFloat,  text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) {
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: size, weight: weight)
        label.frame = CGRect(x: 0, y: y, width: parentView.frame.size.width / 3.5, height: 50)
        label.center.x = view.center.x * x - 10
        parentView.addSubview(label)
    }
    func dataSet() {
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:viewModel.outputs.names)
        let set = BarChartDataSet(entries: viewModel.outputs.entries, label: "県別状況")
        set.colors = [Colors.blue]
        set.valueTextColor = Colors.bluePurple
        set.highlightColor = Colors.white
        chartView.data = BarChartData(dataSet: set)
        view.addSubview(chartView)
    }
}

