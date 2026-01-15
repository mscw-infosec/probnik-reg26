import bz2
import itertools

BYTECODE_ORIG = [
    x ^ 0x67
    for x in bz2.decompress(
        b'BZh91AY&SY_\x9bu\xf7\x00\x01\t\x92\x80\x01\x80@\x01\x84\x00 \x00\x94\x84\x9e\xa9)\xa0T\xd5&Olf{1\xe6\x92\xb6\x9a\x93D\x83\xbc\xe6\x81%\xda\xed\xcc\xb2\xa6\xb8\xee\xa5c\n["n\xfd\xeb\xbd\xae\xa9\xa7+\xed\xbd(6\x12\xab6\xf8\x85\x1a\xcb\x13*O\xc5\xdc\x91N\x14$\x17\xe6\xdd}\xc0'
    )
]
BYTECODE = [a << 8 | b for a, b in itertools.batched(BYTECODE_ORIG, 2)]


def rev_add1(x):
    return x - 1


def rev_sub3(x):
    return x + 3


def rev_div2(x):
    return x * 2


flag_ops = []
cur = []
for op in BYTECODE:
    if op == 0x1337:
        cur.append(rev_add1)
    elif op == 0x1338:
        cur.append(rev_sub3)
    elif op == 0x1339:
        cur.append(rev_div2)
    elif op == 0x1340:
        flag_ops.append(cur)
        cur = []
    elif op == 0x1341:
        flag_ops.append(cur)
        break

for char_funcs in flag_ops:
    t = 0
    for f in char_funcs[::-1]:
        t = f(t)
    print(chr(t), end="")
