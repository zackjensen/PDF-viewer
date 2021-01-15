//
//  HomeTableViewController.swift
//  ExampleProject1
//
//  Created by Zachary Jensen on 1/15/21.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    //MARK: - Variables
    
    var homeTableViewModel : HomeTableViewModel!
    
    //MARK: - IBActions / IBOutlets
    
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    
    @IBAction func filterBtnPressed(_ sender: Any) {
        showFilterMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableViewModel = HomeTableViewModel()
        homeTableViewModel.delegate = self
        homeTableViewModel.loadPDFS()
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeTableViewModel.pdfs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PDFTableViewCell
        let pdf = homeTableViewModel.pdfs[indexPath.row]
        cell.descTextView.text = pdf.description ?? ""
        cell.fileNameLbl.text = pdf.filename ?? ""
        cell.uploadedAtLbl.text = "\(pdf.uploadedAt ?? 0)" // we could format this any way we want in terms of date
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPDFWithURL(homeTableViewModel.pdfs[indexPath.row].url)
    }
    
    // MARK: - Functions
    
    private func showPDFWithURL(_ urlStr: String?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PDFViewerViewController") as! PDFViewerViewController
        vc.pdfURL = urlStr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(_ msg : String){
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showFilterMenu(){
        let alert = UIAlertController(title: "Filter", message: "How would you like to filter the results", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Most Recent", style: .default, handler: { [weak self] (_) in
            self?.homeTableViewModel.sortPDFListBy(.mostRecent)
            self?.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Alphabetical Order", style: .default, handler: { [weak self] (_) in
            self?.homeTableViewModel.sortPDFListBy(.alphabeticalOrder)
            self?.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Description Length", style: .default, handler: { [weak self] (_) in
            self?.homeTableViewModel.sortPDFListBy(.descLength)
            self?.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
extension HomeTableViewController : HomeTableViewModelDelegate{
    
    func pdfsReady(_ errorMsg: String?) {
        if let error = errorMsg{
            self.showError(error)
        }else{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
