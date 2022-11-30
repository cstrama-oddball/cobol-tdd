import sys
import CICSFactory
from PreCompileConstants import *
from FILEStatementProcess import *
from PreCompileEBCDIC import *
from os.path import exists

cics_abend_statement = True
is_main_program = True

fileInfos = []

module_name = ""

def main(file, outfile, finalout):
    tmp = finalout.replace("\\", "/").split("/")
    outfilename = tmp[len(tmp) - 1]
    cicstempfile = file + '.cics'
    delete_file(outfile)
    delete_file(cicstempfile)
    delete_file(cicstempfile + ".tmp")
    processfile(file, cicstempfile, outfilename)
    cics_precompile(cicstempfile, outfile)
    convertEBCDIC(outfile)
    delete_file(cicstempfile)

def processfile(file, outfile, exename):
    global module_name
    has_files = False
    first = True
    with open(file) as f:
        for line in f:
            if len(line) > 5:
                line = "      " + line[6:]
            
            tmp = line.strip()
            if tmp.startswith(INCLUDE_STRING):
                processfile(tmp.replace(INCLUDE_STRING, EMPTY_STRING), outfile, exename)
            elif tmp.startswith(PROGRAM_ID):
                p_array = tmp.split(SPACE)
                module_name = p_array[len(p_array) - 1].replace(PERIOD, EMPTY_STRING)
                append_file(outfile, line)
            elif tmp.startswith(COPY_STRING):
                tmp = tmp.replace(COPY_STRING, EMPTY_STRING)
                if tmp.endswith(PERIOD):
                    tmp = tmp[0:len(tmp) - 1]
                insert_copybook(outfile, tmp)
            elif tmp.startswith(FILE_STATEMENT):
                has_files = True
                append_file(outfile, line)
            elif tmp.startswith(CBL_FASTSRT):
                append_file(outfile, EMPTY_STRING)
            elif tmp == EMPTY_STRING:
                # nothing to do
                continue
            elif tmp.startswith(COMMENT_STRING) == False and tmp.startswith(OTHER_COMMENT_STRING) == False:
                append_file(outfile, line)

    append_file(outfile,NEWLINE)

    #if has_files and (IGNORE_FILE not in file):
    #    file_precompile(outfile, exename)

def file_precompile(file, exename):
    global fileInfos, module_name
    file_statement = ""
    in_file_block = False
    in_file_section = False
    tmp_outfile = file + ".tmp"
    fname = EMPTY_STRING
    has_files = False
    tmp_rec = EMPTY_STRING
    set_file_rec = False
    with open(file) as f:
        for line in f:
            tmp = line.strip()
            if in_file_block == False and tmp.startswith(FILE_STATEMENT):
                in_file_block = True
                file_statement = process(line, fileInfos)
                has_files = True
            elif in_file_block:
                file_statement = file_statement + process(line, fileInfos)
                if tmp.endswith(PERIOD):
                    #in_file_block = False
                    append_file(tmp_outfile, file_statement)
                    file_statement = EMPTY_STRING
            elif in_file_block and tmp.startswith(DATA_DIVISION):
                in_file_block = False
            elif in_file_section == False and tmp.startswith(FILE_SECTION):
                in_file_block = False
                in_file_section = True
                append_file(tmp_outfile, line)
            elif in_file_section:
                if (tmp.startswith(FD)):
                    fileInfos, fname = allocateFile(tmp, fileInfos)
                    append_file(tmp_outfile, line)
                elif (tmp.startswith("01")):
                    file_array = tmp.split(SPACE)
                    count = 1
                    for x in range(count, len(file_array)):
                        if file_array[x] != EMPTY_STRING:
                            tmp_rec = file_array[x]
                            set_file_rec = True
                            break
                    append_file(tmp_outfile, line)
                elif(set_file_rec and (findRecKey(fname,fileInfos) in tmp or findRecord(fname,fileInfos) in tmp)):
                    set_file_rec = False
                    assignFileRecord(fname, tmp_rec, fileInfos)
                    in_file_section = False
                    append_file(tmp_outfile, line)
                else:
                    append_file(tmp_outfile, line)
            elif tmp.startswith(WORKING_STORAGE_SECTION) and has_files:
                append_file(tmp_outfile, line)
                insert_copybook(tmp_outfile, FILE_CALL_COPYBOOK)
            elif tmp.startswith("READ") or tmp.startswith("REWRITE") or tmp.startswith("WRITE") or tmp.startswith("OPEN") or tmp.startswith("CLOSE"):
                append_file(tmp_outfile, CBL_COMMENT + tmp + NEWLINE)
                append_file(tmp_outfile, processFileVerb(tmp, fileInfos, exename, module_name))
            else:
                append_file(tmp_outfile, line)

    rewrite_outfile(tmp_outfile, file)

def rewrite_outfile(file, outfile):
    delete_file(outfile)
    with open(file) as f:
        for line in f:
            #print(line)
            append_file(outfile, line)

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
    file_exists = exists(copybook)
    if file_exists == False:
        copybook = copybook + COPYBOOK_EXT
        file_exists = exists(copybook)
        if file_exists == False:
            copybook = COPYBOOK_FOLDER + copybook
            file_exists = exists(copybook)
            if file_exists == False:
                copybook = copybook.replace(COPYBOOK_EXT, EMPTY_STRING)
                file_exists = exists(copybook)
                if file_exists == False:
                    return

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

if __name__=="__main__":
    inprog = ""
    outprog = ""
    skip = False
    if len(sys.argv) == 1:
        inprog = "cics_test.cbl"
        outprog = "cics_test_out.cbl"
    elif len(sys.argv) < 5:
        print("specify file names")
        print (sys.argv[1])
        skip = True
    else:
        inprog = sys.argv[1]
        outprog = sys.argv[2]
        finalout = sys.argv[4]
        if sys.argv[3] == "-m":
            is_main_program = False
        
    if skip == False:
        main(inprog, outprog, finalout)