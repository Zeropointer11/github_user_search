import Foundation

extension Array {
    
    func item(at index : Int) -> Element? {
        if self.count > index { return self[index] }
        else { return nil }
    }
    
}
