//
//  MenuView.swift
//  Drawing_Menu_Demo
//
//  Created by HY Chuang on 2021/7/4.
//

import SwiftUI


    
struct DrawingMenuView : View {
    
    @EnvironmentObject var drawingVM : DrawingVM
    
    var penColorItems : some View {
        Group {

            ColorPicker("color", selection: $drawingVM.selectedColor)
                .labelsHidden()
                .modifier(SideItemViewModifier(offset: -Consts.iconOffset*7))

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
                drawingVM.changePenWidth(Consts.penSize1)
            } label : {
                ZStack {
                    Image(systemName: "circle.fill")
                        .font(Font.system(size: Consts.iconFontSize))
                        .foregroundColor(.gray)
                    Image(systemName: "circle.fill")
                        .foregroundColor(drawingVM.selectedColor)
                        .font(Font.system(size: Consts.iconPenInnerFontSize1))
                }
            }
            .modifier(BottomItemViewModifier(offset: Consts.iconOffset*1))
            
            Button {
                // pen size 2
                drawingVM.changePenWidth(Consts.penSize2)
            } label : {
                ZStack {
                    Image(systemName: "circle.fill")
                        .font(Font.system(size: Consts.iconFontSize))
                        .foregroundColor(.gray)
                    Image(systemName: "circle.fill")
                        .foregroundColor(drawingVM.selectedColor)
                        .font(Font.system(size: Consts.iconPenInnerFontSize2))
                }
            }.modifier(BottomItemViewModifier(offset: Consts.iconOffset*2))
            
            
            Button {
                // pen size 3
                drawingVM.changePenWidth(Consts.penSize3)
            } label : {
                ZStack {
                    Image(systemName: "circle.fill")
                        .font(Font.system(size: Consts.iconFontSize))
                        .foregroundColor(.gray)
                    Image(systemName: "circle.fill")
                        .foregroundColor(drawingVM.selectedColor)
                        .font(Font.system(size: Consts.iconPenInnerFontSize3))
                }
            }.modifier(BottomItemViewModifier(offset: Consts.iconOffset*3))
            
        }
    }
    
    var penGroup : some View {
        ZStack {
            
            Group{
                if drawingVM.showPenMenu {
                    penColorItems
                    penSizeItems
                }
            }.animation(drawingVM.showPenMenu ? .spring(dampingFraction: 0.7) : .easeInOut)
            
            
            Button {
                withAnimation{
                    drawingVM.showPenMenu.toggle()
                    drawingVM.showSettingMenu = false
                }
            } label : {
                
                ZStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.gray)
                        .font(Font.system(size: Consts.iconFontSize))
                    
                    Image(systemName: "circle.fill")
                        
                }
                .font(Font.system(size: drawingVM.convertPenInnerFontSize(drawingVM.selectedSize)  ))
                .foregroundColor(drawingVM.selectedColor)
            }
            .font(.system(size: Consts.iconFontSize))
            .frame(width: Consts.iconSizeWidth, height: Consts.iconSizeHeight)
            
        }
        .padding(.horizontal)
        
        
        
    }
    
    
    var undo : some View {
        Button {
            drawingVM.undo()
        } label : {
            Image(systemName: "arrow.uturn.left")
        }
        .font(Font.system(size: Consts.iconFontSize))
        .padding(.horizontal)
        
    }
    
    
    var redo : some View {
        Button {
            drawingVM.redo()
        } label : {
            Image(systemName: "arrow.uturn.right")
        }
        .font(Font.system(size: Consts.iconFontSize))
        .padding(.horizontal)
    }
    
    var clean : some View {
        Button {
            print("trash")
            drawingVM.cleanDrawing()
        } label : {
            Image(systemName: "trash")
        }
        .font(Font.system(size: Consts.iconFontSize))
        .padding(.horizontal)

    }
    
    var locker : some View {
        Button {
            print("lock")
            drawingVM.canvas.isUserInteractionEnabled.toggle()
        } label : {
            if !drawingVM.canvas.isUserInteractionEnabled {
                Image(systemName: "lock")
                    .font(.system(size: Consts.iconFontSize))
            }else {
                Image(systemName: "lock.open")
                    .font(.system(size: Consts.iconFontSize))
            }
        }
        .font(Font.system(size: Consts.iconFontSize))
        .padding(.horizontal)
    }
    
    
    
    var settingGroup : some View {
        ZStack {
            if drawingVM.showSettingMenu {
                Group {
                    Button { } label : {
                        Image(systemName: "info.circle")
                    }
                    .modifier(SideItemViewModifier(offset: -Consts.iconOffset*5))
                    
                    
                    Button {
                        drawingVM.showShareSheet()
                    } label : {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .modifier(SideItemViewModifier(offset: -Consts.iconOffset*4))
                    
                    Button {
                        drawingVM.saveImageOnCanvas()
                    } label : {
                        Image(systemName: "arrow.down.to.line")
                    }
                    .modifier(SideItemViewModifier(offset: -Consts.iconOffset*3))
                    
                    Button {
                        drawingVM.drawingEvent = .camera
                        drawingVM.showBackgroundImagePickerSheet = true
                    } label : {
                        Image(systemName: "camera")
                    }
                    
                    .modifier(SideItemViewModifier(offset: -Consts.iconOffset*2))
                    
                    Button {
                        drawingVM.drawingEvent = .photo
                        drawingVM.showBackgroundImagePickerSheet = true
                    } label : {
                        Image(systemName: "photo")
                    }
                    .modifier(SideItemViewModifier(offset: -Consts.iconOffset))
                    
                }
                .animation(drawingVM.showSettingMenu ? .spring(dampingFraction: 0.7) : .easeOut)
            }
            
            Button {
                
                withAnimation {
                    drawingVM.showSettingMenu.toggle()
                    drawingVM.showPenMenu = false
                }
                
            } label : {
                Image(systemName: "gearshape")
            }
            .font(Font.system(size: Consts.iconFontSize))
            .padding(.horizontal)
            
            
        }
        .foregroundColor(Consts.menuIconColor)
        
        
    }
    
    
    var body: some View {
        ZStack {
            
            Color(red: 32/255, green: 110/255, blue: 140/255)
                .frame(height: Consts.menuBackgroundHeight)
                .opacity(0.8)
                //.shadow(color: .black, radius: 3, x: 3, y: 3)
                //.cornerRadius(25)

            HStack {
                penGroup
                Spacer()
                if !drawingVM.showPenMenu {
                    Group {
                        undo
                        Spacer()
                        redo
                        Spacer()
                        clean
                        Spacer()
                        settingGroup
                    }
                    .foregroundColor(Consts.menuIconColor)
                    //.animation(.easeInOut)
                }
                
            }
//            .frame(height: Consts.menuBackgroundHeight)
//            .onTapGesture {
//                print("menu tapped")
//            }
            
        }
    }
    
}


struct SideItemViewModifier: ViewModifier {
    var offset: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .font(.system(size: Consts.iconFontSize))
            .frame(width: Consts.iconSizeWidth, height: Consts.iconSizeHeight)
            .background( Color.white.opacity(0.5) )
            .cornerRadius(8)
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
