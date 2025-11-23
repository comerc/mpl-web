# mpl-web

Это отличная и амбициозная задача! Создание Fullstack-фреймворка на стековом языке (MPL) с компиляцией в WASM — это очень интересный исследовательский проект.

Для реализации **реактивности** (как в SolidJS, Vue или Svelte) и **WASM-интеграции** на MPL, я предлагаю следующий план и архитектуру.

### 1. Компиляция в WASM

Так как `mpl-c` генерирует **LLVM IR** (`.ll` файлы), мы можем использовать `clang` (с поддержкой WASM) или `emcc` (Emscripten) или `wasm-ld` для получения `.wasm` файла.

Примерная цепочка сборки:
`MPL -> mplc -> .ll -> clang --target=wasm32 -> .wasm`

Вам понадобятся внешние функции (FFI) для работы с DOM браузера, так как в WASM нет прямого доступа к DOM.

### 2. Архитектура Реактивности (Signals) на стековом языке

В JS фреймворках (SolidJS, Vue Reactivity) реактивность строится на графе зависимостей. В стековом языке это может выглядеть элегантно.

Предлагаю реализовать паттерн **Signals** (Сигналы):

- **Signal (Сигнал)**: Хранит значение и список подписчиков (эффектов).
- **Effect (Эффект)**: Функция, которая выполняется при изменении сигналов, от которых она зависит.

На MPL это может выглядеть так (псевдокод/дизайн):

```mpl
"Reactivity" use

! Создаем сигнал со значением 0
0 signal: count;

! Создаем эффект (подписку)
[
  count get ! Читаем сигнал (автоматически подписываемся)
  "Count is: " print print LF print
] effect

! Обновляем сигнал
count 1 set ! Триггерит эффект: выведет "Count is: 1"
count 2 set ! Триггерит эффект: выведет "Count is: 2"
```

### 3. Прототип FFI для DOM (взаимодействие с JS)

Чтобы управлять DOM из MPL, нам нужно импортировать JS-функции.
В файле `dom_bindings.mpl`:

```mpl
! Импорт JS-функций (сигнатуры)
{
  tagPtr:    Natx; ! Указатель на строку с тегом
  tagSize:   Natx;
} Natx {convention: cdecl;} "createElement" importFunction

{
  elemPtr:   Natx;
  textPtr:   Natx;
  textSize:  Natx;
} Void {convention: cdecl;} "setTextContent" importFunction

{
  parentPtr: Natx;
  childPtr:  Natx;
} Void {convention: cdecl;} "appendChild" importFunction
```

### 4. Пример компонента (Frontend на MPL)

Вот как может выглядеть компонент "Счетчик" на вашем будущем фреймворке:

```mpl
"DOM" use
"Reactivity" use

counterComponent: [
  parent:;

  ! Состояние (Сигнал)
  0 signal: count;

  ! Создаем элементы
  "div" createElement: wrapper;
  "button" createElement: btn;
  "span" createElement: textDisplay;

  ! Настраиваем кнопку
  btn "Click me" setTextContent
  btn "click" [
    ! Увеличиваем счетчик
    count get 1 + count set
  ] addEventListener

  ! Реактивный биндинг текста (Эффект)
  [
    ! Этот блок перезапускается при изменении count
    textDisplay
    "Count: " count get toString +
    setTextContent
  ] effect

  ! Сборка дерева
  wrapper btn appendChild
  wrapper textDisplay appendChild
  parent wrapper appendChild
];
```

### План реализации (ToDo):

1.  **Сборка в WASM**: Настроить пайплайн компиляции простейшего `main.mpl` в `test.wasm` и запуск в браузере.
2.  **Runtime (JS)**: Написать небольшой JS-файл, который загружает WASM и предоставляет ему функции `env` (createElement, etc).
3.  **Reactivity Core**: Реализовать структуру `Signal` и глобальный стек эффектов (`context stack`) на MPL для отслеживания зависимостей.
