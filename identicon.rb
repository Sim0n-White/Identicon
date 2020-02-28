require 'mini_magick'
require 'digest/md5'
## Параметр user_name - строка
## Параметр path - строка пути, куда сохраняется png с идентиконом. Опциональный, по умолчанию сохраняется в текущую папку
class Identicon
  attr_accessor :user_name, :path
  Tobyte = Struct.new(:name, :byte_array, :color_byte, :grid, :markPoint)
  def initialize(user_name, path = __dir__)
    @user_name = user_name
    @path = path
  end

  def generate
    identicon = arrInput(user_name)
    makeGrid(identicon)
    findBox(identicon)
    MiniMagick::Tool::Convert.new do |i|
      i.size "250x250"
      i.gravity "center"
      i.xc "white"
      i.caption "identicon"
      i << "identicon.png"
    end

    MiniMagick::Tool::Convert.new do |k|
      k.size "50x50"
      k.gravity "center"
      k.xc "rgb(#{identicon.color_byte[0]}, #{identicon.color_byte[1]}, #{identicon.color_byte[2]})"
      k.caption "part"
      k << "part.png"
    end

    image = MiniMagick::Image.new("test_image.png")
    cube = MiniMagick::Image.new("cube.png")
    identicon.markPoint.length.times do |i|
      result = image.composite(cube) do |c|
        x = identicon.markPoint[i] % 5 * 50
        y = identicon.markPoint[i] / 5 * 50
        y = y.to_i
        c.compose "Over"
        c.geometry "+#{x}+#{y}"
      end
      result.write "identicon.png"
    end


  end

  def arrInput(name)
    byte_array = Digest::MD5.hexdigest(name).chars.each_slice(2).map(&:join).map(&:hex)
    color = byte_array.slice(0,3)
    return Tobyte.new(name, byte_array, color)
  end

  def makeGrid(identicon)
    grid = []
    i = 0
    while (i <= identicon.byte_array.length) && (i+3 <= identicon.byte_array.length-1)
      fill = identicon.byte_array[i..i+3]
      fill[3] = fill[1]
      fill[4] = fill[0]
      grid.concat fill
      i+=3
    end
    identicon.grid = grid
  end

  def findBox(identicon)
    identicon.markPoint = []
    identicon.grid.length.times do |i|
      if identicon.grid[i].odd?
        identicon.markPoint << i
      end
    end
  end
end
