

import Foundation


public struct BatteryWidget: Widget {
    
    private var meters = [Meter]()
    private var meterInverse : MeterInverse
    var title : WidgetTitle
    var win   : Window
    
    init(win: Window) {
        // win.width not in use right now
        
        self.win = win
        
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "Battery", winCoords: titleCoords, colour: COLOR_PAIR(5))        

        
        meterInverse = MeterInverse(name: "Charge", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 1)), max: 100, unit: MeterInverse.Unit.Percentage)
        meters.append(Meter(name: "Capacity", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 2)), max: Double(battery.designCapacity()), unit: Meter.Unit.None))
        meters.append(Meter(name: "Cycles", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 3)), max: Double(battery.designCycleCount()), unit: Meter.Unit.None))
        meters.append(Meter(name: "Health", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 4)), max: 100, unit: Meter.Unit.Percentage))
    }
    
    
    mutating func draw() {
        meterInverse.draw(Int(battery.charge()))
        
        var v1 = battery.currentCapacity()
        var v2 = battery.cycleCount()
        var v3 = battery.health()
        
        meters[0].draw(String(v1), percentage:  Double(v1) / Double(battery.designCapacity()))
        meters[1].draw(String(v2), percentage: Double(v2) / Double(battery.designCycleCount()))
        meters[2].draw(String(Int(v3)), percentage: v3 / 100.0)
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        self.win = newCoords
        
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        
        meterInverse.resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
        y_pos++
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
        
        return y_pos
    }
}