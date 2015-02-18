//
// WidgetTemperature.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014, 2015  beltex <https://github.com/beltex>
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

import Foundation

struct WidgetTemperature: WidgetType {

    private var widget: WidgetBase
    let maxValue = 128.0
    private static var map: [String : SMC.Temperature] = [ : ]
    
    init(var window: Window = Window()) {
        widget = WidgetBase(name: "Temperature", window: window)
        
        
        // Sensors list
        let temperatureSensors     = smc.getAllValidTemperatureKeys()
        var temperatureSensorNames = temperatureSensors.map
                                              { SMC.Temperature.allValues[$0]! }
        
        // This comes from SystemKit, have to manually added
        if (hasBattery) {
            temperatureSensorNames.append("BATTERY")
            // Only need to sort if have battery, since already sorted via
            // SMCKit
            if (temperatureSensorNames.count > 1) {
                temperatureSensorNames.sort { $0 < $1 }
            }
        }
        
        for key in temperatureSensors {
            WidgetTemperature.map.updateValue(key, forKey: SMC.Temperature.allValues[key]!)
        }
        
        
        // Meters init - should be sorted here
        window.point.y++
        for sensor in temperatureSensorNames {
            widget.meters.append(Meter(name: sensor, window: window,
                                                     max: maxValue,
                                                     unit: .Celsius))
            window.point.y++
        }
    }
    
    mutating func draw() {
        for var i = 0; i < widget.meters.count; ++i {
            let value: Double
            switch widget.meters[i].name {
                case "BATTERY":
                    value = battery.temperature()
                default:
                    value = smc.getTemperature(WidgetTemperature.map[widget.meters[i].name]!).tmp
            }
            widget.meters[i].draw(String(Int(value)), percentage: value / maxValue)
        }
    }
    
    mutating func resize(window: Window) -> Int32 {
        return widget.resize(window)
    }
}
