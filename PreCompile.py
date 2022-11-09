import sys, os
import CICSFactory
from PreCompileConstants import *

from os.path import exists

cics_abend_statement = True
is_main_program = True

def main(file, outfile):
    cicstempfile = file + '.cics'
    delete_file(outfile)
    delete_file(cicstempfile)
    processfile(file, cicstempfile)
    cics_precompile(cicstempfile, outfile)   
    delete_file(cicstempfile) 

def processfile(file, outfile):
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

def cics_precompile(file,outfile):
    hascics = False
    haslinkagesection = False
    with open(file) as f:
        for line in f:
            tmp = line.strip()
            if tmp.startswith(CICS_STATEMENT):
                hascics = True
                break
            elif tmp.startswith(LINKAGE_SECTION):
                haslinkagesection = True

    if hascics:
        insert_cics_linkage(file, outfile, haslinkagesection)
    else:
        with open(file) as f:
            for line in f:
                append_file(outfile, line)

def insert_cics_linkage(file, outfile, haslinkagesection):
    global is_main_program
    cics_statement = EMPTY_STRING
    iscics = False
    with open(file) as f:
        for line in f:
            tmp = line.strip()
            if tmp.startswith(PROCEDURE_DIVISION):
                if haslinkagesection == False:
                    insert_linkage_section(outfile)
                if USING_STATEMENT in tmp:
                    print (line.split(PERIOD))
                    line = line.split(PERIOD)[0] + SPACE + DFHEIBLK + PERIOD
                elif is_main_program == False:
                    line = line.split(PERIOD)[0] + USING_STATEMENT + DFHEIBLK + PERIOD + NEWLINE

                append_file(outfile, line)
            elif tmp.startswith(WORKING_STORAGE_SECTION):
                append_file(outfile, line)
                insert_copybook(outfile, CICSWORK_COPYBOOK)
            elif tmp.startswith(END_CICS_STATEMENT):
                iscics = False
                cics_statement = cics_statement + CICS_DELIMITER + tmp
                process_cics_statement(outfile, cics_statement)
            elif tmp.startswith(CICS_STATEMENT) or iscics == True:
                iscics = True
                if (tmp.startswith(CICS_STATEMENT)):
                    cics_statement = EMPTY_STRING
                    cics_statement = cics_statement + tmp.replace(NEWLINE, CICS_DELIMITER).replace(SPACE, CICS_DELIMITER) + CICS_DELIMITER
                else:
                    cics_statement = CICS_DELIMITER + cics_statement + tmp.replace(NEWLINE, CICS_DELIMITER).replace(SPACE,CICS_DELIMITER) + CICS_DELIMITER
            else:
                append_file(outfile, line)

def process_cics_statement(outfile, statement):
    global cics_abend_statement
    exec_array = cleanup_array(statement, CICS_DELIMITER)

    append_file(outfile, "      *    " + "|".join(exec_array) + NEWLINE)

    verb_interface = CICSFactory.CreateVerb(exec_array[2])
    verb_interface.process(exec_array, cics_abend_statement, outfile)

    if verb_interface.set_abend_statement() == True:
        cics_abend_statement = verb_interface.get_result()


def insert_linkage_section(outfile):
    append_file(outfile, "       " + LINKAGE_SECTION + "\n")
    insert_copybook(outfile, CICSDHFC_COPYBOOK)
    insert_copybook(outfile, CICSLINK_COPYBOOK)

def insert_copybook(outfile, copybook):
    with open(copybook) as file:
        for line in file:
            append_file(outfile, line)
    append_file(outfile, "       \n")
    append_file(outfile, "       \n")

def cleanup_array(s, delim):
    arr = s.split(delim)
    out = []

    for a in arr:
        if a != EMPTY_STRING:
            out.append(a)

    return out

def delete_file(file):
    if exists(file):
        os.remove(file)

if __name__=="__main__":
    inprog = ""
    outprog = ""
    skip = False
    if len(sys.argv) == 1:
        inprog = "cics_test.cbl"
        outprog = "cics_test_out.cbl"
    elif len(sys.argv) < 4:
        print("specify file names")
        print (sys.argv[1])
        skip = True
    else:
        inprog = sys.argv[1]
        outprog = sys.argv[2]
        if sys.argv[3] == "-m":
            is_main_program = False
        
    if skip == False:
        main(inprog, outprog)