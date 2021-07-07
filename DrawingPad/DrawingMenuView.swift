//
//  MenuView.swift
//  Drawing_Menu_Demo
//
//  Created by HY Chuang on 2021/7/4.
//

import SwiftUI


    
struct DrawingMenuView : View {
    
    @ObservedObject var drawingVM : DrawingVM
    
    var penColorItems : some View {
        Group {
            Button {
                drawingVM.selectedColor = .black
            } label : {
                Image(systemName: "circle.fill" )
                    .foregroundColor(.black)
            }
            .modifier(SideItemViewModifier(offset: -Consts.iconOffset*6))
            
            Button {
                drawingVM.selectedColor = .blue
            } label : {
                Image(systemName: "circle.fill" )
                    .foregroundColor(.blue)
            }
            .modifier(SideItemViewModifier(offset: -Consts.iconOffset*5))
            
            Button {
                drawingVM.selectedColor = .green
            } label : {
                Image(systemName: "circle.fill" )
                    .foregroundColor(.green)
            }
            .modifier(SideItemViewModifier(offset: -Consts.iconOffset*4))
            
            Button {
                drawingVM.selectedColor = .yellow
            } label : {
                Image(systemName: "circle.fill" )
                    .foregroundColor(.yellow)
            }
            .modifier(SideItemViewModifier(offset: -Consts.iconOffset*3))
            
            Button {
                drawingVM.selectedColor = .red
            } label : {
                Image(systemName: "circle.fill" )
                    .foregroundColor(.red)
            }
            .modifier(SideItemViewModifier(offset: -Consts.iconOffset*2))
            //clean button
            Button {
                drawingVM.selectedColor = .white
            } label : {
                Image(systemName: "circle" )
                    .foregroundColor(.black)
            }
            .modifier(SideItemViewModifier(offset: -Consts.iconOffset))
        }
    }
    
    var penSizeItems : some View {
        Group {
            Button {
                // pen size 1
                drawingVM.selectedSize = Consts.penSize1
            } label : {
                ZStack {
                    Image(systemName: "circle.fill")
                        .font(Font.system(size: Consts.iconFontSize))
                        .foregroundColor(.gray)
                    Image(systemName: "circle.fill")
                        .foregroundColor(drawingVM.selectedColor)
                        .font(Font.system(size: Consts.penSize1))
                }
            }
            .modifier(BottomItemViewModifier(offset: Consts.iconOffset*3))
            
            Button {
                // pen size 2
                drawingVM.selectedSize = Consts.penSize2
            } label : {
                ZStack {
                    Image(systemName: "circle.fill")
                        .font(Font.system(size: Consts.iconFontSize))
                        .foregroundColor(.gray)
                    Image(systemName: "circle.fill")
                        .foregroundColor(drawingVM.selectedColor)
                        .font(Font.system(size: Consts.penSize2))
                }
            }.modifier(BottomItemViewModifier(offset: Consts.iconOffset*2))
            
            
            Button {
                // pen size 3
                drawingVM.selectedSize = Consts.penSize3
            } label : {
                ZStack {
                    Image(systemName: "circle.fill")
                        .font(Font.system(size: Consts.iconFontSize))
                        .foregroundColor(.gray)
                    Image(systemName: "circle.fill")
                        .foregroundColor(drawingVM.selectedColor)
                        .font(Font.system(size: Consts.penSize3))
                }
            }.modifier(BottomItemViewModifier(offset: Consts.iconOffset*1))
            
        }
    }
    
    var penGroup : some View {
        ZStack {
            
            if drawingVM.penExpanded {
                penColorItems
                penSizeItems
            }
            
            
            Button {
                withAnimation{
                    drawingVM.penExpanded.toggle()
                    drawingVM.settingExpanded = false
                }
            } label : {
                
                ZStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.gray)
                        .font(Font.system(size: Consts.iconFontSize))
                    
                    Image(systemName: "circle.fill")
                        .font(Font.system(size: drawingVM.selectedSize))
                        .foregroundColor(drawingVM.selectedColor)
                    
                }
            }
            .clipShape(Circle())
            .padding()
        }
        .animation(drawingVM.penExpanded ? .spring(dampingFraction: 0.7) : .easeInOut)
        
        
    }
    
    
    var undo : some View {
        Button {
            drawingVM.drawingEvent = .undo
        } label : {
            Image(systemName: "arrow.uturn.left")
        }
        .font(Font.system(size: Consts.iconFontSize))
        .padding()
    }
    
    
    var redo : some View {
        Button {
            drawingVM.drawingEvent = .redo
        } label : {
            Image(systemName: "arrow.uturn.right")
        }
        .font(Font.system(size: Consts.iconFontSize))
        .padding()
    }
    
    var clean : some View {
        Button {
            print("trash")
            drawingVM.drawingEvent = .clean
        } label : {
            Image(systemName: "trash")
        }
        .font(Font.system(size: Consts.iconFontSize))
        .padding()
    }
    
    
    
    var settingGroup : some View {
        ZStack {
            if drawingVM.settingExpanded {
                
                Button { } label : {
                    Image(systemName: "info.circle")
                }
                .modifier(SideItemViewModifier(offset: -Consts.iconOffset*5))
                
                Button {
                    drawingVM.drawingEvent = .share
                } label : {
                    Image(systemName: "square.and.arrow.up")
                }
                .modifier(SideItemViewModifier(offset: -Consts.iconOffset*4))
                
                Button {
                    drawingVM.drawingEvent = .saveToAlbum
                } label : {
                    Image(systemName: "arrow.down.to.line")
                }
                .modifier(SideItemViewModifier(offset: -Consts.iconOffset*3))
                
                Button {
                    drawingVM.drawingEvent = .camera
                    drawingVM.showSheet = true
                } label : {
                    Image(systemName: "camera")
                }
                .modifier(SideItemViewModifier(offset: -Consts.iconOffset*2))
                
                Button {
                    drawingVM.drawingEvent = .photo
                    drawingVM.showSheet = true
                } label : {
                    Image(systemName: "photo")
                }
                .modifier(SideItemViewModifier(offset: -Consts.iconOffset))
                
            }
            
            Button {
                
                withAnimation {
                    drawingVM.settingExpanded.toggle()
                    drawingVM.penExpanded = false
                }
                
            } label : {
                Image(systemName: "gearshape")
            }
            .font(Font.system(size: Consts.iconFontSize))
            .clipShape(Rectangle())
            .padding()
            
            
        }
        .animation(drawingVM.settingExpanded ? .spring(dampingFraction: 0.7) : .easeOut)
        
    }
    
    
    var body: some View {
        HStack {
            
            penGroup
            Spacer()
            if !drawingVM.penExpanded {
                Group {
                    undo
                    Spacer()
                    redo
                    Spacer()
                    clean
                    Spacer()
                    settingGroup
                }
                .animation(.easeInOut)
            }
            
        }
        .onTapGesture {
            print("menu tapped")
        }
        //.background(Color.purple)
        //.shadow(color: .black, radius: 3, x: 3, y: 3)
        //        .cornerRadius(25)
        .padding()
        
        //.clipShape(Capsule())
    }
    
}


struct SideItemViewModifier: ViewModifier {
    var offset: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .font(.system(size: Consts.iconFontSize))
            .offset(y: offset )
            .transition(
                AnyTransition.asymmetric(
                    insertion:.offset( y: -offset).combined(with: .scale),
                    removal:.offset( y: -offset).combined(with: .scale)
                )
            )
        
        
    }
}


struct BottomItemViewModifier: ViewModifier {
    var offset: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .font(.system(size: Consts.iconFontSize))
            .transition(
                AnyTransition.asymmetric(
                    insertion:.offset( x: -offset).combined(with: .scale),
                    removal:.offset( x: -offset).combined(with: .scale)
                )
            )
            .offset(x: offset)
    }
}
    


//struct MenuView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        VStack {
//            Spacer()
//            DrawingMenuView( penExpanded: .constant(false), settingExpanded: .constant(false), selectedColor: .constant(.black), selectedSize: .constant(8))
//        }
//    }
//}
