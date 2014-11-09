

import Foundation


public class FanWidget {
    
    private var meters = [Meter]()
    //let maxValue : Int
    let title : WidgetTitle
    var win   : Window
    
    init(win : Window) {
        // win.width not in use right now
        
        self.win = win
        
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "Fans", winCoords: titleCoords, colour: COLOR_PAIR(5))
        title.draw()
        
        let numFans = smc.getNumFans().numFans
        var y_pos = win.pos.y + 1 // Becuase of title
        
        for var x : UInt = 0; x < numFans; ++x {
            meters.append(Meter(name: smc.getFanName(x).name, length: win.size.length, width: 1, x: win.pos.x, y: y_pos, max: Int(smc.getFanMaxRPM(x).rpm), unit: Meter.Unit.RPM))
            ++y_pos
        }
    }
    
    func updateWidget() {
        for var x = 0; x < meters.count; ++x {
            meters[x].update(Int(smc.getFanRPM(UInt(x)).rpm))
        }
    }
    
    
    func moveWidget() {
        
    }
    
    
    func resizeWidget() {
        widgetLength = Int32(floor(Double((COLS - gap)) / 2.0))
        
        //title.resize(Int(win.size.length), width: 1)
        title.resize(Window(size: (length: widgetLength, width: 1), pos: (x: widgetLength + gap, y: 0)))
        
        var y_pos = win.pos.y + 1 // Becuase of title
        
        for meter in meters {
            //meter.resize(Int(win.size.length), width: 10)
            meter.resize(Window(size: (length: widgetLength, width: 1), pos: (x: widgetLength + gap, y: y_pos)))
            y_pos++
        }
        
        updateWidget()
    }
}