

import Foundation


public struct TMPWidget: Widget {
    
    private var meters = [Meter]()
    let maxValue = 128.0
    var title : WidgetTitle
    var win   : Window
    var map : [String : SMC.Temperature] = [ : ]
    
    init(win: Window) {
        self.win = win
        
        // Title init
        let titleCoords = Window(length: win.length, pos: (x:win.pos.x, y:win.pos.y))
        title = WidgetTitle(title: "Temperature", winCoords: titleCoords, colour: COLOR_PAIR(5))
        
        
        // Sensors list
        let temperatureSensors = smc.getAllValidTemperatureKeys()
        var temperatureSensorNames = temperatureSensors.map({
                                               SMC.Temperature.allValues[$0]! })
        
        // This comes from SystemKit, have to manually added
        if (hasBattery) {
            temperatureSensorNames.append("BATTERY")
            // Only need to sort if have battery, since already sorted from SMCKit
            if (temperatureSensorNames.count > 1) {
                temperatureSensorNames = sorted(temperatureSensorNames, { $0 < $1 })
            }
        }
        
        for key in temperatureSensors {
            map.updateValue(key, forKey: SMC.Temperature.allValues[key]!)
        }
        
        
        // Meters init - should be sorted here
        var y_pos = win.pos.y + 1 // Becuase of title
        for sensor in temperatureSensorNames {
            let winCoords = Window(length: win.length, pos: (x:win.pos.x, y:y_pos))
            meters.append(Meter(name: sensor, winCoords: winCoords, max: maxValue, unit: Meter.Unit.Celsius))
            ++y_pos
        }
    }
    
    
    mutating func draw() {
        for var i = 0; i < meters.count; ++i {
            var value = 0.0
            switch meters[i].name {
                case "BATTERY":
                    value = battery.temperature()
                default:
                    value = smc.getTemperature(map[meters[i].name]!).tmp
            }
            meters[i].draw(String(Int(value)), percentage: value / maxValue)
        }
    }
    
    
    mutating func resize(newCoords: Window) -> Int32 {
        win = newCoords
        title.resize(win)
        
        var y_pos = win.pos.y + 1 // Becuase of title
        for var i = 0; i < meters.count; ++i {
            meters[i].resize(Window(length: win.length, pos: (x: win.pos.x, y: y_pos)))
            y_pos++
        }
        
        return y_pos
    }
}