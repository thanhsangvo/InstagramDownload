//
//  ImageLayout.swift
//  ImageLayout
//
//  Created by Vo Thanh Sang on 07/09/2021.
//

import SwiftUI
import CoreData

struct ImageLayout: View {
    
    @State var selectedLayout: LayoutType = .double
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Insta.user, ascending: true)],
        animation: .default)
    
    private var insta: FetchedResults<Insta>
    
    init() {
        
    }
    
    var body: some View {
        
        VStack {
            Picker("Layout Style", selection: $selectedLayout) {
                ForEach(LayoutType.allCases, id: \.self) { type in
                    switch type {
                        case .double:
                            Image(systemName: "square.grid.2x2")
                        case .adaptive:
                            Image(systemName: "square.grid.3x3")
                    }
                }
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.all, 10)
            
            ScrollView {
                LazyVGrid(columns: selectedLayout.columns, spacing: 1) {
                    
                    ForEach(insta.indices) { item in
                        
                        LayoutImageView(selectedLayout: $selectedLayout, instagram: insta[item], index: item)
                    }
                }

            }
        }
    }
}

struct LayoutImageView: View {
    
    @Binding var selectedLayout : LayoutType
    
    @Environment(\.presentationMode) var presentationMode

    var instagram : Insta
    
    @State private var isPresented = false
    var index : Int
    
    var body: some View {
        
        switch selectedLayout {
            case .double:
                
                ZStack(alignment: .bottom) {
                    Image(uiImage: UIImage(data: instagram.img!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .modifier(ContextModifier(instagram: instagram))
                        .onTapGesture {
                            self.isPresented.toggle()
                        }
                        .fullScreenCover(isPresented: $isPresented) {
                            didDismiss()
                        } content: {
                            FullView(indexCurrent: index)
                        }

                        
                    Text(instagram.user!)
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.3))
                        .clipShape(Capsule())
                }
                
                
            case .adaptive:
                Image(uiImage: UIImage(data: instagram.img!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
        }
    }
    
    func didDismiss() {
        print("Did Dismiss")
        }
}


struct FullView : View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Insta.user, ascending: true)],
        animation: .default)
    
    private var insta: FetchedResults<Insta>
    
    @Environment(\.presentationMode) var presentationMode

    @State var dragOffset = CGSize.zero

    @State var indexCurrent: Int

    @State var scale = false
    @State private var drag: CGSize = .zero
    
    var body: some View {

//        HStack {
//                Button("<") { if indexCurrent > 0 {
//                     indexCurrent -= 1
//                } }
//                Spacer().frame(width: 40)
//
//            Text("\(indexCurrent) | \(insta.count)").font(.largeTitle).foregroundColor(.red)
//
//            Button(">") { if indexCurrent < (insta.count - 1) {
//                     indexCurrent += 1
//                } }
//            }
        
        TabView(selection: $indexCurrent) {
            
            ForEach(insta) { item in
                
                ZStack(alignment: .topLeading) {
                    Image(uiImage: UIImage(data: insta[indexCurrent].img!)!)
                        .tag(indexCurrent)
                        .scaleEffect(scale ? 2 : 1)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                        .offset(drag)
                        .gesture(DragGesture().onChanged({ value in
                            self.drag = value.translation
                        }))
                        .onTapGesture(count: 2) {
                            self.scale.toggle()
                        }
                        
                        
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .frame(width: 100, height: 100)
                            
                    }
                    .padding([.top, .leading])

                }
                
                
            }
        }
        .tabViewStyle(.automatic)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .gesture(DragGesture().onChanged({ value in
            dragOffset = value.translation
            print(dragOffset)
            
//            if dragOffset.height > 200 {
//                self.presentationMode.wrappedValue.dismiss()
//            }
//            else if dragOffset.width > 100 && indexCurrent > 0 {
//                indexCurrent -= 1
//                print("-")
//
//            }
//            else if dragOffset.width > -100 && indexCurrent < (insta.count - 1) {
//                indexCurrent += 1
//                print("-")
//
//            }
        }))

    }
}


//struct ImageLayout_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ImageLayout(selectedLayout: .double)
//            ImageLayout(selectedLayout: .adaptive)
////                .previewLayout(.sizeThatFits)
//        }
//    }
//}
