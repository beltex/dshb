

import Foundation


public struct BatteryWidget: Widget {
    
    private var meters = [Meter]()
    var title : WidgetTitle
    var win   : Window
    
    init(win: Window) {
        // win.width not in use right now
        
        self.win = win
        
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "Battery", winCoords: titleCoords, colour: COLOR_PAIR(5))        

        
        meters.append(Meter(name: "Charge", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 1)), max: 100, unit: Meter.Unit.Percentage))
        meters[0].lowPercentage = 0.2
        meters[0].midPercentage = 0.0
        meters[0].highPercentage = 0.8
        
        meters[0].lowColour = Int32(3)
        meters[0].highColour = Int32(1)

        
        meters.append(Meter(name: "Capacity", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 2)), max: Double(battery.designCapacity()), unit: Meter.Unit.None))
        meters.append(Meter(name: "Cycles", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 3)), max: Double(battery.designCycleCount()), unit: Meter.Unit.None))
        meters.append(Meter(name: "Health", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 4)), max: 100, unit: Meter.Unit.Percentage))
    }
    
    
    mutating func draw() {
        var charge = battery.charge()
        meters[0].draw(String(Int(battery.charge())), percentage: charge / 100.0)
        
        var v1 = battery.currentCapacity()
        var v2 = battery.cycleCount()
        var v3 = battery.health()
        
        meters[1].draw(String(v1), percentage:  Double(v1) / Double(battery.designCapacity()))
        meters[2].draw(String(v2), percentage: Double(v2) / Double(battery.designCycleCount()))
        meters[3].draw(String(Int(v3)), percentage: v3 / 100.0)
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        self.win = newCoords
        
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        
        //meterInverse.resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
        
        return y_pos
    }
}