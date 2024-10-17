format PE console
entry Start

include 'win32a.inc'

section '.data' data readable writeable
    inputPrompt db 'Enter a number: ', 0
    outputPrompt db 'Reversed number: ', 0
    inputFormat db '%s', 0
    outputFormat db '%s', 0
    number db 11 dup(0)  ; Буфер для введеного числа (до 10 цифр + 0)
    reversed db 11 dup(0) ; Буфер для реверсованого числа
    NULL = 0

section '.code' code readable executable
Start:
    ; Виведення повідомлення "Enter a number: "
    push inputPrompt
    call [printf]

    ; Читання числа з консолі
    push number
    push inputFormat
    call [scanf]

    ; Реверс числа
    mov esi, number      ; Вказівник на початок введеного числа
    mov edi, reversed    ; Вказівник на початок реверсованого числа
    call reverse_string  ; Виклик процедури реверсу

    ; Виведення повідомлення "Reversed number: "
    push outputPrompt
    call [printf]

    ; Виведення реверсованого числа
    push reversed
    push outputFormat
    call [printf]

    ; Завершення програми
    call [getch]
    push NULL
    call [ExitProcess]

; Процедура для реверсування рядка
reverse_string:
    ; Знайти довжину рядка
    mov ecx, 0          ; Лічильник довжини
    find_length:
        cmp byte [esi + ecx], 0 ; Шукаємо кінцевий нуль
        je start_reverse
        inc ecx
        jmp find_length

    start_reverse:
    dec ecx              ; Останній символ (не враховуючи 0)
    reverse_loop:
        cmp ecx, 0       ; Якщо всі символи пройдені, завершити
        jl done_reverse
        mov al, [esi + ecx]   ; Взяти символ з кінця оригінального рядка
        mov [edi], al         ; Помістити символ на початок реверсованого рядка
        inc edi
        dec ecx
        jmp reverse_loop

    done_reverse:
    mov byte [edi], 0    ; Додаємо кінцевий нуль
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
