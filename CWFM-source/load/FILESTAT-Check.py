from os.path import exists
import os

def read_raw_file_lines(file,skip):
    result = []
    count = 0
    with open(file) as file:
        
        for line in file:
            if count >= skip:
                result.append(line)
            count = count + 1
    return result

def check_lines(lines):
    if lines[0].strip() != "FILESTAT  FILE STATUS 00 IS SUCCESSFUL COMPLETION":
        print("line 1 is invalid " + lines[0])
    if lines[1].strip() != "FILESTAT  FILE STATUS 22 IS DUPLICATE KEY":
        print("line 2 is invalid")
    if lines[2].strip() != "FILESTAT  FILE STATUS 23 IS NO RECORD FOUND":
        print("line 3 is invalid")

lines = read_raw_file_lines("file-status-out.txt",0)


if len(lines) != 3:
    print("invalid result " + str(len(lines)))
else:
    check_lines(lines)
