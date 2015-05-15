//
// WidgetProcess.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2015  beltex <http://beltex.github.io>
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

import Cocoa
import Darwin

struct WidgetProcess: WidgetType {

    private var widget: WidgetBase
    var window = Window()
    var usernames = [uid_t : String]()

    init(window: Window = Window()) {
        self.window = Window()
        widget = WidgetBase(name: "   PID USER            COMMAND",
                            window: window)
    }

    mutating func draw() {
        var list = processList()

        list.sort { $0.0.kp_proc.p_pid > $1.0.kp_proc.p_pid }

        for var i = 0; i < Int(LINES) - Int(window.point.y) - 1; ++i {
            if i >= list.count { break }

            var kinfo = list[i]
            let command = withUnsafePointer(&kinfo.kp_proc.p_comm) {
                String.fromCString(UnsafePointer($0))!
            }

            let username: String
            let uid = kinfo.kp_eproc.e_ucred.cr_uid

            if let index = usernames.indexForKey(uid) {
                username = usernames[index].1
            }
            else { username = getUsername(uid) }

            let tokens = [String(kinfo.kp_proc.p_pid),
                          username,
                          command]

            let procStat = WidgetUIProcess(name: processString(tokens, window.length), window: Window(length: window.length, point: (0, window.point.y + i + 1)))

            procStat.draw()
        }
    }

    mutating func resize(window: Window) -> Int32 {
        self.window = window
        return widget.resize(window)
    }
}

struct WidgetUIProcess {

    let name     : String
    var window   : Window

    init(name: String, window: Window) {
        self.name   = name
        self.window = window
    }

    func draw() {
        move(window.point.y, window.point.x)
        addstr(name)
    }

    mutating func resize(window: Window) {
        self.window = window
        draw()
    }
}


private func processString(tokens: [String], length: Int) -> String {
    let pidSpace = 6
    let userSpace = 16

    let pidCount  = count(tokens[0])
    let userCount = count(tokens[1])

    var pidSpaceString  = String()
    var userSpaceString = String()

    for var i = 0; i < pidSpace - pidCount; ++i { pidSpaceString.append(UnicodeScalar(" ")) }
    for var i = 0; i < userSpace - userCount; ++i { userSpaceString.append(UnicodeScalar(" ")) }


    return pidSpaceString + tokens[0] + " " + tokens[1] + userSpaceString + tokens[2]
}


private func processList() -> [kinfo_proc] {
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0]
    var size = 0

    // First need to need size of process list array
    var result = sysctl(&mib, u_int(mib.count), nil, &size, nil, 0)
    assert(result == KERN_SUCCESS)

    // Get process list
    let procCount = size / strideof(kinfo_proc)
    var procList = [kinfo_proc](count: procCount, repeatedValue: kinfo_proc())
    result = sysctl(&mib, u_int(mib.count), &procList, &size, nil, 0)
    assert(result == KERN_SUCCESS)

    return procList
}


private func getUsername(uid: uid_t) -> String {
    let username: String
    var userInfo = passwd()
    var result   = UnsafeMutablePointer<passwd>.alloc(1)

    // TODO: Can we cache this?
    // TODO: Returns -1 on not error
    let bufferSize = sysconf(_SC_GETPW_R_SIZE_MAX)
    let buffer     = UnsafeMutablePointer<Int8>.alloc(bufferSize)

    // TODO: Check result for nil pointer - indictes not found
    // TODO: Add note about not using getpwuid()
    if getpwuid_r(uid, &userInfo, buffer, bufferSize, &result) == 0 {
        username = String.fromCString(userInfo.pw_name)!
    }
    else {
        username = String()
    }

    buffer.dealloc(bufferSize)
    // TODO: Why does this fail?
    //result.dealloc(1)

    return username
}
