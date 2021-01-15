//
//  PdfNetworking.swift
//  ExampleProject1
//
//  Created by Zachary Jensen on 1/15/21.
//

import Foundation


// NOTE: would have had an additional layer where the core networking is handled in a diff module, and this one simply provides headers, endpoint if i had more time

// would have enum for end points as well

class PdfNetworking{
    
    static let shared = PdfNetworking()
    
    
    func getPdfData(_ successBlock: @escaping (( _ pdfData: [PDF]) -> Void) , _ failureBlock : @escaping ((_ errorMsg: String) -> Void)){
        
        guard let url = URL(string: "https://us-central1-mobile-developer-challenge.cloudfunctions.net/listFiles") else {
            failureBlock("error with url")
            // would log this somewhere as well
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{return}
            do{
                let pdfs = try JSONDecoder().decode([PDF].self, from: data)
                successBlock(pdfs)
            }
            catch{
                print(error)
                // would need to log this as well
            }
        }

        task.resume()
        
    }
    

    
    
}
