

import Foundation


public class TMPWidget {
    
    private var meters = [Meter]()
    let maxValue = 95
    let title : WidgetTitle
    var win   : Window
    
    init(win : Window) {
        // win.size.width not currently used
        self.win = win

        
        // Title init
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "TMPs", winCoords: titleCoords, colour: COLOR_PAIR(5))
        // TODO: move this out of init
        title.draw()
        
        // Sensors list
        // TODO: Way too confusing, fix getAllValidTMPKeys()
        var array = smc.getAllValidTMPKeys().values.array
        array.append("BATTERY")
        let tmpSensors = sorted(array, compare)

        
        // Meters init
        var y_pos = win.pos.y + 1 // Becuase of title
        for sensor in tmpSensors {
            let winCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:y_pos))
            meters.append(Meter(name: sensor, winCoords: winCoords, max: maxValue, unit: Meter.Unit.Celsius))
            ++y_pos
        }
    }
    
    
    func draw() {
        for meter in meters {
            switch meter.name {
                case "BATTERY":
                    meter.draw(Int(battery.tmp()))
                default:
                    meter.draw(Int(smc.getTMP(SMC.TMP.allValues[meter.name]!).tmp))

            }
        }
    }
    
    
    func resize() {
        
        title.resize(Window(size: (length: widgetLength, width: 1), pos: (x: 0, y: 0)))
        
        var y_pos = win.pos.y + 1 // Becuase of title
        
        for meter in meters {
            meter.resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }        
    }
}