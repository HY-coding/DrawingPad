//
//  ContentView.swift
//  Drawing_Demo_V2
//
//  Created by HY Chuang on 2021/7/5.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @EnvironmentObject var drawingVM : DrawingVM
    
    var body: some View {
        
        VStack {
            GeometryReader { geometry in
                VStack{
                    ZStack {

                        CanvasView(canvas: $drawingVM.canvas)
                            .onTapGesture {
                                print("onTapGesture")
                                drawingVM.collapseMenu()
                            }
                            
                    }
                }
                .preferredColorScheme(.light)
                .onAppear(){
                    print("onAppear")
                    drawingVM.canvasSize = geometry.size
                }
            }
            Spacer()
            DrawingMenuView()
                .preferredColorScheme(.light)
        }
        .onReceive(drawingVM.$drawingEvent) { event in
            print("rx event \(event)")
            switch event {
            default: break
            }
        } // onReceive
        .sheet(isPresented: $drawingVM.showBackgroundImagePickerSheet){
            switch drawingVM.drawingEvent {
            
            case .camera: Camera(handlePickedImage: { image in
                drawingVM.handlePickerBackgroundImage(image)
            })
            
            case .photo: PhotoLibrary(handlePickedImage:  { image in
                drawingVM.handlePickerBackgroundImage(image)
            })
            
            case .showColorPicker :
                ColorPicker("Pick Color", selection: $drawingVM.selectedColor)
            
            default: EmptyView()
            }
        }
        .alert(isPresented: $drawingVM.showSaveImageDoneAlert){
            Alert(title: Text("Imaged Saved."))
        }
        
    }// body
    
}


struct CanvasView : UIViewRepresentable {
    
    @EnvironmentObject var drawingVM : DrawingVM
    
    @Binding var canvas: PKCanvasView // to do: need to craete model for canvas View
    
    func makeUIView(context: Context) -> PKCanvasView {
        print("makeUIView")
//        canvas.overrideUserInterfaceStyle = .dark
        canvas.drawingPolicy = .anyInput
        
        canvas.tool = PKInkingTool(.pen, color: UIColor(drawingVM.selectedColor), width: drawingVM.selectedSize)
//        canvas.tool = PKInkingTool(ink: , width: 2)
//        canvas.tool = PKInkingTool(.pen, color: UIColor(drawingVM.selectedColor))
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.delegate = context.coordinator
        //canvas.isDirectionalLockEnabled = false
        //canvas.isScrollEnabled = true
        
//        canvas.drawingGestureRecognizer.isEnabled = false
        //toolPicker.setVisible(true, forFirstResponder: canvas)
        //toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
        return canvas
    }
    
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        print("updateUIView")
        
        for stroke in uiView.drawing.strokes {
            print(stroke)
        }
        
    }
    
    func onSaved() {
        print("onSaved")
        
        #if(false)
        var newPoints = [PKStrokePoint]()
        
        if let stroke = canvas.drawing.strokes.last {
            print(stroke)
            for point in stroke.path {
                if point.size.width == 5 && point.size.height == 5 {
                    return
                }
                print(point.location)
                let newPoint = PKStrokePoint(location: point.location,
                                             timeOffset: point.timeOffset,
                                             size: CGSize(width: 5,height: 5),
                                             opacity: CGFloat(1), force: point.force,
                                             azimuth: point.azimuth, altitude: point.altitude)
                newPoints.append(newPoint)
            }
            let newPath = PKStrokePath(controlPoints: newPoints, creationDate: Date())
            let newStroke = PKStroke(ink: PKInk(.pen, color: UIColor.black), path: newPath)
            canvas.drawing.strokes.removeLast()
            canvas.drawing.strokes.append(newStroke)
        }
        #endif
        
        
        
        //        canvas.drawing.strokes.forEach { point in
        //            print(point.)
        //        }
        //
        //print("\(canvas.drawing.strokes)")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvas: $drawingVM.canvas, onSaved: onSaved)
        
    }
    
}




//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
