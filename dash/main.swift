import Foundation


// ncurses settings
initscr()               // Init window
noecho()                // Don't echo user input
nonl()                  // Disable newline mode
keypad(stdscr, true)    // Enable function and arrow keys
curs_set(0)             // Set cursor to invisible


// Sample box
var win = newwin(2, 30, 0, 0)
box(win, CWideChar(" ").value, CWideChar(" ").value)
wrefresh(win)

getchar()


endwin()    // Close window