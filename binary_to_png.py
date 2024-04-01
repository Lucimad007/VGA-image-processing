from PIL import Image  //pip install pillow

input_file = "input.txt"
with open(input_file, 'r') as f:
    data = f.read().strip()

size = int(len(data) ** 0.5)
pixels = [int(bit) * 255 for bit in data]

img = Image.new('L', (size, size))
img.putdata(pixels)

output_file = "output.png"
img.save(output_file)

