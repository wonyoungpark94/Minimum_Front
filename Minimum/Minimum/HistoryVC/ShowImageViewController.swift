//
//  ShowImageViewController.swift
//  Minimum
//
//  Created by park wonyoung on 2021/03/30.
//

import UIKit

class ShowImageViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //뿌려줄 data
    var imagePath : String?
    var date : String?
    //var str : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = date!
        print(date)
        
        //경로 받아와서 이미지 뿌려주기
        var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //print(documentsPath)

        let arr = imagePath!.components(separatedBy: "/")
        let slash = "/"
        
        let tempPath = slash + arr[2] //위치만 딱 받아옴
        print(tempPath)
        
        documentsPath.append(tempPath)
        imageView.image = UIImage(contentsOfFile: documentsPath)
        
        
        
        //print(imagePath)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
