

import Foundation


public class TMPWidget {
    
    private var meters = [Meter]()
    let maxValue = 95
    let title : WidgetTitle
    var win   : Window
    
    init(win : Window) {
        
        // win.size.width not currently used
        
        self.win = win
        
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "TMPS", winCoords: titleCoords, colour: COLOR_PAIR(5))

        let tmpSensors = sorted(smc.getAllValidTMPKeys().values.array, compare)


        var y_pos = win.pos.y + 1 // Becuase of title
        for sensor in tmpSensors {
            meters.append(Meter(name: sensor, length: win.size.length, width: 1, x: win.pos.x, y: y_pos, max: maxValue, unit: Meter.Unit.Celsius))
            ++y_pos
        }

        
        
    }
    
    func updateWidget() {
        for meter in meters {
            meter.update(Int(smc.getTMP(SMC.TMP.allValues[meter.name]!).tmp))
        }
    }
    
    
    func moveWidget() {
    
    }
    
    
    func resizeWidget() {
        
    }
}