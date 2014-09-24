/*
#define NCURSES_ATTR_SHIFT       8
#define NCURSES_BITS(mask,shift) ((mask) << ((shift) + NCURSES_ATTR_SHIFT))

#define A_NORMAL	(1U - 1U)
#define A_ATTRIBUTES	NCURSES_BITS(~(1U - 1U),0)
#define A_CHARTEXT	(NCURSES_BITS(1U,0) - 1U)


#define A_COLOR		NCURSES_BITS(((1U) << 8) - 1U,0)

#define A_STANDOUT	NCURSES_BITS(1U,8)
#define A_UNDERLINE	NCURSES_BITS(1U,9)
#define A_REVERSE	NCURSES_BITS(1U,10)
#define A_BLINK		NCURSES_BITS(1U,11)
#define A_DIM		NCURSES_BITS(1U,12)
#define A_BOLD		NCURSES_BITS(1U,13)
#define A_ALTCHARSET	NCURSES_BITS(1U,14)
#define A_INVIS		NCURSES_BITS(1U,15)
#define A_PROTECT	NCURSES_BITS(1U,16)
#define A_HORIZONTAL	NCURSES_BITS(1U,17)
#define A_LEFT		NCURSES_BITS(1U,18)
#define A_LOW		NCURSES_BITS(1U,19)
#define A_RIGHT		NCURSES_BITS(1U,20)
#define A_TOP		NCURSES_BITS(1U,21)
#define A_VERTICAL	NCURSES_BITS(1U,22)
*/


let NCURSES_ATTR_SHIFT = 8
let A_NORMAL = 0


func NCURSES_BITS(mask : Int, shift : Int) -> Int32 {
    return Int32(mask << (shift + NCURSES_ATTR_SHIFT))
}

let A_ATTRIBUTES = NCURSES_BITS(0, 0)
let A_CHARTEXT   = NCURSES_BITS(1, 0) - 1
let A_COLOR      = NCURSES_BITS((1 << 8) - 1, 0)

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


// Init terminal colours
start_color()
init_pair(1, Int16(COLOR_RED), Int16(COLOR_BLUE));
addstr("-- Hello")
refresh()

// Sample box
var win = newwin(3, 30, 1, 1)
//mvaddch(0, 1, CWideChar("H").value)

//refresh()
box(win, CWideChar(" ").value, CWideChar(" ").value)
//attron()
//attron(1 << 19)
//wattron(win, 1<<20)
//wattrset(win, 1 << 20)
//refresh()
//    attrset(COLOR_PAIR(Int32(i)))
wattrset(win, COLOR_PAIR(Int32(1)))
//waddch(win, CWideChar(" ").value)
mvwaddch(win, 1, Int32(1), CWideChar(" ").value)
mvwaddch(win, 1, Int32(3), CWideChar(" ").value)
mvwaddch(win, 1, Int32(5), CWideChar(" ").value)
wrefresh(win)

sleep(1)
mvwaddch(win, 1, Int32(7), CWideChar(" ").value)
wrefresh(win)

sleep(1)
mvwaddch(win, 1, Int32(9), CWideChar(" ").value)
wrefresh(win)

sleep(1)
mvwaddch(win, 1, Int32(11), CWideChar(" ").value)
wrefresh(win)


//var ptr = UnsafePointer<Int8>()


//COLOR_BLACK


//for var i = 1; i < 3; ++i {
//    //mvwaddch(win, 1, Int32(i), CWideChar("\u{2588}").value)
//    mvwaddch(win, 1, Int32(i + 2), CWideChar(" ").value)
//    wrefresh(win)
//    sleep(1)
//}



//sleep(30)
getchar()


endwin()    // Close window. Must call before exit