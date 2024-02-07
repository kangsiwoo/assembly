main:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $48, %rsp
    call    __main

    ; 반복문 시작
    movl    $0, -4(%rbp)
    jmp     .L2 ; ~~로 이동

    ; 실행코드
.L3:
    addl    $1, -4(%rbp) ; 반복문에 사용된 변수에 1을 더해서 무한루프를 막음

    ; 조건 확인
.L2:
    cmpl    $9, -4(%rbp) ; 두개의 값을 비교하는 명령어
    jle     .L3 ; 작거나 같으면 이동

    movl    $0, %eax

    addq    $48, %rsp
    popq    %rbp
    ret