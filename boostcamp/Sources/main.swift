import Foundation

//////////////////////////////////////////////// 과제 코드 시작

// 수료자 스트링 어레이 선언
var completor : [String] = []

// ABCDF 성적 나누는 함수 선언
func alphabetGrader (name:String, grade:Float) -> String {
    
    switch grade {
        
    case 90..<100:
        completor.append(name)
        return ("A")
        
    case 80..<90:
        completor.append(name)
        return("B")
        
    case 70..<80:
        completor.append(name)
        return ("C")
        
    case 60..<70:
        return ("D")
        
    case 0..<60:
        return ("F")
    default:
        return("Grade Error")
    }
}

// 홈디렉토리 가져오는 코드
var directoryShort = NSHomeDirectory()



// json파일 가져오는 경로 설정
let path : String = directoryShort + "/students.json"
let url = URL(fileURLWithPath: path)

// 데이터 로드
let data = try! Data(contentsOf: url)

// 시리얼라이즈
let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)

// Any 타입 어레이로 변환
let jsonArray = json as? [Any]


// 전체평균 구하기 위한 플롯 선언
var totalGrade:Float = 0
var totalStudentNum: Float = 0

// 학생과 점수 딕셔너리 선언
var theGrade : Dictionary<String, String> = [String: String]()

// Json 파싱
for student in jsonArray! {
    let studentDict = student as! [String: Any]
    let grade = studentDict["grade"] as! [String:Int]
    let name = studentDict["name"] as! String
    var studentSum : Float = 0
    var subjectNum : Float = 0
    for (_, value) in grade {
        var valueFloat = Float(value)
        studentSum = studentSum + valueFloat
        subjectNum += 1
    }
    
    //학생 평균
    var studentAvg = studentSum/subjectNum
    studentAvg = (studentAvg * 100).rounded() / 100
    
    totalGrade += studentAvg
    
    // 학생 종합 평가
    let alphabetGrade = alphabetGrader(name:name, grade:studentAvg)
    theGrade[name] = alphabetGrade
    
    // 학생 수 세는 코드
    totalStudentNum += 1
}

// 전체 평균 구하는 코드
let avgGrade = totalGrade/totalStudentNum


// TXT 위한 스트링 만드는 코드
var text = "성적결과표\n\n전체 평균 : "
text += String(avgGrade)
text += "\n\n개인별 학점\n"
for (key, value) in theGrade.sorted(by: <) {
    let blankNum = 11 - key.characters.count
    let blank = String(repeating: " ", count: blankNum)
    text += key + blank + ": " + value + "\n"
}
text += "\n"
text += "수료생\n"
for (index, com) in completor.sorted().enumerated() {
    if (index == 0) {
        text += com
    }
    else {
        text += ", " + com
    }
}

// 저장할 디렉토리와 파일 명
let saveDirectory = directoryShort + "/result.txt"

// 파일 쓰는 코드
do {
    try text.write(toFile: saveDirectory, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print("File Write fail")
}

////////////////////////////////////////////////////////////// 과제 코드 끝
