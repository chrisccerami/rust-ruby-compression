require "./compresser"

comp = Compresser.new

compressed = comp.compress("moby-dick.txt")
file = File.new("compressed-dick.txt", "w")
file.write(compressed)

decompressed = comp.decompress("compressed-dick.txt")
decomp_file = File.new("decompressed-dick.txt", "w")

original = File.read("moby-dick.txt")

if original == decompressed
  puts "Compression is lossless"
else
  puts "Compression IS NOT lossless"
end

rate = original.size.to_f / compressed.size
puts "Compression rate: #{rate}"
