

import Foundation


public class FanWidget {
    
    private var meters = [Meter]()
    //let maxValue : Int
    let title : WidgetTitle
    var win   : Window
    
    init(win : Window) {
        


        
        self.win = win
        
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "Fans", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        
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
        
    }
}