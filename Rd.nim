import strutils

let f = open("kittens.txt")
# Close the file object when you are done with it
defer: f.close()

let firstLine = f.readLine()
echo firstLine  # prints Spitfire
let tul = firstLine.split({' ', ','})
for i, value in tul:
  echo "index: ", $i, ", value:", $value