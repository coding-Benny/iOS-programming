//
//  StillImageViewController.swift
//  ch08-cameraCoreML
//
//  Created by JeongHyeon Lee on 2021/04/13.
//

import UIKit

class StillImageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(takePicture))
        imageView.addGestureRecognizer(tapGesture)
        
        messageLabel.layer.borderWidth = 2
        messageLabel.layer.borderColor = UIColor.red.cgColor
        // 반드시 설정하여야 한다
        imageView.isUserInteractionEnabled = true
    }
}

extension StillImageViewController {
    @objc func takePicture(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        
        // UIImagePickerController가 활성화 된다
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension StillImageViewController {
    // 사진을 캡쳐하는 경우 호출하는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // 사진을 가져온다
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // 가져온 사진을 UIImageView에 나타나도록 한다
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 사진 캡쳐를 취소하는 경우 호출하는 함수
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
