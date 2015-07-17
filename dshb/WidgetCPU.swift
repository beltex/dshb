//
// WidgetCPU.swift
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

struct WidgetCPU: WidgetType {

    let name = "CPU"
    let displayOrder = 1
    var title: WidgetUITitle
    var stats = [WidgetUIStat]()

    private static var system = System()
    
    init(window: Window = Window()) {
        title = WidgetUITitle(name: "CPU", window: window)

        for stat in ["System", "User", "Idle", "Nice"] {
            stats.append(WidgetUIStat(name: stat, max: 100.0,
                                      unit: .Percentage))
        }

        stats[2].lowColor  = WidgetUIColorStatDanger
        stats[2].highColor = WidgetUIColorStatGood
    }
    
    mutating func draw() {
        let values = WidgetCPU.system.usageCPU()
        stats[0].draw(String(Int(values.system)),
                      percentage: values.system / 100.0)
        stats[1].draw(String(Int(values.user)),
                      percentage: values.user / 100.0)
        stats[2].draw(String(Int(values.idle)),
                      percentage: values.idle / 100.0)
        stats[3].draw(String(Int(values.nice)),
                      percentage: values.nice / 100.0)
    }
}
