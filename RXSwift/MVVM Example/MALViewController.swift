//
//  MALViewController.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit

class MALViewController: UIViewController {
    let viewModel: MALViewModel
    
    init(viewModel: MALViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = MALViewModel()
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MALViewController: UICollectionViewDelegate{
    
}
