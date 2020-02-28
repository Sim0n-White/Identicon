require 'mini_magick'
## Параметр user_name - строка
## Параметр path - строка пути, куда сохраняется png с идентиконом. Опциональный, по умолчанию сохраняется в текущую папку
class Identicon
  attr_accessor :user_name, :path
  def initialize(user_name, path = __dir__)
    @user_name = user_name
    @path = path
  end

  def generate
    MiniMagick::Tool::Convert.new do |i|
      i.size "250x250"
      i.gravity "center"
      i.xc "white"
      i.caption "test"
      i << "test_image.png"
    end
  end
end
