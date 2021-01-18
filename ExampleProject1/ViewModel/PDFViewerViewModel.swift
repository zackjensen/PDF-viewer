//
//  PDFViewerViewModel.swift
//  ExampleProject1
//
//  Created by Zachary Jensen on 1/18/21.
//

import UIKit

class PDFViewerViewModel{
    
    func setSpinnerToShowing(_ to: Bool, _ spinner: UIActivityIndicatorView){
        spinner.isHidden = !to
        if to{
            spinner.startAnimating()
        }else{
            spinner.stopAnimating()
        }
    }
    
    func validatePdfURL(_ urlStr : String?, _ delegate : URLSessionDownloadDelegate, completion: ((_ validURL : Bool) -> Void)){
        
        if let url = urlStr{
            loadPDF(url, delegate)
        }else{
            completion(false)
        }
        
    }
    
    private func loadPDF(_ urlStr: String, _ delegate : URLSessionDownloadDelegate){
        guard let url = URL(string: urlStr) else { return }
                
        let urlSession = URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue())
                
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
}
