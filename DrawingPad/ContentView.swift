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
                .onAppear(){
                    print("onAppear")
                    drawingVM.canvasSize = geometry.size
                }
            }
            Spacer()
            DrawingMenuView()
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
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        
        canvas.delegate = context.coordinator
        //canvas.isDirectionalLockEnabled = false
        //canvas.isScrollEnabled = true
        
        canvas.drawingGestureRecognizer.isEnabled = false
        //toolPicker.setVisible(true, forFirstResponder: canvas)
        //toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
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
        Coordinator(canvas: $drawingVM.canvas, onSaved: onSaved)
        
    }
    
}




//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
