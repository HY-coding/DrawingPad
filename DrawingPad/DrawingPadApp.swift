//
//  DrawingPadApp.swift
//  DrawingPad
//
//  Created by HY Chuang on 2021/7/7.
//

import SwiftUI

@main
struct DrawingPadApp: App {
    @StateObject var drawingVM = DrawingVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(drawingVM)
        }
    }
}
