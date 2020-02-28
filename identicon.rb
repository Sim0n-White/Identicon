require 'mini_magick'
require 'digest/md5'
## Параметр user_name - строка
## Параметр path - строка пути, куда сохраняется png с идентиконом. Опциональный, по умолчанию сохраняется в текущую папку
class Identicon
  attr_accessor :user_name, :path
  Tobyte = Struct.new(:name, :byte_array, :color_byte)
  def initialize(user_name, path = __dir__)
    @user_name = user_name
    @path = path
  end

  def generate
    identicon = arrInput(user_name)
    p identicon.byte_array
    p identicon.byte_array.length
    p identicon.color_byte

    MiniMagick::Tool::Convert.new do |i|
      i.size "250x250"
      i.gravity "center"
      i.xc "white"
      i.caption "test"
      i << "test_image.png"
    end

    MiniMagick::Tool::Convert.new do |k|
      k.size "50x50"
      k.gravity "center"
      k.xc "green"
      k.caption "cube"
      k << "cube.png"
    end
  end

  def arrInput(name)
    byte_array = Digest::MD5.hexdigest(name).bytes.to_a
    byte_array = byte_array.slice(0,16)
    color = byte_array.slice(0,3)
    case color = color.each_with_index.max[1]
    when 0
      color = "red"
    when 1
      color = "green"
    when 2
      color = "blue"
    end
    return Tobyte.new(name, byte_array, color)
  end


end
