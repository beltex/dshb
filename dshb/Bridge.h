//
// Bridge.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014, 2015  beltex <https://github.com/beltex>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#ifndef dshb_Bridge_h
#define dshb_Bridge_h

#import <ncurses.h>

// COPIED FROM SYSTEMKIT
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
