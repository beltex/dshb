//
// WidgetTemperature.swift
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

struct WidgetTemperature: WidgetType {

    let name = "Temperature"
    let displayOrder = 5
    var title: WidgetUITitle
    var stats = [WidgetUIStat]()

    let maxValue = 128.0
    private static var sensorMap: [String : SMC.Temperature] = [ : ]
    
    init(window: Window = Window()) {
        title = WidgetUITitle(name: name, window: window)
        
        // Sensors list
        let sensors     = smc.getAllValidTemperatureKeys()
        var sensorNames = sensors.map { sensor -> String in
            let sensorName = SMC.Temperature.allValues[sensor]!
            WidgetTemperature.sensorMap.updateValue(sensor, forKey: sensorName)
            return sensorName
        }
        

        // This comes from SystemKit, have to manually added
        if hasBattery {
            sensorNames.append("BATTERY")
            // Only need to sort if have battery, since already sorted via
            // SMCKit
            if sensorNames.count > 1 {
                sensorNames.sortInPlace(<)
            }
        }
    
        
        for sensor in sensorNames {
            stats.append(WidgetUIStat(name: sensor, unit: .Celsius,
                                      max: maxValue))
        }
    }
    
    mutating func draw() {
        for var i = 0; i < stats.count; ++i {
            let value: Double
            switch stats[i].name {
            case "BATTERY":
                value = battery.temperature()
            default:
                value = smc.getTemperature(WidgetTemperature.sensorMap[stats[i].name]!).tmp
            }
            stats[i].draw(String(Int(value)), percentage: value / maxValue)
        }
    }
}
