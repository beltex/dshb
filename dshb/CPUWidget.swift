

import Foundation

public struct CPUWidget: Widget {
    
    private var meters = [Meter]()
    var title : WidgetTitle
    var win   : Window
    
    private var sys = System()
    
    init(win: Window) {
        // win.size.width not currently used
        self.win = win
        
        
        // Title init
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "CPU", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        
        meters.append(Meter(name: "System", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 1)), max: 100, unit: Meter.Unit.Percentage))
        meters.append(Meter(name: "User", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 2)), max: 100, unit: Meter.Unit.Percentage))
        meters.append(Meter(name: "Idle", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 3)), max: 100, unit: Meter.Unit.Percentage))
        meters.append(Meter(name: "Nice", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 4)), max: 100, unit: Meter.Unit.Percentage))

    }
    
    
    mutating func draw() {
        let values = sys.usageCPU()
        meters[0].draw(Int(values.system))
        meters[1].draw(Int(values.user))
        meters[2].draw(Int(values.idle))
        meters[3].draw(Int(values.nice))
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
        
        return y_pos
    }
}