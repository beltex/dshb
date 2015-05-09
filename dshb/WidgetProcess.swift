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

    static let titleTokens = ["PID", "USER", "COMMAND"]
    var title: WidgetUITitleProcess
    var window: Window
    
    init(window: Window = Window()) {
        self.window = window
        title = WidgetUITitleProcess(tokens: WidgetProcess.titleTokens,
                                     window: window)
    }

    mutating func draw() {
        var list = processList()

        list.sort { $0.0.kp_proc.p_pid > $1.0.kp_proc.p_pid }

        for var i = 0; i < 5; ++i {
            var kinfo = list[i]
            let command = withUnsafePointer(&kinfo.kp_proc.p_comm) {
                String.fromCString(UnsafePointer($0))!
            }

            let tokens = [String(kinfo.kp_proc.p_pid), String(kinfo.kp_eproc.e_ucred.cr_uid), command]


//            var tempWindow = Window(length: window.length, point: (window.point.x, window.point.y + i + 1))
//            var temp = WidgetUITitleProcess(tokens: tokens, window: tempWindow, spacing: title.spaceLength)
//            temp.draw()
        }
    }

    mutating func resize(window: Window) -> Int32 {
        title.resize(window)

        return window.point.y
    }
}

struct WidgetUIProcess {
    var window: Window
    var padding = String()
    var spaceLength = 0
    private let tokens: [String]
    private var title = String()
    private var tokensCharacterCount = 0

    init(tokens: [String], window: Window) {
        self.tokens = tokens
        self.window = window

        for token in tokens { tokensCharacterCount += count(token) }

        generatePadding()
    }

    func draw() {
        move(window.point.y, window.point.x)
        attrset(COLOR_PAIR(WidgetUIColorBackground))
        addstr(title)
    }

    mutating func resize(window: Window) {
        self.window = window
        generatePadding()
        draw()
    }

    private mutating func generatePadding() {
        title   = String()
        padding = String()
        spaceLength = (Int(window.length) - tokensCharacterCount) / tokens.count

        for var i = 0; i < spaceLength; ++i { padding.append(UnicodeScalar(" ")) }
        for token in tokens { title = title + token + padding }
    }
}

struct WidgetUITitleProcess {

    var window: Window
    var padding = String()
    var spaceLength = 0
    private let tokens: [String]
    private var title = String()
    private var tokensCharacterCount = 0

    init(tokens: [String], window: Window) {
        self.tokens = tokens
        self.window = window

        for token in tokens { tokensCharacterCount += count(token) }

        generatePadding()
    }

    func draw() {
        move(window.point.y, window.point.x)
        attrset(COLOR_PAIR(WidgetUIColorTitle))
        addstr(title)
    }

    mutating func resize(window: Window) {
        self.window = window
        generatePadding()
        draw()
    }

    private mutating func generatePadding() {
        title   = String()
        padding = String()
        spaceLength = (Int(window.length) - tokensCharacterCount) / tokens.count

        for var i = 0; i < spaceLength; ++i { padding.append(UnicodeScalar(" ")) }
        for token in tokens { title = title + token + padding }
    }
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
