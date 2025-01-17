//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ben Gohlke on 5/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum OperatorType: String {
	//+, −, ×, ÷
    case division = "÷"
	case multiplication = "×"
	case subtraction = "−"
	case addition = "+"
}

class CalculatorBrain {
    var operand1String = ""
    var operand2String = ""
    var operatorType: OperatorType?
	var numberFormatter: NumberFormatter = {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		return numberFormatter
	}()
    
    func addOperandDigit(_ digit: String) -> String {
		guard let _ = operatorType else {
			if digit == "." {
				operand1String = safelyAddDecimal(operand1String)
			} else {
				operand1String.append(digit)
			}
			return operand1String
		}
		
		if digit == "." {
			operand2String = safelyAddDecimal(operand2String)
		} else {
			operand2String.append(digit)
		}
		return operand2String
    }
    
    func setOperator(_ operatorString: String) {
		if operatorType == nil {
			operatorType = OperatorType(rawValue: operatorString)
		}
    }
    
    func calculateIfPossible() -> String? {
		if let operatorType = operatorType {
			if operand2String.isEmpty {
				operand2String = operand1String
			}
			guard let number1 = Double(operand1String), let number2 = Double(operand2String) else { return nil}
			var answer = ""
			
			switch operatorType {
			case .addition: answer = ("\(number1 + number2)")
			case .division: answer = ("\(number1 / number2)")
			case .multiplication: answer = ("\(number1 * number2)")
			case .subtraction: answer = ("\(number1 - number2)")
			}
			
			operand1String = dropUnecessaryDecimal(answer)
			clearOperands()
			return operand1String
		}
        return nil
    }
	
	func invertNumber() -> String {
		if operatorType == nil {
			operand1String = invert(operand1String)
			return operand1String
		}
		
		operand2String = invert(operand2String)
		return operand2String
	}
	
	func convertToPercentage() -> String {
		if operatorType == nil {
			operand1String = fractionize(operand1String)
			return operand1String
		}
		
		operand2String = fractionize(operand2String)
		return operand2String
	}
	
	private func dropUnecessaryDecimal(_ digitString: String) -> String {
		let digits = digitString.components(separatedBy: ".")
		if digits.last == "0" {
			return digits[0]
		}
		return digitString
	}
	
	private func safelyAddDecimal(_ digitString: String) -> String {
		if digitString.contains(".") {
			return digitString
		}
		return "\(digitString)."
	}
	
	private func clearOperands() {
		operand2String = ""
		operatorType = nil
	}
	
	private func invert(_ digitString: String) -> String {
		if digitString.isEmpty || digitString == "0" {
			return "0"
		} else if digitString.contains("-") {
			let positiveDigit = String(digitString.dropFirst(1))
			return positiveDigit
		}
		
		return "-\(digitString)"
	}
	
	private func fractionize(_ digitString: String) -> String {
		if let digit = Float(digitString) {
			return "\(digit / Float(100))"
		}
		return "0"
	}
}
