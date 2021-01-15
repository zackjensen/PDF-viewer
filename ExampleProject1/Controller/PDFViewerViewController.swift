//
//  PDFViewerViewController.swift
//  ExampleProject1
//
//  Created by Zachary Jensen on 1/15/21.
//

import UIKit
import PDFKit
class PDFViewerViewController: UIViewController {

    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var pdfURL : String?
    
    // could have made viewmodel for this class if I had more time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PDF Viewer"
       
        validatePdfURL(pdfURL)
    }
    
    func setSpinnerToShowing(_ to: Bool){
        spinner.isHidden = !to
        if to{
            spinner.startAnimating()
        }else{
            spinner.stopAnimating()
        }
    }
    
    func validatePdfURL(_ urlStr : String?){
        
        if let url = pdfURL{
            loadPDF(url)
        }else{
            urlInvalidError()
        }
        
    }
    
    func setupPDFView(_ url: URL){
        
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
    }
    
    func loadPDF(_ urlStr: String){
        guard let url = URL(string: urlStr) else { return }
                
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
                
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlInvalidError(){
        let alert = UIAlertController(title: "Error", message: "This url is invalid", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (_) in
            self?.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
extension PDFViewerViewController:  URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destinationURL)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                self.setupPDFView(destinationURL)
            }
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
