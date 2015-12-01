# Лабораторная работа №1 (FCM)

```
cabal install --enable-tests
cabal build
cabal test

./dist/build/fcm/fcm -l -c 3 -i tasks/irises.txt
```

## Опции

```
  -h --header         Отбросить заголовок
  -f --first          Отбросить первую колонку
  -l --last           Отбросить последнюю колонку
  -e --euclid         Использовать расстояние Эвклида
  -m --hammin         Использовать расстояние Хэмминга
  -c --cluster INT    Количество кластеров
  -r --random         Начать со случайный центров кластеров
  -p --eps DOUBLE     Предел для остановки алгоритма
  -i --input STRING   Входной файл
```
