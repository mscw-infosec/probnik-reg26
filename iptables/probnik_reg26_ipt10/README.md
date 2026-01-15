# DDOS не хочется

Иван заметил аномальную активность — множество коротких TCP-подключений к порту 443. Помогите ему ограничить количество только новых TCP-подключений до 2 в секунду (уже установленные соединения не должны ограничиваться).

- Рекомендуемые утилиты: iptables.
- Цель работы: создание правил(а) для брандмауэра.
- Итог работы: цепочка правил для брандмауэра.
- Критерий оценки: предоставление правильного флага, полученного от проверяющей системы.

## Решение
```
-A INPUT -p tcp --dport 443 --syn -m limit --limit 2/second --limit-burst 2 -j ACCEPT
-A INPUT -p tcp --dport 443 --syn -j DROP
```
 либо
```
-A INPUT -p tcp --dport 443 -m state --state NEW -m limit --limit 2/second --limit-burst 2 -j ACCEPT
-A INPUT -p tcp --dport 443 -m state --state NEW -j REJECT
-A INPUT -p tcp --dport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT
```
