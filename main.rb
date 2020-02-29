require_relative  'identicon'
## Параметр user_name - строка
## Параметр path - строка пути, куда сохраняется png с идентиконом. Опциональный, по умолчанию сохраняется в текущую папку
# path вводить без ковычек
identicon = Identicon.new(gets.chomp, gets.chomp)
identicon.generate # генерирует и сохраняет файл png
