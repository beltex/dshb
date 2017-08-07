//
// WidgetBattery.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014-2017  beltex <https://beltex.github.io>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

struct WidgetBattery: WidgetType {

    let name = "Battery"
    let displayOrder = 4
    var title: WidgetUITitle
    var stats = [WidgetUIStat]()

    init(window: Window = Window()) {
        title = WidgetUITitle(name: name, window: window)


        stats = [WidgetUIStat(name: "Charge", unit: .Percentage, max: 100.0),
                 WidgetUIStat(name: "Capacity Degradation",
                              unit: .MilliampereHour,
                              max: Double(battery.designCapacity())),
                 WidgetUIStat(name: "Cycles",
                              unit: .None,
                              max: Double(battery.designCycleCount())),
                 // TODO: Better max temp for battery
                 WidgetUIStat(name: "Temperature", unit: .Celsius, max: 128.0),
                 WidgetUIStat(name: "Time Remaining", unit: .None, max: 0.0)]

        stats[0].Nominal.range = 0.2..<1.0
        stats[0].Danger.range = 0..<0
        stats[0].Crisis.range = 0..<0.2

        stats[1].Nominal.color = WidgetUIColor.WarningLevelCrisis
        stats[1].Crisis.color = WidgetUIColor.WarningLevelNominal
    }
    
    mutating func draw() {
        let charge = battery.charge()
        stats[0].draw(String(charge), percentage: charge / 100.0)

        let maxCapactiy = battery.maxCapactiy()
        let cycleCount  = battery.cycleCount()
        
        stats[1].draw(String(maxCapactiy - Int(stats[1].maxValue)),
                            percentage: Double(maxCapactiy) / stats[1].maxValue)
        stats[2].draw(String(cycleCount),
                             percentage: Double(cycleCount) / stats[2].maxValue)

        let temperature = battery.temperature()
        stats[3].draw(String(temperature), percentage: temperature / stats[3].maxValue)
        stats[4].draw(battery.timeRemainingFormatted(), percentage: 0.0)
    }
}
