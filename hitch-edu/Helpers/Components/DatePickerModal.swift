//
//  DatePickerModal.swift
//  hitch-edu
//
//  Created by Godson Umoren on 11/21/24.
//

import SwiftUI


struct DatePickerTextField: UIViewRepresentable {
    @Binding var date: Date?
    let placeholder: String
    let dateFormatter: DateFormatter
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DatePickerTextField
        
        init(_ parent: DatePickerTextField) {
            self.parent = parent
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.date = sender.date
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.tintColor = .clear
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        
        // Create UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        
        // Set UIDatePicker as the input view for the text field
        textField.inputView = datePicker
        
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // Add a flexible space to push the Done button to the right
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: textField, action: #selector(textField.resignFirstResponder))

        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar

        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let date = date {
            uiView.text = dateFormatter.string(from: date)
        } else {
            uiView.text = nil // Keep the placeholder visible
        }
    }
}
//#Preview {
//    @Previewable @State var date: Date?
//    @Previewable @State var placeholder: String = "Select a Date"
//    
//    DatePickerModal(date: $date, placeholder: $placeholder) { date in
//        return date?.formatted() ?? "No Date Selected"
//    }
//}
