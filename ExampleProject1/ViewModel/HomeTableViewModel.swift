//
//  HomeTableViewModel.swift
//  ExampleProject1
//
//  Created by Zachary Jensen on 1/15/21.
//

import Foundation

protocol HomeTableViewModelDelegate {
    func pdfsReady( _ errorMsg: String?)
}

enum SortType{
    case mostRecent
    case alphabeticalOrder
    case descLength
}

class HomeTableViewModel{
    
    var pdfs = [PDF]()
    var delegate : HomeTableViewModelDelegate?
    
    func loadPDFS(){
        
        PdfNetworking.shared.getPdfData { [weak self] (pdfs) in
            self?.pdfs = pdfs
            if let del = self?.delegate{
                del.pdfsReady(nil)
            }
        } _: { [weak self] (errorMsg) in
            if let del = self?.delegate{
                del.pdfsReady(errorMsg)
            }
        }
        
    }
    
    func sortPDFListBy(_ type: SortType){
        switch type {
        case .alphabeticalOrder:
            pdfs.sort(by: {$0.filename ?? "" < $1.filename ?? "" })
        case .descLength:
            pdfs.sort(by: {$0.description ?? "" > $1.description ?? "" })
        case .mostRecent:
            pdfs.sort(by: {$0.uploadedAt ?? 0 > $1.uploadedAt ?? 0 })
        }
    }
    
}
