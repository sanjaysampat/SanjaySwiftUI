//
//  ChartDemoView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 19/01/21.
//  Copyright © 2021 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI
import Accessibility
// SSNote : The 'import Accessibility' is required for 'Audio graphs'

struct ChartDemoView: View {
    
    var body: some View {
        return NavigationView {
            List {
                Section(header: Text("Charts")) {
                    
                    NavigationLink(destination: Example31(), label: {
                        Text("Example 31 - Bar Chart")
                    })
                    NavigationLink(destination: Example32(), label: {
                        Text("Example 32 - Line Chart")
                    })
                     /*
                     NavigationLink(destination: Example33(), label: {
                     Text("Exmaple 33 - Another Chart")
                     })
                     */
                    
                }
            }
            .navigationBarTitle(Text("Chart Demo"), displayMode: .inline)
        }
        
    }
    
}

struct BarChartDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

struct BarChartView: View {
    let dataPoints: [BarChartDataPoint]
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(dataPoints) { point in
                VStack {
                    Text("\(String(format: "%.1f", point.value))")
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(point.color)
                        .frame(height: point.value * 30)
                    Text(point.label)
                }
            }
        }
    }
}

struct Example31: View {
    // SSNote : guidence for Visual accessability
    // * Avoid using both Red and Green
    // * Avoid using both Blue and Yellow
    // * Use symbols in addition to colors
    // * Reduce use of transparancy
    
    @State private var dataPoints = [
        BarChartDataPoint(label: "1", value: 3, color: .red),
        BarChartDataPoint(label: "2", value: 5, color: .blue),
        BarChartDataPoint(label: "3", value: 2, color: .red),
        BarChartDataPoint(label: "4", value: 4, color: .blue),
    ]
    
    var body: some View {
        Text("Chart with Audio Graph as accessibility feature.")
            .padding(.bottom, 10)
        if #available(iOS 15.0, *) {
            BarChartView(dataPoints: dataPoints)
                .accessibilityElement()
                .accessibilityLabel("Chart representing some data")
                .accessibilityChartDescriptor(self)
            
            Text("""
                 Audio graphs are available via the rotors menu. To use the rotor, rotate two fingers on your iOS device’s screen as if you’re turning a dial. VoiceOver will say the first rotor option. Keep rotating your fingers to hear more options. Lift your fingers to choose audio graphs. Then flick your finger up or down on the screen to navigate through it.
                 (ON 'Accessability - VoiceOver option' in device settings.)
                 """)
                .font(.subheadline)
                .padding(10)
                
        } else {
            BarChartView(dataPoints: dataPoints)
                .accessibilityElement()
                .accessibilityLabel("Chart representing some data")
        }
    }
    
}

@available(iOS 15.0, *)
extension Example31: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Labels",
            categoryOrder: dataPoints.map(\.label)
        )

        let min = dataPoints.map(\.value).min() ?? 0.0
        let max = dataPoints.map(\.value).max() ?? 0.0

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Values",
            range: min...max,
            gridlinePositions: []
        ) { value in "\(value) points" }

        //  We want to use string labels on the X-axis. That’s why we use the AXCategoricalDataAxisDescriptor type. In the case of a line chart, we will use the AXNumericDataAxisDescriptor for both axes.
        
        let series = AXDataSeriesDescriptor(
            name: "",
            isContinuous: false,
            dataPoints: dataPoints.map {
                .init(x: $0.label, y: $0.value)
            }
        )
        // isContinuous parameter allows us to define different chart styles. For example, it should be false for bar charts but true for line charts.

        return AXChartDescriptor(
            title: "Chart representing some data",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}


struct Example32: View {
    
    var body: some View {
        Text("Line Chart - WIP.")
    }
}

struct ChartDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ChartDemoView()
    }
}
