require 'mini_magick'
require 'digest/md5'

class Identicon
  Tobyte = Struct.new(:name, :byte_array, :color_byte, :grid, :markPoint)

  def initialize(user_name, path)
    if user_name.nil? || user_name.empty?
      @user_name = "unknown"
    else
      @user_name = user_name
    end
    if path.nil? || path.empty?
      @path = __dir__
    else
      if File.directory?(path)
        @path = path
      else
        @path = __dir__
      end
    end
  end

  def generate
    identicon = arrInput(@user_name)
    makeGrid(identicon)
    findBox(identicon)
    MiniMagick::Tool::Convert.new do |i|
      i.size "250x250"
      i.gravity "center"
      i.xc "white"
      i.caption "#{@user_name}"
      i << "#{@path}/#{@user_name}.png"
    end

    MiniMagick::Tool::Convert.new do |k|
      k.size "50x50"
      k.gravity "center"
      k.xc "rgb(#{identicon.color_byte[0]}, #{identicon.color_byte[1]}, #{identicon.color_byte[2]})"
      k.caption "part"
      k << "part.png"
    end

    image = MiniMagick::Image.new("#{@path}/#{@user_name}.png")
    cube = MiniMagick::Image.new("part.png")
    identicon.markPoint.length.times do |i|
      result = image.composite(cube) do |c|
        x = identicon.markPoint[i] % 5 * 50
        y = identicon.markPoint[i] / 5 * 50
        y = y.to_i
        c.compose "Over"
        c.geometry "+#{x}+#{y}"
      end
      result.write "#{@path}/#{@user_name}.png"
    end
    File.delete("part.png")
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
