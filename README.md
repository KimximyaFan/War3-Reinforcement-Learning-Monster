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

![big](https://github.com/user-attachments/assets/2aefe3cb-f8b0-488b-aa44-19c9e145fbfe)

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

<br><br>

