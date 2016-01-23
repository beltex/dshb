//
// WidgetTemperature.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014-2016  beltex <http://beltex.github.io>
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
    private let sensors: [TemperatureSensor]
    
    init(window: Window = Window()) {
        title = WidgetUITitle(name: name, window: window)


        do {
            // TODO: Add battery temperature from SystemKit? SMC will usually
            //       have a key for it too (though not always certain which one)
            let allKnownSensors = try SMCKit.allKnownTemperatureSensors().sort
                                                           { $0.name < $1.name }

            let allUnknownSensors: [TemperatureSensor]
            if CLIUnknownTemperatureSensorsOption.wasSet {
                allUnknownSensors = try SMCKit.allUnknownTemperatureSensors()
            } else { allUnknownSensors = [ ] }

            sensors = allKnownSensors + allUnknownSensors
        } catch {
            // TODO: Have some sort of warning message under temperature widget
            sensors = [ ]
        }


        for sensor in sensors {
            let name: String
            if sensor.name == "Unknown" {
                name = sensor.name + " (\(sensor.code.toString()))"
            } else { name = sensor.name }

            stats.append(WidgetUIStat(name: name, unit: .Celsius,
                                                   max: maxValue))
        }
    }
    
    mutating func draw() {
        for index in 0..<stats.count {
            // TODO: Fix going past bottom of terminal window
            //if stats[i].window.point.y >= LINES - 2 { break }

            do {
                let value = try SMCKit.temperature(sensors[index].code)
                stats[index].draw(String(value), percentage: value / maxValue)
            } catch {
                stats[index].draw("Error", percentage: 0)
                // TODO: stats[i].unit = .None
            }
        }
    }
}
