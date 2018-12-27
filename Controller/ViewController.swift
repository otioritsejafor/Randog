//
//  ViewController.swift
//  Randog
//
//  Created by Oti Oritsejafor on 12/23/18.
//  Copyright © 2018 Magloboid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var selected: Int = 0
    var breeds: [String] = []// = ["greyhound", "poodle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerView.dataSource = self
        pickerView.delegate = self
        DogAPI.requestDogBreedsList(completionHandler: self.handleBreedListResponse(data:error:))
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
            self.pickerView.reloadAllComponents()
        }
    }
    
    func handleRandomImageResponse(data: DogImage?, error: Error?) {
        guard let data = data else {
            return
        }
        DogAPI.requestImageFile(imageFileURL: URL(string: data.message)!, completionHandler: self.handleImageFileResponse(image:error:))
    }
    
    func handleBreedListResponse(data: [String]?, error: Error?) {
        guard let data = data else {
            return
        }
        breeds = data
        DispatchQueue.main.async {
            self.selected = self.pickerView.selectedRow(inComponent: 0)
        }
        DogAPI.requestRandomImage(breed: self.breeds[selected], completionHandler: self.handleRandomImageResponse(data:error:))

        }

}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        DogAPI.requestRandomImage(breed: breeds[row]) {
            (dogImageData, error) in
            self.handleRandomImageResponse(data: dogImageData, error: error)
        }
        
    }
    
    
}
