"String"  use
"control" use
"Math"    use

! Функция проверки делимости
isDivisible: [
  divisor:; ! Сохраняем делитель в переменную (снимаем со стека)
  number:;  ! Сохраняем число
  number divisor % 0 == ! Проверяем остаток от деления
];

fizzBuzz: [
  n:; ! Аргумент функции - число итераций

  ! Цикл от 1 до n
  1 n 1 + [
    i:; ! Текущее число

    ! Логика FizzBuzz
    i 15 isDivisible [
      "FizzBuzz" print
    ] [
      i 3 isDivisible [
        "Fizz" print
      ] [
        i 5 isDivisible [
          "Buzz" print
        ] [
          i print ! Если не делится ни на что, печатаем число
        ] if
      ] if
    ] if

    LF print ! Перевод строки
  ] for
];

! Точка входа
{} Int32 {} [
  100 fizzBuzz ! Запускаем для чисел от 1 до 100
  0            ! Код возврата 0
] "main" exportFunction