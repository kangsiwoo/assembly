# Function
%rbp는 베이스 포인터(Base Pointer) 이다? <br>
보통 함수가 시작될 때 사용됨

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

이 명령어를 해석하자면

옮긴다, $0(0)을, 베이스 포인터로부터 -4(자료형의 크기)만큼

같은 논리로 문자를 저장한다면 -4가 -1로 바뀐다.

    movb    $0, -1(%rbp)

선언과 같이 값을 변경할 때도 동일하게 사용하면 된다.

하지만 증감연산을 사용할 때는 생각보다 단순하지 않다.

    movzbl	-1(%rbp), %eax
    addl	$1, %eax
    movb	%al, -1(%rbp)

이 코드를 분석해보면 

1. movzbl은 읽어온 값을 확장시키고 그 값을 증감연산을 하기 위해 eax 레지스터로 저장한다.
2. eax 레지스터에 있는 값에 1을 더합니다.
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
3. cmpl 명령어로 두 값($9, -4(%rbp))이 같은지 확인
4. 그 결과가 작거나 같다면 .L3 지점으로 이동
5. -4(%rbp)에 1을 더함
6. 이 과정이 끝나면 호출된 곳으로 돌아갑니다 (예상)

### While

While 문도 동일한 반복문 이기 때문에 크게 다른 부분이 없다.

위 코드를 C언어로 번역하면 

    for (int i = 0; i < 10; ++i) {

    }

이렇게 번역할 수 있고,

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

이처럼 jne 명령어를 제외하면 같다는 것을 확인할 수 있다.

이 부분은 for 문에서 i < 10과 i != 9이기 때문에 차이가 나는 것이다.

이처럼 비교하는 명령어는 다양하지만 같은 용도로 사용할 수 있다.

1. je : Jump if Equal
2. jne : Jump if Not Equal
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

(이렇게 정리해두면 외우는 데 크게 문제가 되지는 않을 것 같습니다.)

# Break

break문은 상당히 간단하다.

만약 어떠한 조건이 충족한다면 break하게 하는 코드를 어셈블리 코드로 작성하면

    main:
        ~~~~~~~생략~~~~~~~
        cmpl    -4(%rbp), $2
        je      .L2
.L2:
        nop

이렇게 작성할 수 있다.

# Print

C++에서 프린트를 할 수 있는 방법은 두 가지가 있다.

    printf("Hello World");
<br>

    std::cout << "Hello World";

이렇게 두 가지가 있는데 기능에는 큰 차이가 없지만 어셈블리어에서는 많은 차이가 보인다.

printf를 활용하면 main 함수 위에 명령어가 추가로 생긴다.

    printf(char const*, ...):
        pushq	%rbp
        pushq	%rbx
        subq	$56, %rsp
        leaq	48(%rsp), %rbp
        movq	%rcx, 32(%rbp)
        movq	%rdx, 40(%rbp)
        movq	%r8, 48(%rbp)
        movq	%r9, 56(%rbp)
        leaq	40(%rbp), %rax
        movq	%rax, -16(%rbp)
        movq	-16(%rbp), %rbx
        movl	$1, %ecx
        movq	__imp___acrt_iob_func(%rip), %rax
        call	*%rax
        movq	%rax, %rcx
        movq	32(%rbp), %rax
        movq	%rbx, %r8
        movq	%rax, %rdx
        call	__mingw_vfprintf
        movl	%eax, -4(%rbp)
        movl	-4(%rbp), %eax
        addq	$56, %rsp
        popq	%rbx
        popq	%rbp
        ret

함수를 호출할 때는 

    leaq	.LC0(%rip), %rax
    movq	%rax, %rcx
    call	printf(char const*, ...)

이러한 명령어가 생긴다.

반면에 std::cout을 사용하면 밑에 명령어가 추가된다.

    .refptr.std::cout:
        .quad	std::cout

함수를 호출할 때는 다소 복잡한 오퍼렌드를 활용하여야 한다.

    leaq	.LC0(%rip), %rax
    movq	%rax, %rdx
    movq	.refptr.std::cout(%rip), %rax
    movq	%rax, %rcx
    call	std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)

어셈블리에서 프린트를 사용하기에는 무리가 있을 수 있지만 만약 사용해야 한다면 나는 printf와 같은 방식으로 출력할 것 같다.

# Scan

scan함수도 두가지 방법을 알아볼것이다.

먼저 scanf방식은 printf와 같이 위에 어셈블리 코드가 추가된다.

    scanf(char const*, ...):
        pushq	%rbp
        pushq	%rbx
        subq	$56, %rsp
        leaq	48(%rsp), %rbp
        movq	%rcx, 32(%rbp)
        movq	%rdx, 40(%rbp)
        movq	%r8, 48(%rbp)
        movq	%r9, 56(%rbp)
        leaq	40(%rbp), %rax
        movq	%rax, -16(%rbp)
        movq	-16(%rbp), %rbx
        movl	$0, %ecx
        movq	__imp___acrt_iob_func(%rip), %rax
        call	*%rax
        movq	%rax, %rcx
        movq	32(%rbp), %rax
        movq	%rbx, %r8
        movq	%rax, %rdx
        call	__mingw_vfscanf
        movl	%eax, -4(%rbp)
        movl	-4(%rbp), %eax
        addq	$56, %rsp
        popq	%rbx
        popq	%rbp
        ret

std::cin 방식도 동일하게 복잡한 오퍼렌드를 활용해야 한다.

    leaq	-4(%rbp), %rax
    movq	%rax, %rdx
    movq	.refptr.std::cin(%rip), %rax
    movq	%rax, %rcx
    call	std::basic_istream<char, std::char_traits<char> >::operator>>(int&)

이러한 명령어들은 자료형에 따라 명령어가 달라지는 것을 확인할 수 있다.

### int형
    call	std::basic_istream<char, std::char_traits<char> >::operator>>(int&)
### char형
    call	std::basic_istream<char, std::char_traits<char> >& std::operator>><char, std::char_traits<char> >(std::basic_istream<char, std::char_traits<char> >&, char&)
