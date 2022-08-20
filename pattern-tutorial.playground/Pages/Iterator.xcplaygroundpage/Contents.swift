import Foundation

/*
 MARK: 반복자 패턴
 이터레이터 패턴을 사용하면 기본 문법없이 컬렉션(리스트나 스택, 트리 등)의 요소를 이동할 수 있습니다.
 
 - Problem
 리스트 기반의 컬렉션(ex. Array)의 경우, 특정 원소에 접근하려면 그냥 루프를 돌면 됩니다.
 하지만 트리와 같은 복잡한 구조의 경우 DFS, BFS 외에 다양한 접근이 필요할 수도 있습니다.
 점점 많은 traversal 알고리즘을 추가하게 되면 효율적이지 않을 수도 있습니다.
 또한 컬렉션의 원소에 접근하는 다양한 방법을 제공하려면 특정 컬렉션의 클래스를 쓰는 방법 밖에 없습니다.
 
 - Solution
 이터레이터 패턴의 핵심은 컬렉션을 조회(traversal)하는 동작을 iterator라고 불리는 별도의 객체로 빼내는 것입니다.
 이터레이터 객체는 현재 위치, 마지막 요소까지 얼마나 남아있는 지와 같은 모든 정보를 캡슐화합니다.
 따라서 여러 이터레이터가 동시에 같은 컬렉션을 독립적으로 접근할 수 있습니다.
 이터레이터는 컬렉션의 요소가 반환되지 않을 때(모든 요소 조회)까지 이 메소드를 계속 실행할 수 있습니다.
 
 모든 iterator는 동일한 인터페이스를 구현하기 때문에 컬렉션의 유형(리스트, 트리 등), 조회하는 알고리즘과 호환이 됩니다.
 컬렉션을 조회하는 특별한 방법이 필요한 경우, 새 iterator 클래스를 작성하기만 하면 됩니다.
 */

class WordsCollection {
    fileprivate lazy var items: [String] = []
    
    func append(_ item: String) {
        self.items.append(item)
    }
}

extension WordsCollection: Sequence {
    func makeIterator() -> WordsIterator {
        return WordsIterator(self)
    }
}

class WordsIterator: IteratorProtocol {
    private let collection: WordsCollection
    private var index = 0
    
    init(_ collection: WordsCollection) {
        self.collection = collection
    }
    
    func next() -> String? {
        defer {
            index += 1
        }
        if index < collection.items.count {
            return collection.items[index]
        } else {
            return nil
        }
    }
}

class NumbersCollection {
    fileprivate lazy var items: [Int] = []
    func append(_ item: Int) {
        self.items.append(item)
    }
}

extension NumbersCollection: Sequence {
    func makeIterator() -> AnyIterator<Int> {
        var index = self.items.count - 1
        
        return AnyIterator {
            defer {
                index -= 1 // reversed
            }
            return index >= 0 ? self.items[index] : nil
        }
    }
}


// execution code
func execute<S: Sequence>(sequence: S) {
    for item in sequence {
        print(item)
    }
}

let words = WordsCollection()
words.append("apple")
words.append("orange")
words.append("banana")

execute(sequence: words)

let numbers = NumbersCollection()
numbers.append(0)
numbers.append(1)
numbers.append(2)

execute(sequence: numbers)
