//
//  ProfitsPieChartViewController.swift
//  Project
//
//  Created by raz cohen on 29/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Charts

class ProfitsPieChartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let arrow = right.currentImage else{return}
        let resizedArrow = arrow.resized(with: CGSize(width: 40, height: 32)).withTintColor(#colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1))
        right.setImage(resizedArrow, for: .normal)
        
        guard let arrowTwo = left.currentImage else{return}
        let resizedArrowTwo = arrowTwo.resized(with: CGSize(width: 40, height: 32)).withTintColor(#colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1))
        left.setImage(resizedArrowTwo, for: .normal)
        
        centerCircle(pieChart: pieChart)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerCircle(pieChart: pieChart)
        setDarkMode(view: self.view, labels: nil)
        
        Totals.shared.getTotalDayProfits(callback: { [weak self](sum) in
            
            self?.totalSum = sum
            PieChartDataSource.shared.profitsData(totalSum: sum, numberOfData: self!.numberOfData, pieChart: self!.pieChart,index:0, chosenDate: self!.date)
            
            
            let day = Dates().dayAndMonth(string: self!.todayDateString)
            let sumForamt = ActionDataSource.shared.currencyFormat(amount: sum)
            self?.customeText(string: "\(day)\n \(sumForamt)", size: 22, pieChart: self!.pieChart)
            
            }, date: Date())
        
        pieChart.animate(yAxisDuration: 2.5)
    }
    
    //MARK: variables
    
    var numberOfData = [PieChartDataEntry]()
    var totalSum = 1.0
    var index = Int()
    var date = Date()
    let todayDateString = Dates().castToString(date: Date())
    
    //MARK: outlets
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var right: UIButton!
    
    //MARK: actions
    
    @IBAction func backArrow(_ sender: UIButton) {
        
        setArrowsPie(Minus: true)
    }
    
    @IBAction func nextArrow(_ sender: UIButton) {
        
        setArrowsPie(Minus: false)
    }
    
    func setArrowsPie(Minus:Bool){
          switch index {
              
          case 0:
              if Minus{
                  date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
              }else{
                  date = Calendar.current.date(byAdding: .day, value: +1, to: date)!
              }
              
              Totals.shared.getTotalDayProfits(callback: { [weak self](sum) in
                  self?.totalSum = sum
                  PieChartDataSource.shared.profitsData(totalSum: sum, numberOfData: self!.numberOfData, pieChart: self!.pieChart,index:self!.index, chosenDate: self!.date)
                  
                  let sumForamt = ActionDataSource.shared.currencyFormat(amount: sum)
                  let dateString = Dates().castToString(date: self!.date)
                  let day = Dates().dayAndMonth(string: dateString)
                  self?.customeText(string: "\(day)\n \(sumForamt)", size: 22, pieChart: self!.pieChart)
                  
                  }, date: date)
              
          case 1:
              
              if Minus{
                  
                  date = Calendar.current.date(byAdding: .weekdayOrdinal, value: -1, to: date)!
              }else{
                  date = Calendar.current.date(byAdding: .weekdayOrdinal, value: +1, to: date)!
              }
              
              Totals.shared.getTotalWeekProfits(callback: { [weak self](sum) in
                  self?.totalSum = sum
                  PieChartDataSource.shared.profitsData(totalSum: sum, numberOfData: self!.numberOfData, pieChart: self!.pieChart,index:self!.index, chosenDate: self!.date)
                  
                  let sumForamt = ActionDataSource.shared.currencyFormat(amount: sum)
                  let days = WeekData().getDayOfThisWeek(date: self!.date)
                  let dateOne = Dates().dayAndMonth(string: days.first!)
                  let dateTow = Dates().dayAndMonth(string: days.last!)
                  
                  self?.customeText(string: "\(dateOne)\n\(dateTow)\n \(sumForamt)", size: 20, pieChart: self!.pieChart)
                  
                  }, date: date)
              
              
          case 2:
              
              if Minus{
                  
                  date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
              }else{
                  date = Calendar.current.date(byAdding: .month, value: +1, to: date)!
              }
              
              Totals.shared.getTotalMonthProfits(callback: { [weak self](sum) in
                  self?.totalSum = sum
                  PieChartDataSource.shared.profitsData(totalSum: sum, numberOfData: self!.numberOfData, pieChart: self!.pieChart,index:self!.index, chosenDate: self!.date)
                  
                  let sumForamt = ActionDataSource.shared.currencyFormat(amount: sum)
                  let dateString = Dates().castToString(date: self!.date)
                  let month = Dates().splitToMonth(string: dateString)
                  self?.customeText(string: "\(month)\n \(sumForamt)", size: 22, pieChart: self!.pieChart)
                  
                  }, date: date)
              
              
          case 3:
              
              if Minus{
                  
                  date = Calendar.current.date(byAdding: .year, value: -1, to: date)!
              }else{
                  date = Calendar.current.date(byAdding: .year, value: +1, to: date)!
              }
              
              Totals.shared.getTotalYearProfits(callback: { [weak self](sum) in
                  self?.totalSum = sum
                  PieChartDataSource.shared.profitsData(totalSum: sum, numberOfData: self!.numberOfData, pieChart: self!.pieChart,index:self!.index, chosenDate: self!.date)
                  
                  let sumForamt = ActionDataSource.shared.currencyFormat(amount: sum)
                  let dateString = Dates().castToString(date: self!.date)
                  let year = Dates().splitToYear(string: dateString)
                  self?.customeText(string: "\(year)\n \(sumForamt)", size: 22, pieChart: self!.pieChart)
                  
                  }, date: date)
              
          default:
              break
          }
      }
    
    @IBAction func segment(_ sender: UISegmentedControl) {
        
        index = sender.selectedSegmentIndex
        switch index {
        case 0:
            
            date = Date()
            Totals.shared.getTotalDayProfits(callback: { [weak self](sum) in
                self?.totalSum = sum
                
                PieChartDataSource.shared.profitsData(totalSum: sum, numberOfData: self!.numberOfData, pieChart: self!.pieChart,index:self!.index, chosenDate: self!.date)
                
                let sumForamt = ActionDataSource.shared.currencyFormat(amount: sum)
                let dateString = Dates().castToString(date: self!.date)
                let day = Dates().dayAndMonth(string: dateString)
                self?.customeText(string: "\(day)\n \(sumForamt)", size: 22, pieChart: self!.pieChart)
                
                }, date: date)
            
        case 1:
            
            date = Date()
            Totals.shared.getTotalWeekProfits(callback: { [weak self] (sum) in
                self?.totalSum = sum
                PieChartDataSource.shared.profitsData(totalSum: sum, numberOfData: self!.numberOfData, pieChart: self!.pieChart,index:self!.index, chosenDate: self!.date)
                
                let sumForamt = ActionDataSource.shared.currencyFormat(amount: sum)
                let days = WeekData().getDayOfThisWeek(date: self!.date)
                let dateOne = Dates().dayAndMonth(string: days.first!)
                let dateTow = Dates().dayAndMonth(string: days.last!)
                
                self?.customeText(string: "\(dateOne)\n\(dateTow)\n \(sumForamt)", size: 20, pieChart: self!.pieChart)
                
                }, date: Date())
            
            
        case 2:
            
            date = Date()
            Totals.shared.getTotalMonthProfits(callback: { [weak self] (sum) in
                self?.totalSum = sum
                PieChartDataSource.shared.profitsData(totalSum: sum, numberOfData: self!.numberOfData, pieChart: self!.pieChart,index:self!.index, chosenDate: self!.date)
                
                let sumForamt = ActionDataSource.shared.currencyFormat(amount: sum)
                let dateString = Dates().castToString(date: self!.date)
                let month = Dates().splitToMonth(string: dateString)
                self?.customeText(string: "\(month)\n \(sumForamt)", size: 22,
                                  pieChart: self!.pieChart)
                
                }, date: Date())
            
            
        case 3:
            
            date = Date()
            Totals.shared.getTotalYearProfits(callback: { [weak self] (sum) in
                self?.totalSum = sum
                PieChartDataSource.shared.profitsData(totalSum: sum, numberOfData: self!.numberOfData, pieChart: self!.pieChart,index:self!.index, chosenDate: self!.date)
                
                let sumForamt = ActionDataSource.shared.currencyFormat(amount: sum)
                let dateString = Dates().castToString(date: self!.date)
                let year = Dates().splitToYear(string: dateString)
                self?.customeText(string: "\(year)\n \(sumForamt)", size: 22, pieChart: self!.pieChart)
                
                }, date: Date())
            
        default:
            break
        }
    }
}

extension ProfitsPieChartViewController:ScreenMode{}
