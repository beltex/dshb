

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
        meters[2].lowColour = Int32(3)
        meters[2].highColour = Int32(1)
        
        meters.append(Meter(name: "Nice", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 4)), max: 100, unit: Meter.Unit.Percentage))

    }
    
    
    mutating func draw() {
        let values = sys.usageCPU()
        meters[0].draw(String(Int(values.system)), percentage: values.system / 100.0)
        meters[1].draw(String(Int(values.user)), percentage: values.user / 100.0)
        meters[2].draw(String(Int(values.idle)), percentage: values.idle / 100.0)
        meters[3].draw(String(Int(values.nice)), percentage: values.nice / 100.0)
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