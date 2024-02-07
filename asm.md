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