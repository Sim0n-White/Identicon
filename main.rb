require_relative  'identicon'
## Параметр user_name - строка
## Параметр path - строка пути, куда сохраняется png с идентиконом. Опциональный, по умолчанию сохраняется в текущую папку
user_name = "Кирилл"
path = nil
identicon = Identicon.new(user_name, path)
identicon.generate # генерирует и сохраняет файл png
