import Foundation

/*
 MARK: 템플릿 메서드 패턴
 부모 클래스에서 알고리즘의 틀(template method)을 정의,
 자식 클래스는 구조를 변경하지 않고 알고리즘의 특정 단계를 override할 수 있도록 하는 패턴.

 - Problem
 문서를 분석하는 데이터 마이닝 앱을 만든다고 가정합니다.
 사용자는 다양한 포맷(pdf, doc, csv)로 문서를 전송하고 유의미한 데이터를 추출하고자 합니다.
 어느 순간, 각 포맷에 대하여 파일에서 데이터 추출을 하는 과정에서 중복 코드가 많다는 것을 알게 됩니다.

 세 개의 포맷을 처리하는 각각의 클래스가 모두 공통 인터페이스나 base 클래스를 갖고 있다면
 처리하는 객체에서 해당 메소드를 호출할 때 다형성을 사용할 수 있습니다.

 - Solution
 템플릿 메소드 패턴은 알고리즘을 단계별 메소드로 나누고 이 메소드에 대한
 호출들을 single template method안에 넣습니다. 이 과정은 abstract하거나 기본 구현이 있을 수 있습니다.

 클라이언트는 알고리즘 사용을 위해 하위 클래스를 제공하고 모든 추상 단계를 구현하며
 필요한 경우 일부 메소드를 재정의 해야 합니다. (템플릿 메서드 자체는 아님)

 먼저, 모든 단계를 abstract로 선언하고 서브 클래스가 자체 구현하도록 강제합니다.
 데이터 마이닝 앱의 경우 서브클래스는 이미 필요한 구현이 되어있으므로 부모 클래스의 메소드만 조정하면 됩니다.
 중복 코드를 제거하기 위해 할 수 있는 일을 찾아보자면
 파일 열기/닫기, 데이터 파싱 코드는 데이터 형식에 따라 다르므로 이 부분을 건드는건 의미가 없습니다.
 그러나 raw 데이터를 분석하고 보고서를 작성하는 코드는 유사하므로 base 클래스로 끌어올릴 수 있습니다.

 정리하자면..
 1. 모든 서브클래스에서 abstract 메소드가 구현된다.
 2. 기본 구현은 이미 되어있고 필요하다면 오버라이드 한다.
 */

protocol HomeMakable {
    func makeHome() // template method
    func makeContract()
    func collectResources()
    func makeDoor()
    func makeRoom()
}

extension HomeMakable {
    func makeHome() {
        makeContract()
        collectResources()
        makeDoor()
        makeRoom()
    }
    
    func makeDoor() {
        print("base implement make door")
    }
    
    func makeRoom() {
        print("base implement make room")
    }
    
    func makeContract() {
        print("not required contract")
    }
}

struct Company: HomeMakable {
    func collectResources() {
        print("collect required Resource..")
    }
    
    func makeContract() {
        print("override.. make contract")
    }
}

let instance = Company()
instance.makeHome()
