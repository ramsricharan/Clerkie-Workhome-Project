//
//  DataAnalyticsViewController.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 9/4/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import UIKit
import Charts

class DataAnalyticsViewController: UIViewController, UIScrollViewDelegate {

    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        ///////// My Variables ////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    var currentVisibleView : UIView?
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        /////////  Start up methods ////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        // Setup Views
        setupView()
        baseScrollView.delegate = self
        
        // Setup Chart Data
        barChartSetup()
        horizontalBarChartSetup()
        lineChartSetup()
        duoLineChartSetup()
        setupPieChart()
        
        
        // Setup Navigation bar
        self.navigationItem.title = "Data Analytics"
        self.navigationController?.navigationBar.tintColor = UIColor.myPink

    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    ///////// ScrollView methods ////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    // User stopped dragging the ScrollView
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(baseScrollView.isDecelerating == false)
        {
            animateVisibleView()
        }
    }
    
    // ScrollView stopped after acceleration animation
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateVisibleView()
    }
    
    // Make the current Visible graph to animate
    func animateVisibleView()
    {
        let barGraphFrame : CGRect = self.barGraphContainer.frame
        let horizontalGraphFrame : CGRect = self.horizontalBarGraphContainer.frame
        let singleLineGraphFrame : CGRect = self.singleLineGraphContainer.frame
        let duoLineGraphFrame : CGRect = self.duoLineGraphContainer.frame
        let pieChartFrame : CGRect = self.pieChartContainer.frame
        
        let scrollingContainer : CGRect = CGRect(x: 0, y: baseScrollView.contentOffset.y + 200, width: baseScrollView.frame.size.width, height: baseScrollView.frame.size.height)

        if(scrollingContainer.intersects(barGraphFrame))
        {
            myBarGraphView.animate(xAxisDuration: 0.5, yAxisDuration: 1.0, easingOption: .easeOutBack)
        }
        else if(scrollingContainer.intersects(horizontalGraphFrame))
        {
            myHorizontalGraphView.animate(xAxisDuration: 1.0, yAxisDuration: 0.5, easingOption: .easeOutCubic)
        }
        else if(scrollingContainer.intersects(singleLineGraphFrame))
        {
            mySingleLineGraphView.animate(yAxisDuration: 1.0, easingOption: .easeOutSine)
        }
        else if(scrollingContainer.intersects(duoLineGraphFrame))
        {
            myDuoLineGraphView.animate(xAxisDuration: 1.0, easingOption: .linear)
        }
        else if(scrollingContainer.intersects(pieChartFrame))
        {
            myPieChartView.animate(yAxisDuration: 1.0, easingOption: .easeInExpo)
        }
        else
        {
            print("No match")
        }
        
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                            ///////////////// Graph Methods ////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Setup Bar Graph
    func barChartSetup()
    {
        // Create Data
        let entry1 = BarChartDataEntry(x: 1.0, y: 30.0)
        let entry2 = BarChartDataEntry(x: 2.0, y: 24.0)
        let entry3 = BarChartDataEntry(x: 3.0, y: 63.0)
        let entry4 = BarChartDataEntry(x: 4.0, y: 4.0)
        let entry5 = BarChartDataEntry(x: 5.0, y: 6.0)
        let entry6 = BarChartDataEntry(x: 6.0, y: 43.0)
        let entry7 = BarChartDataEntry(x: 7.0, y: 73.0)
        let entry8 = BarChartDataEntry(x: 8.0, y: 11.0)
        
        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8], label: "Bar Data")
        let data = BarChartData(dataSets: [dataSet])
        myBarGraphView.data = data
        myBarGraphView.chartDescription?.text = ""
        

        dataSet.colors = ChartColorTemplates.joyful()

        myBarGraphView.animate(xAxisDuration: 0.5, yAxisDuration: 1.0, easingOption: .easeOutBack)

        // Notify the data changes
        myBarGraphView.notifyDataSetChanged()
    }
    
    
    
    // Setup Bar Graph
    func horizontalBarChartSetup()
    {
        // Create Chart Data
        let entry1 = BarChartDataEntry(x: 1.0, y: 30.0)
        let entry2 = BarChartDataEntry(x: 2.0, y: 24.0)
        let entry3 = BarChartDataEntry(x: 3.0, y: 63.0)
        let entry4 = BarChartDataEntry(x: 4.0, y: 4.0)
        let entry5 = BarChartDataEntry(x: 5.0, y: 6.0)
        let entry6 = BarChartDataEntry(x: 6.0, y: 43.0)
        let entry7 = BarChartDataEntry(x: 7.0, y: 73.0)
        let entry8 = BarChartDataEntry(x: 8.0, y: 11.0)
        
        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8], label: "Horizontal Bar Data")
        
        // Plug data into the graph
        let data = BarChartData(dataSets: [dataSet])
        myHorizontalGraphView.data = data
        
        // Customize chart View
        myHorizontalGraphView.chartDescription?.text = ""
        dataSet.colors = ChartColorTemplates.liberty()
        
        
        // Notify the data changes
        myHorizontalGraphView.notifyDataSetChanged()
    }
    
    
    
    // Populate Line Chart Data
    func lineChartSetup()
    {
        // Generate Random Data
        var val : Double = 0.0
        let values = (0..<10).map { (i) -> ChartDataEntry in
            val += Double(arc4random_uniform(UInt32(11)))
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let dataset = LineChartDataSet(values: values, label: "Knowledge")
        
        // Plug Data into the Chart View
        let data = LineChartData(dataSet: dataset)
        mySingleLineGraphView.data = data

        // Customize Chart View
        dataset.circleColors = [NSUIColor.black]
        dataset.colors = ChartColorTemplates.colorful()
        dataset.lineWidth = 2
        
        
        // Notify the data changes
        mySingleLineGraphView.notifyDataSetChanged()
    }
    
    
    
    
    
    // Populate Duo Line Chart Data
    func duoLineChartSetup()
    {
        // Generate Random Data for line 1
        let line_1_values = (0..<5).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(UInt32(11)))
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        // Create Data for line 2
        let line_2_values = (0..<5).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(UInt32(11)))
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        // Prepare Datasets
        let dataset = LineChartDataSet(values: line_1_values, label: "Investments")
        let dataset2 = LineChartDataSet(values: line_2_values, label: "Profits")
        
        
        // Plug data into the Chart
        let data = LineChartData(dataSets: [dataset, dataset2])
        myDuoLineGraphView.data = data
        
        // Customize Chart View
        dataset.colors = [NSUIColor.red]
        dataset.circleColors = [NSUIColor.black]
        dataset.lineWidth = 2
        
        dataset2.colors = [NSUIColor.green]
        dataset2.circleColors = [NSUIColor.darkGray]
        dataset2.lineWidth = 2

        
        // Notify the data changes
        myDuoLineGraphView.notifyDataSetChanged()
    }
    
    
    
    // Populate data into Pie Chart
    func setupPieChart()
    {
        // Populate Dataset
        let swift = PieChartDataEntry(value: 35.6, label: "Swift")
        let java = PieChartDataEntry(value: 32.6, label: "Java")
        let cpp = PieChartDataEntry(value: 20.9, label: "C++")
        let others = PieChartDataEntry(value: 10.9, label: "Others")
        
        let dataset = PieChartDataSet(values: [swift, java, cpp, others], label: "Languages")
        
        // Plug the data set into chart
        let data = PieChartData(dataSet: dataset)
        myPieChartView.data = data
        
        // Customize Pie Chart
        dataset.colors = ChartColorTemplates.material()
        
        // Notify the data changes
        myPieChartView.notifyDataSetChanged()
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                            ///////////////// View Components ////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Base Scroll View
    var baseScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.clear
        return scrollView
    }()
    
    // Base StackView
    var baseStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        return stackView
    }()
    
    
    
    
    // BaseContainer for Bar Graph
    var barGraphContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    // Bargraph View
    var myBarGraphView : BarChartView = {
        let view = BarChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    // BaseContainer for Horizontal Bar Graph
    var horizontalBarGraphContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    // Horizontal Bar Graph View
    var myHorizontalGraphView : HorizontalBarChartView = {
        let view = HorizontalBarChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // BaseContainer for SingleLine
    var singleLineGraphContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    // Horizontal Bar Graph View
    var mySingleLineGraphView : LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // BaseContainer for SingleLine
    var duoLineGraphContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    // Horizontal Bar Graph View
    var myDuoLineGraphView : LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    
    // BaseContainer for SingleLine
    var pieChartContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    // Horizontal Bar Graph View
    var myPieChartView : PieChartView = {
        let view = PieChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    
    
    
    
    
    // Arrange all View components into the View Controller
    private func setupView()
    {
        // Setup base scrollView
        view.addSubview(baseScrollView)
        baseScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        baseScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        baseScrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 2).isActive = true
        baseScrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -2).isActive = true
        
        // Add StackView
        baseScrollView.addSubview(baseStackView)
        baseStackView.topAnchor.constraint(equalTo: baseScrollView.topAnchor, constant: 8).isActive = true
        baseStackView.bottomAnchor.constraint(equalTo: baseScrollView.bottomAnchor).isActive = true
        baseStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        baseStackView.centerXAnchor.constraint(equalTo: baseScrollView.centerXAnchor).isActive = true
        
        // Add all other views to stack View
        
        // Add Bar Graph View
        arrangeBarGraphViews()
        
        // Add Horizontal Bar Graph
        arrangeHorizontalBarGraphViews()
        
        // Add Line Graph View
        arrangeSingleLineGraphViews()
        
        // Add Duo Line Graph View
        arrangeDuoLineGraphViews()
        
        // Add Pie Chart View
        arrangePieChartGraphViews()
    }
    
    
    
    // Setup BarGraph Views
    private func arrangeBarGraphViews()
    {
        // Add Container to the stack
        baseStackView.addArrangedSubview(barGraphContainer)
        barGraphContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        
        // Add heading label
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.text = "Bar Graphs"
        headingLabel.textAlignment = .center
        headingLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        barGraphContainer.addSubview(headingLabel)
        headingLabel.widthAnchor.constraint(equalTo: barGraphContainer.widthAnchor).isActive = true
        headingLabel.heightAnchor.constraint(equalTo: barGraphContainer.heightAnchor, multiplier: 0.15).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: barGraphContainer.centerXAnchor).isActive = true
        headingLabel.topAnchor.constraint(equalTo: barGraphContainer.topAnchor, constant: 8).isActive = true
        
        // Add BarGraph to the Container
        barGraphContainer.addSubview(myBarGraphView)
        myBarGraphView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 8).isActive = true
        myBarGraphView.bottomAnchor.constraint(equalTo: barGraphContainer.bottomAnchor, constant: -8).isActive = true
        myBarGraphView.heightAnchor.constraint(equalTo: barGraphContainer.heightAnchor, multiplier: 0.85, constant: -24).isActive = true
        myBarGraphView.widthAnchor.constraint(equalTo: barGraphContainer.widthAnchor, multiplier: 0.85).isActive = true
        myBarGraphView.centerXAnchor.constraint(equalTo: barGraphContainer.centerXAnchor).isActive = true
    }
    
    
    // Setup Horizontal Bar GraphViews
    private func arrangeHorizontalBarGraphViews()
    {
        // Add Container to the stack
        baseStackView.addArrangedSubview(horizontalBarGraphContainer)
        horizontalBarGraphContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        
        // Add heading label
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.text = "Horizontal Graphs"
        headingLabel.textAlignment = .center
        headingLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        horizontalBarGraphContainer.addSubview(headingLabel)
        headingLabel.widthAnchor.constraint(equalTo: horizontalBarGraphContainer.widthAnchor).isActive = true
        headingLabel.heightAnchor.constraint(equalTo: horizontalBarGraphContainer.heightAnchor, multiplier: 0.15).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: horizontalBarGraphContainer.centerXAnchor).isActive = true
        headingLabel.topAnchor.constraint(equalTo: horizontalBarGraphContainer.topAnchor, constant: 8).isActive = true
        
        // Add BarGraph to the Container
        horizontalBarGraphContainer.addSubview(myHorizontalGraphView)
        myHorizontalGraphView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 8).isActive = true
        myHorizontalGraphView.bottomAnchor.constraint(equalTo: horizontalBarGraphContainer.bottomAnchor, constant: -8).isActive = true
        myHorizontalGraphView.heightAnchor.constraint(equalTo: horizontalBarGraphContainer.heightAnchor, multiplier: 0.85, constant: -24).isActive = true
        myHorizontalGraphView.widthAnchor.constraint(equalTo: horizontalBarGraphContainer.widthAnchor, multiplier: 0.85).isActive = true
        myHorizontalGraphView.centerXAnchor.constraint(equalTo: horizontalBarGraphContainer.centerXAnchor).isActive = true
        
    }
    
    
    
    // Arranging Single Line Graph Views
    func arrangeSingleLineGraphViews()
    {
        // Add Container to the stack
        baseStackView.addArrangedSubview(singleLineGraphContainer)
        singleLineGraphContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        
        // Add heading label
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.text = "My Knowledge"
        headingLabel.textAlignment = .center
        headingLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        singleLineGraphContainer.addSubview(headingLabel)
        headingLabel.widthAnchor.constraint(equalTo: singleLineGraphContainer.widthAnchor).isActive = true
        headingLabel.heightAnchor.constraint(equalTo: singleLineGraphContainer.heightAnchor, multiplier: 0.15).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: singleLineGraphContainer.centerXAnchor).isActive = true
        headingLabel.topAnchor.constraint(equalTo: singleLineGraphContainer.topAnchor, constant: 8).isActive = true
        
        // Add BarGraph to the Container
        singleLineGraphContainer.addSubview(mySingleLineGraphView)
        mySingleLineGraphView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 8).isActive = true
        mySingleLineGraphView.bottomAnchor.constraint(equalTo: singleLineGraphContainer.bottomAnchor, constant: -8).isActive = true
        mySingleLineGraphView.heightAnchor.constraint(equalTo: singleLineGraphContainer.heightAnchor, multiplier: 0.85, constant: -24).isActive = true
        mySingleLineGraphView.widthAnchor.constraint(equalTo: singleLineGraphContainer.widthAnchor, multiplier: 0.85).isActive = true
        mySingleLineGraphView.centerXAnchor.constraint(equalTo: singleLineGraphContainer.centerXAnchor).isActive = true
    }
    
    
    
    
    
    // Arranging Single Line Graph Views
    func arrangeDuoLineGraphViews()
    {
        // Add Container to the stack
        baseStackView.addArrangedSubview(duoLineGraphContainer)
        duoLineGraphContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        
        // Add heading label
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.text = "Investment Vs Profits Chart"
        headingLabel.textAlignment = .center
        headingLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        duoLineGraphContainer.addSubview(headingLabel)
        headingLabel.widthAnchor.constraint(equalTo: duoLineGraphContainer.widthAnchor).isActive = true
        headingLabel.heightAnchor.constraint(equalTo: duoLineGraphContainer.heightAnchor, multiplier: 0.15).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: duoLineGraphContainer.centerXAnchor).isActive = true
        headingLabel.topAnchor.constraint(equalTo: duoLineGraphContainer.topAnchor, constant: 8).isActive = true
        
        // Add BarGraph to the Container
        duoLineGraphContainer.addSubview(myDuoLineGraphView)
        myDuoLineGraphView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 8).isActive = true
        myDuoLineGraphView.bottomAnchor.constraint(equalTo: duoLineGraphContainer.bottomAnchor, constant: -8).isActive = true
        myDuoLineGraphView.heightAnchor.constraint(equalTo: duoLineGraphContainer.heightAnchor, multiplier: 0.85, constant: -24).isActive = true
        myDuoLineGraphView.widthAnchor.constraint(equalTo: duoLineGraphContainer.widthAnchor, multiplier: 0.85).isActive = true
        myDuoLineGraphView.centerXAnchor.constraint(equalTo: duoLineGraphContainer.centerXAnchor).isActive = true
    }
    
    
    
    
    
    // Arranging Single Line Graph Views
    func arrangePieChartGraphViews()
    {
        // Add Container to the stack
        baseStackView.addArrangedSubview(pieChartContainer)
        pieChartContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        
        // Add heading label
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.text = "My Programming Skills"
        headingLabel.textAlignment = .center
        headingLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        pieChartContainer.addSubview(headingLabel)
        headingLabel.widthAnchor.constraint(equalTo: pieChartContainer.widthAnchor).isActive = true
        headingLabel.heightAnchor.constraint(equalTo: pieChartContainer.heightAnchor, multiplier: 0.15).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: pieChartContainer.centerXAnchor).isActive = true
        headingLabel.topAnchor.constraint(equalTo: pieChartContainer.topAnchor, constant: 8).isActive = true
        
        // Add BarGraph to the Container
        pieChartContainer.addSubview(myPieChartView)
        myPieChartView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 8).isActive = true
        myPieChartView.bottomAnchor.constraint(equalTo: pieChartContainer.bottomAnchor, constant: -8).isActive = true
        myPieChartView.heightAnchor.constraint(equalTo: pieChartContainer.heightAnchor, multiplier: 0.85, constant: -24).isActive = true
        myPieChartView.widthAnchor.constraint(equalTo: pieChartContainer.widthAnchor, multiplier: 0.85).isActive = true
        myPieChartView.centerXAnchor.constraint(equalTo: pieChartContainer.centerXAnchor).isActive = true
    }
    
    
    
    
    
    
    

}
