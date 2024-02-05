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


1. %rsp: 스택 포인터(Stack Pointer) 레지스터로, 현재 스택의 맨 위를 가리킵니다.
2. %rbp: 베이스 포인터(Base Pointer) 레지스터로, 현재 스택 프레임의 베이스를 가리킵니다.
3. %eax: 누산기(Accumulator) 레지스터로, 함수의 반환값을 저장하기 위해 사용됩니다.

# Variable
정수 변수를 선언하는 방법은 다음과 같다.

    movl	$0, -4(%rbp)

이 명령어를 해석 하자면

옮긴다, $0(0)을, 베이스 포인터로부터 -4(자료형의 크기)만큼

같은 논리로 문자를 저장한다면 -4가 -1로 바뀐다.

    movb    $0, -1(%rbp)