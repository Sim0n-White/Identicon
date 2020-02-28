require 'mini_magick'
require 'digest/md5'
## Параметр user_name - строка
## Параметр path - строка пути, куда сохраняется png с идентиконом. Опциональный, по умолчанию сохраняется в текущую папку
class Identicon
  attr_accessor :user_name, :path
  Tobyte = Struct.new(:name, :byte_array, :color_byte, :grid)
  def initialize(user_name, path = __dir__)
    @user_name = user_name
    @path = path
  end

  def generate
    identicon = arrInput(user_name)
    makeGrid(identicon)
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
      k.xc identicon.color_byte
      k.caption "cube"
      k << "cube.png"
    end

    image = MiniMagick::Image.new("test_image.png")
    cube = MiniMagick::Image.new("cube.png")
    sum = -50
    5.times do
      result = image.composite(cube) do |c|
        sum = sum + 50
        c.compose "Over"
        c.geometry "+#{sum}+100"
      end
      result.write "test_image.png"
    end
  end

  def arrInput(name)
    byte_array = Digest::MD5.hexdigest(name).chars.each_slice(2).map(&:join).map(&:hex)
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

  def makeGrid(identicon)
    grid = []
    i = 0
    while (i <= identicon.byte_array.length) && (i+3 <= identicon.byte_array.length-1)
      fill = identicon.byte_array[i..i+3]
      p fill
      fill[3] = fill[1]
      fill[4] = fill[0]
      grid.concat fill
      i+=3
      p i
    end
    identicon.grid = grid
  end


end
