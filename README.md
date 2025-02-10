# War3 Reinforcement Learning Monster

<br><br><br>

## 작업시점

2024년 6월

<br><br><br>

## 사용한 환경 버전

게임 : Warcraft III (1.28 JN Loader) <br>
에디터 : JN Editor <br>
언어 : JASS

<br><br><br>

## 문제에 대한 정의

게임 내 몬스터가 불특정한 실제 사람 상대로, <br>
게임을 이기기위한 최적 액션 찾기

<br><br><br>

## 문제 선정 동기

게임 장르중에 소울라이크라는 장르가 있습니다. 해당 장르는 유저가 난이도 높은 몬스터와 치열한 1:1 전투를 합니다. <br>
보통 이런 장르에서 몬스터를 제작하는 경우, <br>
특정 상태에서 랜덤 패턴으로 액션을 취하거나, 제작자가 고정적으로 설정해놓은 액션을 취하게 됩니다. <br>
그러나 이런 방식으로 몬스터를 제작하지 않고, 강화학습을 이용해서 다양한 상태를 정의한 후, <br>
학습을 통해 리워드를 극대화 하는 액션을 수행하는 몬스터를 제작하려고 하는게 주제 선정 동기입니다.

<br><br><br>

##  환경에 대한 설명

해당 게임은 넓은 공간에 유저 1명과 몬스터 1마리가 배치됩니다. <br>
유저와 몬스터는 1:1로 전투를 하게 되며, <br> 
유저는 700의 체력, 몬스터는 1000의 체력을 가집니다. <br> 
유저와 몬스터는 서로 공격을 할 수 있고, 한쪽이 죽어야만 게임이 끝납니다. <br> 
게임이 끝난다는 것은, 강화학습 관점에서 한 에피소드가 끝남을 의미합니다.

![image](https://github.com/user-attachments/assets/c083a8a9-7481-442b-8289-cd783a02830d)

<br>

유저는 공격스킬과, 대쉬 스킬을 가지고 있습니다. <br>
유저의 공격은 40의 데미지를 가집니다. <br>
대쉬는 빠르게 공간을 이동하면서, 0.35초의 무적시간을 가집니다.

<br>

![image](https://github.com/user-attachments/assets/49a506e6-cb96-4421-8239-de43e96be7fc)

몬스터는 10가지 액션을 가지고 있습니다. <br> 

Back_Step <br> 
Jump_Attack <br> 
Fast_Attack <br> 
Center_Attack <br> 
Big_Attack <br>

들이 액션으로 존재하고, 해당 액션에 약간의 변형을 가해서 액션을 1개씩 더 추가한 구조입니다. <br>
모든 액션에는 넉백 효과가 포함되어 있으며, <br>
중앙공격, 큰 공격 같은 경우 딜레이가 기므로 넉백효과가 크게 작용합니다.

<br><br>

### Back Step

![backstep](https://github.com/user-attachments/assets/55154cb9-85fc-41b0-a418-0245d313c4dc)

백스텝은 유저로 부터 멀어지는 액션입니다. <br>
유저로부터 360의 거리만큼 멀어지게 되며, 착지시 공격 효과도 가지고 있습니다. <br>
음수 백스텝은 해당 백스텝 함수에 인자를 음수값으로 넣었으며, <br>
유저를 향해서 돌진하는 효과를 가지게 됩니다. <br>

<br><br>

### Fast Attack

![fast](https://github.com/user-attachments/assets/ad8bc6ca-a470-4502-8f10-338b2478172b)

빠른 공격은 사거리가 짧고 범위가 좁지만, 딜레이를 낮게 주었습니다. <br>

<br><br>

### Center Attack

![center](https://github.com/user-attachments/assets/dcf35553-05cc-45f7-b49e-0c76466ad15a)

중앙공격은 적당히 큰 딜레이를 가지고, <br>
몬스터 주위의 큰 넓은 원형 범위로 공격합니다. <br>

<br><br>

### Big Attack

![1](https://github.com/user-attachments/assets/9669f5f8-f992-4f0a-81e5-f1d4ec3a2fda)

큰 공격은, 긴 딜레이 시간을 가지나, <br>
딜레이 기간동안 유저를 타게팅하면서 회전하며, <br>
사거리가 굉장히 깁니다. 

<br><br>

### Jump Attack

![jump](https://github.com/user-attachments/assets/994e3bb5-4a86-4a92-9d57-96a83b1121ac)

점프공격은 1.2초의 딜레이를 가지면서 크게 점프해서 유저를 향해서 점프하고, <br>
착지후 넓은 범위를 공격하는 액션입니다. <br>
해당 액션 수행시, 유저와 몬스터 사이의 거리를 계산한후, 해당 거리를 dist라 할때, <br>
dist-100, 이랑 dist+100 으로 해서 액션을 나누었습니다. <br>

<br><br><br><br>

![image](https://github.com/user-attachments/assets/84cef5c9-fe76-4e36-9a80-635222b5653a)

소울라이크 장르는 사거리라는 요소가 굉장히 중요합니다. <br>
그래서 유저와 몬스터의 거리에 대한 상태를 정의하였습니다.

유저와 몬스터의 거리는

200 미만, <br>
200\~300, <br>
300\~400, <br>
… <br>
900~1000, <br>
Far <br>

등으로 상태를 정의하였고, 갯수는 총 10개 입니다.

<br><br><br>

![1](https://github.com/user-attachments/assets/7f0ddeef-c05c-47ac-9862-65ac86d7648f)

유저와 몬스터는 서로 치열하게 공격을 주고 받습니다. <br>
그렇기에 타격 상태라는 것을 정의 했고, 해당 상태에 기반해서 리워드를 줍니다. <br>

불린변수 2개를 이용해서 상태 4개를 나타냈습니다. <br>
USER_ATTACKED <br>
MONSTER_ATTACKED <br>
불린 변수가 존재합니다. <br>

해당 변수들은 몬스터가 액션을 취하기 직전에 둘 다 false 로 초기화 되며, <br>
유저가 몬스터를 타격하면 MONSTER_ATTACKED 변수가 true, <br>
몬스터가 유저를 타격하면 USER_ATTACKED 변수가 true가 됩니다

<br><br><br>

![image](https://github.com/user-attachments/assets/3f31d9df-2939-4d3c-b41c-4a7f2c36353a)

최종적으로, <br>
거리 상태 10개, 타격상태 4개의 카테시안 곱으로 상태가 40개가 존재하며, <br>
거기에 유저가 죽었을 경우, MONSTER_WIN 상태 그리고 몬스터가 죽었을 경우 USER_WIN 상태 2개를 더해서 총 42개가 존재하게 됩니다. <br>

![image](https://github.com/user-attachments/assets/ba0c6f15-a53c-4d6e-9e0c-0967c18e6889)

위 그림과 같이 타격 상태를 판별해서, 정수를 더해줍니다. <br>

정수 0 \~ 9 인 경우, 유저와 몬스터 둘다 타격받지 않음 상태이고, <br>
10 \~ 19는 몬스터만 타격받은 상태, <br>
20 \~ 29는 유저만 타격받은 상태, <br>
30 \~ 39는 유저와 몬스터 둘다 타격 받은 상태를 나타냅니다. <br>

정수 0~41 의 숫자로 상태를 모두 표현할 수 있게 되며, <br>
액션은 10개 존재하므로, state-action pair의 갯수는 4*10 = 400개에 <br>
final state인 MONSTER_WIN이랑  USER_WIN 상태를 더해서 <br>
최종적으로 402개의 state-action pair를 가집니다. <br>

<br><br><br>

추가적으로 한 에피소드의 포맷은 항상 일정하지만, <br>
불특정 다수의 사람들에 대해서 학습을 진행하기에 환경이 계속 바뀐다고 볼 수 있습니다. <br>
어떤 사람은 게임을 못할 수도, 어떤 사람은 게임을 잘할 수도 있습니다. <br>
하지만 시행횟수가 높아질 수록, 사람에 대한 환경변수는 결국 평균적인 실력의 사람으로 수렴하게 될 것입니다. <br>
그래서 해당 강화학습은 평균적인 실력의 사람에 대한 학습이라고 볼 수 있습니다. <br>

<br><br><br>

## 사용한 강화학습 알고리즘

![image](https://github.com/user-attachments/assets/32e33ace-d630-45b8-9c3b-0c246906cf5d)

불특정한 실제 사람을 상대로 몬스터가 학습을 해야합니다. <br>
사람이 어떻게 행동할지는 알 수 없으므로, Model Free Learning 강화학습 알고리즘을 채택해야 합니다. <br>
위와 같은 상황에서 채택할 알고리즘은 대표적으로 <br>

MC(Monte Carlo) <br>
TD(Temporal Difference) <br>

방식을 생각할 수 있습니다. <br>

몬테카를로 같은 경우, 문제가 episodic 해야만 채택할 수 있는데, 현 문제도 episodic 하므로 MC 알고리즘을 채택 할 수 있습니다. <br>
그러나 에피소드가 종료되고나서 final state부터 initial state까지 일련의 리턴값을 계산해나가야 하므로, 에피소드의 길이가 길면 computation 압박이 세집니다. <br>
현 문제는 전투가 빠르게 끝날 수도 혹은 오래 걸릴 수도 있습니다. <br>
그래서 구현도 용이하고 computation 압력도 낮은 TD의 on policy 알고리즘인 SARSA를 채택하게 되었습니다. <br>

<br><br><br>

## 강화학습 관련 코드에 대한 설명

![image](https://github.com/user-attachments/assets/c1955908-51dd-45d8-8654-3bb18487927f)

해당 게임은 유즈맵이라는 형태로 존재하며, 유즈맵은 워크래프트3 에서 플레이 할 수 있습니다. <br>
게임 커뮤니티에 해당 유즈맵을 올렸고, 불특정 다수가 유즈맵을 다운받아 플레이하면서, 학습에대한 데이터를 제공해주었습니다. <br>
사람들은 각 로컬에서 플레이 하므로, 학습에 대한 Q table은 서버상에 존재하게 됩니다. <br>

![image](https://github.com/user-attachments/assets/fb7858db-58fb-4a22-bbe0-1e162cccd773)

유저들이 게임을 플레이할 때마다, <br>
서버에서 스트링 형태의 Q table 정보를 Load 해오고, 해당 스트링으로 게임 내에서 사용 할 수 있는 Q table로 빌드 합니다. <br>
게임을 플레이하면서 Q table이 계속 업데이트 되며, 에피소드가 끝나면 <br>
다시 서버로 해당 Q table을 스트링 형태로 바꾼 후 서버에 올리게 됩니다. <br>

![image](https://github.com/user-attachments/assets/d2741c03-3963-424f-99ca-dfdc5317f58d)

그리고 total reward 도 계산해서 서버에 로그를 남깁니다.<br>

<br><br><br>

![image](https://github.com/user-attachments/assets/32a827e9-789e-4c04-b73a-2d10c4ed2e00)

해쉬테이블을 사용해서 Q_Table을 만들었습니다. <br>
Key 값으로 state와 action이 존재합니다.<br>

![image](https://github.com/user-attachments/assets/5d6ffc9f-614a-47f3-adaa-856b8b85a83c)

![image](https://github.com/user-attachments/assets/eb384b2b-42d2-4670-896e-41b76727f9ed)

거리 상태는 0~9 까지 존재하고, 타격 상태에 기반해서 padding 의 값이 바뀝니다. <br>

final state 를 의미하는 MONSTER_WIN, USER_WIN 까지, <br>

최종적으로 state는 42개의 정수 값 0~41을 이용하게 됩니다 <br>


![image](https://github.com/user-attachments/assets/c253ba09-6700-42a1-8206-8faf176436b0)

action은 10개의 정수 값 0~9를 이용하였습니다.<br>

![image](https://github.com/user-attachments/assets/658c3e38-16e8-400a-948b-85849cce4ace)

상태 42개, action 10개 <br>

![image](https://github.com/user-attachments/assets/8273889c-4853-4cfa-95fb-7f170b702cf3)

Get_State() 라는 함수는, 거리값을 인자로 받고 <br>
타격상태와 거리상태에 기반해서 state를 리턴해줍니다<br>

<br><br><br>

![image](https://github.com/user-attachments/assets/9e9dd461-56ca-4313-a6af-44dab00d2836)

alpha <br>
gamma <br>
epsilon <br>
은 Learning rate 관련 하이퍼 파라미터 입니다 <br>
적당한 강화 학습 예제에서 알파 값으로 0.4 를 썼길래 저도 0.4를 사용하였습니다. <br>
gamma 값도 높게 0.99를 사용하길래 0.99를 사용했습니다. <br>
엡실론 값은 state-action pair 갯수가 402개 이므로 exploration이 중요하다 생각해서 0.5로 설정하였습니다. <br>

![image](https://github.com/user-attachments/assets/6d70c214-7cfb-4cc1-a8d9-07490322d23f)


그 외에 total reward 계산을 위한 변수가 존재합니다. <br>

<br><br><br>

![image](https://github.com/user-attachments/assets/f161a566-71d8-4793-abd3-fcb0f1a6108f)

위그림은 Q_Table 관련 코드입니다.<br>

Get_Q_Value() 함수는 인자로 state와 action값을 받으며, <br>
해당 state-action pair의 Q value 값을 리턴해줍니다. <br>

Set_Q_Value()는 인자로 state, action, value를 받으며, <br>
해당 state-action pair의 Q value 값을 수정해주는 함수입니다. <br>

Get_Max_Action() 함수는 인자로 state를 받으며, <br>
해당 state에서 Q value 값이 제일 높은 액션을 리턴해줍니다. <br>
(제일 큰 Q value를 쓴다는 건, 확률적으로 좋은 reward 받을 확률이 높다는 뜻입니다) <br>

<br><br><br>

![image](https://github.com/user-attachments/assets/59e7e081-51ef-4598-a86b-59b01bca83c4)

위 코드는 epsilon-greedy policy 에 기반한 액션 선택 함수입니다. <br>

Epsilon-Greedy는 강화 학습에서 사용되는 탐험(Exploration)과 활용(Exploitation)을 조절하는 전략입니다. <br>
이 방법은 에이전트가 대부분의 경우 현재 가장 좋은 행동을 선택하되(활용), 일정 확률(ε)로 무작위 행동을 선택(탐험)합니다.<br>

만약 final state라면 Q-table에서 state-action pair의 action 값은 0밖에 없으므로, 0을 리턴해줍니다. <br>
그 외, 보통의 경우 엡실론 그리디 과정을 거칩니다. <br>

랜덤 실수값이 epsilon 보다 작은 경우, 가능한 액션들 중에서 균일 확률로 액션을 랜덤 선택합니다. <br>
랜덤 실수값이 epsilon 확률보다 크다면, Get_Max_Action() 함수를 통해 greedy 하게 액션을 선택합니다.<br>

<br><br><br>

![image](https://github.com/user-attachments/assets/f86b292e-5484-4df8-91c9-2dd6d8d476d0)

위 코드는 리워드를 주는 함수에 대한 코드입니다. <br>

기본적으로 final state인지 체크를 합니다. <br>
final state는 몬스터나 유저 둘중 하나 이상 죽었고, 게임이 종료되야함을 의미합니다.<br>
게임 중, 몬스터가 죽었다면 몬스터는 리워드를 -10 받게 됩니다. <br>
유저가 죽었다면 리워드를 +10 받게 됩니다. <br>
만약 동시에 둘 다 죽으면 유저 승리 판정으로 인해 리워드를 -10 받게 됩니다.<br>

만약 final state가 아니라면 타격 상태에 기반해서 리워드를 줍니다. <br>
유저 몬스터 둘 다 타격 받지 않으면 리워드는 0입니다. <br>
몬스터만 타격 받으면 -1을 받습니다. <br>
유저만 타격 받으면 +1을 받습니다. <br>
만약 둘 다 타격 받았다면, <br>
체력과 데미지는 몬스터가 더 높으므로, 그런 상태는 몬스터쪽이 더 유리합니다. <br>
그러므로 리워드를 0.5로 책정하였습니다.<br>

<br><br><br>

![image](https://github.com/user-attachments/assets/9f8a0e14-8db7-4bd8-94e1-fa4510ee4bf5)

위 코드는 강화학습 관련 핵심 코드 입니다. <br>

Q_Table을 업데이트 해주는 함수입니다. <br>
Get_reward를 통해 리워드를 받아오고,<br>
그림에는 표현되지 않았지만,<br>
Get_State() 함수에서 current_state, current_action 그리고 before_state, before_action 값이 계속 갱신됩니다. <br>

![image](https://github.com/user-attachments/assets/52ff9f94-8bb9-4ac3-b6c0-8bca7725db02)

해당 코드가 SARSA 알고리즘 수식을 나타냅니다 <br>

![image](https://github.com/user-attachments/assets/3f940792-b572-4a72-9f45-87134251e392)

그런데 짚고 넘어가야할 점이 있습니다. <br>
업데이트는 게임 내 실시간으로 이루어집니다. <br>
해당 강화학습 환경은, 강한 실시간성을 띄고 있기 때문에, <br>
보통의 TD 알고리즘에서 이루어지는, 상태  S(t)  에서 바로 Q Value를 업데이트하는게 불가능합니다. <br>
물리적으로 S(t+1) 이 미래에 있기 때문입니다. <br>
유저의 행동은 예측 불가능하고 몬스터의 액션 딜레이가 끝나야 다음  state를 알 수 있습니다.  <br>
그래서 업데이트는 before_state 기준으로 진행됩니다. <br>
Q table 업데이트 수식은 S(t-1) ← S(t-1) + α[ R + r*S(t) – S(t-1)] 로 하게 됩니다. <br>

![image](https://github.com/user-attachments/assets/ceb9f18f-87ac-46f8-a3cc-b6070ddd15f1)

Update_Process() 함수의 첫부분에 (before_state == -1) if 문 판별이 있는데 이는 initial state를 의미하고, <br>
첫 state에서는 Q_Table 업데이트가 불가능하므로 그냥 바로 return을 하게 됩니다. <br>

![image](https://github.com/user-attachments/assets/5fa41124-0d81-40d6-8f09-7f6ab9242e5b)

![image](https://github.com/user-attachments/assets/a816753f-142f-48b5-96db-c6c594e5edd9)

마지막으로 Is_Final_State() == true if 문 판별이 존재하는데, 만약 final state라면 그 다음 state를 진행 할 수 없으므로, <br>
final 이전 state에 대한 Q_Table 업데이트와 동시에 현재 final state에 대한 Q_Table 업데이트도 진행합니다.<br>

<br><br><br>

![image](https://github.com/user-attachments/assets/74dd2f8b-ad2f-46da-8216-e46b0a6c4c7d)

최종적으로, 위 그림의 빨간색 테두리 박스 부분이 강화학습 관련 함수들입니다. <br>

<br><br><br>

## 결과, 평가 그리고 고찰

<br>

![image](https://github.com/user-attachments/assets/ff442d14-5743-4844-b076-b8134bf27b74)

한 에피소드가 끝나면 total_reward를 서버에 로그 형식으로 남겼습니다. <br>
총 408번의 episode에 대해 학습 했습니다.<br>

![image](https://github.com/user-attachments/assets/e660a7df-0bb7-4a79-9156-2b18fc81381b)

Data frame은 위 그림과 같이 나오며, 행의 번호가 episode가 진행된 순서입니다.<br>

<br>

![image](https://github.com/user-attachments/assets/4df74cb7-0915-4219-b69d-607e8e4eeff3)

해당 total reward들을 그래프로 그려보면 위 그림과 같습니다. <br>

결과가 그리 좋지는 않습니다. <br>
다양한 문제점이 존재하지만 대표적으로 꼽자면 <br>

<br>

문제점 1 - 몬스터 난이도가 너무 높음 <br>

: 학습 초기상태에서도 사람들이 뭐 해보지도 못하고 죽어 나갔습니다 <br>
이는 학습 초기부터 높은 total reward를 기록하게 되었습니다 <br>

<br>

문제점 2 - 평균적인 사람들의 게임 수행능력이 생각보다 낮았음 <br>

: 몬스터가 주로 낮은 수행능력, 저숙련도 대상으로 학습되었습니다 <br>
이는 정적이고 단조로운 액션 정책으로 수렴되었습니다 <br>

<br>

문제점 3 - 리워드 설정을 잘못함

: 몬스터는 리워드를 극대와 하는 방향으로 학습하기에, 리워드만 얻으면 장땡입니다.  <br>
몬스터는 학습을 통해 리워드를 얻는 안정적인 액션을 추구하게됨을 깨달았고 <br>
이는 정적이고 단조로운 액션 정책으로 수렴되었습니다 <br>

<br>

![image](https://github.com/user-attachments/assets/e5458df8-699f-418e-b793-4c84131a387d)

Linear Regression 적용해보면 추세 자체는 증가하는 방향이라 그래도 학습이 되고는 있다라고 말할 수는 있으나, <br>
강화학습을 통해 역동적인 몬스터를 기대했었던 것과는 달리  <br>
정적이고 단조로운 결과가 나타나서 이 부분은 의도하지 않은 결과가 되었습니다 <br>

<br><br><br>

![image](https://github.com/user-attachments/assets/9115922e-fbf2-40cf-8811-9603d4b4e46c)

위 그림은 최종 408번의 학습 후 나온 Q table 데이터프레임 입니다. <br>
해당 state에서 해당 action이 수치적으로 얼마나 좋은지를 나타내며, <br>
수치가 높은 액션을 선택하면 확률적으로 더 높은 reward를 얻게 됩니다. <br>

이걸로 optimal policy를 뽑아내면 다음과 같이 나옵니다 <br>

![image](https://github.com/user-attachments/assets/a9cc5e06-3607-4b76-8f10-730b10413e24)

​총 40개의 state에 대해서, 강화학습을 통해 얻어낸 optimal policy 입니다 <br>
해당 상태일 때, optimal policy의 action을 수행하면 최적의 reward를 얻을 수 있다는 뜻입니다. <br>

### 학습 초기, 제로베이스
[![Video Label](http://img.youtube.com/vi/4zzFT4OZ5Z8/0.jpg)](https://youtu.be/4zzFT4OZ5Z8) <br>
(이미지를 클릭하시면 플레이 영상이 있는 유튜브 링크로 넘어갑니다)

백스텝 위주로 액션이 나오며, 전체적으로 쉽고 플레이 타임도 짧습니다. <br>

<br>

### 학습 400회, optimal policy
[![Video Label](http://img.youtube.com/vi/UTd_NhSVbXE/0.jpg)](https://youtu.be/UTd_NhSVbXE) <br>
(이미지를 클릭하시면 플레이 영상이 있는 유튜브 링크로 넘어갑니다)

학습 후, 확실히 패턴이 까다로워졌으며, 플레이타임도 27초 늘어났습니다. <br>

거리 가까우면 Fast Attack, <br>
중거리에 있으면 주로 Center Attack 을 하는게 특징적입니다. <br>

정적이고 단조로운 패턴의 몬스터가 되었는데, <br>
이게 왜 이렇게 되었을까를 고찰해보면, <br>
몬스터는 리워드를 극대화 하는 방향으로 학습하는거고,  <br>
저 Center Attack이 범위도 넓고 넉백도 크고 그러니 리워드 얻기에는 안정적이고 좋은 액션이기 때문인 것 같습니다. <br>

이게 단조롭기는 하나, <br>
불특정 다수의 유저를 대상으로, 평균적인 실력의 유저를 대상으로 <br>
통계적, 수학적으로 보면 <br>
유저를 이기는, reward를 얻는 최적화된 방법이라는 것입니다. <br>

저숙련도의 유저를 대상으로는 굉장히 효과적인 패턴이나 <br>
잘하는 유저를 대상으로 할 때는 쉬운 패턴이 되어버렸습니다. <br>

처음 강화학습 설계를 시작할 때는 막 이리저리 뛰어다니고 동적이고 다채로운 패턴을 구사하는 화려한 <br>
몬스터가 나올줄 알았는데 그게 안되건 살짝 아쉬운 부분입니다. <br>

<br><br><br>

### 결론

파이썬이 아닌, 다른 언어로 제가 직접 환경을 만들어서 강화학습을 시도해본 것은 처음입니다.  <br>
total_reward의 경향성은 증가하는 방향이지만,  <br>
몬스터의 난이도와 리워드 설정에 대해서 미숙한 부분이 있어서 제가 원하는 결과는 나타나지 않았습니다.  <br>
하지만 해당 경험을 통해서 파이썬 라이브러리나, Open AI Gym 같은 주어진 라이브러리가 없더라도  <br>
제가 직접 만들 수 있다는 자신감을 가지고 앞으로 강화학습을 유용하게 사용할 수 있을 것 같습니다 <br>
