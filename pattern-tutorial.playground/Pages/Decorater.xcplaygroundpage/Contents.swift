import Foundation

/*
 MARK: 데코레이터 패턴
 동작이 포함된 특정 wrapper 객체 내부에 또 다른 객체를 배치하여 객체에 새 동작을 부착할 수 있는 구조 패턴.
 
 - Problem
 클라이언트로부터 메시지 argument를 받아서 이메일을 보내는 Notifier 클래스가 있다.
 클라이언트는 Notifier 객체를 한 번 만들고 configure한 다음 이벤트가 발생할 때마다 사용하고 있다.
 
 유저가 SMS나 페이스북, Slack을 통해 알림을 받고 싶어한다면, Notifier 클래스를 확장하고 추가 기능을 서브 클래스에 추가합니다.
 이제 클라이언트는 '보내고자하는 Notifier 클래스'를 생성하여 사용합니다.
 
 만약 한번에 여러 알림 타입을 사용하고 싶다면..
 -> 한 클래스에 여러 알림 타입을 합친 서브 클래스(ex. SMS+Slack Notifier)를 만든다.
 Notifier 코드 뿐만 아니라 클라이언트 코드까지 엄청 커진다는 단점.
 
 - Solution
 객체의 동작을 변경해야할 때 클래스를 상속하는 것은 몇 가지 단점이 있습니다.
 1. 상속은 정적이라 런타임에 기존 객체의 동작을 변경할 수 없습니다. 객체를 하위클래스에서 만든 다른 객체로만 바꿀 수 있습니다.
 2. 하위 클래스는 하나의 상위 클래스만 가질 수 있습니다. (다중 상속 X)
 
 위 문제를 해결하기 위해 한 객체가 다른 객체에 대한 참조를 가지고 일부 작업을 위임(delegate)하는 방법이 있습니다.
 
 "Wrapper"는 데코레이터 패턴의 대체 별명인데요. 래퍼는 target 객체와 연결할 수 있는 객체입니다.
 래퍼는 target과 동일한 메소드들이 있고 수신되는 모든 요청을 위임합니다. 또한 래퍼는 target에 요청을 전달하기 전후로
 어떤 작업을 수행함으로써 결과를 변경할 수 있습니다.
 
 래퍼는 wrapped되는 객체와 동일한 인터페이스를 갖기때문에 클라이언트 입장에서보면 두 객체는 똑같아 보입니다.
 래퍼의 참조 필드에 이 인터페이스를 따르는 객체를 허용하도록 하면 객체를 여러 래퍼로 덮어 모든 래퍼의 결합된 동작을 추가할 수 있습니다.
 
 아래 예제에서는 기본 Notifier 클래스 내에 메일 알람 동작은 그대로 두고 추가적인 알림 방법을 데코레이터로 전환합니다.
 니즈에 맞게 기본 Notifier 객체를 데코레이터의 set으로 wrap하여 결과적으로 스택처럼 구성됩니다.
 모든 데코레이터가 기본 Notifier와 동일한 인터페이스를 구현하고 스택의 마지막 데코레이터는 실제로 작업하는 객체입니다.
 notifier.send("Alert") // Email -> Facebook -> Slack
 */

protocol DataSource {
    func writeData(_ data: String)
    func readData() -> String
}

struct FileDataSource: DataSource {
    private let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func writeData(_ data: String) {
        print("write \(data)")
    }
    
    func readData() -> String {
        print("read \(fileName) data")
        return "\(fileName)'s data"
    }
}

class DataSourceDecorator: DataSource {
    let wrappee: DataSource
    
    init(source: DataSource) {
        self.wrappee = source
    }
    
    func writeData(_ data: String) {
        wrappee.writeData(data)
    }
    
    func readData() -> String {
        wrappee.readData()
    }
}

class EncryptionDecorator: DataSourceDecorator {
    override func writeData(_ data: String) {
        // data를 encrypt 한다
        wrappee.writeData("encrypt \(data)")
    }
    
    override func readData() -> String {
        let data = wrappee.readData()
        // 읽어온 데이터를 decrypt 한다
        return data
    }
}

class CompressionDecorator: DataSourceDecorator {
    override func writeData(_ data: String) {
        // 데이터를 compress 한다
        wrappee.writeData("compress \(data)")
    }
    
    override func readData() -> String {
        let data = wrappee.readData()
        // 데이터를 decompress 한다
        return data
    }
}

var source: DataSource = FileDataSource(fileName: "keyword.txt")
let data = "abcd"
source.writeData(data)

source = CompressionDecorator(source: source)
source.writeData(data)

source = EncryptionDecorator(source: source)
source.writeData(data)
