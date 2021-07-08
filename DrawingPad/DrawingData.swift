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
    @Published var canvasSize = CGSize.zero
    
    
    @Published var showPenMenu = false
    @Published var showSettingMenu = false
    @Published var showSaveImageDoneAlert = false
    @Published var showBackgroundImagePickerSheet = false
    
    @Published var selectedColor = Consts.defaultColor {
        didSet {
            drawingEvent = .colorChanged
        }
    }
    
    @Published var selectedSize = Consts.penSize2 {
        didSet {
            drawingEvent = .penSizeChanged
        }
    }
     

    init(){
        
    }
    
    func collapseMenu() {
        self.showPenMenu = false
        self.showSettingMenu = false
    }
    
    
}

// functions
extension DrawingVM {
    
    func removeBackgroundImage() {
        if let viewWithTag = canvas.subviews[0].viewWithTag(Consts.backgroundImageTag) {
            print("found viewWithTag")
            viewWithTag.removeFromSuperview()
        }
    }
    
    
    func cleanDrawing(){
        canvas.drawing.strokes.removeAll()
        redoStrokes.removeAll()
        imageData.removeAll()
        removeBackgroundImage()
    }
        
    
    func undo(){
        if canvas.drawing.strokes.count > 0 {
            redoStrokes.append(canvas.drawing.strokes.last!)
            canvas.drawing.strokes.removeLast()
        }
    }
    
    func redo(){
        if redoStrokes.count > 0 {
            canvas.drawing.strokes.append(redoStrokes.last!)
            redoStrokes.removeLast()
        }
        print("\(redoStrokes)")
    }
    
    
    
        
    func changePenColor(_ color:Color) {
        selectedColor = color
        canvas.tool = PKInkingTool(.pen, color: UIColor(selectedColor), width: selectedSize)
    }
    func changePenWidth(_ width:CGFloat){
        selectedSize = width
        canvas.tool = PKInkingTool(.pen, color: UIColor(selectedColor), width: selectedSize)
    }
    
    
    func handlePickerBackgroundImage(_ image: UIImage?) {
        print("handlePickerBackgroundImage")
        
        if let imageData = image?.jpegData(compressionQuality: 1){
            print("imageData \(imageData)")
            
            //imageData = imageData
            
            removeBackgroundImage()
            
            if let image = UIImage(data: imageData) {
                
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height)
                imageView.contentMode   = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.tag = Consts.backgroundImageTag
                
                let subView = canvas.subviews[0]
                subView.addSubview(imageView)
                subView.sendSubviewToBack(imageView)
            }
            
            
        }
    }
    
    
    func showShareSheet(){
        
        if let image = exportDrawingToUIimage() {
            let activityItems = [image]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    func saveImageOnCanvas(){
        if let image = exportDrawingToUIimage() {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print("Save ok!")
            showSaveImageDoneAlert = true
        }
    }
    
    private func exportDrawingToUIimage()->UIImage? {
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0)
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: canvasSize), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
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
