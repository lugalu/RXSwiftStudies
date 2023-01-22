//
//  Subjects.swift
//  RXSwift
//
//  Created by Lugalu on 13/01/23.
//

import Foundation
import RxSwift

func Subjects(){
    //MARK: Publish Subjects
    example(of: "PublishSubject"){
        let subject = PublishSubject<String>()
        
        subject.on(.next("HELLO"))
        
        let subscription = subject.subscribe(onNext: { valeu in
            print(valeu)
        })
        
        subject.on(.next("Hello World"))
        subject.onNext("Test")
        
        let subscriptionTwo = subject
          .subscribe { event in
            print("2)", event.element ?? event)
          }
        
        subject.onNext("Another test")
        subscription.dispose()
        subject.onNext("Another Test Test")
        
        subject.onCompleted()
        
        subject.onNext("5")

        // 3
        subscriptionTwo.dispose()

        let disposeBag = DisposeBag()

        // 4
        subject
          .subscribe {
            print("3)", $0.element ?? $0)
          }
          .disposed(by: disposeBag)

        subject.onNext("?")
        
    }
    
    
    //MARK: Behaviour
    example(of: "BehaviorSubject") {
        let subject = BehaviorSubject(value: "Initial value")
        let disposeBag = DisposeBag()
        
        subject.onNext("X")
        
        subject
          .subscribe {
            customprint(label: "1)", event: $0)
          }
          .disposed(by: disposeBag)
        
        // 1
        subject.onError(MyError.anError)

        // 2
        subject
          .subscribe {
              customprint(label: "2)", event: $0)
          }
          .disposed(by: disposeBag)
        
        
    }
    
    //MARK: Replay
    example(of: "ReplaySubject") {
        // 1
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        let disposeBag = DisposeBag()
        
        // 2
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        // 3
        subject
          .subscribe {
            customprint(label: "1)", event: $0)
          }
          .disposed(by: disposeBag)

        subject
          .subscribe {
              customprint(label: "2)", event: $0)
          }
          .disposed(by: disposeBag)
        
        subject.onNext("4")
        subject.onError(MyError.anError)

        subject.dispose()
        subject
          .subscribe {
            customprint(label: "3)", event: $0)
          }
          .disposed(by: disposeBag)

    }

    //MARK: 
    
}

enum MyError: Error {
  case anError
}

public func customprint<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, (event.element ?? event.error) ?? event)
}
