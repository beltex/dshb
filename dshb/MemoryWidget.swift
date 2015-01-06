

import Foundation

public struct MemoryWidget: Widget {
    
    private var meters = [Meter]()
    let maxValue = System.physicalMemory()
    var title : WidgetTitle
    var win   : Window
    
    init(win : Window) {
        // win.size.width not currently used
        self.win = win
        
        
        // Title init
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "Memory", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        
        meters.append(Meter(name: "Free", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 1)), max: Int(maxValue), unit: Meter.Unit.Gigabyte))
        meters.append(Meter(name: "Wired", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 2)), max: Int(maxValue), unit: Meter.Unit.Gigabyte))
        meters.append(Meter(name: "Active", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 3)), max: Int(maxValue), unit: Meter.Unit.Gigabyte))
        meters.append(Meter(name: "Inactive", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 4)), max: Int(maxValue), unit: Meter.Unit.Gigabyte))
        meters.append(Meter(name: "Compressed", winCoords: Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y + 5)), max: Int(maxValue), unit: Meter.Unit.Gigabyte))
    }
    
    
    mutating func draw() {
        let values = System.memoryUsage()
        meters[0].draw(Int(values.free))
        meters[1].draw(Int(values.wired))
        meters[2].draw(Int(values.active))
        meters[3].draw(Int(values.inactive))
        meters[4].draw(Int(values.compressed))
    }
    
    
    mutating func resize(newCoords: Window) {
        win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
    }
}