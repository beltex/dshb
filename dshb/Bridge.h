/*
 * Bridging header for accessing ncurses C API.
 *
 * Bridge.h
 * dshb
 *
 * Copyright (C) 2014  beltex <https://github.com/beltex>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef dshb_Bridge_h
#define dshb_Bridge_h

// TODO: Get rid of extra imports. ncurses.h should include everything we need
//       but for some reason it doesn't import everything over to Swift

#import <panel.h>
#import <curses.h>
#import <ncurses.h>

#import <stdio.h>
#import <stdlib.h>
#import <term.h>
#import <termios.h>
#import <termcap.h>
#import <wchar.h>


#endif
