# Виртуальный миксер
Однажды, один мой преподаватель потребовал пояснять все аббревиатуры. В ответ на вопрос о том, как можно интерпретировать "ВМ", он ответил "Виртуальный Миксер"

## Решение
Приводим код в порядок, получаем примерно следующее:
```python
import bz2
from itertools import batched

class VirtualMixer:
    def __init__(self, inp, bc) -> None:
        self.bc = [x ^ 0x67 for x in bz2.decompress(bc)]
        self.inp = [int(x) for x in inp]
        self.curop, self.curinp = 0, 0

    def add1(self):
        self.inp[self.curinp] += 1

    def sub3(self):
        self.inp[self.curinp] -= 3

    def div2(self):
        self.inp[self.curinp] //= 2

    def nextinp(self):
        self.curinp += 1

    def check(self):
        if all([x == 0 for x in self.inp]):
            print("good")
        else:
            print("bad")

    OOPS = {0x1337: add1, 0x1338: sub3, 0x1339: div2, 0x1340: nextinp, 0x1341: check}

    def prep(self):
        self.bcp = [a << 8 | b for a, b in batched(self.bc, 2)]
        print(self.bcp)

    def step(self):
        VirtualMixer.OOPS[self.bcp[self.curop]](self)
        self.curop += 1

    def run(self):
        self.prep()
        for _ in range(len(self.bcp)):
            try:
                self.step()
            except IndexError:
                print("bad")
                exit(1337)


VirtualMixer(
    input("enter the flag: ").encode(),
    b'BZh91AY&SY_\x9bu\xf7\x00\x01\t\x92\x80\x01\x80@\x01\x84\x00 \x00\x94\x84\x9e\xa9)\xa0T\xd5&Olf{1\xe6\x92\xb6\x9a\x93D\x83\xbc\xe6\x81%\xda\xed\xcc\xb2\xa6\xb8\xee\xa5c\n["n\xfd\xeb\xbd\xae\xa9\xa7+\xed\xbd(6\x12\xab6\xf8\x85\x1a\xcb\x13*O\xc5\xdc\x91N\x14$\x17\xe6\xdd}\xc0',
).run()
```


Видим по факту простейшую виртуальную машину. В ней есть
1) "код" который определяет, какие операции выполняются (получается как ксор с 0x67 декомпрессированной строки)
2) введенная пользователем строка, каждый символ которой приведен к числу
3) счётчик, указывающий на номер текущей операции
4) счётчик, указывающий на номер символа ввода

У неё есть 5 операций:
1) добавлять 1 к текущему символу ввода
2) вычитать 3 из текущего символа ввода
3) делить нацело на 2 текущий символ ввода
4) переходить к следующему символу ввода
5) сравнивать все элементы из массива ввода с 0 и выводить "good", если это так

Получается, введенная строка пройдет проверку только есть при выполнении всех операций из "расшифрованного" кода, все символы обнулятся. Для этого в своем решении нужно "расшифровать" код и применить все операции на каждую ячейку в обратном порядке. Полное решение: [splo.py](splo.py)
