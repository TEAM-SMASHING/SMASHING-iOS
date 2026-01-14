//
//  OreTier.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

enum OreTier: String, CaseIterable {
    case iron = "Iron"
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    case diamond = "Diamond"
    case challenger = "Challenger"
    
    func skills(sports: Sports) -> [SkillExplanation] {
        switch sports {
        case .tableTennis:
            return tableTennisSkills()
        case .tennis:
            return tennisSkills()
        case .badminton:
            return badmintonSkills()
        }
    }
    
    func actualTier(sports: Sports) -> String {
        switch sports {
        case .tableTennis:
            return tableTennisActualTier
        case .tennis:
            return tennisActualTier
        case .badminton:
            return badmintonActualTier
        }
    }
    
    var percentage: String {
        switch self {
        case .iron:
            return "상위 100%"
        case .bronze:
            return "상위 70%"
        case .silver:
            return "상위 50%"
        case .gold:
            return "상위 30%"
        case .platinum:
            return "상위 10%"
        case .diamond:
            return "상위 3%"
        case .challenger:
            return "상위 1%"
        }
    }
    
    var index: Int {
        switch self {
        case .iron:
            return 0
        case .bronze:
            return 1
        case .silver:
            return 2
        case .gold:
            return 3
        case .platinum:
            return 4
        case .diamond:
            return 5
        case .challenger:
            return 6
        }
    }
}

// MARK: - 종목별 기술 설명 생성

private extension OreTier {
    
    func tableTennisSkills() -> [SkillExplanation] {
        switch self {
        case .iron:
            return [
                SkillExplanation(name: "기본 그립", explanation: "라켓을 올바르게 잡고 손목의 힘을 빼는 법을 익힙니다."),
                SkillExplanation(name: "준비 자세", explanation: "상대의 공에 반응하기 위한 기본 스탠스를 배웁니다."),
                SkillExplanation(name: "포핸드 롱", explanation: "가장 기초적인 타법으로 공을 정확히 맞추는 연습을 합니다.")
            ]
        case .bronze:
            return [
                SkillExplanation(name: "백핸드 쇼트", explanation: "상대의 공격을 가볍게 밀어내어 방어하는 기술입니다."),
                SkillExplanation(name: "커트(푸시)", explanation: "하회전 공을 안전하게 넘기는 기초적인 수비 기술입니다."),
                SkillExplanation(name: "기본 서브", explanation: "회전 없이 정확하게 상대 코트로 공을 보내는 법을 익힙니다.")
            ]
        case .silver:
            return [
                SkillExplanation(name: "포핸드 드라이브", explanation: "상향 전회전을 걸어 공을 공격적으로 보내기 시작합니다."),
                SkillExplanation(name: "횡회전 서브", explanation: "공의 옆면을 맞춰 상대의 리시브 실수를 유도합니다."),
                SkillExplanation(name: "풋워크(사이드스텝)", explanation: "공의 위치에 따라 발을 빠르게 움직여 타점을 잡습니다.")
            ]
        case .gold:
            return [
                SkillExplanation(name: "백핸드 드라이브", explanation: "백사이드에서 전회전을 걸어 공격을 전개합니다. 백사이드에서 전회전을 걸어 공격을 전개합니다. 백사이드에서 전회전을 걸어 공격을 전개합니다."),
                SkillExplanation(name: "스매싱", explanation: "높게 뜬 공을 강한 힘으로 내리쳐 득점합니다."),
                SkillExplanation(name: "3구 공격", explanation: "본인의 서브 후 돌아오는 공을 바로 공격으로 연결합니다.")
            ]
        case .platinum:
            return [
                SkillExplanation(name: "치키타", explanation: "백핸드 측면 회전을 사용하여 상대의 짧은 공을 공격합니다."),
                SkillExplanation(name: "카운터 드라이브", explanation: "상대의 드라이브를 맞드라이브로 받아칩니다."),
                SkillExplanation(name: "돌아서기 포핸드", explanation: "백코너로 오는 공을 포핸드로 처리하기 위해 빠르게 움직입니다.")
            ]
        case .diamond:
            return [
                SkillExplanation(name: "훅 서브/YG 서브", explanation: "복잡한 회전의 고급 서브로 랠리의 주도권을 잡습니다."),
                SkillExplanation(name: "대상 플레이(스톱)", explanation: "네트 근처의 공을 아주 짧게 놓아 상대의 선제 공격을 막습니다."),
                SkillExplanation(name: "중진 드라이브", explanation: "탁구대와 떨어진 거리에서도 강력한 위력을 유지합니다.")
            ]
        case .challenger:
            return [
                SkillExplanation(name: "전술적 코스 공략", explanation: "상대의 약점과 움직임을 읽고 정확한 코스로 공을 보냅니다."),
                SkillExplanation(name: "극한의 회전 제어", explanation: "어떤 상황에서도 공의 회전량을 자유자재로 조절합니다."),
                SkillExplanation(name: "경기 운영 및 심리전", explanation: "서브와 리시브 전술을 통해 경기의 전체 흐름을 지배합니다.")
            ]
        }
    }
    
    func tennisSkills() -> [SkillExplanation] {
        switch self {
        case .iron:
            return [
                SkillExplanation(name: "그립 체인지", explanation: "포핸드와 백핸드 상황에 맞춰 그립을 바꾸는 법을 익힙니다."),
                SkillExplanation(name: "스플릿 스텝", explanation: "상대가 치는 순간 가볍게 뛰어 반응 속도를 높입니다."),
                SkillExplanation(name: "플랫 서브", explanation: "가장 기본적인 형태로 네트를 넘겨 서브를 넣습니다.")
            ]
        case .silver:
            return [
                SkillExplanation(name: "슬라이스", explanation: "공에 하회전을 걸어 낮게 깔리게 보내는 기술입니다."),
                SkillExplanation(name: "네트 발리", explanation: "네트 근처에서 공이 바운드되기 전에 처리합니다."),
                SkillExplanation(name: "더블 폴트 방지", explanation: "안정적인 세컨드 서브를 확보합니다.")
            ]
        case .platinum:
            return [
                SkillExplanation(name: "킥 서브", explanation: "공이 튀어 오른 후 상대 몸쪽이나 바깥쪽으로 크게 휘게 합니다."),
                SkillExplanation(name: "어프로치 샷", explanation: "찬스 볼을 치고 네트로 전진하여 압박을 가합니다."),
                SkillExplanation(name: "로브", explanation: "전진한 상대의 키를 넘기는 높은 궤적의 샷을 구사합니다.")
            ]
        default:
            return [
                SkillExplanation(name: "기본 스트로크", explanation: "일관성 있는 포핸드와 백핸드를 구사합니다."),
                SkillExplanation(name: "탑스핀", explanation: "공에 순회전을 걸어 안정적인 궤적을 만듭니다."),
                SkillExplanation(name: "전략적 배치", explanation: "상대의 빈 공간을 찾아 스트로크를 보냅니다.")
            ]
        }
    }
    
    func badmintonSkills() -> [SkillExplanation] {
        switch self {
        case .iron:
            return [
                SkillExplanation(name: "하이클리어", explanation: "셔틀콕을 높고 멀리 보내 시간을 확보합니다."),
                SkillExplanation(name: "언더핸드 스트로크", explanation: "낮게 오는 셔틀콕을 위로 퍼올립니다."),
                SkillExplanation(name: "롱 서브", explanation: "단식에서 주로 쓰이는 높고 깊은 서브를 배웁니다.")
            ]
        case .gold:
            return [
                SkillExplanation(name: "점프 스매시", explanation: "도약하여 체중을 실어 강력하게 내리칩니다."),
                SkillExplanation(name: "헤어핀", explanation: "네트를 살짝 넘겨 상대의 네트 앞 실수를 유도합니다."),
                SkillExplanation(name: "드라이브", explanation: "네트 높이로 빠르게 직선으로 셔틀콕을 보냅니다.")
            ]
        case .challenger:
            return [
                SkillExplanation(name: "디셉티브 샷", explanation: "치는 순간 자세를 바꿔 상대를 속이는 고급 기술입니다."),
                SkillExplanation(name: "크로스 넷 킬", explanation: "네트 앞 찬스를 대각선 방향으로 빠르게 끝냅니다."),
                SkillExplanation(name: "연속 공격 전환", explanation: "수비 상황에서 단숨에 공격으로 전환하는 능력을 갖춥니다.")
            ]
        default:
            return [
                SkillExplanation(name: "드롭 샷", explanation: "상대 코트 네트 근처에 셔틀콕을 툭 떨어뜨립니다."),
                SkillExplanation(name: "푸시", explanation: "네트 위로 뜨는 셔틀콕을 빠르게 눌러 칩니다."),
                SkillExplanation(name: "수비 리턴", explanation: "상대의 스매시를 안정적으로 받아냅니다.")
            ]
        }
    }
}

private extension OreTier {
    
    var tableTennisActualTier: String {
        switch self {
        case .iron: return "입문(새싹)"
        case .bronze: return "6부"
        case .silver: return "5부"
        case .gold: return "4부"
        case .platinum: return "3부"
        case .diamond: return "2부"
        case .challenger: return "1부 이상"
        }
    }
    
    var tennisActualTier: String {
        switch self {
        case .iron: return "NTRP 1.5 (입문)"
        case .bronze: return "NTRP 2.0 (초보)"
        case .silver: return "NTRP 2.5 (신인부)"
        case .gold: return "NTRP 3.0 (오픈부)"
        case .platinum: return "NTRP 3.5 (베테랑)"
        case .diamond: return "NTRP 4.0 (지도자급)"
        case .challenger: return "NTRP 4.5+ (선출급)"
        }
    }
    
    var badmintonActualTier: String {
        switch self {
        case .iron: return "초심"
        case .bronze: return "D조"
        case .silver: return "C조"
        case .gold: return "B조"
        case .platinum: return "A조"
        case .diamond: return "전국 A조"
        case .challenger: return "자강(자유강습)"
        }
    }
}

struct SkillExplanation {
    let name: String
    let explanation: String
}
