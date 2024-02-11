# Function
%rbp는 베이스 레지스터 포인터 이다? <br>
보통 함수가 시작될때 사용됨

    main:
        pushq	%rbp
        movq	%rsp, %rbp
        subq	$32, %rsp
        call	__main
        movl	$0, %eax
        addq	$32, %rsp
        popq	%rbp
        ret


1. rsp 레지스터: 스택 포인터(Stack Pointer) 레지스터로, 현재 스택의 맨 위를 가리킵니다.
2. rbp 레지스터: 베이스 포인터(Base Pointer) 레지스터로, 현재 스택 프레임의 베이스를 가리킵니다.
3. eax 레지스터: 누산기(Accumulator) 레지스터로, 연산 결과를 저장하는 레지스터입니다.

# Variable
정수 변수를 선언하는 방법은 다음과 같다.

    movl	$0, -4(%rbp)

이 명령어를 해석 하자면

옮긴다, $0(0)을, 베이스 포인터로부터 -4(자료형의 크기)만큼

같은 논리로 문자를 저장한다면 -4가 -1로 바뀐다.

    movb    $0, -1(%rbp)

선언과 같이 값을 변경할때도 동일하게 사용하면 된다.

하지만 증감연산자를 사용할때는 생각보다 단순하지 않다.

    movzbl	-1(%rbp), %eax
	addl	$1, %eax
	movb	%al, -1(%rbp)

이 코드를 분석해보면 

1. movzbl은 읽어온 값을 확장시키고 그 값을 증감연산을 하기 위해 eax레지스터로 저장한다.
2. eax 레지스터에 있는 값에 1을 더한다.
3. 원래 레지스터에 연산된 값(al 레지스터)을 넣어서 계산을 끝낸다.

# For
반복문 코드는 다음과 같다.

    main: 
        ~~~~~~~생략~~~~~~~
        movl	$0, -4(%rbp)
	    jmp	.L2
    .L3:
        addl	$1, -4(%rbp)
    .L2:
        cmpl	$9, -4(%rbp)
        jle	.L3

분석해 보자면

1. 반복문에 사용될 변수를 지정
2. .L2 지점으로 이동
3. cmpl명령어로 두 값($9, -4(%rbp))이 같은지 확인
4. 그 결과가 작거나 같다면 .L3지점으로 이동
5. -4(%rbp)에 1을 더함
6. 이 과정이 끝나면 호출된 자리로 돌아감 (예상)

### While

While 문도 동일한 반복문 이기 때문에 크게 다른 부분이 없다.

위 코드를 C언어로 번역하면 

    for (int i = 0; i < 10; ++i) {

    }

이렇게 변역할 수 있고,

while 문을 어셈블리 코드로 번역하면

    int i = 0;
    while(i != 9) {
        i++;
    }

이 코드가 

        movl	$0, -4(%rbp)
        jmp	.L2
    .L3:
        addl	$1, -4(%rbp)
    .L2:
        cmpl	$9, -4(%rbp)
        jne	.L3

이렇게 번역 될 수 있다.

이처럼 jne명령어를 제외하면 같다는걸 확인할 수 있다.

이 부분은 for문에서 i < 10와 i != 9이기 때문에 차이가 나는 것이다.

이처럼 비교하는 명령어는 다양하지만 같은용도로 사용할 수 있다.

1. je : Jump if Equal
2. jen : Jump if Not Equal
3. jz : Jump if Zero
4. jnz : Jump if Not Zero
5. jl : Jump if Less than
6. jle : Jump if Less than or Equal
7. jg : Jump if Greater than
8. jge : Jump if Greater than or Equal
9. jb : Jump if Below
10. jbe : Jump if Below or Equal
11. ja : Jump if Above
12. jae : Jump if Above or Equal

(이렇게 정리해두면 외우는데 크게 문제가 되지는 않을거 같다.)

이 연산자들과 명령어의 배열을 바꾸면 어렵지 않게 do-while 반복문도 구현할 수 있다.

# Break

break문은 상당히 간단하다.

만약 어떠한 조건이 충족한다면 break하게 하는 코드를 어셈블리 코드로 작성하면

    main:
        ~~~~~~~생략~~~~~~~
        cmpl    -4(%rbp), $2
        je      .L2
    .L2:
        nop

이렇게 작성할 수있다.