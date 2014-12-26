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

//#import <panel.h>
//#import <curses.h>
#import <ncurses.h>

//#import <stdio.h>
//#import <stdlib.h>
//#import <term.h>
//#import <termios.h>
//#import <termcap.h>
//#import <wchar.h>


// COPIED FROM SYSTEMKIT
//#include <stdio.h>
#include <sys/sysctl.h>

// Temp simplified struct with only the things we need for now
typedef struct {
    struct timeval __p_starttime;     // Process start time - p_un.__p_starttime
    int	p_flag;			              // P_* flags
    char	p_stat;			          // S* process status
    char	p_comm[MAXCOMLEN+1];
    struct	_ucred e_ucred;		      // Current credentials
    pid_t	e_ppid;                   // Parent process id
    // TODO: Why does kinfo_proc have this as pid_t? top works with it as gid_t
    gid_t	e_pgid;                   // Process group id
} kinfo_proc_systemkit;

int kinfo_for_pid(pid_t pid, kinfo_proc_systemkit *kinfo_sk);


#endif
