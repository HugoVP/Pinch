//
//  ContentView.swift
//  Pinch
//
//  Created by Hugo Vázquez Paleo on 12/12/24.
//

import SwiftUI

struct ContentView: View {
    // MARK: Properties
    
    @State private var isAnimating = false
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let pages = pagesData
    
    @State private var pageIndex: Int = 1
    
    // MARK: Functions
    
    func resetAnimation() {
        withAnimation(.spring) {
            imageScale = 1.0
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    // MARK: Content
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                
                // MARK: Page Image
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) { // MARK: Tap Gesture
                        if imageScale == 1.0 {
                            withAnimation(.spring) {
                                imageScale = 5.0
                            }
                        } else {
                            withAnimation(.spring) {
                                resetAnimation()
                            }
                        }
                    }
                    .gesture(DragGesture()
                        .onChanged { value in
                            withAnimation(.linear(duration: 1)) {
                                imageOffset = value.translation
                            }
                        }
                        .onEnded { _ in
                            if imageScale <= 1.0 {
                                withAnimation(.spring) {
                                    resetAnimation()
                                }
                            }
                        }
                    )
                    .gesture( // MARK: Magnification
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1.0 && imageScale < 5.0 {
                                        imageScale = value
                                    } else if imageScale > 5.0 {
                                        imageScale = 5.0
                                    }
                                }
                            }
                            .onEnded { _ in
                                if imageScale > 5.0 {
                                    imageScale = 5.0
                                } else if imageScale <= 1.0 {	
                                    resetAnimation()
                                }
                            }
                    )
            } //: ZStack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
            .overlay( // MARK: Info Panel
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30),
                alignment: .top
            )
            .overlay( // MARK: Controls
                Group {
                    HStack {
                        // Scale down
                        Button {
                            if imageScale > 1.0 {
                                imageScale -= 1.0
                                
                                if imageScale <= 1.0 {
                                    resetAnimation()
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        // Reset
                        Button {
                            resetAnimation()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // Scale up
                        Button {
                            withAnimation(.spring) {
                                if imageScale < 5.0 {
                                    imageScale += 1.0
                                    
                                    if imageScale > 5.0 {
                                        imageScale = 5.0
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                        
                    } //: Controls
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30),
                alignment: .bottom
            )
            .overlay( // MARK: Drawer
                HStack(spacing: 12) {
                    // MARK: Drawer handle
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    // MARK: Thumbnails
                    
                    ForEach(pages) { item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = item.id
                            }
                    }
                    
                    Spacer()
                } //: Drawer
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 16))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215),
                alignment: .topTrailing
            )
            
            
            
        } //: Navigation
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
