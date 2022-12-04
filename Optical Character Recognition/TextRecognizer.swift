//
//  TextRecognizer.swift
//  Optical Character Recognition
//
//  Created by Minh Quan on 04/12/2022.
//

import Vision
import Foundation
import VisionKit

final class TextRecognizer {
    
    let cameraScan: VNDocumentCameraScan
    
    private let queue = DispatchQueue(label: "scan-codes", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    
    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }
    
    func recognizeText(withCompletionHandler completionHandler: @escaping ([String]) -> Void) {
        queue.async {
            let image = (0..<self.cameraScan.pageCount).compactMap {
                self.cameraScan.imageOfPage(at: $0).cgImage
            }
            
            let imagesAndRequests = image.map({(image: $0, request: VNRecognizeTextRequest())})
            let textPerPage = imagesAndRequests.map { (image, request) -> String in
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do {
                    try handler.perform([request])
                    guard let observations = request.results else { return "" }
                    return observations.compactMap({ $0.topCandidates(1).first?.string}).joined(separator: "\n")
                } catch {
                    print(error)
                    return ""
                }
            }
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}
