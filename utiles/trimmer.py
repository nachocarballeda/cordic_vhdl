counter = 0
new_amount = 0
with open("coords.txt", "r+") as fi:
    lines = fi.readlines()
    number_of_lines = enumerate(fi)
with open("trimmed_coords.txt", "w") as fo:
    for line in lines:
        if counter%4==0:
            fo.write(line)
            new_amount = new_amount+1
        counter=counter+1
print("number of lines in original file = ", counter,  " new amount of lines ", new_amount)
