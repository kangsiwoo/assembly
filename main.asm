main:
    ; 호출
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    call __main

    ; 반환값
    movl $0, %eax

    ; 끝
    addq $32, %rsp
    popq %rbp
    ret