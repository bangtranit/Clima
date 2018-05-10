//
//  ChangeCtityViewController.swift
//  Clima
//
//  Created by Tran Thanh Bang on 2018/05/09.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredNameCity(cityName : String)
}

class ChangeCtityViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    var delegate : ChangeCityDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickToGetWeatherOfCity(_ sender: UIButton) {
        delegate?.userEnteredNameCity(cityName: cityTextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
