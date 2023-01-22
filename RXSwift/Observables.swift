//
//  Observables.swift
//  RXSwift
//
//  Created by Lugalu on 13/01/23.
//

import Foundation
import RxSwift

fileprivate func Observables(){
        //MARK: Ways of creating an Observable
        example(of: "just, of, from"){
            let one = 1
            let two = 2
            let three = 3

            let _ = Observable<Int>.just(one)
            let _ = Observable.of(one, two, three)
            let _ = Observable.of([one, two, three])
            let _ = Observable.from([one, two, three])
        }
        
        //MARK: Way of creating and subscribing
        example(of: "subscribe") {
            let one = 1
            let two = 2
            let three = 3

            let observable = Observable.of(one, two, three)
            //MARK: Default subscription
                let _ = observable.subscribe{ event in
                    print(event) // See as the type eg: next(1)
                    if let element = event.element {
                      print(element) //See as the element itself eg: 1
                    }
                }
            
            //MARK: onNextSubscription
            let _ = observable.subscribe(onNext: { element in
                print(element)
            })
            
            //MARK: Example of Empty
            example(of: "empty") {
              let observable = Observable<Void>.empty()
               let _ = observable.subscribe(
                  // 1
                  onNext: { element in
                    print(element)
                  },

                  // 2
                  onCompleted: {
                    print("Completed")
                  }
                )
            }
            
            //MARK: Example of never
            example(of: "never") {
                let disposeBag = DisposeBag()
                
                let observable = Observable<Void>.never().do(onSubscribe: {
                    print("Hey I subscribed!")
                }, onDispose: {
                    print("Hey never is disposed")
                })
                

                let _ = observable.subscribe().disposed(by: disposeBag)
                
                    
                    
            }
            
            //MARK: Range and fibonacci
            example(of: "range") {
              // 1
              let observable = Observable<Int>.range(start: 1, count: 10)

              let _ = observable
                .subscribe(onNext: { i in
                  // 2
                  let n = Double(i)

                  let fibonacci = Int(
                    ((pow(1.61803, n) - pow(0.61803, n)) /
                      2.23606).rounded()
                  )

                  print(fibonacci)
              })
            }
            
            //MARK: Dispose of observable
            example(of: "dispose") {
                let observable = Observable.of("A", "B", "C")

                let subscription = observable.subscribe { event in
                    print(event)
                }
                
                subscription.dispose()

            }
            
            //MARK: Dispose Bag
            example(of: "DisposeBag") {
                let disposeBag = DisposeBag()
                Observable.of("A", "B", "C")
                .subscribe { // 3
                    print($0)
                }
                .disposed(by: disposeBag) // 4
                
                
                
                //MARK: Create Example
                
                example(of: "create") {
                    let disposeBag = DisposeBag()
                    
                    enum MyError: Error {
                      case anError
                    }

                    
                    let _ = Observable<String>.create { observer in
                        observer.onNext("1")
                        observer.onError(MyError.anError)
                        observer.onCompleted()
                        observer.onNext("?")

                        return Disposables.create()
                    }
                    .subscribe(
                      onNext: { print($0) },
                      onError: { print($0) },
                      onCompleted: { print("Completed") },
                      onDisposed: { print("Disposed") }
                    )
                    .disposed(by: disposeBag)
                    
                    
                }
                
                //MARK: Factory Example
                example(of: "deferred") {
                    let disposeBag = DisposeBag()
                    var flip = false
                    let factory: Observable<Int> = Observable.deferred {
                        flip.toggle()
                        if flip {
                            return Observable.of(1, 2, 3)
                        } else {
                            return Observable.of(4, 5, 6)
                        }
                    }
                    
                    
                    for _ in 0...3 {
                      factory.subscribe(onNext: {
                        print($0, terminator: "")
                      })
                      .disposed(by: disposeBag)

                      print()
                    }
                    
                }

            //MARK: Traits
                example(of: "Single") {
                  let disposeBag = DisposeBag()

                  enum FileReadError: Error {
                    case fileNotFound, unreadable, encodingFailed
                  }

                  func loadText(from name: String) -> Single<String> {
                    return Single.create { single in
                        let disposable = Disposables.create()

                        guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                          single(.failure(FileReadError.fileNotFound))
                          return disposable
                        }

                        guard let data = FileManager.default.contents(atPath: path) else {
                          single(.failure(FileReadError.unreadable))
                          return disposable
                        }

                        guard let contents = String(data: data, encoding: .utf8) else {
                          single(.failure(FileReadError.encodingFailed))
                          return disposable
                        }

                        single(.success(contents))
                        return disposable

                    }
                  }
                    
                    loadText(from: "")
                        .subscribe(onSuccess: { value in
                            print("Success \(value)")
                        }, onFailure: { error in
                            print("Error \(error)")
                        })
                    
                }
                
                //MARK: Debug
                example(of: "Debug"){
                    let disposeBag = DisposeBag()
                    
                    let observable = Observable<Void>.never().debug("DebugNever")
                    
                    let _ = observable.subscribe().disposed(by: disposeBag)
        
                }
                
                

            }
            
        }
    }

public func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}
