import UIKit
import Charts

class News4ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var rect = view.bounds
        rect.origin.y += 20
        rect.size.height -= 20
        let chartView = LineChartView(frame: rect)
        let entries = [
            BarChartDataEntry(x: 1, y: 30),
            BarChartDataEntry(x: 2, y: 20),
            BarChartDataEntry(x: 3, y: 40),
            BarChartDataEntry(x: 4, y: 10),
            BarChartDataEntry(x: 5, y: 30)
        ]
        let set = LineChartDataSet(values: entries, label: "Data")
        chartView.data = LineChartData(dataSet: set)
        view.addSubview(chartView)
    }
}
