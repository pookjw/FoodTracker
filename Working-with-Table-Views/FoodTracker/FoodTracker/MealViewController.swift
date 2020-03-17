//
//  MealViewController.swift
//  FoodTracker
//
//  Created by pook on 3/15/20.
//  Copyright © 2020 pookjw. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    var meal: Meal?
    
    override func viewDidLoad() {
        print("ViewController: viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewController: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewController: viewDidAppear")
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            if textField == nameTextField {
                mealNameLabel.text = textField.text
            } else if textField == descriptionTextField {
                descriptionLabel.text = textField.text
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn: \(textField.text!)")
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    // MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "Default Text"
        descriptionLabel.text = "Default Description"
    }
    @IBAction func setFiveStars(_ sender: UIButton) {
        self.ratingControl.rating = 5
    }
    @IBAction func selectImageFromPhotoLibrary(_ sender: UIButton) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: {print("Hello! 1")})
        print("Hello! 2")
    }
    
    //MARK: Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        dismiss(animated: true, completion: {print("Hello! 3")})
        print("Hello! 4")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}

