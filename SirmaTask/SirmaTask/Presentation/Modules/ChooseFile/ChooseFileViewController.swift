//
//  ChooseFileViewController.swift
//  SirmaTask
//
//  Created by Ahd on 11/24/23.
//

import UIKit
import UniformTypeIdentifiers

class ChooseFileViewController: UIViewController {
    
    @IBOutlet weak var chooseFileView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configureView() {
        self.chooseFileView.layer.cornerRadius = 15.0
        self.chooseFileView.clipsToBounds = true
    }
    
    //MARK: - Utilities
    
    func showFilePicker() {
        let filePicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.commaSeparatedText, .aiff, .compositeContent])
        filePicker.delegate = self
        filePicker.allowsMultipleSelection = false
        present(filePicker, animated: true, completion: nil)
    }
    
    func pushWorkViewController(filePath: URL) {
        guard let  navigationController = navigationController else {
            return
        }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main);
        let vc: WorkViewController = storyboard.instantiateViewController(identifier:String(describing: WorkViewController.self)) as WorkViewController;
        
        navigationController.pushViewController(vc, animated: true);
        vc.configureView(filePath: filePath)
        
    }
    
    //MARK: - Actions
    
    @IBAction func didTapChooseFileView(_ sender: Any) {
        self.showFilePicker()
    }
    
}

extension ChooseFileViewController:UIDocumentPickerDelegate {
    // MARK: - UIDocumentPickerDelegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        
        controller.dismiss(animated: true) {[weak self] in
            self?.pushWorkViewController(filePath: url)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
}


