//
// TMPWidget.swift
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


public struct TMPWidget: Widget {
    
    private var meters = [Meter]()
    let maxValue = 128.0
    var title : WidgetTitle
    var win   : Window
    var map : [String : SMC.Temperature] = [ : ]
    
    init(win: Window = Window()) {
        self.win = win
        
        // Title init
        let titleCoords = Window(length: win.length, pos: (x: win.pos.x,
                                                           y: win.pos.y))
        title = WidgetTitle(title: "Temperature", winCoords: titleCoords,
                                                  colour: COLOR_PAIR(5))
        
        
        // Sensors list
        let temperatureSensors = smc.getAllValidTemperatureKeys()
        var temperatureSensorNames = temperatureSensors.map({
                                               SMC.Temperature.allValues[$0]! })
        
        // This comes from SystemKit, have to manually added
        if (hasBattery) {
            temperatureSensorNames.append("BATTERY")
            // Only need to sort if have battery, since already sorted via
            // SMCKit
            if (temperatureSensorNames.count > 1) {
                temperatureSensorNames = sorted(temperatureSensorNames,
                                                                    { $0 < $1 })
            }
        }
        
        for key in temperatureSensors {
            map.updateValue(key, forKey: SMC.Temperature.allValues[key]!)
        }
        
        
        // Meters init - should be sorted here
        var y_pos = win.pos.y + 1 // Becuase of title
        for sensor in temperatureSensorNames {
            let winCoords = Window(length: win.length, pos: (x: win.pos.x,
                                                             y: y_pos))
            meters.append(Meter(name: sensor, winCoords: winCoords,
                                              max: maxValue,
                                              unit: Meter.Unit.Celsius))
            ++y_pos
        }
    }
    
    
    mutating func draw() {
        for var i = 0; i < meters.count; ++i {
            var value = 0.0
            switch meters[i].name {
                case "BATTERY":
                    value = battery.temperature()
                default:
                    value = smc.getTemperature(map[meters[i].name]!).tmp
            }
            meters[i].draw(String(Int(value)), percentage: value / maxValue)
        }
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(length: win.length, pos: (x: win.pos.x,
                                                              y: y_pos)))
            y_pos++
        }
        
        return y_pos
    }
}