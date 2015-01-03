

import Foundation


public class BatteryWidget: Widget {
    
    private var meters = [Meter]()
    var title : WidgetTitle
    var win   : Window
    
    init(win : Window) {
        // win.width not in use right now
        
        self.win = win
        
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "Battery", winCoords: titleCoords, colour: COLOR_PAIR(5))        

        meters.append(Meter(name: "Capacity", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 1)), max: battery.designCapacity(), unit: Meter.Unit.None))
        //meters.append(Meter(name: "Charge", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 1)), max: 100, unit: Meter.Unit.Percentage))
        meters.append(Meter(name: "Cycles", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 2)), max: battery.designCycleCount(), unit: Meter.Unit.None))
        meters.append(Meter(name: "Health", winCoords : Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 3)), max: 100, unit: Meter.Unit.Percentage))
    }
    
    
    func draw() {
        meters[0].draw(battery.currentCapacity())
        meters[1].draw(battery.cycleCount())
        meters[2].draw(Int(battery.health()))
    }
    
    
    func resize(newCoords: Window) {
        self.win = newCoords
        
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        
        for meter in meters {
            meter.resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
    }
}