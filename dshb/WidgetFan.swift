//
// WidgetFan.swift
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

struct WidgetFan: WidgetType {

    let name = "Fan"
    let displayOrder = 6
    var title: WidgetUITitle
    var stats = [WidgetUIStat]()

    init(window: Window = Window()) {
        title = WidgetUITitle(name: name, window: window)

        
        let fanCount: Int
        do    { fanCount = try SMCKit.fanCount() }
        catch { fanCount = 0 }


        for index in 0..<fanCount {
            // Not sorting fan names, most will not have more than 2 anyway
            let fanName: String
            do    { fanName = try SMCKit.fanName(index) }
            catch { fanName = "Fan \(index)" }


            let fanMaxSpeed: Int
            do {
                fanMaxSpeed = try SMCKit.fanMaxSpeed(index)
            } catch {
                // Skip this fan
                continue
            }

            stats.append(WidgetUIStat(name: fanName, unit: .RPM,
                                      max: Double(fanMaxSpeed)))
        }
    }

    mutating func draw() {
        for index in 0..<stats.count {
            do {
                let fanSpeed = try SMCKit.fanCurrentSpeed(index)
                stats[index].draw(String(fanSpeed),
                              percentage: Double(fanSpeed) / stats[index].maxValue)
            } catch {
                stats[index].draw("Error", percentage: 0)
            }
        }
    }
}

