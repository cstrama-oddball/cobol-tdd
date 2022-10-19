import sys, os

from os.path import exists

INCLUDE_STRING = "*++INCLUDE "
COPY_STRING = "COPY "
COMMENT_STRING = "*"
OTHER_COMMENT_STRING = "/"
NEWLINE = "\n"
APPEND_FLAG = "a"
EMPTY_STRING = ""
PERIOD = "."

def main(file, outfile):
    delete_file(outfile)
    processfile(file, outfile)

def processfile(file, outfile):
    count = 0
    with open(file) as file:
        for line in file:
            tmp = line.strip()
            if tmp.startswith(INCLUDE_STRING):
                processfile(tmp.replace(INCLUDE_STRING, EMPTY_STRING), outfile)
            elif tmp.startswith(COPY_STRING):
                tmp = tmp.replace(COPY_STRING, EMPTY_STRING)
                if tmp.endswith(PERIOD):
                    tmp = tmp[0:len(tmp) - 1]
                processfile(tmp, outfile)
            elif tmp.startswith(COMMENT_STRING) == False and tmp.startswith(OTHER_COMMENT_STRING) == False:
                append_file(outfile, line)

    append_file(outfile,NEWLINE)

def _write_file_data(file,data,method):
    f = open(file,method)
    f.write(data)
    f.close()

def append_file(file,data):
    _write_file_data(file,data,APPEND_FLAG)

def delete_file(file):
    if exists(file):
        os.remove(file)

if __name__=="__main__":
    if len(sys.argv) < 3:
        print("specify file names")
        main("CMNDATCV.cbl", "out.tmp")
    else:
        main(sys.argv[1], sys.argv[2])