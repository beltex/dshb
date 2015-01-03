

import Foundation


public class TMPWidget: Widget {
    
    private var meters = [Meter]()
    let maxValue = 95
    var title : WidgetTitle
    var win   : Window
    var map : [String : SMC.Temperature] = [ : ]
    
    init(win : Window) {
        // win.size.width not currently used
        self.win = win

        
        // Title init
        let titleCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "TMPs", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        
        // Sensors list
        let temperatureSensors = smc.getAllValidTemperatureKeys()
        var temperatureSensorNames = temperatureSensors.map({
                                               SMC.Temperature.allValues[$0]! })
        // This comes from SystemKit, have to manually added
        // TODO: Check if laptop
        temperatureSensorNames.append("BATTERY")
        if (temperatureSensors.count > 1) {
            temperatureSensorNames = sorted(temperatureSensorNames, { $0 < $1 })
        }
        
        
        for key in temperatureSensors {
            map.updateValue(key, forKey: SMC.Temperature.allValues[key]!)
        }
        
        
        // Meters init - should be sorted here
        var y_pos = win.pos.y + 1 // Becuase of title
        for sensor in temperatureSensorNames {
            let winCoords = Window(size: (length: win.size.length, width: 1), pos: (x:win.pos.x, y:y_pos))
            meters.append(Meter(name: sensor, winCoords: winCoords, max: maxValue, unit: Meter.Unit.Celsius))
            ++y_pos
        }
    }
    
    
    func draw() {
        for meter in meters {
            switch meter.name {
                case "BATTERY":
                    meter.draw(Int(battery.temperature()))
                default:
                    meter.draw(Int(smc.getTemperature(map[meter.name]!).tmp))
            }
        }
    }
    
    
    func resize(newCoords: Window) {
        win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for meter in meters {
            meter.resize(Window(size: (length: widgetLength, width: 1), pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }        
    }
}