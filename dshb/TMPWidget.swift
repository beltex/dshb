

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
        title.draw()

        var array = smc.getAllValidTMPKeys().values.array
        array.append("BATTERY")
        let tmpSensors = sorted(array, compare)


        var y_pos = win.pos.y + 1 // Becuase of title
        for sensor in tmpSensors {
            let winCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:y_pos))
            meters.append(Meter(name: sensor, winCoords: winCoords, max: maxValue, unit: Meter.Unit.Celsius))
            ++y_pos
        }

        
        
    }
    
    
    func updateWidget() {
        for meter in meters {
            if meter.name == "BATTERY" {
                meter.draw(Int(battery.tmp()))
            }
            else {
                meter.draw(Int(smc.getTMP(SMC.TMP.allValues[meter.name]!).tmp))
            }
        }
    }
    
    
    func resizeWidget() {
        widgetLength = Int32(floor(Double((COLS - gap)) / 2.0))
        
        //title.resize(Int(win.size.length), width: 1)
        title.resize(Window(size: (length: widgetLength, width: 1), pos: (x: 0, y: 0)))
        
        var y_pos = win.pos.y + 1 // Becuase of title
        
        for meter in meters {
            //meter.resize(Int(win.size.length), width: 10)
            meter.resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
        
        updateWidget()
    }
}