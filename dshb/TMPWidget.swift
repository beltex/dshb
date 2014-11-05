

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
        title = WidgetTitle(title: "TMPs", winCoords: titleCoords, colour: COLOR_PAIR(5))

        var array = smc.getAllValidTMPKeys().values.array
        array.append("BATTERY")
        let tmpSensors = sorted(array, compare)


        var y_pos = win.pos.y + 1 // Becuase of title
        for sensor in tmpSensors {
            meters.append(Meter(name: sensor, length: win.size.length, width: 1, x: win.pos.x, y: y_pos, max: maxValue, unit: Meter.Unit.Celsius))
            ++y_pos
        }

        
        
    }
    
    func updateWidget() {
        for meter in meters {
            if meter.name == "BATTERY" {
                meter.update(Int(battery.tmp()))
            }
            else {
                meter.update(Int(smc.getTMP(SMC.TMP.allValues[meter.name]!).tmp))
            }
        }
    }
    
    
    func moveWidget() {
    
    }
    
    
    func resizeWidget() {
        win.size.length = Int32(ceil(Double((COLS - gap)) / 2.0))
        
        title.resize(Int(win.size.length), width: 1)
        
        for meter in meters {
            meter.resize(Int(win.size.length), width: 10)
        }
        
        updateWidget()
    }
}