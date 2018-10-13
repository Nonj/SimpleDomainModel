//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  private let currencyVals : [String] = ["USD", "CAN", "GBP", "EUR"]
  
    
  public init( amount : Int, currency : String) {
    if !self.currencyVals.contains(currency) {
        NSException(name:NSExceptionName(rawValue: "Currency"), reason:"Not Supported Currency", userInfo:nil).raise()
    }
    self.amount = amount
    self.currency = currency
  }
  
  public func convert(_ to: String) -> Money {
    switch self.currency {
        
        case self.currencyVals[0]: // USD
            switch to {
            case self.currencyVals[1]: // TO CAN
                return Money(amount: Int(Double(self.amount) * 1.25), currency: "CAN" )
                
            case self.currencyVals[2]: // TO GBP
                return Money(amount: Int(Double(self.amount) * 0.5), currency: "GBP" )
            
            case self.currencyVals[3]: // TO EUR
                return Money(amount: Int(Double(self.amount) * 1.5), currency: "EUR" )
            default:
                return Money(amount: self.amount, currency: self.currency)
            }
        
        case self.currencyVals[1]: // CAN
            switch to {
            case self.currencyVals[0]: // TO USD
                return Money(amount: Int(Double(self.amount) * 0.8), currency: "USD" )
                
            case self.currencyVals[2]: // TO GBP
                return Money(amount: Int((Double(self.amount) * 0.8) * 0.5), currency: "GBP" )
                
            case self.currencyVals[3]: // TO EUR
                return Money(amount: Int((Double(self.amount) * 0.8) * 1.5), currency: "EUR" )
            default:
                return Money(amount: self.amount, currency: self.currency)
            }
        
        case self.currencyVals[2]: // GBP
            switch to {
            case self.currencyVals[0]: // TO USD
                return Money(amount: Int(Double(self.amount) * 2.0), currency: "USD" )
                
            case self.currencyVals[1]: // TO CAN
                return Money(amount: Int((Double(self.amount) * 2.0) * 1.25), currency: "CAN" )
                
            case self.currencyVals[3]: // TO EUR
                return Money(amount: Int((Double(self.amount) * 2.0) * 1.5), currency: "EUR" )
            default:
                return Money(amount: self.amount, currency: self.currency)
            }
        
        default: // EUR
            switch to {
            case self.currencyVals[0]: // TO USD
                return Money(amount: Int(Double(self.amount) * (2.0/3.0)), currency: "USD" )
                
            case self.currencyVals[1]: // TO CAN
                return Money(amount: Int((Double(self.amount) * (2.0/3.0)) * 1.25), currency: "CAN" )
                
            case self.currencyVals[2]: // TO GBP
                return Money(amount: Int((Double(self.amount) * (2.0/3.0)) * 0.5), currency: "GBP" )
            default:
                return Money(amount: self.amount, currency: self.currency)
            }
    }
    
  }
  
  public func add(_ to: Money) -> Money {
    return to.currency == self.currency ? Money(amount: self.amount + to.amount, currency: self.currency) : Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
    
  }
    
  public func subtract(_ from: Money) -> Money {
    return from.currency == self.currency ? Money(amount: self.amount - from.amount, currency: self.currency) : Money(amount: self.amount - from.convert(self.currency).amount, currency: self.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Salary(let incomeAmt):
        return incomeAmt
        
    case .Hourly(let incomeAmt):
        return Int(incomeAmt * Double(hours))
    }
  }
  
    
  open func raise(_ amt : Double) {
    switch self.type {
    case .Salary(let incomeAmt):
        type = .Salary(Int(amt + Double(incomeAmt)))
        
    case .Hourly(let incomeAmt):
        type = .Hourly(incomeAmt + amt)
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return self._job}
    set(value) {
        if self.age > 15 {
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return self._spouse}
    set(value) {
        if self.age > 17 {
            self._spouse = value
        }
        
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self._job) spouse:\(self._spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    
    self.members.append(spouse1)
    self.members.append(spouse2)
  }
  
  open func haveChild(_ child: Person) -> Bool {
    let personOverTwentyOne : Int = max(self.members[0].age, self.members[1].age)
    if personOverTwentyOne < 21 {
        return false
    }
    self.members.append(child)
    return true
  }
  
  open func householdIncome() -> Int {
    var familyIncome : Int? = 0
    
    for i in self.members {
        let income : Int? = i.job?.calculateIncome(2000)
        if income != nil {
           familyIncome! += income!
        }
        
    }
    return familyIncome!
  }
}





