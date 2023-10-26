import SwiftUI

struct SimplePickerView: View {
    @State private var selectedOption = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        VStack {
            Picker("Select an option:", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Text("Selected option: \(selectedOption)")
            
            Button(action: {
                print("Selected option: \(selectedOption)")
            }) {
                Text("Print Selection")
            }
        }
    }
}

struct SimplePickerView_Previews: PreviewProvider {
    static var previews: some View {
        SimplePickerView()
    }
}
