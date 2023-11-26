//
//  WorkViewController.swift
//  SirmaTask
//
//  Created by Ahd on 11/26/23.
//

import UIKit

import Combine

class WorkViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataVeiw: UIView!
    @IBOutlet weak var emptyDataLabel: UILabel!
   
    var viewModel: WorkViewModel?
    
    private var subscribers: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Projects details"
        self.navigationController?.navigationBar.tintColor = .black
        
        tableView.register(UINib.init(nibName: String(describing: WorkRecordCell.self), bundle: .main), forCellReuseIdentifier: String(describing: WorkRecordCell.self));
        
        tableView.register(UINib.init(nibName: String(describing: WorkRecordsTableViewHeader.self), bundle: .main), forHeaderFooterViewReuseIdentifier: String(describing: WorkRecordsTableViewHeader.self))
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    
    func configureView(filePath: URL) {
        self.viewModel = WorkViewModel()
        viewModel?.filePath = filePath;
        viewModel?.$longestPairWorkProjects
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _  in
                self?.updateView()
            }.store(in: &subscribers)
        
    }
    
    func updateView() {
        guard let viewModel = viewModel else {
            return
        }
        
        if let message = viewModel.emptyDataMessage {
            self.contentView.isHidden = true
            self.emptyDataVeiw.isHidden = false
            self.emptyDataLabel.text = message
            
        } else  {
            self.tableView.reloadData()
            self.emptyDataVeiw.isHidden = true
            self.contentView.isHidden = false
        }
    }
}

extension WorkViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.longestPairWorkProjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WorkRecordCell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorkRecordCell.self)) as! WorkRecordCell
        
        if let record = viewModel?.longestPairWorkProjects?[indexPath.row] {
            cell.configureCell(pair: record, highlighted: indexPath.row % 2 != 0 );
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: WorkRecordsTableViewHeader.self))
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
