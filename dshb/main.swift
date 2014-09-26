setlocale(LC_ALL, "")

// ncurses settings
initscr()                // Init window. Must be first
cbreak()
noecho()                 // Don't echo user input
nonl()                   // Disable newline mode
intrflush(stdscr, false) // Prevent flush
keypad(stdscr, true)     // Enable function and arrow keys
curs_set(0)              // Set cursor to invisible


if (!has_colors()) {
    println("WARN: Terminal doesn't have support for colours")
}
// do custom colors check

// Init terminal colours
start_color()
init_pair(1, Int16(COLOR_BLACK), Int16(COLOR_GREEN))
init_pair(2, Int16(COLOR_BLACK), Int16(COLOR_YELLOW))
init_pair(3, Int16(COLOR_BLACK), Int16(COLOR_RED))
init_pair(4, Int16(COLOR_WHITE), Int16(use_default_colors()))

addstr("-- Hello")
refresh()



//----------------------

// Sample box
//var win = newwin(1, 30, 10, 10)
//var win2 = newwin(1, 30, 11, 10)
//

var cpu_bar = BarGraph(name: "CPU_0_DIODE", length: 30, width: 1, x: 10, y: 10, max: 105, unit: BarGraph.Unit.Celsius)
var cpu_bar2 = BarGraph(name: "CPU_0_HEATSINK", length: 30, width: 1, x: 10, y: 11, max: 105, unit: BarGraph.Unit.Celsius)
var cpu_bar3 = BarGraph(name: "CPU_0_PROXIMITY", length: 30, width: 1, x: 10, y: 12, max: 105, unit: BarGraph.Unit.Celsius)

for var i = 0; i < 10; ++i {
    cpu_bar.updateVal(Int(arc4random_uniform(105)))
    cpu_bar2.updateVal(Int(arc4random_uniform(105)))
    cpu_bar3.updateVal(Int(arc4random_uniform(105)))
    sleep(5)
}

//
//func updateVal(win_v : COpaquePointer, val : Int, name : String) {
//    var spaceLen = 30 - (countElements(name) + countElements(String(val)) + 2)
//    var range = 105
//    var perct : Double = Double(val) / Double(range)
//    var valRange = Int(floor(30 * perct))
//    var len = countElements(name)
//    var space = String()
//    
//    for var x = 0; x < spaceLen; ++x {
//        space.append(UnicodeScalar(" "))
//    }
//    
//    var char_array = Array(name + space + String(val) + "°C")
//    var color_array = [Int](count: 30, repeatedValue: 4)
//    
//    
//    // Setup
//    wattroff(win_v, COLOR_PAIR(Int32(1)))
//    wattroff(win_v, COLOR_PAIR(Int32(2)))
//    wattroff(win_v, COLOR_PAIR(Int32(3)))
//    wclear(win_v)
//    
//    var count = 0
//    for char in char_array {
//        if (count < valRange) {
//                    if (count < 14) {
//                        // Green
//                        wattrset(win_v, COLOR_PAIR(Int32(1)))
//                        waddstr(win_v, String(char))
//                    }
//                    else if (count >= 14 && count < 23) {
//                        // Yellow
//                        wattrset(win_v, COLOR_PAIR(Int32(2)))
//                        waddstr(win_v, String(char))
//                        //mvwaddch(win_v, 0, Int32(i), CWideChar("|").value)
//                    }
//                    else {
//                        // Red
//                        // > 23
//                        wattrset(win_v, COLOR_PAIR(Int32(3)))
//                        waddstr(win_v, String(char))
//                        //mvwaddch(win_v, 0, Int32(i), CWideChar("|").value)
//                    }
//        }
//        else {
//            wattrset(win_v, COLOR_PAIR(Int32(4)))
//            waddstr(win_v, String(char))
//        }
//        
//        ++count
//    }
//    
//    wrefresh(win_v)
//}

//    var a = Array(name)
////    var i = 0
////    for char in name.utf8 {
////        if < 14)
////        ++i
////    }
//    
//    for var i = 0; i < len; ++i {
//        if (i < 14) {
//            // Green
//            wattrset(win_v, COLOR_PAIR(Int32(1)))
//            waddch(win_v, CWideChar("|").value)
//        }
//        else if (i >= 14 && i < 23) {
//            // Yellow
//            wattrset(win_v, COLOR_PAIR(Int32(2)))
//            waddch(win_v, CWideChar("|").value)
//            //mvwaddch(win_v, 0, Int32(i), CWideChar("|").value)
//        }
//        else {
//            // Red
//            // > 23
//            wattrset(win_v, COLOR_PAIR(Int32(3)))
//            waddch(win_v, CWideChar("|").value)
//            //mvwaddch(win_v, 0, Int32(i), CWideChar("|").value)
//        }
//    }
//    
//    
//    var i = 0
//    for char in name.utf8 {
//        if (i < 14) {
//            // Green
//            wattrset(win_v, COLOR_PAIR(Int32(1)))
//            waddch(win_v, CWideChar("|").value)
//        }
//        else if (i >= 14 && i < 23) {
//            // Yellow
//            wattrset(win_v, COLOR_PAIR(Int32(2)))
//            waddch(win_v, CWideChar("|").value)
//            //mvwaddch(win_v, 0, Int32(i), CWideChar("|").value)
//        }
//        else {
//            // Red
//            // > 23
//            wattrset(win_v, COLOR_PAIR(Int32(3)))
//            waddch(win_v, CWideChar("|").value)
//            //mvwaddch(win_v, 0, Int32(i), CWideChar("|").value)
//        }
//        
//        ++i
//    }


//    var loop = 0
//    if (valRange < 14) {
//        // Off by one if 13 or 0
//        loop = valRange
//    }
//    else {
//        loop = 14
//    }
//    
//        // Green
//        wattrset(win_v, COLOR_PAIR(Int32(1)))
//        for var i = 1; i < loop; ++i {
//            mvwaddch(win_v, 0, Int32(i), CWideChar("|").value)
//            //waddch(win, CWideChar(" ").value)
//        }
//    
//    if (valRange < 23 && valRange >= 14) {
//        // Off by one if 13 or 0
//        loop = valRange
//    }
//    else {
//        loop = 23
//    }

//        // Yellow
//        wattroff(win_v, COLOR_PAIR(Int32(1)))
//        wattrset(win_v, COLOR_PAIR(Int32(2)))
//        for var i = 14; i < loop; ++i {
//            waddch(win, CWideChar("|").value)
//            //mvwaddch(win_v, 0, Int32(i), CWideChar(" ").value)
//        }
////
//    if (valRange < 30 && valRange >= 22) {
//        // Off by one if 13 or 0
//        loop = valRange
//    }
//    else {
//        loop = 30
//    }
//
//        // Red
//        wattroff(win_v, COLOR_PAIR(Int32(2)))
//        wattrset(win_v, COLOR_PAIR(Int32(3)))
//        for var i = 23; i < loop; ++i {
//            waddch(win, CWideChar(" ").value)
//            //mvwaddch(win_v, 0, Int32(i), CWideChar(" ").value)
//        }
//        //mvwaddstr(win_v, 0, 25, "55°C")
//    
//        wattroff(win_v, COLOR_PAIR(Int32(3)))
//        wattrset(win_v, COLOR_PAIR(Int32(1)))
        //mvwaddstr(win_v, 0, 1, name)
    

//func updateVal(val : Int) {
//    // Setup
//    wattroff(win, COLOR_PAIR(Int32(1)))
//    wattroff(win, COLOR_PAIR(Int32(2)))
//    wattroff(win, COLOR_PAIR(Int32(3)))
//    wclear(win)
//    box(win, CWideChar(" ").value, CWideChar(" ").value)
//    
//    
//    // Green
//    wattrset(win, COLOR_PAIR(Int32(1)))
//    for var i = 1; i < 14; i += 2 {
//        mvwaddch(win, 1, Int32(i), CWideChar(" ").value)
//    }
//    
//    // Yellow
//    wattroff(win, COLOR_PAIR(Int32(1)))
//    wattrset(win, COLOR_PAIR(Int32(2)))
//    for var i = 15; i < 23; i += 2 {
//        mvwaddch(win, 1, Int32(i), CWideChar(" ").value)
//    }
//    
//    // Red
//    wattroff(win, COLOR_PAIR(Int32(2)))
//    wattrset(win, COLOR_PAIR(Int32(3)))
//    for var i = 23; i < 30; i += 2 {
//        mvwaddch(win, 1, Int32(i), CWideChar(" ").value)
//    }
//    
//    wrefresh(win)
//}

//for var i = 0; i < 10; ++i {
//    updateVal(Int(arc4random_uniform(27)) + 1)
//    sleep(1)
//}

//updateVal(win , 55, "CPU_0_DIODE")
//updateVal(win2 , 60, "CPU_0_PROX")
//sleep(1)
//updateVal(win , 59, "CPU_0_DIODE")
//sleep(1)
//updateVal(win , 52, "CPU_0_DIODE")
//sleep(1)
//updateVal(win , 54, "CPU_0_DIODE")
//updateVal(win2 , 70, "CPU_0_PROX")
//sleep(1)
//updateVal(win , 58, "CPU_0_DIODE")
//sleep(1)
//
//updateVal(win , 70, "CPU_0_DIODE")
//sleep(1)
//
//updateVal(win , 80, "CPU_0_DIODE")
//sleep(1)
//
//updateVal(win , 30, "CPU_0_DIODE")
//sleep(1)
//updateVal(win , 90, "CPU_0_DIODE")
//sleep(1)
//updateVal(win , 105, "CPU_0_DIODE")


//attron(1 << 19)
//wattron(win, 1<<20)
//wattrset(win, 1 << 20)
//refresh()
//    attrset(COLOR_PAIR(Int32(i)))


//for var i = 1; i < 8; i += 2 {
//    sleep(1)
//    mvwaddch(win, 1, Int32(i), CWideChar(" ").value)
//    wrefresh(win)
//}
//wclear(win)
//wrefresh(win)


//mvwaddstr(win, 1, 1, "||||||||||")
//wrefresh(win)
//for var i = 7; i  > 1; i -= 2 {
//    sleep(1)
//    mvwdelch(win, 1, Int32(i))
//    wrefresh(win)
//}
//
//wclear(win)


//func setBarGraph(

//----------------------



getchar()


endwin()    // Close window. Must call before exit