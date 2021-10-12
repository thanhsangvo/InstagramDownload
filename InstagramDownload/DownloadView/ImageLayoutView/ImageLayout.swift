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

    var insta: FetchedResults<Insta>
    
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
                    
                    ForEach(insta) { item in
                        
                        LayoutImageView(selectedLayout: $selectedLayout, instagram: item, insta: insta)
                    }
                }

            }
        }
        .preferredColorScheme(.dark)
    }
}

struct LayoutImageView: View {
    
    @Binding var selectedLayout : LayoutType
    
    @Environment(\.presentationMode) var presentationMode

    @State var instagram : Insta
    @State var current = NSManagedObjectID()
    var insta : FetchedResults<Insta>
    @State private var isPresented = false
        
    var body: some View {
        
        switch selectedLayout {
                
            case .double:
                
                    Image(uiImage: UIImage(data: instagram.img!)!)
//                Image(instagram.img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .fullScreenCover(isPresented: $isPresented, onDismiss: {
                        
                    }, content: {
                        FullView(insta: insta, indexCurrent: $current)
                    })
                    .onTapGesture {
                        withAnimation {
                            current = instagram.objectID
                            isPresented.toggle()
                            print(current)
                        }
                    }
                
            case .adaptive:
                Image(uiImage: UIImage(data: instagram.img!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
        }
    }

}


struct FullView : View {

    @Environment(\.presentationMode) var presentationMode
    
    var insta : FetchedResults<Insta>
    @Binding var indexCurrent: NSManagedObjectID
    @State var fullPreview : Bool = false

    var body: some View {

        TabView(selection: $indexCurrent) {

            ForEach(insta) { post in
                
                GeometryReader { proxy in
                    
                    let size = proxy.size
                        
                        Image(uiImage: UIImage(data: post.img!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
//                            .overlay(
//                                Text("\(post.objectID)")
//                                    .foregroundColor(Color.green)
//                            )
                }
                .tag(post.objectID)
                .ignoresSafeArea()

            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .onTapGesture {
            withAnimation {
                fullPreview.toggle()
            }
        }
        .overlay(
            
            topOverlay()
            .padding(10)
            .background(BlurView(style: .systemThinMaterialDark).ignoresSafeArea())
            .offset(y: fullPreview ? -150 : 0),
            alignment: .top
        )

        .overlay(
            
            ScrollViewReader { proxy in
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 10) {
                        
                        ForEach(insta) { post in
                            
                            Image(uiImage: UIImage(data: post.img!)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .cornerRadius(12)
                                .padding(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.white, lineWidth: 2)
                                        .opacity(indexCurrent == post.objectID ? 1 : 0)
                                )
                                .id(post.objectID)
                                .onTapGesture {
                                    withAnimation {
                                        indexCurrent = post.objectID
                                    }
                                }
                        }
                    }
                }
                .frame(height: 65)
                .background(BlurView(style: .systemUltraThinMaterialDark).ignoresSafeArea())
                .onChange(of: indexCurrent) { _ in

                    withAnimation {
                        proxy.scrollTo(indexCurrent, anchor: .bottom)
                    }
                }
            }
                .offset(y: fullPreview ? 150 : 0),
            alignment: .bottom
        )
    }
    @ViewBuilder
    func topOverlay() -> some View {
        
        HStack {
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.down.square.fill")
                    .font(.system(size: 20))
            }
            
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.octagon")
                .font(.system(size: 20))
                
            }

        }
    }
}


struct ImageLayout_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImageLayout(selectedLayout: .double)
//            ImageLayout(selectedLayout: .adaptive)
//                .previewLayout(.sizeThatFits)
        }
    }
}



struct BlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        
    }
    
}
