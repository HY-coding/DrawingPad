//
//  ContentView.swift
//  Drawing_Demo_V2
//
//  Created by HY Chuang on 2021/7/5.
//

import SwiftUI
import PencilKit

struct ContentView: View {
        
    @ObservedObject var drawingVM : DrawingVM
    
    @State private var canvas = PKCanvasView()
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CanvasView(drawingVM: drawingVM, canvas: $canvas)
                Spacer()
                DrawingMenuView(drawingVM: drawingVM)
                
            }
            .onReceive(drawingVM.$drawingEvent) { event in
                print("rx event \(event)")
                switch event {
                
                case .clean:
                    canvas.drawing.strokes.removeAll()
                    drawingVM.redoStrokes.removeAll()
                    drawingVM.imageData.removeAll()
                    removeBackgroundImage()
                case .undo:
                    if canvas.drawing.strokes.count > 0 {
                        drawingVM.redoStrokes.append(canvas.drawing.strokes.last!)
                        canvas.drawing.strokes.removeLast()
                    }
                    
                case .redo:
                    if drawingVM.redoStrokes.count > 0 {
                        canvas.drawing.strokes.append(drawingVM.redoStrokes.last!)
                        drawingVM.redoStrokes.removeLast()
                    }
                    print("\(drawingVM.redoStrokes)")
                    
                case .saveToAlbum:
                    drawingVM.saveImageOnCanvas( canvas, size: geometry.size)
                    
                case .camera:
                    print("rx camera")
                    
                case .photo:
                    print("rx photo")
                  
                case .colorChanged:
                    canvas.tool = PKInkingTool(.pen, color: UIColor(drawingVM.selectedColor), width: drawingVM.selectedSize)
                case .penSizeChanged:
                    canvas.tool = PKInkingTool(.pen, color: UIColor(drawingVM.selectedColor), width: drawingVM.selectedSize)
                    
                case .share:
                    showShareSheet(canvas, size: geometry.size)
                default: break
                }
            } // onReceive
            .sheet(isPresented: $drawingVM.showSheet){
                switch drawingVM.drawingEvent {
                
                case .camera: Camera(handlePickedImage: { image in
                    handlePickerBackgroundImage(image, size: geometry.size)
                })
                
                case .photo: PhotoLibrary(handlePickedImage:  { image in
                    handlePickerBackgroundImage(image, size: geometry.size)
                })
                
                default: EmptyView()
                }
            }
            .alert(isPresented: $drawingVM.showAlert){
                Alert(title: Text("Imaged Saved."))
            }
        }
        
    }// body
    
    
    
    private func handlePickerBackgroundImage(_ image: UIImage?, size: CGSize) {
        print("handlePickerBackgroundImage")
        
        if let imageData = image?.jpegData(compressionQuality: 1){
            print("imageData \(imageData)")
            drawingVM.imageData = imageData
            
            removeBackgroundImage()
            
            if let image = UIImage(data: imageData) {
                
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                imageView.contentMode   = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.tag = Consts.backgroundImageTag
                
                let subView = canvas.subviews[0]
                subView.addSubview(imageView)
                subView.sendSubviewToBack(imageView)
            }
            
            
        }
    }
    
    private func removeBackgroundImage() {
        if let viewWithTag = canvas.subviews[0].viewWithTag(Consts.backgroundImageTag) {
            print("found viewWithTag")
            viewWithTag.removeFromSuperview()
        }
    }
    
    
    func showShareSheet(_ canvas: PKCanvasView, size: CGSize){
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        if image != nil {
            let activityItems = [image!]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
}


struct CanvasView : UIViewRepresentable {
    
    @ObservedObject var drawingVM : DrawingVM
    @Binding var canvas: PKCanvasView // to do: need to craete model for canvas View
    
    func makeUIView(context: Context) -> PKCanvasView {
        print("makeUIView")
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: UIColor(drawingVM.selectedColor), width: drawingVM.selectedSize)
        //canvas.backgroundColor = .white
        canvas.isOpaque = false
        canvas.delegate = context.coordinator
        
        //toolPicker.setVisible(true, forFirstResponder: canvas)
        //toolPicker.addObserver(canvas)
        //canvas.becomeFirstResponder()
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        print("updateUIView")
        
        
    }
    
    func onSaved() {
        print("onSaved")
        //print("\(canvas.drawing.strokes)")
    }
    
    func makeCoordinator() -> Coordinator {
      Coordinator(canvas: $canvas, onSaved: onSaved)
    }
    
}




//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
