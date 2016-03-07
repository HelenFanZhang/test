require 'digest/md5'
require 'RMagick'
require 'chunky_png'


#Produces checksums for both images
img1 = Magick::Image.read("firstphoto.png").first
img2 = Magick::Image.read("secondphoto.png").first
puts Digest::MD5.hexdigest img1.export_pixels.join
puts Digest::MD5.hexdigest img2.export_pixels.join

#Produces pixel diffs between 2 images
images = [
  ChunkyPNG::Image.from_file('step1a.png'),
  ChunkyPNG::Image.from_file('step1b.png')
]

diff = []

images.first.height.times do |y|
  images.first.row(y).each_with_index do |pixel, x|
    diff << [x,y] unless pixel == images.last[x,y]
  end
end

puts "pixels (total):     #{images.first.pixels.length}"
puts "pixels changed:     #{diff.length}"
puts "pixels changed (%): #{(diff.length.to_f / images.first.pixels.length) * 100}%"


#produce a diff image if there are changes
if diff.length.to_f != 0
  x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }
  images.last.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(0,255,0))
  images.last.save('diff.png')
end
