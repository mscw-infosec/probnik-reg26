Видим перед нами дамп памяти, первое что хочется сделать это посмотреть файлы и процессы.
После windows.filescan видны некоторые файлы на рабочем столе пользователя `user`, уточним запрос поиска.

```bash
vol -f dumpA.raw windows.filescan | grep -iF "user\Desktop"
```

Получаем такой вывод:

```
0xa79d1a60 100.0\Users\user\Desktop
0xa79d1ce8 \Users\user\Desktop
0xab33d088 \Users\user\Desktop
0xab343778 \Users\user\Desktop\GoodbyeWorld.py
0xab344f18 \Users\user\Desktop\todo.txt
0xab3455d8 \Users\user\Desktop\desktop.ini
0xaeeafa80 \Users\user\Desktop
0xaeeb70a0 \Users\user\Desktop\You_look_loneley.jpg
```

Сдампим все интересные файлы:

```bash
vol -f dumpA.raw windows.dumpfiles --virtaddr 0xab343778
vol -f dumpA.raw windows.dumpfiles --virtaddr 0xab344f18
vol -f dumpA.raw windows.dumpfiles --virtaddr 0xaeeb70a0
```

Попробуем прочитать файлы и увидим, что они зашифрованы. Кроме `GoodbyeWorld.py`. Читаем его и видим строку: `KEY_ENV = "AnonymousEvilCryptorKey` которая загружает данные из переменной окружения. Сдампим все переменные окружения и найдём там нужную нам:

```bash
vol -f dumpA.raw windows.envars | grep "AnonymousEvilCryptorKey"
```

Увидим закодированную строчку. `gC9N3MtlGdl1GMz9Fb1Z2MzV3XzFzXzJXY25WZfdmbxs2Yzg2Y7h2cvNnd`
По равно в начале можем предположить что это base64, но перевёрнутый. Также это подтверждается в скрипте шифровальщика, который в коде делает именно обратные действия.

Проделаем ровно то же самое в терминале или в питоне:

```bash
echo '==gC9N3MtlGdl1GMz9Fb1Z2MzV3XzFzXzJXY25WZfdmbxs2Yzg2Y7h2cvNnd' | rev | base64 -d
```

Получим первый флаг.

Проанализировав логику скрипта, понимаем что там обычный xor с первым флагом. Позаимствуем функцию xor из скрипта и напишем свои 6 строк для расшифрования и запустим нашу прогу на файлах `You_look_loneley.jpg` и `todo.txt`.

```python

def xor_bytes(data: bytes, key: bytes) -> bytes:
    out = bytearray(len(data))
    for i, b in enumerate(data):
        out[i] = b ^ key[i % len(key)]
    return bytes(out)

key = b'vsosh{ch3ck1ng_envars_1s_us3ful_s0metim3s}'
with open("You_look_loneley.jpg", "rb") as f:
    data = f.read()
result = xor_bytes(data, key)
with open("output.jpg", "wb") as f:
    f.write(result)
```

В `todo.txt` лежит:

```
- [ ] Echo the mirror
- [ ] Get a key without lock
- [ ] Observe node 7
- [ ] Checksum the silence
- [ ] Leave the mark

- [ ] Edit You_look_loneley.jpg
```

Видим указание на `You_look_loneley.jpg`, смотрим его:
![[You_look_loneley.jpg]]
Вот и второй флаг: **vsosh{X0r_1s_r3v3rs4ble}**.
