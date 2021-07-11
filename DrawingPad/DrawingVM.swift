//
//  DrawingData.swift
//  Drawing_Demo_V2
//
//  Created by HY Chuang on 2021/7/5.
//

import SwiftUI
import PencilKit


public struct Consts{
    
    
    static let iconSizeWidth:CGFloat = 32
    static let iconSizeHeight:CGFloat = 32
    static let iconOffset: CGFloat = 60
    static let iconFontSize: CGFloat = 24
    static let iconSize: CGSize = CGSize(width: 24, height: 24)
    
    static let iconPenInnerFontSize1 : CGFloat = 10
    static let iconPenInnerFontSize2 : CGFloat = 16
    static let iconPenInnerFontSize3 : CGFloat = 22
    
    static let menuBackgroundHeight: CGFloat = 48
    static let menuIconColor = Color.black
    
    static let penSize1: CGFloat = 1
    static let penSize2: CGFloat = 5
    static let penSize3: CGFloat = 10
    static let defaultColor  = Color.black
    
    static let backgroundImageTag = 100
}


class DrawingVM: ObservableObject {
    
    enum Event: Equatable {
        case idle
        case camera
        case photo
        case showColorPicker
    }

    
    @Published var canvas = PKCanvasView()
    @Published var drawingEvent:Event = .idle
    @Published var redoStrokes = [PKStroke]()
    @Published var imageData: Data = Data(count: 0)
    
    
    
    @Published var showPenMenu = false {
        didSet {
            if showPenMenu == true {
                canvas.isUserInteractionEnabled = false
            }
            if !showPenMenu && !showSettingMenu {
                canvas.isUserInteractionEnabled = true
            }
        }
    }
    
    @Published var showSettingMenu = false {
        didSet {
            if showSettingMenu == true {
                canvas.isUserInteractionEnabled = false
            }
            if !showPenMenu && !showSettingMenu {
                canvas.isUserInteractionEnabled = true
            }
        }
    }
    
    @Published var showSaveImageDoneAlert = false {
        didSet {
            collapseMenu()
        }
    }
    
    @Published var showBackgroundImagePickerSheet = false {
        didSet {
            collapseMenu()
        }
    }
    
    @Published var selectedColor = Consts.defaultColor {
        didSet {
            changePenColor(selectedColor)
            collapseMenu()
        }
    }
    
    @Published var selectedSize = Consts.penSize2 {
        didSet {
            collapseMenu()
        }
    }
     

    init(){
        
        
    }
    
    func collapseMenu() {
        withAnimation {
            self.showPenMenu = false
            self.showSettingMenu = false
            self.canvas.isUserInteractionEnabled = true
        }
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
        collapseMenu()
    }
        
    
    func undo(){
        if canvas.drawing.strokes.count > 0 {
            redoStrokes.append(canvas.drawing.strokes.last!)
            canvas.drawing.strokes.removeLast()
        }
        collapseMenu()
    }
    
    func redo(){
        if redoStrokes.count > 0 {
            canvas.drawing.strokes.append(redoStrokes.last!)
            redoStrokes.removeLast()
        }
        collapseMenu()
        print("\(redoStrokes)")
    }
    
        
    func changePenColor(_ color:Color) {
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
                imageView.frame = CGRect(x: 0, y: 0, width: canvas.bounds.size.width, height: canvas.bounds.size.height)
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
        
        if let image = convertCanvasToUIimage() {
            print("showShareSheet")
            let activityItems = [image]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    func saveImageOnCanvas(){
        if let image = convertCanvasToUIimage() {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print("Save ok!")
            showSaveImageDoneAlert = true
        }
    }
    
    private func convertCanvasToUIimage()->UIImage? {
        
        print("convertDrawingToUIimage")
        UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, false, 0)
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: canvas.bounds.size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    //iconPenInnerFontSize2
    func convertPenInnerFontSize(_ penSize: CGFloat) -> CGFloat {
        if penSize == Consts.penSize1 {
            return Consts.iconPenInnerFontSize1
        }
        
        if penSize == Consts.penSize2 {
            return Consts.iconPenInnerFontSize2
        }
        
        if penSize == Consts.penSize3 {
            return Consts.iconPenInnerFontSize3
        }
        
        return 0
    }
    
    func claerRedoStrokes() {
        print("redoStrokes.removeAll()")
        redoStrokes.removeAll()
    }
    
}


class Coordinator: NSObject {
    
    var canvas: Binding<PKCanvasView>
    @Published var redoStrokes: [PKStroke]
    
    let onChanged: () -> Void
    let onDrawingBegin: () -> Void
    let onDrawingEnd: () -> Void
    
    init(canvas:  Binding<PKCanvasView>,
         redoStrokes : [PKStroke],
         onSaved: @escaping () -> Void,
         onDrawingBegin: @escaping () -> Void,
         onDrawingEnd: @escaping () -> Void
    ) {
        self.canvas = canvas
        self.redoStrokes = redoStrokes
        self.onChanged = onSaved
        self.onDrawingBegin = onDrawingBegin
        self.onDrawingEnd = onDrawingEnd
        
    }
    
    
    
}

extension Coordinator: PKCanvasViewDelegate {
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        
    }
    
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        print("canvasViewDidBeginUsingTool")
        print( redoStrokes.count )
        onDrawingBegin()
        
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        print("canvasViewDidEndUsingTool")
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        print("canvasViewDidFinishRendering")
    }
    
    
    func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
        print("canvasViewDrawingDidChange")
        //print("Strokes ")
        if !canvas.drawing.bounds.isEmpty {
            onChanged()
        }

    }
    
}
