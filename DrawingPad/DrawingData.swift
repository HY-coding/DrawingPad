//
//  DrawingData.swift
//  Drawing_Demo_V2
//
//  Created by HY Chuang on 2021/7/5.
//

import SwiftUI
import PencilKit


public struct Consts{
    static let iconSizeWidth:CGFloat = 60
    static let iconSizeHeight:CGFloat = 60
    static let iconOffset: CGFloat = 60
    static let iconFontSize: CGFloat = 24
    
    static let penSize1: CGFloat = 16
    static let penSize2: CGFloat = 12
    static let penSize3: CGFloat = 8
    static let defaultColor  = Color.black
    
    static let backgroundImageTag = 100
}


class DrawingVM: ObservableObject {
    
    enum Event: Equatable {
        case idle
        case colorChanged
        case penSizeChanged
        case clean
        case undo
        case redo
        case camera
        case photo
        case saveToAlbum
        case share
    }

    
    @Published var canvas = PKCanvasView()
    @Published var drawingEvent:Event = .idle {
        didSet {
            collapseMenu()
        }
    }
    @Published var redoStrokes = [PKStroke]()
    @Published var imageData: Data = Data(count: 0)
    
    
    @Published var penExpanded = false
    @Published var settingExpanded = false
    @Published var showAlert = false
    @Published var showSheet = false
    
    @Published var selectedColor = Consts.defaultColor {
        didSet {
            drawingEvent = .colorChanged
//            collapseMenu()
        }
    }
    
    @Published var selectedSize = Consts.penSize2 {
        didSet {
            drawingEvent = .penSizeChanged
//            collapseMenu()
        }
    }
     

    init(){
        
    }
    
    
    func collapseMenu() {
        self.penExpanded = false
        self.settingExpanded = false
    }
    
    
    func saveImageOnCanvas(_ canvas: PKCanvasView, size: CGSize){
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print("Save ok!")
            showAlert = true
        }
        
    }
    
}


class Coordinator: NSObject {
  var canvas: Binding<PKCanvasView>
  let onSaved: () -> Void

  init(canvas: Binding<PKCanvasView>, onSaved: @escaping () -> Void) {
    self.canvas = canvas
    self.onSaved = onSaved
  }
}

extension Coordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
        print("canvasViewDrawingDidChange")
        //print("Strokes ")
        if !canvas.drawing.bounds.isEmpty {
            onSaved()
        }
    }
    
}
