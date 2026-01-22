//
//  OreTier.swift
//  SMASHING
//
//  Created by 이승준 on 1/14/26.
//

import UIKit

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
    
    var tableTennisPercentage: String {
        switch self {
        case .iron:
            return "상위 100%"
        case .bronze:
            return "상위 80%"
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
    
    func percentage(sports: Sports) -> Int {
        switch sports {
        case .tableTennis:
            switch self {
            case .iron:
                return 100
            case .bronze:
                return 80
            case .silver:
                return 60
            case .gold:
                return 40
            case .platinum:
                return 20
            case .diamond:
                return 5
            case .challenger:
                return 1
            }
        case .tennis:
            switch self {
            case .iron:
                return 100
            case .bronze:
                return 80
            case .silver:
                return 50
            case .gold:
                return 30
            case .platinum:
                return 10
            case .diamond:
                return 3
            case .challenger:
                return 1
            }
        case .badminton:
            switch self {
            case .iron:
                return 60
            case .bronze:
                return 40
            case .silver:
                return 25
            case .gold:
                return 10
            case .platinum:
                return 10
            case .diamond:
                return 3
            case .challenger:
                return 1
            }
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
    
    var image: UIImage {
        switch self {
        case .iron:
            return UIImage.tierIron
        case .bronze:
            return UIImage.tierBronze
        case .silver:
            return UIImage.tierSliver
        case .gold:
            return UIImage.tierGold
        case .platinum:
            return UIImage.tierPlatium
        case .diamond:
            return UIImage.tierDiamond
        case .challenger:
            return UIImage.tierChallenger
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .iron:
            UIColor.Tier.ironText
        case .bronze:
            UIColor.Tier.bronzeText
        case .silver:
            UIColor.Tier.silverText
        case .gold:
            UIColor.Tier.goldText
        case .platinum:
            UIColor.Tier.platinumText
        case .diamond:
            UIColor.Tier.diamondText
        case .challenger:
            UIColor.Tier.challengerText
        }
    }
}

// MARK: - 종목별 기술 설명 생성

private extension OreTier {
    
    func tableTennisSkills() -> [SkillExplanation] {
        switch self {
        case .iron:
            return []
        case .bronze:
            return [
                SkillExplanation(name: "그립 (Grip)", explanation: "라켓을 올바르게 쥐는 법(쉐이크핸드/펜홀더)을 익혀 안정적인 타구의 기초를 다지는 단계입니다."
                                ),
                SkillExplanation(name: "포핸드 롱 (Forehand Long)", explanation: "가장 기초가 되는 스윙으로, 공을 정확하게 맞추고 넘기는 감각을 익히는 기술입니다."
                                ),
                SkillExplanation(name: "기본 서비스 (Basic Service)", explanation: "규칙에 맞는 올바른 토스와 타구로 경기를 시작하는 방법입니다."
                                )
            ]
        case .silver:
            return [
                SkillExplanation(name: "백핸드 쇼트 (Backhand Short)", explanation: "몸 쪽으로 오는 공을 가볍게 밀어내며 방어하고 연결하는 필수 기술."),
                SkillExplanation(name: "포핸드 스매시 (Smash)", explanation: "공높게 뜬 공을 강하게 내려쳐 득점을 결정짓는 공격 기술"),
                SkillExplanation(name: "기본 풋워크 (Footwork)", explanation: "공의 위치에 따라 잔발을 움직여 정확한 타구 위치를 잡는 스텝")
            ]
        case .gold:
            return [
                SkillExplanation(
                    name: "포핸드 드라이브 (Forehand Drive)",
                    explanation: "공에 전진 회전(Topspin)을 걸어 네트 높이보다 낮게 온 공도 공격적으로 넘기는 기술"
                ),
                SkillExplanation(
                    name: "백핸드 블록 (Block)",
                    explanation: "상대의 강한 공격을 라켓 면을 조절해 안정적으로 막아내는 수비 기술"
                ),
                SkillExplanation(
                    name: "커트 서비스 (Backspin Service)",
                    explanation: "공의 밑부분을 깎아 역회전을 줌으로써 상대가 공격하기 어렵게 만드는 서브"
                )
            ]
        case .platinum:
            return [
                SkillExplanation(
                    name: "백핸드 드라이브 (Backhand Drive)",
                    explanation: "백핸드 쪽으로 오는 공에도 회전을 걸어 선제 공격을 가하는 고급 기술"
                ),
                SkillExplanation(
                    name: "3구 공격 (3rd Ball Attack)",
                    explanation: "자신의 서브 후 리시브되어 넘어오는 공을 바로 공격하여 득점하는 전술"
                ),
                SkillExplanation(
                    name: "루프 드라이브 (Loop Drive)",
                    explanation: "강한 회전을 이용해 공의 궤적을 급격하게 떨어뜨려 상대를 교란하는 기술"
                )
            ]
        case .diamond:
            return [
                SkillExplanation(
                    name: "치키타 (Chiquita)",
                    explanation: "테이블 위에서 손목을 꺾어 백핸드로 짧은 공을 선제 공격하는 기술"
                ),
                SkillExplanation(
                    name: "카운터 드라이브 (Counter Drive)",
                    explanation: "상대가 건 드라이브의 회전을 이용해 더 강하게 되받아치는 최상위 기술"
                ),
                SkillExplanation(
                    name: "코스 공략 (Placement)",
                    explanation: "상대의 빈 곳이나 약점(미들, 사이드)을 순간적으로 파악해 공을 보내는 경기 운영 능력"
                )
            ]
        case .challenger:
            return []
        }
    }
    
    func tennisSkills() -> [SkillExplanation] {
        switch self {
        case .iron:
            return []
        case .bronze:
            return [
                SkillExplanation(name: "포핸드 스트로크", explanation: "기본 자세로 공을 넘기며 랠리를 이어갈 수 있는 수준"),
                SkillExplanation(name: "기본 풋워크", explanation: "공을 치고 멈추지 않고 전후·좌우 이동을 시도하는 단계"),
                SkillExplanation(name: "서브 인", explanation: "더블폴트 없이 서브를 넣어 게임을 시작할 수 있는 능력")
            ]
        case .silver:
            return [
                SkillExplanation(name: "백핸드 스트로크", explanation: "포핸드·백핸드로 기본적인 랠리를 유지할 수 있는 단계"),
                SkillExplanation(name: "크로스 랠리", explanation: "대각선 코스를 활용해 실수를 줄이며 랠리를 이어가는 플레이"),
                SkillExplanation(name: "리턴 안정성", explanation: "상대 서브를 받아내며 포인트를 시작할 수 있는 능력")
            ]
        case .gold:
            return [
                SkillExplanation(name: "탑스핀 포핸드", explanation: "회전을 활용해 깊이 있는 공격을 시도하는 주력 샷"),
                SkillExplanation(name: "네트 접근", explanation: "짧은 공을 인지하고 전진해 공격 기회를 만드는 판단"),
                SkillExplanation(name: "랠리 운영", explanation: "무리한 위너보다 코스와 깊이로 포인트를 설계하는 플레이")
            ]
        case .platinum:
            return [
                SkillExplanation(name: "서브 & 퍼스트 샷", explanation: "서브 이후 공격 흐름을 이어가는 패턴 플레이"),
                SkillExplanation(name: "발리 컨트롤", explanation: "네트 앞에서 안정적으로 포인트를 마무리하는 기술"),
                SkillExplanation(name: "풋워크 연계", explanation: "베이스라인과 네트를 오가는 이동을 끊김 없이 수행하는 능력")
            ]
        case .diamond:
            return [
                SkillExplanation(name: "공격 패턴 설계", explanation: "서브·포핸드·네트 플레이를 연결해 득점 루트를 만드는 전략"),
                SkillExplanation(name: "상대 약점 공략", explanation: "상대의 백핸드, 이동 방향 등을 지속적으로 공략하는 능력"),
                SkillExplanation(name: "경기 운영 완성도", explanation: "점수·체력·리스크를 종합적으로 관리하는 경기력")
            ]
        case .challenger:
            return []
        }
    }
    
    func badmintonSkills() -> [SkillExplanation] {
        switch self {
        case .iron:
            return []
        case .bronze:
            return [
                SkillExplanation(name: "클리어", explanation: "코트 뒤쪽으로 높고 길게 보내 상대를 뒤로 밀어내는 기본 스트로크"),
                SkillExplanation(name: "기본 풋워크", explanation: "제자리에서 멈추지 않고 전·후·좌·우로 이동하며 셔틀을 받는 기본 움직임"),
                SkillExplanation(name: "서비스", explanation: "규칙에 맞는 정확한 언더 서비스로 랠리를 안정적으로 시작하는 기술")
            ]
        case .silver:
            return [
                SkillExplanation(name: "드롭 샷", explanation: "네트 근처로 부드럽게 떨어뜨려 상대의 전진을 유도하는 컨트롤 샷"),
                SkillExplanation(name: "사이드 스텝", explanation: "좌우 이동 시 균형을 유지하며 빠르게 포지션을 잡는 풋워크"),
                SkillExplanation(name: "리턴 안정성", explanation: "상대의 서비스와 공격을 실수 없이 넘겨 랠리를 이어가는 능력")
            ]
        case .gold:
            return [
                SkillExplanation(name: "스매시", explanation: "점프 또는 스텝을 활용해 강한 각도로 공격하는 결정구"),
                SkillExplanation(name: "백핸드 클리어", explanation: "백코트에서 백핸드로 안정적인 수비 및 전환을 만드는 기술"),
                SkillExplanation(name: "랠리 운영", explanation: "무리한 공격보다 코스와 타이밍을 조절하며 흐름을 가져가는 플레이")
            ]
        case .platinum:
            return [
                SkillExplanation(name: "드라이브", explanation: "빠르고 낮은 궤적으로 셔틀을 주고받으며 압박하는 공격·전환 기술"),
                SkillExplanation(name: "네트 플레이", explanation: "헤어핀, 푸시 등 네트 앞에서 주도권을 잡는 세밀한 컨트롤"),
                SkillExplanation(name: "풋워크 연계", explanation: "공격 후 복귀, 수비 후 전환까지 끊김 없이 이어지는 움직임")
            ]
        case .diamond:
            return [
                SkillExplanation(name: "공격 패턴 설계", explanation: "스매시–드롭–네트 연계를 통해 득점 루트를 만드는 플레이"),
                SkillExplanation(name: "상대 분석 대응", explanation: "상대의 습관과 약점을 빠르게 파악해 전략적으로 공략하는 능력"),
                SkillExplanation(name: "경기 운영 완성도", explanation: "체력, 멘탈, 리스크 관리까지 포함한 안정적인 경기 컨트롤")
            ]
        case .challenger:
            return []
        }
    }
}

private extension OreTier {
    
    var tableTennisActualTier: String {
        switch self {
        case .iron: return ""
        case .bronze: return "실제 기준 뉴비"
        case .silver: return "실제 기준 E조"
        case .gold: return "실제 기준 D조"
        case .platinum: return "실제 기준 C조"
        case .diamond: return "실제 기준 B조"
        case .challenger: return ""
        }
    }
    
    var tennisActualTier: String {
        switch self {
        case .iron: return ""
        case .bronze: return "실제 기준 NTRP 2.0"
        case .silver: return "실제 기준 NTRP 3.0"
        case .gold: return "실제 기준 NTRP 3.5"
        case .platinum: return "실제 기준 NTRP 4.0"
        case .diamond: return "실제 기준 NTRP 4.5"
        case .challenger: return "실제 기준 NTRP 5.0"
        }
    }
    
    var badmintonActualTier: String {
        switch self {
        case .iron: return ""
        case .bronze: return "실제 기준 뉴비"
        case .silver: return "실제 기준 E조"
        case .gold: return "실제 기준 D조"
        case .platinum: return "실제 기준 C조"
        case .diamond: return "실제 기준 B조"
        case .challenger: return "실제 기준 A조"
        }
    }
}

struct SkillExplanation {
    let name: String
    let explanation: String
}
