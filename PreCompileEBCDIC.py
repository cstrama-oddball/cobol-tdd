from PreCompileConstants import *

def convertEBCDIC(outfile):
    # Open a file: file
    file = open(outfile,mode='r')
    
    # read all lines at once
    all_of_it = file.read()

    # close the file
    file.close()

    all_of_it = convertSSATORRB(all_of_it)

    write_new_file(outfile, all_of_it)

def convertSSATORRB(text):

    SSATORRBOld = "           AND SP-INTERNAL-HIC (1:1)   >=  X'C0'\n           AND                         <=  X'C9'"
    SSATORRBNew = "           AND (SP-INTERNAL-HIC (1:1)   =  '{'\n           OR                           =  'A'\n           OR                           =  'B'\n           OR                           =  'C'\n           OR                           =  'D'\n           OR                           =  'E'\n           OR                           =  'F'\n           OR                           =  'G'\n           OR                           =  'H'\n           OR                           =  'I')"
    result = text.replace(SSATORRBOld, SSATORRBNew)

    return result