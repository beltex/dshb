

import Foundation

public struct MemoryWidget: Widget {
    
    private var meters = [Meter]()
    let maxValueGB = System.physicalMemory(unit: System.Unit.Gigabyte)
    let maxValueMB = System.physicalMemory(unit: System.Unit.Megabyte)

    let stats = ["Free", "Wired", "Active", "Inactive", "Compressed"]
    
    var title : WidgetTitle
    var win   : Window
    
    init(win: Window) {
        // win.size.width not currently used
        self.win = win
        
        // Title init
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "Memory", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        var yShift = 1
        for stat in stats {
            meters.append(Meter(name: stat,
                                winCoords: Window(size: (length: win.size.length, width: 1),
                                                  pos: (x:win.pos.x, y:win.pos.y + yShift)),
                                max: maxValueGB,
                                unit: Meter.Unit.Gigabyte))
            ++yShift
        }
        
        meters[0].lowPercentage = 0.20
        meters[0].highPercentage = 0.45
        meters[0].lowColour = Int32(3)
        meters[0].highColour = Int32(1)
    }
    
    
    mutating func draw() {
        let values = System.memoryUsage()
        unitCheck(values.free, index: 0)
        unitCheck(values.wired, index: 1)
        unitCheck(values.active, index: 2)
        unitCheck(values.inactive, index: 3)
        unitCheck(values.compressed, index: 4)
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
    
    
    private mutating func unitCheck(val: Double, index: Int) {
        if (val < 1.0) {
            meters[index].unit = Meter.Unit.Megabyte
            meters[index].max = maxValueMB
            let value = val * 1000.0
            meters[index].draw(String(Int(value)), percentage: value / maxValueMB)
        }
        else {
            meters[index].unit = Meter.Unit.Gigabyte
            meters[index].max = maxValueGB
            meters[index].draw(NSString(format:"%.2f", val), percentage: val / maxValueGB)
        }
    }
}