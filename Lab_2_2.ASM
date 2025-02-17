format PE console
entry Start

include 'win32a.inc'

section '.data' data readable writeable
    inputPrompt db 'Enter a number: ', 0
    outputPrompt db 'Reversed number: ', 0
    inputFormat db '%s', 0
    outputFormat db '%s', 0
    number db 11 dup(0)  ; ����� ��� ��������� ����� (�� 10 ���� + 0)
    reversed db 11 dup(0) ; ����� ��� ������������� �����
    NULL = 0

section '.code' code readable executable
Start:
    ; ��������� ����������� "Enter a number: "
    push inputPrompt
    call [printf]

    ; ������� ����� � ������
    push number
    push inputFormat
    call [scanf]

    ; ������ �����
    mov esi, number      ; �������� �� ������� ��������� �����
    mov edi, reversed    ; �������� �� ������� ������������� �����
    call reverse_string  ; ������ ��������� �������

    ; ��������� ����������� "Reversed number: "
    push outputPrompt
    call [printf]

    ; ��������� ������������� �����
    push reversed
    push outputFormat
    call [printf]

    ; ���������� ��������
    call [getch]
    push NULL
    call [ExitProcess]

; ��������� ��� ������������ �����
reverse_string:
    ; ������ ������� �����
    mov ecx, 0          ; ˳������� �������
    find_length:
        cmp byte [esi + ecx], 0 ; ������ ������� ����
        je start_reverse
        inc ecx
        jmp find_length

    start_reverse:
    dec ecx              ; �������� ������ (�� ���������� 0)
    reverse_loop:
        cmp ecx, 0       ; ���� �� ������� ��������, ���������
        jl done_reverse
        mov al, [esi + ecx]   ; ����� ������ � ���� ������������ �����
        mov [edi], al         ; �������� ������ �� ������� ������������� �����
        inc edi
        dec ecx
        jmp reverse_loop

    done_reverse:
    mov byte [edi], 0    ; ������ ������� ����
    ret

section '.idata' import data readable
    library kernel32, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

    import kernel32,\
           ExitProcess, 'ExitProcess'

    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'
