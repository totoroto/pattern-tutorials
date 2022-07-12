/*
 MARK: 컴포지트 패턴
 Composite는 앱의 핵심 모델을 트리 구조로 구성한 다음, 이 구조(트리)를 개별 객체인 것처럼 작업할 수 있는 구조 설계 패턴.
 
 - Problem
 'Products'와 'Boxes' 객체가 있다고 가정합시다.
 Box에는 여러 개의 Product, 여러 개의 작은 Box들이 포함될 수 있습니다.
 
 이러한 클래스를 사용하여 주문 시스템을 만들어 봅시다.
 주문에는 Box없이 Product만 들어있을 수도 있고 Product로 채워진 Box, Box로 채워진 Box도 있을 수 있습니다.
 주문의 총 가격을 정해야 한다면 어떻게 해야할까요?
 
 모든 상자를 까본 후 제품을 계산하는 직접적인 방법이 있긴 합니다.
 하지만 제품 및 상자의 종류, 상자가 얼마나 중첩되어 있는지 알고 있어야 하기 때문에 루프를 도는것은 적합한 방법이 아닙니다.
 
 - Solution
 Composite 패턴은 총 가격을 계산하는 메서드를 가진 공통 인터페이스를 통해 Product와 Box를 다룹니다.
 
 Product: 제품 가격 리턴
 Box: 상자에 들어있는 것들을 검토하고 이 상자의 총액을 반환합니다.
      상자 안에 상자가 있다면 모든 내부 요소의 가격이 계산될 때 까지 검토합니다.
      상자의 포장 금액도 일부 있을 수 있습니다.
 
 Composite 패턴의 이점은 트리를 구성하는 객체의 구체적인 정보에 대해 신경쓸 필요가 없다는 것입니다.
 공통 인터페이스를 통해 모두 동일하게 취급할 수 있습니다.
 메소드를 호출하면 객체 자체가 요청을 트리의 노드들로 전달합니다.
 */


protocol Component {
    var parent: Component? { get set }
    func execute() -> String
}

// MARK: - Tree

struct Composite: Component {
    var parent: Component?
    private var children: [Component] = []
    
    mutating func add(child: Component) {
        var item = child
        item.parent = self
        children.append(item)
    }
    
    mutating func remove(child: Component) {
        print("remove child")
    }
    
    func getChildren() -> [Component] {
        return children
    }
    
    func execute() -> String {
        // delegate all work to child components
        let result = children.map { $0.execute() }
        return "\(result.joined(separator: " ")) |"
    }
}

// MARK: - Node
struct Leaf: Component {
    var parent: Component?
    
    func execute() -> String {
        return "leaf"
    }
}

struct Leaf1: Component {
    var parent: Component?
    
    func execute() -> String {
        return "leaf1"
    }
}

// MARK: -
var tree = Composite()
var node1 = Composite()
node1.add(child: Leaf())
node1.add(child: Leaf1())

var node2 = Composite()
node2.add(child: Leaf1())
node2.add(child: Leaf())

tree.add(child: node1)
tree.add(child: node2)

print(tree.execute())
