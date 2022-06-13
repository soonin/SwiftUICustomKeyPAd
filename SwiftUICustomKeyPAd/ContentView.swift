//
//  ContentView.swift
//  SwiftUICustomKeyPAd
//
//  Created by Amir Hatami on 2022-06-12.
//

import SwiftUI

struct ContentView: View {
    @State var textView : String = ""
    @State var isKeyPadVisible : Bool = false
    
    var body: some View {
        VStack {
            Text(textView)
                .frame(width: 200, height: 60, alignment: .center)
                .foregroundColor(.white)
                .background(.blue)
                .font(.system(size: 36))
                .padding()
                .popover(isPresented: $isKeyPadVisible, attachmentAnchor: .point(.trailing), arrowEdge: .leading) {
                    ZStack{
                        Color.gray.scaleEffect(1.5).opacity(0.2)
                        CustomKeyPad(
                            string: $textView,
                            show: $isKeyPadVisible,
                            maxDigits: 8,
                            keyPadtype: .minus,
                            updateCallback: {
//                                $isKeyPadVisible.wrappedValue = false
                                isKeyPadVisible = false
                            },
                            updateMessage: {
                                print("\(textView)")
                            }
                        ).frame(width: KeyPadConstants.keyPadWidth, height: KeyPadConstants.KeyPadHeightWithDoneButton)
                            .interactiveDismissDisabled(true)
                    }
                }
        }.onTapGesture {
            isKeyPadVisible.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
