//
//  ContentView.swift
//  Optical Character Recognition
//
//  Created by Minh Quan on 04/12/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var showScannerSheet = false
    @State private var texts: [ScanData] = []
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    if texts.count > 0 {
                        List {
                            ForEach(texts) { text in
                                NavigationLink {
                                    ScrollView{ Text(text.content)}
                                } label: {
                                    Text(text.content).lineLimit(1)
                                }

                            }
                        }
                    } else {
                        Text("No scan yet").font(.title)
                    }
                }
                    .navigationTitle("Scan OCR")
                    .navigationBarItems(trailing:
                                            Button(action: {
                        self.showScannerSheet = true
                    }, label: {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.title)
                    })
                    )
                    .sheet(isPresented: $showScannerSheet) {
                        cmakeScannerView()
                    }
                
            }
            
        }
        .padding()
    }
    
    private func cmakeScannerView() -> ScannerView {
        ScannerView { textPerPage in
            if let outoutText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outoutText)
                self.texts.append(newScanData)
            }
            self.showScannerSheet = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
