

import Foundation


public struct BatteryWidget: Widget {
    
    private var meters = [Meter]()
    var title : WidgetTitle
    var win   : Window
    
    private let stats: [(name: String, maxValue: Double, unit: Meter.Unit)] =
               [("Charge", 100.0, Meter.Unit.Percentage),
                ("Capacity", Double(battery.designCapacity()), Meter.Unit.None),
                ("Cycles", Double(battery.designCycleCount()), Meter.Unit.None)]
    
    init(win: Window) {
        self.win = win
        title = WidgetTitle(title: "Battery",
                            winCoords: Window(size: (length: win.size.length, width: 1),
                            pos: (x:win.pos.x, y:win.pos.y)),
                            colour: COLOR_PAIR(5))

        var yShift = 1
        for stat in stats {
            meters.append(Meter(name: stat.name,
                                winCoords: Window(size: (length: win.size.length, width: 1),
                                                  pos: (x: win.pos.x, y: win.pos.y + yShift)),
                                max: stat.maxValue,
                                unit: stat.unit))
            
            ++yShift
        }
        
        
        meters[0].lowPercentage = 0.2
        meters[0].midPercentage = 0.0
        meters[0].highPercentage = 0.8
        meters[0].lowColour = Int32(3)
        meters[0].highColour = Int32(1)
    }
    
    
    mutating func draw() {
        var charge = battery.charge()
        meters[0].draw(String(Int(battery.charge())), percentage: charge / 100.0)
        
        var v1 = battery.currentCapacity()
        var v2 = battery.cycleCount()
        
        meters[1].draw(String(v1), percentage:  Double(v1) / Double(battery.designCapacity()))
        meters[2].draw(String(v2), percentage: Double(v2) / Double(battery.designCycleCount()))
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        self.win = newCoords
        
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
        
        return y_pos
    }
}