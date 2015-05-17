//
// WidgetBattery.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2015  beltex <http://beltex.github.io>
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
    
    private var widget: WidgetBase
    
    init(window: Window = Window()) {
        widget = WidgetBase(name: "Battery", window: window)

        
        let stats: [(name: String, maxValue: Double, unit: Unit)] =
  [("Charge", 100.0, .Percentage),
   ("Capacity Degradation", Double(battery.designCapacity()), .MilliampereHour),
   ("Cycles", Double(battery.designCycleCount()), .None),
   ("Time Remaining", 0.0, .None)]
        
        for stat in stats {
            widget.stats.append(WidgetUIStat(name: stat.name,
                                              max: stat.maxValue,
                                              unit: stat.unit))
        }
        
        
        widget.stats[0].lowPercentage = 0.2
        widget.stats[0].midPercentage = 0.0
        widget.stats[0].highPercentage = 0.8
        widget.stats[0].lowColor  = WidgetUIColorStatDanger
        widget.stats[0].highColor = WidgetUIColorStatGood
        
        widget.stats[1].lowColor  = WidgetUIColorStatDanger
        widget.stats[1].highColor = WidgetUIColorStatGood
    }
    
    mutating func draw() {
        let charge = battery.charge()
        widget.stats[0].draw(String(Int(battery.charge())),
                       percentage: charge / 100.0)
        
        let maxCapactiy = battery.maxCapactiy()
        let cycleCount  = battery.cycleCount()
        
        widget.stats[1].draw(String(maxCapactiy - Int(widget.stats[1].max)),
                              percentage:  Double(maxCapactiy) / widget.stats[1].max)
        widget.stats[2].draw(String(cycleCount), percentage: Double(cycleCount) / widget.stats[2].max)
        widget.stats[3].draw(battery.timeRemainingFormatted(), percentage: 0.0)
    }
    
    mutating func resize(window: Window) -> Int32 {
        return widget.resize(window)
    }
}
