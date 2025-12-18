ORG 0x7c00          ; BIOS가 부트섹터를 메모리 0x7C00에 로드
BITS 16             ; 16비트 리얼모드

start:
    mov si, message ; SI 레지스터에 message 문자열의 주소를 저장
    call print
    jmp $           ; 현재 위치로 무한 점프 (무한 루프)

print:
    mov bx, 0       ; 페이지 번호 0
.loop:
    lodsb           ; DS:SI에서 1바이트를 AL에 로드하고 SI를 1 증가
    cmp al, 0       ; AL이 0(널 문자)인지 비교
    je .done        ; 0이면 .done으로 점프
    call print_char ; 문자 출력 함수 호출
    jmp .loop       ; 다음 문자로 반복
.done:
    ret

print_char:
    mov ah, 0eh     ; BIOS 비디오 서비스 - TTY 모드 (문자 출력)
    int 0x10        ; BIOS 비디오 인터럽트 호출 → 화면에 'A' 출력
    ret

message: db 'Hello World!', 0

times 510-($ - $$) db 0 ; 510바이트까지 0으로 채움
dw 0xAA55           ; 부트 시그니처 (BIOS가 이걸 확인)
