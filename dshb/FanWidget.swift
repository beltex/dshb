

import Foundation


public class FanWidget: Widget {
    
    private var meters = [Meter]()
    //let maxValue : Int
    var title : WidgetTitle
    var win   : Window
    
    init(win : Window) {
        // win.width not in use right now
        
        self.win = win
        
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "Fans", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        let numFans = smc.getNumFans().numFans
        var y_pos = win.pos.y + 1 // Becuase of title
        
        // TODO: Sort fan names
        
        for var x : UInt = 0; x < numFans; ++x {
            let winCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:y_pos))
            meters.append(Meter(name: smc.getFanName(x).name, winCoords : winCoords, max: Int(smc.getFanMaxRPM(x).rpm), unit: Meter.Unit.RPM))
            ++y_pos
        }
    }
    
    
    func draw() {
        for var x = 0; x < meters.count; ++x {
            meters[x].draw(Int(smc.getFanRPM(UInt(x)).rpm))
        }
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