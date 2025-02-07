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
200~300, <br>
300~400, <br>
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

state는 42개의 정수 값 0~41을 이용하였고 <br>

![image](https://github.com/user-attachments/assets/c253ba09-6700-42a1-8206-8faf176436b0)

![image](https://github.com/user-attachments/assets/658c3e38-16e8-400a-948b-85849cce4ace)

action은 10개의 정수 값 0~9를 이용하였습니다.<br>

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

